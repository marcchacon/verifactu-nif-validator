require 'savon'
require 'nokogiri'
require 'erb'

require_relative 'verifactu-nif-validator/verifactu-nif-xml-builder'
require_relative 'verifactu-nif-validator/verifactu_nif_validator_error'
require_relative 'verifactu-nif-validator/verifactu_nif_builder'
require_relative 'verifactu-nif-validator/contribuyente'
require_relative 'verifactu-nif-validator/envio_verifactu_nif_validator_service'

require_relative 'verifactu-nif-validator/helpers/valida_validator_xsd'
require_relative 'verifactu-nif-validator/helpers/xsd_loader'
