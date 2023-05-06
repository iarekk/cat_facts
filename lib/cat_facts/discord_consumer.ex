defmodule CatFacts.DiscordConsumer do
  use Nostrum.Consumer
  require Logger

  alias Nostrum.Api

  def start_link() do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Logger.debug("handle event #{inspect(msg)}")

    case msg.content do
      "ping!" ->
        Api.create_message(msg.channel_id, "pong!")

      _ ->
        :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(event) do
    Logger.debug("handle default event #{inspect(event)}")
    :noop
  end
end
