require 'savon'
require 'nokogiri'
require 'erb'

require_relative 'aeat-nif-validator/aeat_nif_xml_builder'
require_relative 'aeat-nif-validator/aeat_nif_validator_error'
require_relative 'aeat-nif-validator/aeat_nif_builder'
require_relative 'aeat-nif-validator/contribuyente'
require_relative 'aeat-nif-validator/envio_aeat_nif_validator_service'

require_relative 'aeat-nif-validator/helpers/valida_validator_xsd'
require_relative 'aeat-nif-validator/helpers/xsd_loader'
