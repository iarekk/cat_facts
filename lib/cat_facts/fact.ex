defmodule CatFacts.Fact do
  defstruct ~w[created_at text]a

  def new(raw_fact) do
    with {:ok, date_time, _shift} <- DateTime.from_iso8601(raw_fact["createdAt"]) do
      %__MODULE__{
        created_at: date_time,
        text: raw_fact["text"]
      }
    else
      error -> error
    end
  end
end
