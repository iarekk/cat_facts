defmodule CatFacts.ApiClient do
  require Logger
  alias CatFacts.{Fact, FactParser}
  @user_agent [{"User-agent", "Elixir iarek"}]
  @api_url Application.compile_env(:cat_facts, :api_url)
  @batch_size Application.compile_env(:cat_facts, :batch_size)
  @max_attempts Application.compile_env(:cat_facts, :max_attempts)

  def get_verified_fact(attempts_remaining \\ @max_attempts)

  def get_verified_fact(attempts_remaining) when attempts_remaining > 0 do
    batch = batch_get_verified_facts(@batch_size)
    Logger.debug("received verified facts #{inspect(batch)}")

    case batch do
      [fact | _] ->
        {:ok, fact}

      _ ->
        get_verified_fact(attempts_remaining - 1)
    end
  end

  def get_verified_fact(_), do: {:error, "Max attempts reached"}

  def batch_get_verified_facts(batch_size) do
    with {:ok, raw_facts} <- get_random_facts(batch_size) do
      raw_facts |> Enum.filter(&Fact.is_verified?(&1))
    else
      error -> error
    end
  end

  @doc """
  Get the random facts endpoint URL.

  ## Examples

    iex> CatFacts.ApiClient.random_fact_url(3)
    "https://cat-fact.herokuapp.com/facts/random?amount=3"
  """
  def random_fact_url(amount) do
    "#{@api_url}/facts/random?amount=#{amount}"
  end

  def get_random_facts(amount) when is_integer(amount) and amount > 0 do
    random_fact_url(amount)
    |> HTTPoison.get(@user_agent)
    |> parse_response
  end

  def parse_response({:ok, %{status_code: status_code, body: body}}) do
    Logger.debug("Received response with status code=#{status_code}")
    Logger.debug(fn -> inspect(body) end)

    # TODO IK I don't liek that we parse response even if status code is bad, replace with `with`?
    {
      status_code |> check_for_error,
      body |> FactParser.parse_facts()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
