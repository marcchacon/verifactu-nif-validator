module VerifactuNifValidator
  class VerifactuNifBuilder
    attr_reader :contribuyentes
    def initialize
      @contribuyentes = []
    end

    # Add nif to the list to validate
    def self.add_nif(nif, name: nil)
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'A max of 10.000 nifs can be validated at once' if @contribuyentes.size >= 10_000
      @contribuyentes << VerifactuNif.new(nif, name)
    end

    # Builds the XML document
    def self.build
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'No contribuyentes to build' if @contribuyentes.empty?
      VerifactuNifValidator::VerifactuNifXmlBuilder.build(@contribuyentes)
    end

    # Validates one nif
    def self.validar_nif(nif, name: nil)
      @contribuyentes = []
      add_nif(nif, name: name)
      build
    end
  end
end
