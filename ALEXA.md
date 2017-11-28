# Amazon development


## First get in contact

For your skill get a clientID and clientSecret from the Crownstone developers. 

## Create a Smart Home skill

Create a skill at <https://developer.amazon.com/edw/home.html#/skills>. Almost everything is pretty standard for a 
Smart Home skill type (you can follow the usual manuals or guides).

Then in the <https://developer.amazon.com/edw/home.html#/skill/$YOUR_SKILL_ID/$YOUR_LANG/configuration> Configuration
tab you can add the Authorization URL:

* <https://cloud.crownstone.rocks/oauth/authorize>

The Client Id:

* **You got this from the Crownstone developers.**

Domain List:

* crownstone.rocks
* amazon.com
* lambda.amazonaws.com

Scope:

* user_information
* user_location
* stone_information
* switch_stone

Authorization Grant Type:

* Auth Code Grant
* Access Token URI: https://cloud.crownstone.rocks/oauth/token
* Client Secret: **You got this from the Crownstone developers.**

Privacy Policy. The privacy policy of Crownstone can be found at https://crownstone.rocks/privacy-policy/.

## Running the actual Smart Home skill on AWS

A skill can be hosted by Amazon on AWS, which can be accessed through <https://console.aws.amazon.com/lambda/home?region=us-east-1#/functions>

You can again use the standard tutorials to create a proper function...

Now, create a test function, e.g. **Discovery**.

It will look something like this:

	{
	  "header": {
	    "payloadVersion": "2",
	    "namespace": "Alexa.ConnectedHome.Discovery",
	    "name": "DiscoverAppliancesRequest",
	    "messageId": "F8752B11-69BB-4246-B923-3BFB27C06C7D"
	  },
	  "payload": {
	    "accessToken": "$ACCESS_TOKEN"
	  }
	}

You can use here an $ACCESS_TOKEN you have previously acquired through <https://cloud.crownstone.rocks>, but to get
the one with the proper scope, you'll have to go through the OAUTH process via the Amazon Alexa app. 



