require 'uri'
require 'net/http'
require 'json'
require 'nokogiri'
require 'resolv'

module ReverseIp
  module Sites
    class IpWWW
      def initialize(target)
        @@target = target
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
        request = @@http.get(@@url.path)
        response = request.body
        result_parser(response)
      end

      def set_url
        # set url
        ip_adress = Resolv.getaddresses(@@target).first
        URI.parse("http://ip-www.net/#{ip_adress}")
      end

      def result_parser(results)
        # parsing request results
        results = Nokogiri::HTML(results)
        domains = results.css('a#hlWebsite')
        domains.each do |domain|
          site = domain.text
          @@domains << site unless @@domains.include?(site)
        end
      end
    end
  end
end