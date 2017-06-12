require "spec_helper"

RSpec.describe Moneyexchange do
  it "has a version number" do
    expect(Moneyexchange::VERSION).not_to be nil
  end
  
  it "inspects showing amount and currency in a string" do
    @money = Money.new("USD", 95.05)
    expect(@money.inspect).to eq("95.05 USD")
    expect(Money.new("EUR",20).inspect).to eq("20 EUR")
    expect(Money.new("BITCOIN",30).inspect).to eq("30 BITCOIN")
  end
  
  it "raises an error for incorrect arguments" do
    expect { Money.new("us", 100) }.to raise_error(ArgumentError)
    expect { Money.new("EUR", "kg") }.to raise_error(ArgumentError)
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
      expect(@converted_to_usd.amount).to eq((@money.amount * Money::CONVERSION_RATE_USD).round(2)) #111
      expect(@converted_to_usd.currency).to eq("USD")
    end
 
    it "converts EUR to BITCOIN" do
      @money = Money.new("EUR", 100)
      @converted_to_bitcoin = @money.convert_to("BITCOIN")
      expect(@converted_to_bitcoin.amount).to eq((@money.amount * Money::CONVERSION_RATE_BITCOIN)) #0.47
      expect(@converted_to_bitcoin.currency).to eq("BITCOIN")
    end
  
    it "converts USD to EUR" do
      @money = Money.new("USD", 111)
      @converted_to_eur = @money.convert_to("EUR")
      expect(@converted_to_eur.amount).to eq((@money.amount / Money::CONVERSION_RATE_USD).round(2)) #100
      expect(@converted_to_eur.currency).to eq("EUR")
    end
    
    it "converts BITCOIN to EUR" do
      @money = Money.new("BITCOIN", 0.47)
      @converted_to_eur = @money.convert_to("EUR")
      expect(@converted_to_eur).to eq(@converted_to_eur.convert_to("BITCOIN")) #100
      expect(@converted_to_eur.currency).to eq("EUR")
    end
    
    it "converts BITCOIN to USD" do
      @money = Money.new("BITCOIN", 0.47)
      @converted_to_usd = @money.convert_to("USD")
      expect(@converted_to_usd.amount).to eq( ((@money.amount / Money::CONVERSION_RATE_BITCOIN) * Money::CONVERSION_RATE_USD).round(2) ) #111
      expect(@converted_to_usd.currency).to eq("USD")
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
      expect(@fifty_eur_in_usd).to eq(@fifty_eur)
      expect(@fifty_eur_in_usd).to eq(@fifty_eur.convert_to("BITCOIN"))
      expect(@fifty_eur_in_usd).to_not eq(Money.new("BITCOIN",0.20))
    end
    
    it "compares two currencies of the same type with >" do
      expect(@fifty_eur > Money.new("EUR", 60)).to eq(false)
      expect(@twenty_dollars > Money.new("USD", 10)).to eq(true)
      expect(Money.new("BITCOIN", 10) > Money.new("BITCOIN", 9)).to eq(true)
    end
    
    it "compares two currencies of a different type with >" do
      expect(@fifty_eur > Money.new("USD", 40)).to eq(true)
      expect(@twenty_dollars > Money.new("EUR", 10)).to eq(true)
      expect(Money.new("BITCOIN", 10) > Money.new("USD", 10)).to eq(true)
    end
    
    it "compares two currencies of the same type with <" do
      expect(@fifty_eur < Money.new("EUR", 60)).to eq(true)
      expect(@twenty_dollars < Money.new("USD", 10)).to eq(false)
      expect(Money.new("BITCOIN", 10) < Money.new("BITCOIN", 9)).to eq(false)
    end
    
    it "compares two currencies of a different type with <" do
      expect(@fifty_eur < Money.new("USD", 50)).to eq(false)
      expect(@twenty_dollars < Money.new("EUR", 20)).to eq(true)
      expect(Money.new("BITCOIN", 10) < Money.new("USD", 10)).to eq(false)
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
    
    describe "addition" do 
      it "adds the same currency types together" do
        expect(@fifty_eur + @fifty_eur).to eq(Money.new("EUR", 100))
        expect(@twenty_dollars + @twenty_dollars).to eq(Money.new("USD", 40))
        expect(@ten_bitcoin + @ten_bitcoin).to eq(Money.new("BITCOIN", 20))
      end
        
      it "adds different currency types together" do
        expect(@fifty_eur + @twenty_dollars).to eq(Money.new("EUR", 50 + @twenty_dollars.convert_to("EUR").amount)) #68.02
        expect(@ten_bitcoin + @fifty_eur).to eq(@fifty_eur.convert_to("BITCOIN") + @ten_bitcoin )
        expect(@twenty_dollars + @ten_bitcoin).to eq(Money.new("USD", 20 + @ten_bitcoin.convert_to("USD").amount)) #2381.70
      end
      
      it "add integers or floats to the current currency" do
        expect(@fifty_eur + 50).to eq(Money.new("EUR", 100))
        expect(@twenty_dollars + 50.25).to eq(Money.new("USD", 70.25))
        expect(@ten_bitcoin + 50).to eq(Money.new("BITCOIN", 60))
      end
    end #end addition
  
    describe "subtraction" do
      it "subtracts the same currency types from each other" do
        expect(@fifty_eur - @fifty_eur).to eq(Money.new("EUR", 0))
        expect(@twenty_dollars - @twenty_dollars).to eq(Money.new("USD", 0))
        expect(@ten_bitcoin - @ten_bitcoin).to eq(Money.new("BITCOIN", 0))
      end
      
      it "subtracts integers or floats with the current currency" do
        expect(@fifty_eur - 50).to eq(Money.new("EUR", 0))
        expect(@twenty_dollars - 10.05).to eq(Money.new("USD", 9.95))
        expect(@ten_bitcoin - 50).to eq(Money.new("BITCOIN", -40))
      end
      
      it "subtracts different currency types from each other" do
        expect(@fifty_eur - @twenty_dollars).to eq(Money.new("EUR", 50 - @twenty_dollars.convert_to("EUR").amount)) #31.98
        expect(@ten_bitcoin - @fifty_eur).to eq(@ten_bitcoin - @fifty_eur.convert_to("BITCOIN")) #9.765
        expect(@twenty_dollars - @ten_bitcoin).to eq(Money.new("USD", (@twenty_dollars.amount - (@ten_bitcoin.convert_to("USD")).amount))) #-2341.70
      end
    end #end subtraction
    
    describe "division" do
      it "divides the currency by numbers" do
        expect(@fifty_eur / 5).to eq(Money.new("EUR", 10))
        expect(@twenty_dollars / 1).to eq(Money.new("USD", 20))
        expect(@ten_bitcoin / 2.5).to eq(Money.new("BITCOIN", 4))
      end
    
      it "raises an error when given something other than a number" do
        expect { @fifty_eur / "h" }.to raise_error(RuntimeError)
        expect { @fifty_eur / @fifty_eur }.to raise_error(RuntimeError)
      end
    end #end division
    
    describe "multiply" do
      it "multiples the currency by numbers" do
        expect(@fifty_eur * 5).to eq(Money.new("EUR", 250))
        expect(@twenty_dollars * 1).to eq(Money.new("USD", 20))
        expect(@ten_bitcoin * 2.5).to eq(Money.new("BITCOIN", 25))
      end
    
      it "raises an error when given something other than a number" do
        expect { @fifty_eur * "h" }.to raise_error(RuntimeError)
        expect { @fifty_eur * @fifty_eur }.to raise_error(RuntimeError)
      end
    end #end multiply
    
  end #end describe arithmetics    

end