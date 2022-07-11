# Import API specifics
use 'ontap_base'

resource_name :ontap_ip_interface
provides :ontap_ip_interface, target_mode: true, platform: 'ontap'

description 'Create and manage Cluster-scoped or SVM-scoped interfaces.'

property :name, String,
          name_property: true,
          description: 'Name of the interface.'

property :svm, String,
          required: true,
          description: 'The name of the SVM.'

# TODO: Currently only SVM IF, not Cluster, thus required

property :home_node, String,
          required: true,
          description: 'Home node.'

property :ip_address, String,
          required: true,
          description: 'IP address.'

property :ip_netmask, [Integer, String],
          required: true,
          # TODO: Helper to explain "counting of 1s"
          coerce: proc { |x|
                    x.is_a?(String) && x.to_s != x.to_i.to_s ? ::IPAddr.new(x).to_i.to_s(2).count('1') : x.to_i
                  },
          description: 'Netmask length or IP address.'

property :broadcast_domain, String,
          description: 'Name of the broadcast domain, scoped to its IPspace.'

property :home_port, String,
          description: 'Home port.'

# TODO: Should be action
property :enabled, [TrueClass, FalseClass],
          description: 'The administrative state of the interface.'

property :ip_family, [Symbol, String],
          equal_to: %i[ipv4 ipv6],
          coerce: proc { |x| x.to_sym },
          description: 'IPv4 or IPv6.'

property :scope, [Symbol, String],
          default: :svm,
          equal_to: %i[svm cluster],
          coerce: proc { |x| x.to_sym },
          description: 'Set to :svm for interfaces owned by an SVM. Otherwise, set to :cluster.'

property :service_policy, [String],
          equal_to: %w[default-management default-data-files default-data-blocks],
          coerce: proc { |x| x.to_s },
          description: 'Built-in service policies for SVMs.'

rest_api_collection '/api/network/ip/interfaces'
rest_api_document   '/api/network/ip/interfaces?name={name}&svm.name={svm}&fields=*', first_element_only: true

rest_property_map({
                    enabled: 'enabled',
                    scope: 'scope',

                    ip_address: 'ip.address',
                    ip_family: 'ip.family',
                    ip_netmask: 'ip.netmask',
                    broadcast_domain: 'location.broadcast_domain.name',
                    home_node: 'location.home_node.name',
                    home_port: 'location.home_port.name',

                    service_policy: 'service_policy.name'
                  })
