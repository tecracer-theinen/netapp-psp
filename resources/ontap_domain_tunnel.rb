# Import API specifics
use 'ontap_base'

resource_name :ontap_domain_tunnel
provides :ontap_domain_tunnel, target_mode: true, platform: 'ontap'

description 'Configures a data SVM as a proxy for Active Directory based authentication for cluster user accounts.'

property :svm, String,
          name_property: true,
          description: 'The name of the SVM. '

rest_api_collection '/api/security/authentication/cluster/ad-proxy'
rest_api_document   '/api/security/authentication/cluster/ad-proxy?svm.name={name}&fields=*',
                    first_element_only: true

rest_property_map({
                    svm: 'svm.name'
                  })
