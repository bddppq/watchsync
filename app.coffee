watchman = require 'fb-watchman'
client = new watchman.Client()

client.capabilityCheck {optional: [], required: ['relative_root']}, (err, res) ->
  if err
    console.error 'error:', err
    client.end()
  else
    if 'warning' of res
      console.log 'warning:', res.warning
