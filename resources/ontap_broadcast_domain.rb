# Import API specifics
use 'ontap_base'

resource_name :ontap_broadcast_domain

provides :ontap_broadcast_domain, target_mode: true, platform: 'ontap'

description 'Creates a new broadcast domain.'

property :name, String,
          name_property: true,
          description: 'Name of the broadcast domain, scoped to its IPspace.'

property :ipspace, String,
          description: 'IPspace name.'

property :mtu, [Integer, String],
          coerce: proc { |x| x.is_a?(Integer) ? x : x.to_i },
          description: 'Maximum transmission unit, largest packet size on this network.'

property :ports, [Array, String],
          coerce: proc { |x| Array(x) },
          description: 'Ports that belong to the broadcast domain.'

rest_api_collection '/api/network/ethernet/broadcast-domains'
rest_api_document   '/api/network/ethernet/broadcast-domains?name={name}&fields=*', first_element_only: true

rest_property_map({
                    ipspace: 'ipspace.name',
                    mtu: 'mtu'
                  })
