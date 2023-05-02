# Federico Vicentini
# 01 - 05 - 2023
# Download Code RA Data


library(fredr)
fredr_set_key("5946a6a1c79f3fe49bea4be0ef8e82e8")
gdp = fredr(
  series_id = "GDP",
  observation_start = as.Date("1981-01-01"),
  observation_end = as.Date("2020-12-31"),
  frequency = "a",
  units = "pc1",
  aggregation_method = "eop"
)

gdp1 = fredr(
  series_id = "GDP",
  observation_start = as.Date("1981-01-01"),
  observation_end = as.Date("1990-12-31"),
  frequency = "a",
  units = "pc1",
  aggregation_method = "eop"
)

gdp2 = fredr(
  series_id = "GDP",
  observation_start = as.Date("2011-01-01"),
  observation_end = as.Date("2019-12-31"),
  frequency = "a",
  units = "pc1",
  aggregation_method = "eop"
)


gdp = data.frame(gdp)
gdp1 = data.frame(gdp1)
gdp2 = data.frame(gdp2)

deflator = fredr(
  series_id = "A191RI1Q225SBEA",
  observation_start = as.Date("1981-01-01"),
  observation_end = as.Date("2020-12-31"),
  frequency = "a",
  units="lin",
  aggregation_method = "eop"
)

deflator1 = fredr(
  series_id = "A191RI1Q225SBEA",
  observation_start = as.Date("1981-01-01"),
  observation_end = as.Date("1990-12-31"),
  frequency = "a",
  units="lin",
  aggregation_method = "eop"
)

deflator2 = fredr(
  series_id = "A191RI1Q225SBEA",
  observation_start = as.Date("2011-01-01"),
  observation_end = as.Date("2019-12-31"),
  frequency = "a",
  units="lin",
  aggregation_method = "eop"
)

deflator = data.frame(deflator)
deflator1 = data.frame(deflator1)
deflator2 = data.frame(deflator2)

realgdp = gdp
realgdp$value = realgdp$value - deflator$value
mean(realgdp$value)

realgdp1 = gdp1
realgdp1$value = realgdp1$value - deflator1$value
mean(realgdp1$value)

realgdp2 = gdp2
realgdp2$value = realgdp2$value - deflator2$value
mean(realgdp2$value)

plot(realgdp$date, realgdp$value, type="h")
