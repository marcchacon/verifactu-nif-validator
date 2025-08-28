module VerifactuNifValidator
  class VerifactuNifXmlBuilder
    def self.build(contribuyentes)
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'contribuyentes is required' if contribuyentes.nil?
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'contribuyentes must be an array of contribuyentes' unless contribuyentes.is_a?(Array)
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'contribuyentes must not be empty' if contribuyentes.empty?

      # Create the XML document
      xml_document = Nokogiri::XML('<vnif:VNifV2Ent/>')
      root = xml_document.root
      root.add_namespace_definition('vnif', 'http://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/burt/jdit/ws/VNifV2Ent.xsd')
      xml_document.encoding = 'UTF-8'

      contribuyentes.each do |contribuyente|
        agregar_contribuyente(xml_document, contribuyente)
      end

      return xml_document
    end

    private

    def self.agregar_contribuyente(xml_document, contribuyente)
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'xml_document must be an instance of Nokogiri::XML::Document' unless xml_document.is_a?(Nokogiri::XML::Document)
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'contribuyente must be an instance of VerifactuNifValidator::Contribuyente' unless contribuyente.is_a?(VerifactuNifValidator::Contribuyente)

      contribuyente_element = Nokogiri::XML::Node.new('vnif:Contribuyente', xml_document)
      contribuyente_nif_element = Nokogiri::XML::Node.new('vnif:NIF', xml_document)
      contribuyente_nif_element.content = contribuyente.nif
      contribuyente_element.add_child(contribuyente_nif_element)

      if contribuyente.name
        contribuyente_nombre_element = Nokogiri::XML::Node.new('vnif:Nombre', xml_document)
        contribuyente_nombre_element.content = contribuyente.nombre
        contribuyente_element.add_child(contribuyente_nombre_element)
      end

      xml_document.root.add_child(contribuyente_element)
    end
  end
end