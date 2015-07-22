defmodule WeatherSearch.Worker do

  def fetch_temp(location) do
    result = api_search_url(location) |> HTTPoison.get |> parse_response
    case result do
      {:ok, temp } -> "#{location} #{temp} Celcius"
      {:error, _} -> "#{location} not found"
    end
  end

  defp api_search_url( location ) do
    _location = URI.encode(location)
    url = "http://api.openweathermap.org/data/2.5/weather?q=#{_location}"
    IO.puts url
    url
  end

  defp parse_response( {:ok, %HTTPoison.Response{body: body, status_code: 200}} ) do
    body |> JSON.decode! |> compute_temp
  end

  defp parse_response( {:ok, %HTTPoison.Response{body: body, status_code: 500}} ) do
    parse_response
  end

  defp parse_response( ) do
    {:error, :false}
  end


  defp compute_temp( data ) do
    IO.puts data["name"]
    try do 
      temp = (data["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue 
      _ -> {:error, :notcomputed}
    end
  end

  def loop do 
    receive do 
      { s_pid, location } -> send( s_pid, {:ok, fetch_temp( location ) })
      { s_pid, _ }  -> send( s_pid, "Unknown message" )
    end
    loop
  end

end