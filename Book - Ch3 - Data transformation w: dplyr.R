# Chapter 3: Data transformation with dplyr

library(tidyverse)
install.packages("nycflights13")
library(nycflights13)

nycflights13::flights
?flights                 
view(nycflights13::flights)

#dplyr basics
filter()
arrange()
mutate()
summarise()
group_by()

Jan_1_nyc_flights <- filter(flights, month == 1, day == 1)
Jan_1_nyc_flights

# brackets around prints & saves the new variable
(dec25 <- filter(flights, month == 12, day == 25))


#using near() for comparisons
?near

sqrt(2) ^ 2 == 2
1/49 * 49 == 1

near(sqrt(2) ^ 2, 2)
near(1/49 * 49, 1)

# using &, | and !
# finding Nov or Dec flights
filter(flights, month == 11 | month == 12)
filter(flights, month %in% c(11, 12))

# WRONG- looks at 11 and 12 like numbers (=TRUE, hence 1, hence Jan)- Finds flight in Jan
filter(flights, month == 11 | 12)


# ! De Morgan's law: !(x & y) is the same as !x | !y
#   DeMorgan's law: !(x | y) same as !x & !y

#Finding flights that were not delayed by more than 2h
filter(flights, !(arr_delay > 120 | dep_delay > 120))

#same as this:
filter(flights, arr_delay <= 120, dep_delay <= 120)

# NA values
(df <- tibble(x = c(1, NA, 3)))
filter(df, x>1)
filter(df, is.na(x) | x > 1)

# Exercises p 49: 1
?flights
filter(flights, arr_delay >= 120)

to_HSTN <- filter(flights, dest == "IAH" | dest == "HOU")
to_HSTN

carriers_United_American_Delta <- filter(flights, 
                                         carrier %in% c("UA", "AA", "DL"))
carriers_United_American_Delta
head(carriers_United_American_Delta)

carriers_United_American_Delta_2 <- filter(flights, 
                                           carrier == "UA" |
                                             carrier == "AA"|
                                             carrier == "DL")
carriers_United_American_Delta_2
head(carriers_United_American_Delta_2)

filter(flights, month %in% c(7, 8, 9))

filter(flights, arr_delay > 120 & dep_delay <= 0)

filter(flights, dep_delay >= 60 & arr_delay <= -30)

filter(flights, dep_time == 2400 | dep_time <= 600)

# exercise 2: between()
?between
filter(flights, between(month, 7, 9))

filter(flights, between(dep_time, 2400, 600))

# exercise 3: missing dep_time
filter(flights, is.na(dep_time))
    #maybe cancelled flights

# exercise 4:  <-
filter(flights, is.na(dep_time) | TRUE)
filter(flights, is.na(dep_time) | FALSE)
filter(flights, is.na(dep_time) | TRUE)


# arrange()
arrange(flights, year, month, day)

arrange(flights, desc(arr_delay))

#exercises p 51: 1.
filter(flights, is.na(dep_time))
summary(flights)
arrange(flights, dep_time) %>%
  tail()

arrange(flights, desc(is.na(dep_time)), dep_time)

# exercise 2
arrange(flights, desc(dep_delay))
arrange(flights, desc(is.na(dep_delay)))
arrange(flights, dep_delay)

# exercise 3
arrange(flights, air_time)
head(arrange(flights, air_time))

#alternatively:
head(arrange(flights, desc(distance / air_time)))

# exercise 4
arrange(flights, distance)
arrange(flights, desc(distance))

# select()
select(flights, year, month, day)
select(flights, year:day)

#excluding using select()
select(flights, -(year:day))

#useful functions
starts_with("abc")
ends_with("xyz")
contains("ijk")
matches("(.)\\1")
num_range("x", 1:3)

# e.g.
select(flights, starts_with("dep"))
select(flights, ends_with("delay"))
select(flights, contains("_"))
select(flights, matches("_time"))
select(flights, num_range("arr", 1:200)) ???

# rename()  ???
?rename()
rename(flights, tail_num = tailnum)
  
