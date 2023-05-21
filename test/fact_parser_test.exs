defmodule FactParserTest do
  use ExUnit.Case
  alias CatFacts.{Fact, FactParser}

  test "can parse json" do
    json = """
    [
      {
        "status": {
            "verified": true,
            "sentCount": 1
        },
        "_id": "591f98783b90f7150a19c1ad",
        "__v": 0,
        "text": "The catnip plant contains an oil called hepetalactone which does for cats what marijuana does to some people. Not all cats react to it those that do appear to enter a trancelike state. A positive reaction takes the form of the cat sniffing the catnip, then licking, biting, chewing it, rub & rolling on it repeatedly, purring, meowing & even leaping in the air.",
        "source": "api",
        "updatedAt": "2020-08-23T20:20:01.611Z",
        "type": "cat",
        "createdAt": "2018-04-20T20:27:41.961Z",
        "deleted": false,
        "used": false,
        "user": "5a9ac18c7478810ea6c06381"
        }
    ]
    """

    expected_text =
      "The catnip plant contains an oil called hepetalactone which does for cats what marijuana does to some people. Not all cats react to it those that do appear to enter a trancelike state. A positive reaction takes the form of the cat sniffing the catnip, then licking, biting, chewing it, rub & rolling on it repeatedly, purring, meowing & even leaping in the air."

    {:ok, [raw_fact]} = FactParser.decode_facts(json)

    # IO.puts("#{inspect(raw_fact)}")

    assert "2018-04-20T20:27:41.961Z" == raw_fact["createdAt"]
    assert expected_text == raw_fact["text"]
    assert true == raw_fact["status"]["verified"]
  end

  test "fact parses from a valid map" do
    expected_text = "cat fact"

    raw_fact = %{
      "createdAt" => "2018-04-20T20:27:41.961Z",
      "text" => expected_text,
      "status" => %{"verified" => true}
    }

    fact = Fact.new(raw_fact)

    assert ~U[2018-04-20T20:27:41.961Z] == fact.created_at
    assert expected_text == fact.text
    assert true == fact.verified
  end
end
