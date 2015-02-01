module Spree
  class Gateway::SimplifyGateway < Gateway
    preference :public_key, :string
    preference :private_key, :string

    def provider_class
      ActiveMerchant::Billing::SimplifyGateway
    end

    def authorize(money, creditcard, gateway_options)
      provider.authorize(money, creditcard, gateway_options)
    end

    def purchase(money, creditcard, gateway_options)
      provider.purchase(money, creditcard, gateway_options)
    end

    def refund(money, creditcard, response_code, gateway_options)
      provider.refund(money, creditcard, response_code, gateway_options)
    end
  end
end
