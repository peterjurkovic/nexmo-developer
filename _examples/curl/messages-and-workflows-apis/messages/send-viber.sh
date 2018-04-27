curl -X POST https://api.nexmo.com/beta/messages \
  -H 'Authorization: Bearer '$JWT\
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d $'{
    "from": { "type": "viber_service_msg", "id": "VIBER_SERVICE_MESSAGE_ID" },
    "to": { "type": "viber_service_msg", "number": "TO_NUMBER" },
    "message": {
      "content": {
        "type": "text",
        "text": "This is a Viber Service Message sent from the Messages API"
      }
    }
  }'