# everything()
select(flights, time_hour, air_time, everything())

# exercises p54: 1
flights
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, 4, 6, 7, 9)
select(flights, one_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))

        variables <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, one_of(variables))
select(flights, starts_with("dep"), starts_with("arr"))
select(flights, ends_with("time"), ends_with("delay"))  - # WRONG
select(flights, matches("^(dep|arr)_(time|delay)$"))

# exercises p 54: 2
select(flights, dep_time, dep_time)

# exercise 3: one_of() only selects strings, it is unknown if they are variables or col names

?one_of
select(flights, one_of("dep_time", "arr_time", "year"))

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

# exercise 4
select(flights, contains("TIME"))

select(flights, contains("time", ignore.case = FALSE))
?select


# mutate() - adding new columns
view(flights)

flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
view(flights_sml)

mutate(flights_sml, 
       gain = arr_delay - dep_delay, 
       speed = distance / air_time * 60)
view(flights_sml)

mutate(flights_sml, 
       gain = arr_delay - dep_delay,
       hours = air_time / 60, 
       gain_per_hour = gain / hours)

# transmute() - only keeping new/specified columns
transmute(flights, arr_time,
          gain = arr_delay - dep_delay, 
          hours = air_time / 60, 
          gain_per_hour = gain / hours)


# Useful creation functions
%/% = integer division
%% = remainder
transmute(flights, dep_time, hour = dep_time %/% 100, minute = dep_time %% 100)

# logs
log2()

# offsets
lead()
lag()
  # example
x <-  1:10
x
lag(x)
lead(x)

#cumulative and rolling aggregates
running sum:      cumsum()
running products: cumprod()
running min:      cummin()
running max:      cummax()
cumulative means: cummean()
# useful package: RcppRoll

cumsum(x)
cummean(x)

# logical comparisons: <, <=, >, >=, !=

# ranking
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))

row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

# exercises p58: 1
select(flights, dep_time, sched_dep_time)
mutate(flights, 
       dep_time = ((dep_time %/% 100) * 60 + dep_time %% 100), 
       sched_dep_time = (sched_dep_time %/% 100) * 60 + sched_dep_time %% 100)

# exercise 2:
mutate(flights, air_time, arr_time, dep_time, 
          new_time = arr_time - dep_time,
          new_correct_time = (new_time %/% 100) * 60 + new_time %% 100,
          new_correct_air_time = (air_time %/% 100) * 60 + air_time %% 100)

flights_airtime <- mutate(flights,
                          air_time = (air_time %/% 100) * 60 + air_time %% 100,
                          arr_time = (arr_time %/% 100) * 60 + arr_time %% 100,
                          dep_time = (dep_time %/% 100) * 60 + dep_time %% 100,
                          arr_dep_times = arr_time - dep_time,
                          air_time_diff = air_time - arr_dep_times)
select(flights_airtime, air_time, arr_time, dep_time, arr_dep_times, air_time_diff)

nrow(filter(flights_airtime, air_time_diff != 0))
nrow(flights_airtime, air_time_diff !=0)

# exersice 3:
select(flights, dep_time, sched_dep_time, dep_delay)
transmute(flights, sched_dep_time, dep_delay, dep_time, is_same = sched_dep_time + dep_delay )

# exercise 4:
?min_rank
dep_delay = flights$dep_delay
dep_delay
min_rank(desc(dep_delay), 10)

  # answers using the answer site
#1
flight_delays <- arrange(flights, desc(dep_delay))
flight_delays <- slice(flight_delays, 1:10)
select(flight_delays,  month, day, carrier, flight, dep_delay)

#2
flights_delayed <- mutate(flights, 
                          dep_delay_min_rank = min_rank(desc(dep_delay)),
                          dep_delay_row_number = row_number(desc(dep_delay)),
                          dep_delay_dense_rank = dense_rank(desc(dep_delay))
)
flights_delayed <- filter(flights_delayed, 
                          !(dep_delay_min_rank > 10 | dep_delay_row_number > 10 |
                              dep_delay_dense_rank > 10))
