require 'spec_helper'

describe Spree::Gateway::SimplifyGateway do
  let(:public_key){'key'}
  let(:private_key){'key'}

  before do
    subject.preferences = { public_key: public_key, private_key: private_key }

    @credit_card = create(:credit_card,
      verification_value: '123',
      number:             '4111111111111111',
      month:              9,
      year:               Time.now.year + 1,
      name:               'John Doe',
      cc_type:            '')
  end

  context 'authorizing' do
    after do
      subject.authorize(19.99, @credit_card, {})
    end

    it 'send the authorization to the provider' do
      Simplify::Authorization.should_receive(:create).with({
        "amount" => 19.99,
        "description" => "test authorization",
        "card" => {
           "expMonth" => @credit_card.month,
           "expYear" => @credit_card.year,
           "cvc" => @credit_card.verification_value,
           "number" => @credit_card.number
        },
        "reference" => "KP-76TBONES",
        "currency" => "USD"
      })
    end
  end

  context 'purchasing' do
    after do
      subject.purchase(19.99, @credit_card, {})
    end

    it 'send the payment to the provider' do
      Simplify::Payment.should_receive(:create).with({
        "amount" => 19.99,
        "description" => "payment description",
        "invoice" => "[INVOICE ID]",
        "card" => {
           "expMonth" => @credit_card.month,
           "expYear" => @credit_card.year,
           "cvc" => @credit_card.verification_value,
           "number" => @credit_card.number
        }
      })
    end
  end

  context 'credit' do
    after do
      subject.credit(19.99, @credit_card, '200', {})
    end

    it 'send the payment to the provider' do
      Simplify::Refund.should_receive(:create).with({
        "amount" => 19.99,
        "payment" => "[PAYMENT ID]",
        "reason" => "Refund Description",
        "reference" => "76398734634"
      })
    end
  end
end
