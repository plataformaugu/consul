require 'savon'

module TarjetaVecino
    def get_tarjeta_vecino_data(rut)
        client = Savon.client(
        wsdl: 'https://www.lascondesonline.cl/web_service/Ws_DecomTarjeta/ConsultaVecino.asmx?wsdl',
        pretty_print_xml: true,
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
    end
end
