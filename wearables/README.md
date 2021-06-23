# Wearables

Crownstone support for wearables is very, very new! The release is planned for Q3 2021. We will make things much easier before we release and many steps that are described here will become easier or redundant.

## Scan

Crownstones can scan for Bluetooth LE messages from devices that broadcast those regularly. If a device does not broadcast at regular times, we cannot force it to do so.

We have tested the following devices:

| Brand    | Freq (Hz) | Recognized by |
|----------|----------:|---------------|
| ...      |         1 |   MAC address |

The device has to have something that it is recognized by. This can be a **manufacturer ID** for all devices of a particular brand. Or this can be something unique, for example a **MAC address**. In that case it is important that this information does **not** change over time. It should not "rotate" its address.

The Crownstones have to be configured in such way that they are only reacting to a particular manufacturer ID or a particular MAC address. For that a **filter** has to be configured. The filter has as task to only pass through the messages from devices we would like.

## Firmware

This was tested with firmware 5.5.0.

## Configuring filter

A filter can be configured using our python libraries. Make sure you have python 3.7 or higher.
At this time, the released libraries do not have this feature yet, so you have to install them from git.
Use option 2 of [these instructions](https://github.com/crownstone/crownstone-lib-python-core/blob/master/docs/TUTORIAL_VENV_SETUP.md)


The following example script uses the library to upload a filter with MAC addresses.
Once uploaded to a crownstone, it will be synchronized to other crownstones in the sphere as well.

```
#!/usr/bin/env python3

"""
Example to remove all asset filters, and upload a filter with MAC addresses.
"""
import math
import argparse
import os
import asyncio

from crownstone_core.packets.assetFilter.FilterMetaDataPackets import *
from crownstone_core.util import AssetFilterUtil
from crownstone_core.util.AssetFilterUtil import get_filter_crc
from crownstone_core.util.Cuckoofilter import CuckooFilter
from crownstone_uart import CrownstoneUart
import itertools

from bluenet_logs import BluenetLogs

import logging
#logging.basicConfig(format='%(asctime)s %(levelname)-7s: %(message)s', level=logging.DEBUG)


defaultSourceFilesDir = os.path.abspath(f"{os.path.dirname(os.path.abspath(__file__))}/../source")

argParser = argparse.ArgumentParser(description="Client to show binary logs")
argParser.add_argument('--assetAddress',
                       '-a',
                       dest='assetMacAddresses',
                       metavar='MAC',
                       type=str,
                       nargs='+',
                       required=True,
                       help='The MAC addresses of the assets, for example: 00:11:22:33:44:55 AA:BB:CC:66:77:88')
argParser.add_argument('--device',
                       '-d',
                       dest='device',
                       metavar='path',
                       type=str,
                       default=None,
                       help='The UART device to use, for example: /dev/ttyACM0')
argParser.add_argument('--sourceFilesDir',
                       '-s',
                       dest='sourceFilesDir',
                       metavar='path',
                       type=str,
                       default=f"{defaultSourceFilesDir}",
                       help='The path with the bluenet source code files on your system.')
args = argParser.parse_args()

sourceFilesDir = args.sourceFilesDir


# Init bluenet logs, it will listen to events from the Crownstone lib.
bluenetLogs = BluenetLogs()

# Set the dir containing the bluenet source code files.
bluenetLogs.setSourceFilesDir(sourceFilesDir)

# Init the Crownstone UART lib.
uart = CrownstoneUart()

async def main():
	# The try except part is just to catch a control+c to gracefully stop the UART lib.
	try:
		print(f"Listening for logs and using files in \"{sourceFilesDir}\" to find the log formats.")
		await uart.initialize_usb(port=args.device, writeChunkMaxSize=64)

		filters = await uart.control.getFilterSummaries()
		masterVersion = filters.masterVersion.val

		##############################################################################################
		##################################### Remove all filters #####################################
		##############################################################################################

		print("Remove all filters")
		for f in filters.summaries.val:
			print(f"    Remove id={f.filterId}")
			await uart.control.removeFilter(f.filterId)

		masterVersion += 1
		filtersAndIds = []
		masterCrc = AssetFilterUtil.get_master_crc_from_filters(filtersAndIds)
		print("Master CRC:", masterCrc)
		print("Commit")
		await uart.control.commitFilterChanges(masterVersion, masterCrc)

		#############################################################################################
		##################################### Create new filter #####################################
		#############################################################################################

		filter = AssetFilter()

		filterInput = FilterInputDescription()
		filterInput.format.type = AdvertisementSubdataType.MAC_ADDRESS

		filterOutputDescription = FilterOutputDescription()
		filterOutputDescription.out_format.type = FilterOutputFormat.MAC_ADDRESS
		# filterOutputDescription.in_format = None

		metadata = FilterMetaData()

		# Using the EXACT_MATCH filter takes up more space, but has no false positives.
		metadata.type = FilterType.EXACT_MATCH

		# Setting profile ID 0 will make the asset also trigger behaviours.
		metadata.profileId = 0

		metadata.inputDescription = filterInput
		metadata.outputDescription = filterOutputDescription
		filter.metadata = metadata

		print(f"MACs={args.assetMacAddresses}")
		macAddressesAsBytes = []
		for a in args.assetMacAddresses:
			print(f"Adding asset MAC {a} to filter.")
			buf = Conversion.address_to_uint8_array(a)
			if not buf:
				raise Exception(f"Invalid MAC: {a}")
			macAddressesAsBytes.append(list(buf))

		if metadata.type == FilterType.CUCKOO:
			# Create the cuckoo filter
			max_buckets_log2 = int(math.log2(len(macAddressesAsBytes))) + 1
			nests_per_bucket = 2
			cuckooFilter = CuckooFilter(max_buckets_log2, nests_per_bucket)
			max_items = cuckooFilter.fingerprintcount()
			for a in macAddressesAsBytes:
				if not cuckooFilter.add(a):
					print("Failed to add to cuckoo filter")
					raise Exception("Failed to add to cuckoo filter")
			cuckooFilterData = cuckooFilter.getData()
			filter.filterdata.val = cuckooFilterData

		elif metadata.type == FilterType.EXACT_MATCH:
			# Create the exact filter
			exactFilter = ExactMatchFilterData(len(macAddressesAsBytes), 6)
			exactFilter.itemArray.val = list(itertools.chain.from_iterable(macAddressesAsBytes))
			filter.filterdata.val = exactFilter

		else:
			raise Exception("Invalid filter type")

		print("Filter size:", len(filter.getPacket()))
		print("Filter CRC:", get_filter_crc(filter))


		###########################################################################################
		##################################### Uploade filters #####################################
		###########################################################################################

		filters = [filter]

		filterId = 0
		masterVersion += 1

		filtersAndIds = []
		for f in filters:
			filtersAndIds.append(AssetFilterAndId(filterId, filter))
			filterId += 1

		masterCrc = AssetFilterUtil.get_master_crc_from_filters(filtersAndIds)
		print("Master CRC:", masterCrc)
		print("Master version:", masterVersion)

		filterId = 0
		for f in filters:
			print(f"Upload filter {filterId}")
			await uart.control.uploadFilter(filterId, f)
			filterId += 1
		print("Commit")
		await uart.control.commitFilterChanges(masterVersion, masterCrc)
		print("Done!")
		print("Press ctrl-c to exit.")

		# Simply keep the program running.
		while True:
			await asyncio.sleep(0.1)
	except KeyboardInterrupt:
		pass
	finally:
		# time.sleep(1)
		print("\nStopping UART..")
		uart.stop()
		print("Stopped")

asyncio.run(main())
```

You can test if the proper filter has been uploaded to the Crownstone by:

```
# test
```

## Presence

Note that by setting profile ID to 0, the assets will also count for **presence detection** as someone being in the sphere.

You can test this most easily by having a rule that reacts to presence and which controls the power for a light based on that presence. If you have a Nordic Semi development board you can inspect the logs (with non-release firmware and logs enabled).

## Recommendation

We have tested the following hardware:

* ...
* ...

If you want to be able to do presence detection with some **other hardware**, please contact us. We can check if this is possible. Give us as much information as possible on the messages it is broadcasting. For example using the Nordic Semi [nRF Connect for Mobile](https://www.nordicsemi.com/Software-and-tools/Development-Tools/nRF-Connect-for-mobile) app.
