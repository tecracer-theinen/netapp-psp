# Import API specifics
use 'ontap_base'

resource_name :ontap_dns
provides :ontap_dns, target_mode: true, platform: 'ontap'

description 'Set DNS configuration of an SVM.'

property :name, String,
          name_property: true,
          description: 'Name of the SVM.'

property :domains, [Array, String],
          coerce: proc { |x| Array(x) },
          callbacks: {
            'contains no domains' => lambda { |a|
              a.count.positive?
            },
            'contains too many domains (max: 6)' => lambda { |a|
              a.count <= 6
            }
          },
          description: <<~DOC
            A list of DNS domains.

            Domain names have the following requirements:

            * The name must contain only the following characters: A through Z,
              a through z, 0 through 9, ".", "-" or "_".
            * The first character of each label, delimited by ".", must be one
              of the following characters: A through Z or a through z or 0
              through 9.
            * The last character of each label, delimited by ".", must be one of
              the following characters: A through Z, a through z, or 0 through 9.
            * The top level domain must contain only the following characters: A
              through Z, a through z.
            * The system reserves the following names:"all", "local", and "localhost".
          DOC

property :servers, [Array, String],
          coerce: proc { |x| Array(x) },
          callbacks: {
            'contains no DNS servers' => lambda { |a|
              a.count.positive?
            },
            'contains too many DNS servers (max: 3)' => lambda { |a|
              a.count <= 3
            }
          },
          description: 'The list of IP addresses of the DNS servers. Addresses can be either IPv4 or IPv6 addresses.'

rest_api_collection '/api/name-services/dns'
rest_api_document   '/api/name-services/dns?svm.name={name}&fields=*', first_element_only: true

rest_property_map   %w[domains servers]
