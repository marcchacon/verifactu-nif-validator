module VerifactuNifValidator
  class Contribuyente
    attr_reader :nif, :name

    def initialize(nif, name)
      raise VerifactuNifValidator::VerifactuNifValidatorError, 'NIF must be a 9-character string' if nif.nil? || nif.strip.empty? || nif.length != 9

      raise VerifactuNifValidator::VerifactuNifValidatorError, 'Si el NIF es de persona fisica, el nombre es obligatorio' if name.nil? && nif[-1] =~ /[A-Za-z]/
      @nif = nif
      @name = name
    end
  end
end
