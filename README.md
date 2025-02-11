# TowerDiscord

Error reporting to Discord.

A simple post-to-Discord reporter for Tower error handler that sends formatted error messages to a Discord channel via webhooks.

## Installation

The package can be installed by adding `tower_discord` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tower_discord, "~> 0.1.0"}
  ]
end
```

## Usage

Register the reporter with Tower:

```elixir
# config/config.exs

config :tower, :reporters, [
  # along with any other possible reporters
  TowerDiscord
]
```

Add the Discord-specific configurations:

```elixir
# config/runtime.exs

config :tower_discord,
  webhook_url: System.get_env("TOWER_DISCORD_WEBHOOK_URL"),
  level: :error # Optional, defaults to :error
```

### Discord Webhook Setup

1. In your Discord server, go to Server Settings -> Integrations
2. Click on "Create Webhook"
3. Choose the channel where you want the error reports to appear
4. Copy the Webhook URL and use it in your configuration

The reporter will format error messages with:
- Error type and source location
- Exception details
- Stacktrace information
- Hashtags for easy filtering (#tower_report #tower_type_[kind])

## Configuration Options

| Option | Required | Description | Default |
|--------|----------|-------------|---------|
| webhook_url | Yes | Discord webhook URL for message delivery | - |
| level | No | Minimum level for reported events | :error |

## License

Copyright 2024 Your Name/Organization

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
