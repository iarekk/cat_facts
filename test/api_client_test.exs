defmodule ApiClientTest do
  alias CatFacts.ApiClient
  use ExUnit.Case

  doctest CatFacts.ApiClient

  test "valid json handled" do
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

    {code, [fact]} = ApiClient.parse_response({:ok, %{status_code: 200, body: json}})

    assert :ok == code
    assert ~U[2018-04-20T20:27:41.961Z] == fact.created_at
  end

  test "invalid json handled" do
    {code, err} = ApiClient.parse_response({:ok, %{status_code: 200, body: "asdf"}})

    assert :error == code
    assert %Poison.ParseError{data: "asdf", skip: 0, value: nil} == err
  end

  test "bad status code" do
    {code, err} = ApiClient.parse_response({:ok, %{status_code: 419, body: nil}})

    assert :error == code
    assert "Bad status code 419" == err
  end
end
