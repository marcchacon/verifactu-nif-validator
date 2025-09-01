require 'spec_helper'

RSpec.describe AeatNifValidator::AeatNifBuilder do

  before do
    AeatNifValidator::AeatNifBuilder.class_variable_set(:@@contribuyentes, [])
  end

  describe '#initialize' do

    it "genera un xml de un NIF (validar_nif)" do
      xml = AeatNifValidator::AeatNifBuilder.validar_nif(nif: '99999999R', name: 'ESPANOL ESPANOL JUAN')
      validate_schema = AeatNifValidator::Helpers::ValidaValidatorXSD.execute(xml.root.to_xml)
      expect(validate_schema[:valid]).to be true
    end

    it "genera un xml de un NIF (add_nif)" do
      xml = AeatNifValidator::AeatNifBuilder.add_nif(nif: '99999999R', name: 'ESPANOL ESPANOL JUAN').build
      validate_schema = AeatNifValidator::Helpers::ValidaValidatorXSD.execute(xml.root.to_xml)
      expect(validate_schema[:valid]).to be true
    end

    it "genera un xml de dos NIF (add_nif)" do
      xml = AeatNifValidator::AeatNifBuilder.add_nif(nif: '99999999R', name: 'ESPANOL ESPANOL JUAN')
                                            .add_nif(nif: '55555555K', name: 'Brad Stark').build
      validate_schema = AeatNifValidator::Helpers::ValidaValidatorXSD.execute(xml.root.to_xml)
      expect(validate_schema[:valid]).to be true
    end

    it "salta error al generar un xml sin NIF" do
      expect {AeatNifValidator::AeatNifBuilder.build}.to raise_error(AeatNifValidator::AeatNifValidatorError)
    end

  end

end
