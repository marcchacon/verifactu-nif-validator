module VerifactuNifValidator
  class VerifactuNifBuilder

    # Add nif to the list to validate
    def self.add_nif(nif, name: nil)
      @@contribuyentes ||= []
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'A max of 10.000 nifs can be validated at once' if @@contribuyentes.size >= 10_000
      @@contribuyentes << Contribuyente.new(nif, name)
      self
    end

    # Builds the XML document
    def self.build
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'No contribuyentes to build' if @@contribuyentes.empty?
      VerifactuNifValidator::VerifactuNifXmlBuilder.build(@@contribuyentes)
    end

    # Validates one nif
    def self.validar_nif(nif:, name: nil)
      add_nif(nif, name: name)
      build
    end

  end
end
