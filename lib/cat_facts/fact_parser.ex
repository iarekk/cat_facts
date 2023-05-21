defmodule CatFacts.FactParser do
  alias CatFacts.Fact

  def decode_facts(json_str) when is_binary(json_str) do
    Poison.decode(json_str)
  end

  def decode_facts(arg) do
    {:error, {"Bad input", arg}}
  end

  def parse_facts(body_string) do
    with {:ok, raw_fact_list} <- decode_facts(body_string) do
      # TODO do we need validation for e.g. JSON not containing a list? How can it be done?
      Enum.map(raw_fact_list, &Fact.new(&1))
    else
      error -> error
    end
  end
end
