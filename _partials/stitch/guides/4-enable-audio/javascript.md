---
title: JavaScript
language: javascript
---

# Getting Started with the Nexmo Stitch JavaScript SDK

In this getting started guide we'll cover adding audio events to the Conversation we created in the [simple conversation with events](/stitch/in-app-messaging/guides/3-utilizing-events/javascript) getting started guide. We'll deal with media events, the ones that come via the conversation, and the ones we send to the conversation.

## Concepts

This guide will introduce you to the following concepts.

- **Audio** - enabling and disabling Audio streams in a Conversation
- **Media Events** - `member:media` events that fire on a Conversation when media state changes for a member

## Before you begin

- Ensure you have run through the [previous guide](/stitch/in-app-messaging/guides/3-utilizing-events/javascript)

## 1 - Update the JavaScript App

We will use the application we already created for [the third getting started guide](/stitch/in-app-messaging/guides/3-utilizing-events/javascript). All the basic setup has been done in the previous guides and should be in place. We can now focus on updating the client-side application.

### 1.1 - Add audio UI

First, we'll add the UI for user to enable and disable audio, as well as an `<audio>` element that we'll use to play the Audio stream from the conversation. Let's add the UI at the top of the messages area.

```html
<section id="messages">
  <div>
    <audio id="audio">
      <source>
    </audio>
    <button id="enable">Enable Audio</button>
    <button id="disable">Disable Audio</button>
  </div>
  ...
</section>

```

And add the buttons and `<audio>` element in the class constructor

```javascript
constructor() {
...
  this.audio = document.getElementById('audio')
  this.enableButton = document.getElementById('enable')
  this.disableButton = document.getElementById('disable')
}
```

### 1.2 - Add enable audio handler

We'll then update the `setupUserEvents` method to trigger `conversation.media.enable()` when the user clicks the `Enable Audio` button. `conversation.media.enable()` returns a promise with a stream object, which we'll use as the source for our `<audio>` element. We'll then add a listener on the `<audio>` element to start playing as soon as the metadata has been loaded.

```javascript
setupUserEvents() {
...
  this.enableButton.addEventListener('click', () => {
    this.conversation.media.enable().then(stream => {
      // Older browsers may not have srcObject
      if ("srcObject" in this.audio) {
        this.audio.srcObject = stream;
      } else {
        // Avoid using this in new browsers, as it is going away.
        this.audio.src = window.URL.createObjectURL(stream);
      }

      this.audio.onloadedmetadata = () => {
        this.audio.play();
      }

      this.eventLogger('member:media')()
    }).catch(this.errorLogger)
  })
}
```

### 1.3 - Add disable audio handler

Next, we'll add the ability for a user to disable the audio stream as well. In order to do this, we'll update the `setupUserEvents` method to trigger `conversation.media.disable()` when the user clicks the `Disable Audio` button.

```javascript
setupUserEvents() {
...
  this.disableButton.addEventListener('click', () => {
    this.conversation.media.disable().then(this.eventLogger('member:media')).catch(this.errorLogger)
  })
}
```

### 1.4 - Add member:media listener

With these first parts we're sending `member:media` events into the conversation. Now we're going to register a listener for them as well that updates the `messageFeed`. In order to do that, we'll add a listener for `member:media` events at the end of the `setupConversationEvents` method

```javascript
setupConversationEvents(conversation) {
  ...

  conversation.on("member:media", (member, event) => {
    console.log(`*** Member changed media state`, member, event)
    const text = `${member.user.name} <b>${event.body.audio ? 'enabled' : 'disabled'} audio in the conversation</b><br>`
    this.messageFeed.innerHTML = text + this.messageFeed.innerHTML
  })

}
```

If we want the conversation history to be updated, we need to add a case for `member:media` in the `showConversationHistory` switch:

```javascript
showConversationHistory(conversation) {
  ...
  switch (value.type) {
    ...
    case 'member:media':
      eventsHistory = `${conversation.members[value.from].user.name} @ ${date}: <b>${value.body.audio ? "enabled" : "disabled"} audio</b><br>` + eventsHistory
      break;
    ...
  }
}
```


### 1.5 - Open the conversation in two browser windows

Now run `index.html` in two side-by-side browser windows, making sure to login with the user name `jamie` in one and with `alice` in the other. Enable audio on both and start talking. You'll also see events being logged in the browser console.

That's it! Your page should now look something like [this](https://github.com/Nexmo/stitch-js-quickstart/blob/master/examples/4-enable-audio/index.html).

## Where next?

- Have a look at the [Nexmo Stitch JavaScript SDK API Reference](/sdk/stitch/javascript/)
