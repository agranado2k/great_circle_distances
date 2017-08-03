require "minitest/autorun"

require "json"

class Hash
  def symbolize_keys
    self.reduce({}){|h, (k,v)| h[k.to_sym] = v; h}
  end
end

class CalculateDistances
  def customers_distance_less_equal(customers, point, distance)
    result = []
    customers.each do |customer|
      lat = customer["latitude"].to_f
      lon = customer["longitude"].to_f
      result.push(customer) if distance_less_and_equal_than(lat, lon, point[:latitude], point[:longitude], distance)
    end
    result
  end

  def distance_less_and_equal_than(lat1, lon1, lat2, lon2, distance)
    great_circle_distance(lat1, lon1, lat2, lon2) <= distance
  end

  def great_circle_distance(lat1, lon1, lat2, lon2)
    lat1_in_radians = to_radians(lat1)
    lat2_in_radians = to_radians(lat2)
    delta_lon = to_radians(lon2 - lon1)

    (Math::acos(
      Math::sin(lat1_in_radians)*Math::sin(lat2_in_radians) +
      Math::cos(lat1_in_radians)*Math::cos(lat2_in_radians)*Math::cos(delta_lon)
    )*earth_radius).round(2)
  end

  def to_radians(degrees)
    degrees*(Math::PI/180)
  end

  def earth_radius
    6_371
  end
end

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
    customers = JSON.parse(File.read("customers.json"))
    reference_point = {latitude: 53.3393, longitude: -6.2576841}
    distance = 100
    selected_customers = @cd.customers_distance_less_equal(customers, reference_point, distance)

    assert_equal 16, selected_customers.size
  end
end
