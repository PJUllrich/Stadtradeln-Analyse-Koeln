# Köln Stadtgebiet Bounding Box
[min_x1, min_y1, max_x2, max_y2] = [6.748277, 50.828117, 7.167895, 51.088701]

# Regex matching the edges of the bounding box
r = ~r/(6\.[0-9]{7} (50\.|51\.)|7\.[0-9]{7} (50\.|51\.))/

filter_fn = fn [geo, _occurrences] ->
  if Regex.match?(r, geo) do
    [_linestring | coordinates] = String.split(geo, ~r/[() ,]/, trim: true)

    [x1, y1, x2, y2] = Enum.map(coordinates, fn xy -> xy |> Float.parse() |> elem(0) end)

    x1 >= min_x1 && y1 >= min_y1 && x2 <= max_x2 && y2 <= max_y2
  else
    false
  end
end

year = 2019

output = File.open!("verkehrsmengen_koeln_#{year}.csv", [:write, :utf8])
IO.write(output, "geo,occurrences\n")

File.stream!("verkehrsmengen_#{year}.csv")
|> CSV.decode!()
|> Stream.filter(filter_fn)
|> CSV.encode()
|> Enum.each(&IO.write(output, &1))
