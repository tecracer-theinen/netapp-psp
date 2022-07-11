Ohai.plugin(:NetappOntapOs) do
  provides "os", "platform", "platform_version", "platform_hierarchy", "ontap"
  depends "os"

  def cluster
    transport_connection.get("/api/cluster").data
  end

  def ontap_version
    format('%s.%s', cluster["version"]["generation"], cluster["version"]["major"])
  end

  def netapp_ontap?
    cluster && true
  rescue Errno::EHOSTUNREACH, RestClient::Unauthorized => e
    logger.fatal("Plugin ONTAP: #{e.message}")
    false
  rescue RestClient::NotFound => _e
    false
  end

  collect_data(:rest) do
    return unless netapp_ontap?

    # Switch OS to allow platform-specific detectors
    os "ontap"
    transport_connection.detected_os = "ontap"

    # Custom OS detection/reporting
    platform "ontap"
    platform_version ontap_version
    platform_family "netapp"
    platform_hierarchy %w[ontap netapp rest api]

    ontap Mash.new
  end
end
