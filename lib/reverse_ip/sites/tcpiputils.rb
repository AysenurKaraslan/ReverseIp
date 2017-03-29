require 'uri'
require 'net/http'
require 'json'
require 'nokogiri'

module ReverseIp
  module Sites
    class TCPIPUtils
      def initialize(target)
        # TODO: Bu class tamamen yapılmalı.
        @@target = target
        @@url = set_url
        @@domains = {}
        @@http = Net::HTTP.new(@@url.host, @@url.port)
        @@error = false
        @@error_message = ''
        send_request
      end

      def get_results
        response = {'tcpiputils' => {}}
        if @@error
          response['tcpiputils'] = {'error' => @@error_message}
        else
          response['tcpiputils']['count'] = @@domains.count
          response['tcpiputils']['domains'] = @@domains
        end

        response
      end

      private

      def send_request
        # give domains
        request = @@http.get(@@url.path)
        response = request.body
        result_parser(response)
      end

      def set_url
        # set url
        URI.parse("http://www.tcpiputils.com/domain-neighbors/#{@@target}")
      end

      def result_parser(results)
        # parsing request results
        results = Nokogiri::HTML(results)
        rows = results.css('.table-condensed tbody tr')
        rows.each_with_index do |row, index|
          next if index == 0
          site_name = row.css('td:nth-child(2)').text
          @@domains << site_name unless @@domains.include?(site_name)
        end
      end
    end
  end
end