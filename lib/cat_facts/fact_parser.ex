defmodule CatFacts.FactParser do
  alias CatFacts.Fact

  def decode_facts(json_str) when is_binary(json_str) do
    Poison.decode(json_str)
  end

  def decode_facts(arg) do
    {:error, {"Bad input", arg}}
  end

  def check_if_list(raw_facts) when is_list(raw_facts), do: {:ok, raw_facts}
  def check_if_list(_), do: {:error, "Input json didn't parse into a list"}

  def parse_facts(body_string) do
    with {:ok, raw_facts} <- decode_facts(body_string),
         {:ok, raw_fact_list} <- check_if_list(raw_facts) do
      {:ok, raw_fact_list |> Enum.filter(&Fact.can_parse(&1)) |> Enum.map(&Fact.new(&1))}
    else
      error -> error
    end
  end
end
