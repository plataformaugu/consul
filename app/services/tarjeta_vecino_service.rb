require 'savon'

module TarjetaVecino
    def get_tarjeta_vecino_data(rut)
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

            if result[:mensaje] == 'RUT NO REGISTRADO EN SISTEMA SOCIAL'
                return nil
            end

            return result
        rescue Savon::Error => e
            return nil
        rescue Net::OpenTimeout => e
            return nil
        rescue
            return nil
        rescue Exception => e
            return nil
        end
    end 
end
