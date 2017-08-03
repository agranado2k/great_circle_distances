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
