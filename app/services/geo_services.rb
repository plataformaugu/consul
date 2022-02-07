require 'json'

module GeoServices
    def get_sector(lat, long)
        file = File.open(File.join(File.dirname(__FILE__), 'UV_KML.geojson'))
        geojson = JSON.load(file)
        feature = get_feature_from_point(geojson['features'], [lat, long])

        if feature
            return feature['properties']['name'].gsub('-', '')
        else
            return ''
        end
    end

    def get_feature_from_point(features, point)
        x = point[1]
        y = point[0]

        found_feature = nil

        for feature in features
            coordinates = feature['geometry']['coordinates'][0][0]
            j = coordinates.length() - 1
            inside = false

            coordinates.each_with_index do |_, i|
                xi = coordinates[i][0]
                xj = coordinates[j][0]
                yi = coordinates[i][1]
                yj = coordinates[j][1]
        
                intersects = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
        
                if intersects
                    inside = !inside
                end
        
                j = (i + 1) - 1
            end

            if inside
                found_feature = feature
            end
        end

        return found_feature
    end
end
