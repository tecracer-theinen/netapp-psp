# Import API specifics
use 'ontap_base'

resource_name :ontap_nfs_server
provides :ontap_nfs_server, target_mode: true, platform: 'ontap'

description 'Create and manage NFS services'

# 1-ary resource
property :svm, String,
          name_property: true,
          description: 'Name of the SVM.'

# Optional properties
property :enable, [TrueClass, FalseClass],
          default: true,
          description: 'Specifies if the NFS service is administratively enabled.'

property :protocol_v3, [TrueClass, FalseClass],
          description: 'Support for NFSv3.'

property :protocol_v3_64bit_identifiers, [TrueClass, FalseClass],
          description: 'Use 64bit identifiers for NFSv3 (ONTAP 9.8+).'

property :protocol_v40, [TrueClass, FalseClass],
          description: 'Support for NFSv4.0'

property :protocol_v4_64bit_identifiers, [TrueClass, FalseClass],
          description: 'Use 64bit identifiers for NFSv4 (ONTAP 9.8+).'

property :protocol_v40_features, Array,
          default: [],
          coerce: proc { |x| x.map(&:to_sym) },
          callbacks: {
            'contains values not in :acl, :write_delegation, :read_delegation' => lambda { |a|
              a.all? { |s| %i[acl write_delegation read_delegation].include?(s) }
            }
          },
          description: 'NFSv4.0 features.'

property :protocol_v41, [TrueClass, FalseClass],
          description: 'Support for NFSv4.1 and NFSv4.2.'

property :protocol_v41_features, Array,
          default: [],
          coerce: proc { |x| x.map(&:to_sym) },
          callbacks: {
            'contains values not in :pnfs, :acl, :write_delegation, :read_delegation' => lambda { |a|
              a.all? { |s| %i[pnfs acl write_delegation read_delegation].include?(s) }
            }
          },
          description: 'NFSv4.1 and NFSv4.2 features.'

property :protocol_v4_id_domain, String,
          description: 'NFSv4 ID domain.'

property :transport_tcp, [TrueClass, FalseClass],
          description: 'Enable TCP transport.'

property :transport_udp, [TrueClass, FalseClass],
          description: 'Enable UDP transport.'

# Usability aliases
alias protocol_v4 protocol_v40
alias protocol_v4_features protocol_v40_features

# API URLs and mappings
rest_api_collection '/api/protocols/nfs/services'
rest_api_document   '/api/protocols/nfs/services?svm.name={svm}&fields=*', first_element_only: true

rest_property_map({
                    protocol_v3: 'protocol.v3_enabled',
                    protocol_v3_64bit_identifiers: 'protocol.v3_64bit_identifiers_enabled',
                    protocol_v4_64bit_identifiers: 'protocol.v4_64bit_identifiers_enabled',
                    protocol_v4_id_domain: 'protocol.v4_id_domain',
                    protocol_v40: 'protocol.v40_enabled',
                    protocol_v41: 'protocol.v41_enabled',
                    transport_tcp: 'transport.tcp_enabled',
                    transport_udp: 'transport.udp_enabled',

                    protocol_v40_features: :custom_mapping,
                    protocol_v41_features: :custom_mapping
                  })

action_class do
  # Custom mapping
  def protocol_v40_features_from_json(data)
    read_feature_map data&.dig('protocol', 'v40_features')
  end

  def protocol_v40_features_to_json(data)
    write_feature_map data&.dig('protocol', 'v40_features')
  end

  def protocol_v41_features_from_json(data)
    read_feature_map data&.dig('protocol', 'v41_features')
  end

  def protocol_v41_features_to_json(data)
    write_feature_map data&.dig('protocol', 'v41_features')
  end

  private

  def read_feature_map(raw_input)
    enabled_features = raw_input.select { |_feature, enabled| enabled }.keys
    feature_names    = enabled_features.map { |feature| feature.delete_suffix('_enabled') }

    feature_names.map(&:to_sym)
  end

  def write_feature_map(raw_input)
    return if raw_input.nil?

    raw_input.map do |feature|
      { "#{feature}_enabled" => true }
    end.reduce(:merge)
  end
end
