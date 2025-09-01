module AeatNifValidator
  class Contribuyente
    attr_reader :nif, :name

    def initialize(nif, name = nil)
      raise AeatNifValidator::AeatNifValidatorError, 'NIF must be a 9-character string' if nif.nil? || nif.strip.empty? || nif.length != 9

      raise AeatNifValidator::AeatNifValidatorError, 'Si el NIF es de persona fisica, el nombre es obligatorio' if name.nil? && nif[-1] =~ /[A-Za-z]/
      @nif = nif
      @name = name
    end
  end
end
