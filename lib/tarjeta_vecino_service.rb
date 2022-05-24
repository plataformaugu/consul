require 'savon'

module TarjetaVecino
    def get_tarjeta_vecino_data(rut)
        final_result = {
            :has_tarjeta_vecino => false,
            :is_tarjeta_vecino_active => false,
            :neighbor_type => NeighborType.find_by(name: 'Registrado sin Tarjeta Vecino'),
            :data => {},
        }

        begin
            client = Savon.client(
                wsdl: 'https://www.lascondesonline.cl/web_service/Ws_DecomTarjeta/ConsultaVecino.asmx?wsdl',
                pretty_print_xml: true,
                open_timeout: 15,
                read_timeout: 15,
            )
            response = client.call(
                :consulta_estado_tarjeta,
                xml: '<?xml version="1.0" encoding="utf-8"?>
                    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
                    <soap:Body>
                <ConsultaEstadoTarjeta xmlns="http://tempuri.org/">
                    <RutVecino>%s</RutVecino>
                    <RutUsuario>15489428-4</RutUsuario>
                </ConsultaEstadoTarjeta>
                    </soap:Body>
                    </soap:Envelope>' % rut,
            )
            result = response.body[:consulta_estado_tarjeta_response][:consulta_estado_tarjeta_result]

            if result[:mensaje].nil?
                final_result[:status] = true
                final_result[:has_tarjeta_vecino] = true
                final_result[:is_tarjeta_vecino_active] = true
                final_result[:data] = result

                if result[:numero_tarjeta].to_s.start_with?('2', '9')
                    final_result[:neighbor_type] = NeighborType.find_by(name: 'Vecino Residente Las Condes')
                elsif result[:numero_tarjeta].to_s[0].to_i >= 3
                    final_result[:neighbor_type] = NeighborType.find_by(name: 'Vecino Flotante Las Condes')
                end
            elsif result[:mensaje].kind_of?(String)
                if result[:mensaje].include? 'NO VIGENTE'
                    final_result[:has_tarjeta_vecino] = true
                    final_result[:is_tarjeta_vecino_active] = false
                end
            end

            return final_result
        rescue Savon::Error => e
            return final_result
        rescue Net::OpenTimeout => e
            return final_result
        rescue
            return final_result
        rescue Exception => e
            return final_result
        end
    end 
end