flights_delayed <- arrange(flights_delayed, dep_delay_min_rank)
print(select(flights_delayed, month, day, carrier, flight, dep_delay, 
             dep_delay_min_rank, dep_delay_row_number, dep_delay_dense_rank), 
      n = Inf)

# 3 - not working maybe needs a diff mackage for slice_max
flights_delayed3 <- slice_max(flights, dep_delay, n = 10)
select(flights_delayed3,  month, day, carrier, flight, dep_delay)

# exercise 5
1:3 + 1:10 # = 1+1, 2+2, 3+3, 1+4, 2+5, 3+6, 1+7, 2+8, 3+9, 1+10
1:3
1:10
1:2+1:2

# exercise 6
??trig


# summarize() - makes grouped summaries
by_day <- group_by(flights, year, month, day)
by_day
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

# multiple operations with the Pipe
    # long way
by_dest <- group_by(flights, dest)

delay <- summarize(by_dest, 
                   count =n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
                   )
delay <- filter(delay, count> 20 , dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# shorter way
delays <- flights %>%
  group_by(dest) %>%
  summarize(
    count = n(), 
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")

    # 3 steps involved in this pipeline: grouping, summarizing, filtering 

# removing cancelled flights: NA values represent cancelled flights
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))


# Counts - including n number is good practice to know your sample number
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay)
  )

 # shows that some planes have *average* delay of 5h
ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

# more nuanced results
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)
 # with this plot ^ we see that as sample size increases, variability decreases
# meaning that when there are a few flights, there is greater variation in average delay

# removing the groups with the smallest numbers of observations:
    # the pattern clears out, and less extreme variation
delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)


install.packages("Lahman", repos="http://R-Forge.R-project.org")

batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
batters

batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)

# people with the best batting averages are lucky, not skilled
batters %>%
  arrange(desc(ba))

# useful summary functions
mean()
median()   # 50% is above x, and 50% is below

# better practice to combine aggregation with logical subsetting:
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    # average delay
    avg_delay1 = mean(arr_delay), 
    # average positive delay
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

# measures of spread
sd()
IQR()
mad()   # median absolute deviation

# why is distance to some destinations more variable than to others?
not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

# measures of rank
min()
quantile(x, 0.25)   # this cmd will find a value of x that is >25% of the values and <75%
max()

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first = min(dep_time),
    last = max(dep_time))
  )

# measures of position
first()
nth(x, 2)
last()

# first and last departure of each day:
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

# these functions are complementary to filtering on ranks
not_cancelled %>%
  group_by( year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

# Counts
n()
sum(!is.na(x))
n_distinct(x)
?count()

#which desitantions have the most carriers?
not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

# optionally, you can provide a weight variable using count()
not_cancelled %>%
  count(tailnum, wt = distance)
      # counts total number of miles a plane flew

# counts and proportions of logical values 
sum(x > 10)
mean(y == 0)

  # how many flights left before 5am
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

  # what proportion of flights are delayed by more than an hour
not_cancelled %>% 
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))


# grouping multiple variables
daily <- group_by(flights, year, month, day)

per_day <- summarize(daily, flights = n())
per_day

(per_month <- summarize(per_day, flights = sum(flights)))

(per_year <- summarize(per_month, flights = sum(flights)))

  # ! you cannot do progressive roll-up summaries with rank-based stats e.g. the median
  # the overall median is not the groupwise median

# Ungrouping
daily %>%
  ungroup() %>%
  summarize(flights = n())    # no longer grouped by date. now shows all flights

flights


# grouped mutates (and filters)
  # a grouped filter is a grouped mutate followed by an ungrouped filter
  # functions that work nturally in grouped mutates and filters are known as 
  # window functions, vs summary functions - used for summaries

  # useful window functions in: 'vignette("window-functions")'

flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

    # bigger than a threshold
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)
popular_dests

popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)



# EXERCISES??? p72, 75-76




