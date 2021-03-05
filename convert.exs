round = fn coordinate -> Float.round(coordinate, 6) end

convert = fn %{"geo" => linestring, "occurrences" => occurrences} ->
  occurrences = String.to_integer(occurrences)
  {:ok, linestring} = Geo.WKT.decode(linestring)
  [{x1, y1}, {x2, y2}] = linestring.coordinates

  s =
    %{
      "type" => "Feature",
      "geometry" => %{
        "type" => "LineString",
        "coordinates" => [
          [round.(x1), round.(y1)],
          [round.(x2), round.(y2)]
        ]
      },
      "properties" => %{
        "occurrences" => occurrences
      }
    }
    |> Jason.encode!()

  s <> ",\n"
end

years = [2018, 2019, 2020]

output = File.open!("verkehrsmengen_koeln_#{Enum.join(years, "_")}.geojson", [:write, :utf8])
IO.write(output, "{\n\"type\": \"FeatureCollection\",\n\"features\": [\n")

for year <- years do
  File.stream!("verkehrsmengen_koeln_#{year}.csv")
  |> CSV.decode!(headers: true)
  |> Stream.map(convert)
  |> Enum.each(&IO.write(output, &1))
end

IO.write(output, "]\n}")
