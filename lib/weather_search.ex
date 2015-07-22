defmodule WeatherSearch do
  def seek_temps(cities) do 
    # 
    coordinator_pid = spawn(WeatherSearch.Coordinator, :loop, [[], Enum.count(cities)])
    
    cities |> Enum.each(fn(city) ->
      worker_pid = spawn(WeatherSearch.Worker, :loop, [])
      send( worker_pid, {coordinator_pid, city})
    end)
    
  end
end
