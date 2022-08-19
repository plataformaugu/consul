require 'savon'

module TarjetaVecino
    def get_tarjeta_vecino_data(rut)
        final_result = {
            :has_tarjeta_vecino => false,
            :is_tarjeta_vecino_active => false,
            :neighbor_type => NeighborType.find_by(name: 'Registrado sin Tarjeta Vecino'),
            :tarjeta_vecino_code => nil,
            :tarjeta_vecino_start_date => nil,
            :data => {},
        }

        url = URI("https://idfbfafxhk.execute-api.us-west-2.amazonaws.com/webservicelc/validar/v2?apikey=pxlcb34f454c279ef21eb4311503f9ce9e01lof0f&secret=sk4c8582584a3a2k32bd&rut=#{rut}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        response = https.request(request)

        begin
            if response.kind_of? Net::HTTPSuccess
                result = JSON.parse(response.body)['vecino']

                if result.fetch('estado', nil) == 'NO_VIGENTE'
                    final_result[:has_tarjeta_vecino] = true
                    final_result[:is_tarjeta_vecino_active] = false
                elsif result.fetch('estado', nil) == 'VIGENTE'
                    final_result[:status] = true
                    final_result[:has_tarjeta_vecino] = true
                    final_result[:is_tarjeta_vecino_active] = true
                    final_result[:tarjeta_vecino_code] = result['cod_tarjeta']
                    final_result[:tarjeta_vecino_start_date] = result['fecha_incorporacion'].to_date
                    final_result[:data] = result

                    if result.fetch('tipo_vecino', nil) == 'Residente'
                        final_result[:neighbor_type] = NeighborType.find_by(name: 'Vecino Residente Las Condes')
                    else
                        final_result[:neighbor_type] = NeighborType.find_by(name: 'Vecino Flotante Las Condes')
                    end
                end
            end
        rescue
            return final_result
        rescue Exception
            return final_result
        end

        return final_result
    end 
end
