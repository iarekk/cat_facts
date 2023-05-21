defmodule CatFacts.Fact do
  defstruct ~w[created_at text verified]a

  def new(%{"createdAt" => created_at, "text" => text, "status" => %{"verified" => verified}}) do
    with {:ok, date_time, _shift} <- DateTime.from_iso8601(created_at) do
      %__MODULE__{
        created_at: date_time,
        text: text,
        verified: verified
      }
    else
      error -> error
    end
  end

  def is_verified?(%__MODULE__{verified: true}), do: true
  def is_verified?(_), do: false
end
