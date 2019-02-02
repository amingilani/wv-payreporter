# encoding : utf-8

MoneyRails.configure do |config|
  config.default_currency = :cad
end
Money.locale_backend = :currency
