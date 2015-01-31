module Spree
  class Gateway::SimplifyGateway < Gateway
    preference :public_key, :string
    preference :private_key, :string
    require 'simplify'

    def provider_class
      Simplify
    end

    def authorize(money, creditcard, gateway_options)
      p "Money: #{money.inspect}"
      p "Credit Card: #{creditcard.inspect}"
      p "Gateway options: #{gateway_options.inspect}"

      Simplify::Authorization.create({
        "amount" => money,
        # "description" => "test authorization",
        "card" => {
           "expMonth" => creditcard.month,
           "expYear" => creditcard.year.to_s[2..3],
           "cvc" => creditcard.verification_value,
           "number" => creditcard.number
        },
        "reference" => "KP-76TBONES",
        "currency" => gateway_options[:currency]
      })
    end

    def purchase(money, creditcard, gateway_options)
      Simplify::Payment.create({
        "amount" => money,
        "description" => "payment description",
        "invoice" => "[INVOICE ID]",
        "card" => {
           "expMonth" => creditcard.month,
           "expYear" => creditcard.year.to_s[2..3],
           "cvc" => creditcard.verification_value,
           "number" => creditcard.number
        }
      })
    end

    def credit(money, creditcard, response_code, gateway_options)
      Simplify::Refund.create({
        "amount" => money,
        "payment" => "[PAYMENT ID]",
        "reason" => "Refund Description",
        "reference" => "76398734634"
      })
    end
  end
end
