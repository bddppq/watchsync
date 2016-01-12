fs = require 'fs'
watchman = require 'fb-watchman'
client = new watchman.Client()

# take the last argument as project_dir to be watched
[..., project_dir] = process.argv
project_dir = fs.realpathSync project_dir
sub_tag = 'subscription'
sub =
  expression: ['allof', ['match', '*']]
  fields: ['name', 'size', 'exists', 'type']

client.capabilityCheck {optional: [], required: ['relative_root']}, (err, res) ->
  if err
    console.error 'Capability check error:', err
    client.end()
  else
    if 'warning' of res
      console.log 'Capability check warning:', res.warning
    console.log 'Capability checked'

    # get the 'watch'
    client.command ['watch-project', project_dir], (err, res) ->
      if err
        console.log 'Watch error:', err
        client.end()
      else
        if 'warning' of res
          console.log 'Watch warning:', res.warning
        console.log 'Watched'

        client.command ['subscribe', res.watch, sub_tag, sub], (err, res) ->
          if err
            console.log 'Subscribe error:', err
            client.end()
          else
            if 'warning' of res
              console.log 'Subscribe warning:', res.warning
            console.log 'Subscribed'

client.on 'subscription', (res) ->
  for f in res.files
    if res.subscription == sub_tag
      console.log f
