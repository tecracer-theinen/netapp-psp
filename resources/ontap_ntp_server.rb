# Import API specifics
use 'ontap_base'

resource_name :ontap_ntp_server
provides :ontap_ntp_server, target_mode: true, platform: 'ontap' # , platform_version_min: '9.7'

description 'Validates the provided external NTP time server for usage and configures ONTAP so that all nodes in the cluster use it.'

property :server, String,
          name_property: true,
          description: 'NTP server host name, IPv4, or IPv6 address.'

property :version, [Symbol, String],
          default: :auto,
          equal_to: %i[3 4 auto],
          coerce: proc { |x| x.to_sym },
          description: 'NTP protocol version for server. Valid versions are :3, :4, or :auto.'

rest_api_collection '/api/cluster/ntp/servers'
rest_api_document   '/api/cluster/ntp/servers?server={server}?fields=*'

rest_property_map   %w[server version]
