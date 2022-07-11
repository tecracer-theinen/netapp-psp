# Import API specifics
use 'ontap_base'

resource_name :ontap_ems_destination
provides :ontap_ems_destination, target_mode: true, platform: 'ontap'

description 'Updates an event destination.'

# 1-ary resource
property :name, String,
          name_property: true,
          description: 'Destination name.'

# Required properties

# Optional properties
property :type, [Symbol, String],
          description: 'Type of destination.',
          equal_to: %i[snmp email syslog rest_api],
          coerce: proc { |x| x.to_sym }

property :filters, [Array, String],
          description: 'Filter names that should direct to this destination.',
          coerce: proc { |x| Array(x) }

property :destination, String,
          description: 'Event destination.'

# API URLs and mappings
rest_api_collection '/api/support/ems/destinations'
rest_api_document   '/api/support/ems/destinations?name={name}&fields=*', first_element_only: true

rest_property_map({
                    type:        'type',
                    destination: 'destination',

                    filters:     :custom_mapping
                  })

action_class do
  def filters_from_json(data)
    data.fetch('filters', []).map { |filter| filter['name'] }
  end

  def filters_to_json(data)
    { 'filters' => data&.map { |name| { 'name' => name } } }
  end
end
