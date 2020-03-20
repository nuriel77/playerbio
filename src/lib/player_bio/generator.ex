defmodule PlayerBio.Generator do
  def new() do
    name = Enum.join([name(), surname()], " ")

    %{
      :name => name,
      :age => age(),
      :country => country(),
      :sport => sport()
    }
  end

  @names [
    "Mesut",
    "Yuvraj",
    "Serena",
    "Antoine",
    "Khabib",
    "Tiger",
    "Rafael",
    "LeBron",
    "Fernando"
  ]
  defp name, do: name(@names)
  defp name(names), do: Enum.random(names)

  @surnames [
    "Özil",
    "Singh",
    "Williams",
    "Griezmann",
    "Nurmagomedov",
    "Woods",
    "Nadal",
    "James",
    "Alonso"
  ]
  defp surname, do: surname(@surnames)
  defp surname(surnames), do: Enum.random(surnames)

  @countries ["Germany", "India", "USA", "France", "Russia", "Spain"]
  defp country, do: country(@countries)
  defp country(countries), do: Enum.random(countries)

  @ages 18..40
  defp age, do: age(@ages)
  defp age(ages), do: Enum.random(ages)

  @sports ["Football", "Cricket", "Tennis", "MMA", "Golf", "Basketball"]
  defp sport, do: sport(@sports)
  defp sport(sports), do: Enum.random(sports)
end
