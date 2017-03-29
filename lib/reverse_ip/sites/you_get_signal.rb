require 'uri'
require 'net/http'
require 'json'

module ReverseIp
  module Sites
    class YouGetSignal
      @@target = ''
      @@url = ''
      @@params = ''
      @@headers = ''

      def initialize(target)
        @@target = target
        @@url = set_url
        @@params = set_params
        @@headers = set_headers
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
        request = @@http.post(@@url.path, @@params, @@headers)
        response = request.body
        result_parser(response)
      end

      def set_url
        # set url
        URI.parse('http://domains.yougetsignal.com/domains.php')
      end

      def set_headers
        # set request headers
        {'Host' => 'domains.yougetsignal.com', 'Connection' => 'keep-alive', 'Content-Length' => "#{@@params.length}",
         'Origin' => 'http://www.yougetsignal.com',
         'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36',
         'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8',
         'Accept' => 'text/javascript, text/html, application/xml, text/xml, */*',
         'X-Prototype-Version' => '1.6.0', 'X-Requested-With' => 'XMLHttpRequest',
         'Referer' => 'http://www.yougetsignal.com/tools/web-sites-on-web-server/',
         'Accept Encoding' => 'gzip, deflate', 'Accept-Language' => 'en-US,en;q=0.8,tr;q=0.6'}
      end

      def set_params
        # set request datas
        "remoteAddress=#{@@target}&key=&_="
      end

      def result_parser(results)
        # parsing request results
        results = JSON.parse(results)
        if results['status'] == 'Fail' or results['domainCount'] == '0'
          @@error = true
          @@error_message = results['message']
        else
          results['domainArray'].each do |domain|
            @@domains << domain[0] unless @@domains.include?(domain[0])
          end
        end
      end
    end
  end
end
