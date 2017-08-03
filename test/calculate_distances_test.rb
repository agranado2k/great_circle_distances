require "minitest/autorun"

require_relative "../lib/calculate_distances"

class CalculateDistancesTest < Minitest::Test
  def setup
    @cd = CalculateDistances.new
  end

  def test_convert_degrees_to_radians
    degrees = 20
    radians = 0.3490658503988659

    assert_equal radians, @cd.to_radians(degrees)
  end

  def test_earth_radius_in_km
    assert_equal 6_371, @cd.earth_radius
  end

  def test_calculate_great_circle_distance_in_km
    lat1, lon1 = -21.7208486,-43.0592113
    lat2, lon2 = -22.9568571,-43.1809198
    distance = 138.01

    assert_equal distance, @cd.great_circle_distance(lat1, lon1, lat2, lon2)
  end

  def test_distance_less_and_equal_than_100_km
    lat1, lon1 = 53.3393,-6.2576841
    lat2, lon2 = 52.986375,-6.043701
    km_100 = 100

    assert @cd.distance_less_and_equal_than(lat1, lon1, lat2, lon2, km_100)
  end

  def test_distance_greater_than_100_km
    lat1, lon1 = 53.3393,-6.2576841
    lat2, lon2 = 51.92893,-10.27699
    km_100 = 100

    refute @cd.distance_less_and_equal_than(lat1, lon1, lat2, lon2, km_100)
  end

  def test_select_customers_that_are_less_than_100_km
    customers = [
      {"latitude" => "51.92893", "user_id" => 1, "name" => "Alice Cahill", "longitude" => "-10.27699"},
      {"latitude" => "53.761389", "user_id" => 30, "name" => "Nick Enright", "longitude" => "-7.2875"},
      {"latitude" => "53.74452", "user_id" => 29, "name" => "Oliver Ahearn", "longitude" => "-7.11167"}
    ]
    reference_point = {latitude: 53.3393, longitude: -6.2576841}
    distance = 100
    selected_customers = [
       {"latitude" => "53.74452", "user_id" => 29, "name" => "Oliver Ahearn", "longitude" => "-7.11167"},
       {"latitude" => "53.761389", "user_id" => 30, "name" => "Nick Enright", "longitude" => "-7.2875"}
    ]

    assert_equal selected_customers, @cd.customers_distance_less_equal(customers, reference_point, distance)
  end

  def test_select_customers_from_file
    file = "customers.json"

    assert_equal 16, @cd.select_customers(file).size
  end
end
