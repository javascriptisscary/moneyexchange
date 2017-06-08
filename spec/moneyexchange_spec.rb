require "spec_helper"

RSpec.describe Moneyexchange do
  it "has a version number" do
    expect(Moneyexchange::VERSION).not_to be nil
  end
  
  
  describe "conversions" do
  
    before do
      @money = Money.new("EUR", 100)
    end
  
    it "has a currency" do
      expect(@money.currency).to eq("EUR")
    end
  
    it "has an amount" do
      expect(@money.amount).to eq(100)
    end
  
    it "converts to USD" do
      @money.convert_to("USD")
      expect(@money.amount).to eq(111.00)
      expect(@money.currency).to eq("USD")
    end
 
    before do
      @money = Money.new("EUR", 100)
    end
 
    it "converts to BITCOIN" do
      @money.convert_to("bitcoin")
      expect(@money.amount).to eq(0.47)
      expect(@money.currency).to eq("BITCOIN")
    end

    it "raises an error on an incorrect currency_type" do
      expect { @money.convert_to("ladeda") }.to raise_error(RuntimeError)
    end
  
  end #end describe conversions





  describe "comparisons" do
    before do
      @twenty_dollars = Money.new("USD", 20)
      @fifty_eur_in_usd = Money.new("EUR", 50)
      @fifty_eur_in_usd.convert_to("USD")
      puts @fifty_eur_in_usd.currency
      puts @fifty_eur_in_usd.amount
    end
 
    it "compares two equal currencys with ==" do
      expect(@twenty_dollars).to eq(Money.new("USD",20))
      expect(@twenty_dollars).to_not eq(Money.new("USD",30))
    end
    
    it "compares two different currencys with ==" do
      expect(@fifty_eur_in_usd).to eq(Money.new("EUR", 50))
      expect(@fifty_eur_in_usd).to_not eq(Money.new("BITCOIN",20))
    end
  
  end #end describe comparisons


end