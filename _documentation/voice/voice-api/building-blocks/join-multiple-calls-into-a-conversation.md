---
title: Join multiple calls into a conversation
navigation_weight: 6
---

# Join multiple calls into a conversation

This building block shows how to join multiple calls into a conversation.

Multiple inbound calls can be joined into a conversation (conference
call) by simply connecting the call into the same named
conference.

Conference names are scoped at the Nexmo Application
level. For example, NexmoApp1 and NexmoApp2 could both have a
conference called `nexmo-conference` and there would be no problem.

## Example

```tabbed_content
source: '_examples/voice/join-multiple-calls-into-a-conversation'
```

## Try it out

Start your server and make multiple inbound calls to the Nexmo Number
assigned to this Nexmo Application. The inbound calls will be connected
into the same conversation (conference).
