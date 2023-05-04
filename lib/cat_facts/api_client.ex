defmodule CatFacts.ApiClient do
  require Logger

  @user_agent [{"User-agent", "Elixir iarek"}]
  @api_url Application.compile_env(:cat_facts, :api_url)

  @doc """
  Get the random facts endpoint URL.

  ## Examples

    iex> CatFacts.ApiClient.random_fact_url()
    "https://cat-fact.herokuapp.com/facts/random"
  """
  def random_fact_url() do
    "#{@api_url}/facts/random"
  end

  def get_random_fact() do
    random_fact_url()
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    Logger.info("Received response with status code=#{status_code}")
    Logger.debug(fn -> inspect(body) end)

    {
      status_code |> check_for_error,
      body |> Poison.Parser.parse!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
