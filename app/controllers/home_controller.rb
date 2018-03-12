class HomeController < ApplicationController
  skip_before_action :require_login, raise: false

  def index
    if params[:waf_block_by_ip] == "true"
      p "-----"
      target_ip_addr = request.remote_ip
      # WAF 設定準備
      client = Aws::WAF::Client.new(
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
      # 1. 既に存在する blacklist ip のルールを取得する
      ip_set_id = nil
      waf_responce = client.list_ip_sets
      waf_responce.ip_sets.each do |ipset|
        if ipset.name == "LoginMockTestIPmath"
          ip_set_id = ipset.ip_set_id
          break
        end
      end
      waf_responce = client.get_change_token({})
      change_token = waf_responce.change_token
      # 2. 1. で取得したルールの blacklist ip に新規 ip アドレスを追加する
      waf_responce = client.update_ip_set({
        change_token: change_token,
        ip_set_id: ip_set_id,
        updates: [
          {
            action: "INSERT",
            ip_set_descriptor: { type: "IPV4", value: "#{target_ip_addr}/32" }
          }
        ]
      })
      p waf_responce
    end
  end

end
