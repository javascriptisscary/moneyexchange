require "spec_helper"

RSpec.describe Moneyexchange do
  it "has a version number" do
    expect(Moneyexchange::VERSION).not_to be nil
  end
  
  
    #######################
    ##    CONVERSIONS    ##
    #######################
  
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
  
    it "converts EUR to USD" do
      @money = Money.new("EUR", 100)
      @money.convert_to("USD")
      expect(@money.amount).to eq(111.00)
      expect(@money.currency).to eq("USD")
    end
 
    it "converts EUR to BITCOIN" do
      @money = Money.new("EUR", 100)
      @money.convert_to("bitcoin")
      expect(@money.amount).to eq(0.47)
      expect(@money.currency).to eq("BITCOIN")
    end
  
    it "converts USD to EUR" do
      @money = Money.new("USD", 111)
      @money.convert_to("eur")
      expect(@money.amount).to eq(100)
      expect(@money.currency).to eq("EUR")
    end
    
    it "converts BITCOIN to EUR" do
      @money = Money.new("BITCOIN", 0.47)
      @money.convert_to("EUR")
      expect(@money.amount).to eq(100)
      expect(@money.currency).to eq("EUR")
    end
    
    it "converts BITCOIN to USD" do
      @money = Money.new("BITCOIN", 0.47)
      @money.convert_to("USD")
      expect(@money.amount).to eq(111)
      expect(@money.currency).to eq("BITCOIN")
    end

    it "raises an error on an incorrect currency_type" do
      expect { @money.convert_to("ladeda") }.to raise_error(RuntimeError)
    end
  
  end #end describe conversions


    #######################
    ##    COMPARISONS    ##
    #######################
    
  describe "comparisons" do
    before do
      @twenty_dollars = Money.new("USD", 20)
      @fifty_eur = Money.new("EUR", 50)
      @fifty_eur_in_usd = @fifty_eur.convert_to("USD")
    end
 
    it "compares two equal currencys with ==" do
      expect(@twenty_dollars).to eq(Money.new("USD",20))
      expect(@twenty_dollars).to_not eq(Money.new("USD",30))
    end
    
    it "compares two different currencys with ==" do
      expect(@fifty_eur_in_usd).to eq(Money.new("EUR", 50))
      expect(@fifty_eur_in_usd).to eq(Money.new("BITCOIN", 0.235))
      expect(@fifty_eur_in_usd).to_not eq(Money.new("BITCOIN",0.20))
    end
  
  end #end describe comparisons


end