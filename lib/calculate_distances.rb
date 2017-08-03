require "json"

class Hash
  def symbolize_keys
    self.reduce({}){|h, (k,v)| h[k.to_sym] = v; h}
  end
end

class CalculateDistances
  def select_customers(customers, distance = 100, latitude=53.3393,longitude=-6.2576841)
    point = {latitude: latitude, longitude: longitude}
    print_customers(customers_distance_less_equal(customers, point, distance))
  end

  def print_customers(customers)
    customers.reduce("") do |r, customer|
      r += "#{customer["user_id"]} - #{customer["name"]}\n"
    end
  end

  def customers_distance_less_equal(customers, point, distance)
    customers.select do |customer|
      lat = customer["latitude"].to_f
      lon = customer["longitude"].to_f
      distance_less_and_equal_than(lat, lon, point[:latitude], point[:longitude], distance)
    end.sort_by{|c| c["user_id"]}
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
