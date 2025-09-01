require 'spec_helper'

RSpec.describe AeatNifValidator::Contribuyente do

  describe '#initialize' do

    it "valida un nif de ejemplo" do
      AeatNifValidator::Contribuyente.new('99999999R', 'ESPANOL ESPANOL JUAN')
    end

    it "valida un nif de persona juridica sin nombre" do
      AeatNifValidator::Contribuyente.new('R99999999')
    end

    it "valida un nif de persona juridica con nombre" do
      AeatNifValidator::Contribuyente.new('R99999999', 'ESPANOL ESPANOL JUAN')
    end

    it "salta error al crear un nif de persona fisica sin nombre" do
      expect {AeatNifValidator::Contribuyente.new('99999999R')}.to raise_error(AeatNifValidator::AeatNifValidatorError)
    end

    it "salta error al introducir un nif que no sea de 9 caracteres" do
      expect {AeatNifValidator::Contribuyente.new('9R', 'ESPANOL ESPANOL JUAN')}.to raise_error(AeatNifValidator::AeatNifValidatorError)
    end
  end

end
