# Import API specifics
use 'ontap_base'

resource_name :ontap_aggregate
provides :ontap_aggregate, target_mode: true, platform: 'ontap'

require_relative '../abstract_resources/ontap_rest_resource'

description 'Create and manage aggregates.'

property :name, String,
          name_property: true,
          description: 'Name of the aggregate.'

property :node_name, String,
          required: true,
          description: 'Node which owns the aggregate.'

property :disk_count, Integer,
          required: true,
          description: 'Number of disks to use.'

property :checksum_style, [Symbol, String],
          description: 'Checksum class to apply.',
          equal_to: %i[block advanced_zoned mixed],
          coerce: proc { |x| x.to_sym }

property :disk_class, [Symbol, String],
          description: 'Class of disks.',
          equal_to: %i[capacity performance archive solid_state array virtual data_center capacity_flash],
          coerce: proc { |x| x.to_sym }

property :raid_size, Integer,
          description: 'Maximum RAID group size.'

property :raid_type, [Symbol, String],
          description: 'RAID type for aggregate.',
          equal_to: %i[raid0 raid4 raid_dp raid_tec],
          coerce: proc { |x| x.to_sym }

property :software_encryption, [TrueClass, FalseClass],
          description: 'Enable software encryption.'

rest_api_collection '/api/storage/aggregates'
rest_api_document   '/api/storage/aggregates?name={name}&fields=*', first_element_only: true

rest_property_map({
                    node_name: 'node.name',
                    checksum_style: 'block_storage.primary.checksum_style',
                    disk_class: 'block_storage.primary.disk_class',
                    disk_count: 'block_storage.primary.disk_count',
                    raid_size: 'block_storage.primary.raid_size',
                    raid_type: 'block_storage.primary.raid_type',
                    software_encryption: 'data_encryption.software_encryption_enabled'
                  })
