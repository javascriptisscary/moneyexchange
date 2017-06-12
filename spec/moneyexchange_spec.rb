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
    
    it "compares two currencies of the same type with >" do
      expect(@fifty_eur > Money.new("EUR", 60)).to eq(false)
      expect(@twenty_dollars > Money.new("USD", 10)).to eq(true)
      expect(Money.new("BITCOIN", 10) > Money.new("BITCOIN", 9)).to eq(true)
    end
    
    it "compares two currencies of a different type with >" do
      expect(@fifty_eur > Money.new("USD", 50)).to eq(true)
      expect(@twenty_dollars > Money.new("EUR", 10)).to eq(true)
      expect(Money.new("BITCOIN", 10) > Money.new("USD", 10)).to eq(true)
    end
    
    it "compares two currencies of the same type with <" do
      expect(@fifty_eur < Money.new("EUR", 60)).to eq(true)
      expect(@twenty_dollars < Money.new("USD", 10)).to eq(false)
      expect(Money.new("BITCOIN", 10) < Money.new("BITCOIN", 9)).to eq(false)
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
        expect(@fifty_eur + @twenty_dollars).to eq(Money.new("EUR", 68.02))
        expect(@ten_bitcoin + @fifty_eur).to eq(Money.new("BITCOIN", 10.24))
        expect(@twenty_dollars + @ten_bitcoin).to eq(Money.new("USD", 2381.70))
      end
      
      it "add integers or floats to the current currency" do
        expect(@fifty_eur + 50).to eq(Money.new("EUR", 100))
        expect(@twenty_dollars + 50.25).to eq(Money.new("USD", 70.25))
        expect(@ten_bitcoin + 50).to eq(Money.new("BITCOIN", 60))
      end
    end
  
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
        expect(@fifty_eur - @twenty_dollars).to eq(Money.new("EUR", 31.98))
        expect(@ten_bitcoin - @fifty_eur).to eq(Money.new("BITCOIN", 9.76))
        expect(@twenty_dollars - @ten_bitcoin).to eq(Money.new("USD", -2341.70))
      end
    end
    
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
    end
    
    describe "multiplys" do
      it "multiples the currency by numbers" do
        expect(@fifty_eur * 5).to eq(Money.new("EUR", 250))
        expect(@twenty_dollars * 1).to eq(Money.new("USD", 20))
        expect(@ten_bitcoin * 2.5).to eq(Money.new("BITCOIN", 25))
      end
    
      it "raises an error when given something other than a number" do
        expect { @fifty_eur * "h" }.to raise_error(RuntimeError)
        expect { @fifty_eur * @fifty_eur }.to raise_error(RuntimeError)
      end
    end
    
  end #end describe arithmetics    

end