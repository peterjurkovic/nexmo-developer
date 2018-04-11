---
title: PHP
language: php
---

## Implement a server

The following code implements a server which responds to callbacks on
`/webhooks/answer`:

```code
config: voice.inbound.php
```

## Run your server

Save this file and then run it:

```
$ php -t . -S localhost:3000
```
