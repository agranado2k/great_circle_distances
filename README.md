## Mission

We have some customer records in a text file (customers.json) -- one
customer per line, JSON-encoded. We want to invite any customer within
100km of our Dublin office for some food and drinks on us.

Write a program that will read the full list of customers and output the
names and user ids of matching customers (within 100km), sorted by User
ID (ascending).
* You can use the first formula from [this Wikipedia
  article](https://en.wikipedia.org/wiki/Great-circle_distance) to
calculate distance. Don't forget, you'll need to convert degrees to
radians.
* The GPS coordinates for our Dublin office are 53.3393,-6.2576841.
* You can find the Customer list
  [here](https://gist.github.com/brianw/19896c50afa89ad4dec3).

## How to test

Execute:
```
ruby test/calculate_distances_test.r
```

## How to run

Execute:
```
./bin/intercon customers.json
```

or

```
ruby ./bin/intercon customers.json
```

## Result
```
4 - Ian Kehoe
5 - Nora Dempsey
6 - Theresa Enright
8 - Eoin Ahearn
11 - Richard Finnegan
12 - Christina McArdle
13 - Olive Ahearn
15 - Michael Ahearn
17 - Patricia Cahill
23 - Eoin Gallagher
24 - Rose Enright
26 - Stephen McArdle
29 - Oliver Ahearn
30 - Nick Enright
31 - Alan Behan
39 - Lisa Ahearn
```
