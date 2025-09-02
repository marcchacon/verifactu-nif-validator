module AeatNifValidator
  class AeatNifXmlBuilder
    #
    # Builds an XML document from an array of contribuyentes
    # @param contribuyentes [Array<AeatNifValidator::Contribuyente>] the array of contribuyentes
    # @return [Nokogiri::XML::Document] the generated XML document
    #
    def self.build(contribuyentes)
      raise AeatNifValidator::AeatNifValidatorError, 'contribuyentes is required' if contribuyentes.nil?
      raise AeatNifValidator::AeatNifValidatorError, 'contribuyentes must be an array of contribuyentes' unless contribuyentes.is_a?(Array)
      raise AeatNifValidator::AeatNifValidatorError, 'contribuyentes must not be empty' if contribuyentes.empty?

      # Create the XML document
      xml_document = Nokogiri::XML('<vnif:VNifV2Ent/>')
      root = xml_document.root
      root.add_namespace_definition('vnif', 'http://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/burt/jdit/ws/VNifV2Ent.xsd')
      root.add_namespace_definition('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      root['xsi:schemaLocation'] = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/burt/jdit/ws/VNifV2Ent.xsd VNifV2Ent.xsd'
      xml_document.encoding = 'UTF-8'

      contribuyentes.each do |contribuyente|
        agregar_contribuyente(xml_document, contribuyente)
      end

      return xml_document
    end

    private

    # Adds a contribuyente to the XML document
    def self.agregar_contribuyente(xml_document, contribuyente)
      raise AeatNifValidator::AeatNifValidatorError, 'xml_document must be an instance of Nokogiri::XML::Document' unless xml_document.is_a?(Nokogiri::XML::Document)
      raise AeatNifValidator::AeatNifValidatorError, 'contribuyente must be an instance of AeatNifValidator::Contribuyente' unless contribuyente.is_a?(AeatNifValidator::Contribuyente)

      contribuyente_element = Nokogiri::XML::Node.new('vnif:Contribuyente', xml_document)
      contribuyente_nif_element = Nokogiri::XML::Node.new('vnif:Nif', xml_document)
      contribuyente_nif_element.content = contribuyente.nif
      contribuyente_element.add_child(contribuyente_nif_element)

      if contribuyente.name
        contribuyente_name_element = Nokogiri::XML::Node.new('vnif:Nombre', xml_document)
        contribuyente_name_element.content = contribuyente.name
        contribuyente_element.add_child(contribuyente_name_element)
      end

      xml_document.root.add_child(contribuyente_element)
    end
  end
end
