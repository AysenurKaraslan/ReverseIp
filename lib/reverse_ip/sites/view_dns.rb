require 'uri'
require 'net/http'
require 'json'
require 'nokogiri'
require 'resolv'

module ReverseIp
  module Sites
    class ViewDNS
      def initialize(target, api_key)
        @@target = target
        @@api_key = api_key
        @@url = set_url
        @@domains = []
        @@http = Net::HTTP.new(@@url.host, @@url.port)
        @@error = false
        @@error_message = ''
        send_request
      end

      def get_results
        response = {}
        response['count'] = @@domains.count
        response['domains'] = @@domains
        response
      end

      private
      def send_request
        # give domains
        # response = requests.post(self.url, data=self.params, headers=self.headers)
        request = @@http.get(@@url)
        response = request.body
        result_parser(response)
      end

      def set_url
        # set url
        ip_adress = Resolv.getaddresses(@@target).first
        URI.parse("http://pro.viewdns.info/reverseip/?host=#{ip_adress}&apikey=#{@@api_key}&output=xml")
      end

      def result_parser(results)
        # parsing request results
        results = Nokogiri::XML(results)
        domains = results.xpath('//name')
        domains.each do |domain|
          site = domain.text
          @@domains << site unless @@domains.include?(site)
        end
      end
    end
  end
end