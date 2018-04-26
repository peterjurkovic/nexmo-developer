---
title: Nexmo Call Control Objects
description: The Nexmo Call Control Objects used to manage your Voice API calls.
---

# Nexmo Call Control Objects

A Nexmo Call Control Object (NCCO) is a JSON array of actions that is used to control the flow of a Voice API Call.

This section describes:

* [About Nexmo Call Control Objects](#about-nexmo-call-control-objects)
* [Creating a custom Call or Conversation for each user](#creating-a-custom-call-or-conversation-for-each-user)

## About Nexmo Call Control Objects

The Call event model is asynchronous. A static or dynamically created NCCO script provides the business logic for your Call. When a Call is placed to your number, Nexmo makes a synchronous request to the webhook endpoint you set as the [answer_url](/api/voice#answer_url) for your number and retrieves the [NCCO object](#controlling) that controls the Call.

The general schema of an NCCO is:

```json
[
  {
    "action": "<value>",
    "<option1>": "<value>",
    "<option2>": [
      {
        "type": "<value>",
        "<option1>": "<value>"
      },
      {
        "type": "<value>",
        "<option1>": "<value>",
        "<option2>": "<value>"
      }
    ]
  }
]
```

The elements of an NCCO instruction are:

* `action` - something to be done in the Call.
* `option` - how to customize an *action*.
* `type` - describes an *option*. For example, `type=phone` for an endpoint option.

The order of actions in the NCCO controls the flow of the call. This is called the stack. The order of instructions on the stack matters: the actions are executed in order. Unless explicitly halted NCCO are executed on a FIFO basis. When an action is completed, the next action in the stack is executed. Actions that have to complete before the next action can be executed are *synchronous*. Other actions are *asynchronous*. That is, they are supposed to continue over the following actions until a condition is met. For example, a *record* action terminates when the *endOnSilence* option is met. When all the actions in the NCCO are complete, the voice call ends.

Some actions and options are:

```tabbed_content
source: '_examples/voice/ncco/actions'
```

For your NCCO to execute correctly, the JSON syntax must be valid. It is better to generate JSON dynamically using a JSON library than to attempt to write it yourself programatically.

The actions you can use in an NCCO are:

* [`record`](/api/voice/ncco#record) - all or part of a call
* [`conversation`](/api/voice/ncco#conversation) - create a standard or hosted conversation
* [`connect`](/api/voice/ncco#connect) - connect to a connectable endpoint such as a phone number
* [`talk`](/api/voice/ncco#talk) - send synthesized speech to a conversation
* [`stream`](/api/voice/ncco#stream) - send audio files to a conversation
* [`input`](/api/voice/ncco#input) - collect digits and speech from the person you are calling, then process them

##Creating a custom call or conversation for each user

When you make an outbound call or accept an inbound call, Nexmo makes a request to your webhook endpoint at *answer_url* and retrieves your NCCO. This  request contains the following parameters:

Name | Description
-- | --
`to` | The endpoint being called.
`from` | The endpoint you are calling from.
`conversation_uuid` | The unique ID for this Conversation.
`uuid` | The unique ID for this Call.

You can use these parameters to customize the NCCO you return to Nexmo. The following code examples show how to provide the NCCO that controls your call or conversation:

```tabbed_examples
source: '_examples/voice/ncco/creating-a-custom-call-or-conversation-for-each-user'
```
