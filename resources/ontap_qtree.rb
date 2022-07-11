# Import API specifics
use 'ontap_base'

resource_name :ontap_qtree
provides :ontap_qtree, target_mode: true, platform: 'ontap'

description 'Creates a qtree in a FlexVol volume or a FlexGroup volume. '

property :name, String,
          name_property: true,
          description: 'Name for the qtree.'

property :svm, String,
          required: true,
          description: 'Existing SVM for which to create the qtree.'

property :volume, String,
          required: true,
          description: 'Existing volume in which to create the qtree.'

property :export_policy, String,
          default: 'default',
          description: 'Export Policy to use'

property :security_style, [Symbol, String],
          equal_to: %i[unix ntfs mixed],
          coerce: proc { |x| x.to_sym },
          description: 'Security style.'

property :unix_permissions, Integer,
          description: 'The UNIX permissions for the qtree.'

rest_api_collection '/api/storage/qtrees'
rest_api_document   '/api/storage/qtrees/?svm.name={svm}&volume.name={volume}&name={name}',
                    first_element_only: true

rest_property_map({
                    security_style: 'security_style',
                    unix_permissions: 'unix_permissions',

                    export_policy: 'export_policy.name',
                    volume: 'volume.name'
                  })
