defmodule WeatherSearch.Coordinator do
  
  def loop(results\\[], expected_results) do
    receive do
      {:ok, result} -> 
        new_results = [result|results]
        if expected_results == Enum.count(new_results), do: send(self, :exit)
        loop(new_results, expected_results)
      :exit -> 
        final = results |> Enum.sort |> Enum.join(", ")
        IO.puts final
      _ ->  loop(results, expected_results)
    end
  end
end