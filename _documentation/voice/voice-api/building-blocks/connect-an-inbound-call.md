---
title: Connect an inbound call
---

# Connect an inbound call

In this example your Nexmo Application will accept an inbound call and then connect this
call to another user via a new outbound call.

Replace the following variables in the example below:

Key |	Description
-- | --
`YOUR_SECOND_NUMBER` |	The number you wish the inbound caller to be connected to.

```tabbed_content
source: '_examples/voice/connect-an-inbound-call'
```

You will need to expose your server to the public internet. This is so
Nexmo can call back on URLs such as the Event URL and the Answer URL.

During development you can use a tool like [Ngrok](https://ngrok.com)
to ensure that Nexmo is able to call back to your development
system. This is explained in detail in [this blog
post]((https://www.nexmo.com/blog/2017/07/04/local-development-nexmo-ngrok-tunnel-dr/)).

## Associate a Nexmo Application to your webhook

To link your number to the endpoint you've just created we'll need an Application:

```
$ nexmo app:create demo <YOUR_HOSTNAME>/webhooks/answer <YOUR_HOSTNAME>/webhooks/event
$ nexmo link:app <NEXMO_NUMBER> <NEXMO_APPLICATION_ID>
```

## Call your number

When you call your Nexmo number you are connected to the the
number you specified in place of `YOUR_SECOND_NUMBER`.
