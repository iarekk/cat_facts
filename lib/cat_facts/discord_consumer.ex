defmodule CatFacts.DiscordConsumer do
  use Nostrum.Consumer
  require Logger

  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Logger.debug("handle event #{inspect(msg)}")

    case msg.content do
      "!fact" ->
        publish_fact(msg.channel_id)

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

  def publish_fact(channel_id) do
    Task.start(fn ->
      {:ok, %CatFacts.Fact{text: text}} = CatFacts.ApiClient.get_verified_fact()
      Api.create_message(channel_id, "#{text}")
    end)
  end
end
