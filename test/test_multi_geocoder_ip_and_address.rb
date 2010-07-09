require File.join(File.dirname(__FILE__), 'test_base_geocoder')

Geokit::Geocoders::provider_order    = [:google,:yahoo,:us]
Geokit::Geocoders::ip_provider_order = [:geo_plugin,:ip]


class MultiGeocoderIPAndAddressTest < BaseGeocoderTest #:nodoc: all
  
  def setup
    super
    @ipv6_address = '2001:0db8:85a3:08d3:1319:8a2e:0370:7334'
    @ipv4_address = '10.10.10.10'
    
    @success = Geokit::GeoLoc.new({:city=>"SAN FRANCISCO", :state=>"CA", :country_code=>"US", :lat=>37.7742, :lng=>-122.417068})
    @success.success = true
    @failure = Geokit::GeoLoc.new
  end

  def test_ipv6_does_not_call_address_geocoder
    Geokit::Geocoders::GoogleGeocoder.expects(:geocode).never
    Geokit::Geocoders::YahooGeocoder.expects(:geocode).never
    Geokit::Geocoders::UsGeocoder.expects(:geocode).never
    
    assert_equal @failure, Geokit::Geocoders::MultiGeocoder.geocode(@ipv6_address)
  end
  
  def test_ipv4_does_not_call_address_geocoder
    Geokit::Geocoders::GoogleGeocoder.expects(:geocode).never
    Geokit::Geocoders::YahooGeocoder.expects(:geocode).never
    Geokit::Geocoders::UsGeocoder.expects(:geocode).never
    
    assert_equal @failure, Geokit::Geocoders::MultiGeocoder.geocode(@ipv4_address)
  end
  
  def test_address_does_not_call_ip_geocoders
    Geokit::Geocoders::GeoPluginGeocoder.expects(:geocode).never
    Geokit::Geocoders::IpGeocoder.expects(:geocode).never
    
    Geokit::Geocoders::GoogleGeocoder.expects(:geocode).with(@address, {}).returns(@success)
    
    assert_equal @success, Geokit::Geocoders::MultiGeocoder.geocode(@address)
  end
  

end
