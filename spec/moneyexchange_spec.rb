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
      @converted_to_usd = @money.convert_to("USD")
      expect(@converted_to_usd.amount).to eq(111.00)
      expect(@converted_to_usd.currency).to eq("USD")
    end
 
    it "converts EUR to BITCOIN" do
      @money = Money.new("EUR", 100)
      @converted_to_bitcoin = @money.convert_to("bitcoin")
      expect(@converted_to_bitcoin.amount).to eq(0.47)
      expect(@converted_to_bitcoin.currency).to eq("BITCOIN")
    end
  
    it "converts USD to EUR" do
      @money = Money.new("USD", 111)
      @converted_to_eur = @money.convert_to("eur")
      expect(@converted_to_eur.amount).to eq(100)
      expect(@converted_to_eur.currency).to eq("EUR")
    end
    
    it "converts BITCOIN to EUR" do
      @money = Money.new("BITCOIN", 0.47)
      @converted_to_eur = @money.convert_to("EUR")
      expect(@converted_to_eur.amount).to eq(100)
      expect(@converted_to_eur.currency).to eq("EUR")
    end
    
    it "converts BITCOIN to USD" do
      @money = Money.new("BITCOIN", 0.47)
      @converted_to_usd = @money.convert_to("USD")
      expect(@converted_to_usd.amount).to eq(111)
      expect(@converted_to_usd.currency).to eq("USD")
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
 
    it "compares two equal currencies with ==" do
      expect(@twenty_dollars).to eq(Money.new("USD",20))
      expect(@twenty_dollars).to_not eq(Money.new("USD",30))
    end
    
    it "compares two different currencies with ==" do
      expect(@fifty_eur_in_usd).to eq(Money.new("EUR", 50))
      expect(@fifty_eur_in_usd).to eq(Money.new("BITCOIN", 0.235))
      expect(@fifty_eur_in_usd).to_not eq(Money.new("BITCOIN",0.20))
    end
  
  end #end describe comparisons


  #######################
  ##    ARITHMETICS    ##
  #######################
    
  describe "arithmetics" do
    before do
      @twenty_dollars = Money.new("USD", 20)
      @fifty_eur = Money.new("EUR", 50)
      @ten_bitcoin = Money.new("BITCOIN", 10)
    end
    
    it "adds the same currency types together" do
      expect(@fifty_eur + @fifty_eur).to eq(Money.new("EUR", 100))
      expect(@twenty_dollars + @twenty_dollars).to eq(Money.new("USD", 40))
      expect(@ten_bitcoin + @ten_bitcoin).to eq(Money.new("BITCOIN", 20))
    end
      
    it "adds different currency types together" do
      expect(@fifty_eur + @twenty_dollars).to eq(Money.new("EUR", 68.02))
      expect(@ten_bitcoin + @fifty_eur).to eq(Money.new("BITCOIN", 10.24))
      expect(@twenty_dollars + @ten_bitcoin).to eq(Money.new("USD", 2381.70))
    end
    
    
    
  end #end describe arithmetics    

end