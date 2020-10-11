

## lon = x, lat = y

library(dplyr)
library(data.table)
library(sf)

get_points <- function(data) {
  print(data)
  print(1)
  x <- as.numeric(data[2])
  y <- as.numeric(data[1])
  st_point(c(x, y))
}

ships2 <- ships[, ..to_keep]
ships3 <- ships2[SHIPNAME == "KAROLI",]
ships3 <- ships3[, x := .I]

#ships3 <- ships2[1:3,]

ships4 <- ships3[, .(LAT, LON, to = .(st_point(c(LON, LAT)))), by = x]


ships4 <- ships4[, from := c(to[1], to[1:(.N-1)])]


ships4 <- ships4[, distance := st_distance(from[[1]], to[[1]]), by = x]

ships4 <- ships4[, .(LAT, LON, from, to, distance)]
#ships5 <- ships4[, .(from2 = st_point(from)), by = x]
ships4
ships4


s <- st_sfc(ships4$from[[5]], ships4$to[[5]], crs = 4326)
st_crs(s) <- 4236

st_distance(s)

ships2 %>% 
  rowwise() %>% 
  mutate(from = get_points(.))

ps <- apply(ships2[1:5,], 1, get_points)

p1 <- get_points(ships2, 1)
p5 <- get_points(ships2, 5)

p100 <- get_points(ships2, 100)

s <- st_sfc(p1, p5, p100)
st_crs(s) <- 4326

d <- st_distance(s, which = "Great Circle")

d[,1]

max(d)

p11 <- st_point(c(as.numeric(ships2[1,2]), as.numeric(ships2[1,1])))

p12 <- st_point(c(as.numeric(ships2[100,2]), as.numeric(ships2[100,1])))

s2 <- st_sfc(p11, p12)
st_crs(s2) <- 4326

st_distance(p11, p12)
