require "minitest/autorun"

require "json"
class CalculateDistances
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

end
