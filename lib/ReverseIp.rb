require_relative './reverse_ip/version'
require_relative './reverse_ip/sites/ip-www'
require_relative './reverse_ip/sites/you_get_signal'
require_relative './reverse_ip/sites/view_dns'
require_relative './reverse_ip/sites/small_seo_tools'
require_relative './reverse_ip/sites/ip_finger_prints'
require_relative './reverse_ip/sites/tcpiputils'

ips = gets.chomp.strip.split(',')

ips.each_with_index do |ip, index|
  ip = ip.strip
  puts "Scanning #{ip}"
  results = []
  you_get_signal = ReverseIp::Sites::YouGetSignal.new(ip)
  results.push(you_get_signal.get_results)

  ip_finger_prints = ReverseIp::Sites::IpFingerPrints.new(ip)
  results.push(ip_finger_prints.get_results)

  small_seo_tools = ReverseIp::Sites::SmallSeoTools.new(ip)
  results.push(small_seo_tools.get_results)

  tcp_ip_utils = ReverseIp::Sites::TCPIPUtils.new(ip)
  results.push(tcp_ip_utils.get_results)

  # view_dns = ReverseIp::Sites::ViewDNS.new(ip)
  # results.push(view_dns.get_results)

  ip_www = ReverseIp::Sites::IpWWW.new(ip)
  results.push(ip_www.get_results)

  total_result[index] = results
end

puts total_result
