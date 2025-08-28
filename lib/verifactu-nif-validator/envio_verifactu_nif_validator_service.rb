module VerifactuNifValidator
  class EnvioVerifactuNifValidatorService

    URL = 'https://www1.agenciatributaria.gob.es/wlpl/BURT-JDIT/ws/VNifV2SOAP'

    # Envia un registro de facturación a Verifactu
    # @param reg_factu_xml [String] XML del registro de facturación
    # @param client_cert [String] Certificado del cliente en formato PEM
    # @param client_key [String] Clave privada del cliente en formato PEM
    # @param cert_password [String, nil] Contraseña del certificado (opcional)
    #
    def send_verifactu(reg_factu_xml:, certificado_sello: , client_cert:, client_key:, cert_password: nil)

      # Validación del XML
      if reg_factu_xml.nil? || reg_factu_xml.empty?
        raise VerifactuNifValidator::VerifactuNifValidatorError, 'XML del registro de facturación no puede estar vacío'
      end

      #validate_schema = validate_schema(reg_factu_xml)
      #unless validate_schema[:valid]
      #  raise VerifactuNifValidator::VerifactuNifValidatorError, "El XML del registro de facturación no es válido según el esquema XSD: "\
      #                       "#{validate_schema[:error_type]} - #{validate_schema[:errors].join(', ')}"
      #end

      # Construcción del request SOAP
      request_str = build_soap_request(reg_factu_xml)

      # Envío a Verifactu
      send_request(url: URL,
                   xml: request_str,
                   client_cert: client_cert,
                   client_key: client_key,
                   cert_password: cert_password)


    end

    private

    #
    # Sends a request to the Verifactu service using Savon
    # @param url [String] URL del servicio Verifactu
    # @param xml [String] XML del registro de facturación
    # @param client_cert [String] Certificado del cliente en formato PEM
    # @param client_key [String] Clave privada del cliente en formato PEM
    # @param cert_password [String, nil] Contraseña del certificado (opcional)
    # @return [Hash] Resultado de la petición
    #
    # @example
    #   send_request(url: 'https://example.com/soap',
    #                xml: '<xml>...</xml>',
    #                client_cert: '-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----',
    #                client_key: '-----BEGIN RSA PRIVATE KEY----- ... -----END RSA PRIVATE KEY-----',
    #                cert_password: 'password')
    #
    # @return [Hash] Resultado de la petición con claves :result, :body, :fault, :http_code, :error, :backtrace
    #
    # @raise [Verifactu::VerifactuError] Si el XML está vacío o si el entorno no es válido
    #
    # @raise [Savon::SOAPFault] Si hay un error en la respuesta SOAP
    # @raise [Savon::HTTPError] Si hay un error HTTP al hacer la petición
    # @raise [StandardError] Si ocurre cualquier otro error durante la petición
    #
    def send_request(url:, xml:, client_cert:, client_key:, cert_password: nil)

      client = build_savon_client(url: url,
                                  client_cert: client_cert,
                                  client_key: client_key,
                                  cert_password: cert_password)

      begin
        response = client.call(
          :verifactu,
          xml: xml
        )

        return {
          result: :ok,
          body: response.body
        }

      rescue Savon::SOAPFault => e
        return {
          result: :error_soap_fault,
          fault: e.to_hash
        }

      rescue Savon::HTTPError => e
        return {
          result: :error_http,
          http_code: e.http.code,
          body: e.http.body
        }

      rescue => e
        return {
          result: :error_exception,
          error: e.message,
          backtrace: e.backtrace
        }
      end


    end

    # Builds a Savon client for the Verifactu service
    # @param url [String] URL del servicio Verifactu
    # @param client_cert [String] Certificado del cliente en formato PEM
    # @param client_key [String] Clave privada del cliente en formato PEM
    # @param cert_password [String, nil] Contraseña del certificado (opcional)
    # @return [Savon::Client] Cliente Savon configurado
    #
    # @raise [Verifactu::VerifactuError] Si el certificado o la clave están vacíos
    #
    # @example
    #   client = build_savon_client(
    #     url: 'https://example.com/soap',
    #     client_cert: '-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----',
    #     client_key: '-----BEGIN RSA PRIVATE KEY----- ... -----END RSA PRIVATE KEY-----',
    #     cert_password: 'password'
    #   )
    def build_savon_client(url:, client_cert:, client_key:, cert_password: nil)

      cert = OpenSSL::X509::Certificate.new(client_cert)
      key = if cert_password && !cert_password.empty?
              OpenSSL::PKey.read(client_key, cert_password)
            else
              OpenSSL::PKey::RSA.new(client_key)
            end

      Savon.client(
        endpoint: url,
        namespace: "http://schemas.xmlsoap.org/soap/envelope/",
        soap_version: 1,
        ssl_cert: cert,
        ssl_cert_key: key,
        ssl_verify_mode: :peer,
        log: true,
        log_level: :debug,
        pretty_print_xml: true,
        convert_request_keys_to: :none,
        headers: {
          "Content-Type" => "text/xml;charset=UTF-8"
        }
      )

    end

    #
    #
    #
    def validate_schema(registro_xml)

      raise "Implement this method in a subclass"

    end

    #
    # Builds the SOAP request for Verifactu
    # @param xml [String] XML del registro de envío a Verifactu
    # @return [String] SOAP request
    #
    def build_soap_request(xml)

      message = <<-SOAP
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:vnif="http://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/burt/jdit/ws/VNifV2Ent.xsd">
        <soapenv:Header/>
        <soapenv:Body>
          #{xml}
        </soapenv:Body>
      </soapenv:Envelope>
    SOAP

    return message.strip

    end

  end
end
