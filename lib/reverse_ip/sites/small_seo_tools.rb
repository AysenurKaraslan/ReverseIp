require 'nokogiri'
require 'net/http'


module ReverseIp
  module Sites
    class SmallSeoTools
      def initialize(target)
        @@target = target
        @@url = set_url
        @@params = set_params
        @@domains = []
        @@http = Net::HTTP.new(@@url.host, @@url.port)
        @@error = false
        @@error_message = ''
        send_request
      end

      def get_results
        response = {}
        if @@error
          response['error'] = @@error_message
        else
          response['count'] = @@domains.count
          response['domains'] = @@domains
        end

        response
      end

      private
      def send_request
        # give domains
        # response = requests.post(self.url, data=self.params, headers=self.headers)
        request = @@http.post(@@url.path, @@params)
        response = request.body
        result_parser(response)
      end

      def set_url
        # set url
        URI.parse('http://smallseotools.com/reverse-ip-domain-check/')
      end

      def set_params
        # set request datas
        "url=http%3A%2F%2F#{@@target}&check=Check"
      end

      def result_parser(results)
        # parsing request results
        results = Nokogiri::HTML(results)
        rows = results.css('table tr td:nth-child(2)')
        rows.each do |site|
          site_name = site.css('a').text
          @@domains << site_name unless @@domains.include?(site_name)
        end
      end
    end
  end
end