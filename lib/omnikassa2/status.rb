module Omnikassa2
  class Status
    #attr_accessor :notification_token

    #def initialize(notification_token)
    #  #self.notification_token = JSON.parse(notification_token)['notification_token:']
    #  puts JSON.parse(eval(notification_params))['notification_params']
    #  self.notification_token = notification_params['authentication']
    #  self.notification_token = notification_token
    #end

    def self.uri
      tmp_url = Omnikassa2.url + '/order/server/api/events/results/merchant.order.status.changed'
      URI(tmp_url)
    end

    def connect(notification_token)
      req = Net::HTTP::Get.new(Omnikassa2::Status.uri)
      req['Authorization'] = "Bearer #{notification_token}"
      @res = Net::HTTP.start(Omnikassa2::Status.uri.hostname, Omnikassa2::Status.uri.port, use_ssl: true) { |http| http.request(req) }
      JSON.parse(@res.body)
    end

    def results
      result = JSON.parse(@res.body) || []
      result['orderResults'].map { |res| [res['merchantOrderId'], res['orderStatus']] }.to_h
    end
  end
end
