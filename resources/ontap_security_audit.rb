# Import API specifics
use 'ontap_base'

resource_name :ontap_security_audit
provides :ontap_security_audit, target_mode: true, platform: 'ontap'

description 'Updates administrative audit settings for GET requests.'

examples <<~DOC
  ontap_security_audit 'Enable auditing' do
    ontapi true
    cli true
    http false
  end
DOC

property :ontapi, [TrueClass, FalseClass],
          description: 'Enable auditing of ONTAP API GET operations.'

property :cli, [TrueClass, FalseClass],
          description: 'Enable auditing of CLI GET Operations.'

property :http, [TrueClass, FalseClass],
          description: 'Enable auditing of HTTP GET Operations.'

rest_api_collection '/api/security/audit'
rest_api_document   '/api/security/audit'

rest_property_map   %w[ontapi cli http]
