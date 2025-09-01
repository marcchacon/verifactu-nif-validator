module AeatNifValidator
  class AeatNifBuilder

    # Add nif to the list to validate
    def self.add_nif(nif:, name: nil)
      @@contribuyentes ||= []
      raise AeatNifValidator::AeatNifValidatorError, 'A max of 10.000 nifs can be validated at once' if @@contribuyentes.size >= 10_000
      @@contribuyentes << Contribuyente.new(nif, name)
      self
    end

    # Builds the XML document
    def self.build
      @@contribuyentes ||= []
      raise AeatNifValidator::AeatNifValidatorError, 'No contribuyentes to build' if @@contribuyentes.empty?
      AeatNifValidator::AeatNifXmlBuilder.build(@@contribuyentes)
    end

    # Validates ONE
    def self.validar_nif(nif:, name: nil)
      add_nif(nif: nif, name: name)
      build
    end

  end
end
