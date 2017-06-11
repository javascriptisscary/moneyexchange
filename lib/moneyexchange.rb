require "moneyexchange/version"

class Money
  attr_accessor :currency, :amount
  
  #obviously in some real iteration of this gem,conversions rates would change, but they will be constant in this example
  CONVERSION_RATE_USD = 1.11.freeze
  CONVERSION_RATE_BITCOIN = 0.0047.freeze

  def initialize(currency, amount)
    @currency = currency
    @amount = amount
  end
  
  def ==(money2)
    return true if (self.currency == money2.currency) && (self.amount == money2.amount) #same currency type, same amount. #equal
    return false if (self.currency == money2.currency) && (self.amount != money2.amount) #same currency type, but different amount. #not equal
     
    #if we get this far, currency types are different.
    money2.convert_to(self.currency)
    self.amount == money2.amount ? true : false #currency types now match, are the amounts equal? return true or false 
  end
  
  def convert_to(currency_type)
    currency_type.upcase!
    
    #unless currency type is either USD, EUR, BITCOIN... raise error
    return raise "#{currency_type} is an incorrect currency type" unless currency_type == "USD" || currency_type == "EUR" || currency_type == "BITCOIN"
    
    #Convert from USD
    if self.currency == "USD"
      if currency_type == "EUR"
        @amount = ( self.amount / CONVERSION_RATE_USD)
        @currency = "EUR"
      elsif currency_type == "BITCOIN"
        @amount = ( self.amount / CONVERSION_RATE_USD) * CONVERSION_RATE_BITCOIN #convert from USD -> EUR -> BITCOIN
        @currency = "BITCOIN"
      end
      
      @amount = @amount.round(2) #round off to cents
      return self  #return money object with converted values
    end
    
    #Convert from EUR
    if self.currency == "EUR"
      if currency_type == "USD"
        @amount = (CONVERSION_RATE_USD * self.amount)
        @currency = "USD"
      elsif currency_type == "BITCOIN"
        @amount = (CONVERSION_RATE_BITCOIN * self.amount)
        @currency = "BITCOIN"
      end
      
      @amount = @amount.round(2)
      return self
    end
    
    #Convert from BITCOIN
    if self.currency == "BITCOIN"
      if currency_type == "EUR"
        @amount = ( self.amount / CONVERSION_RATE_BITCOIN)
        @currency = "EUR"
      elsif currency_type == "USD"
        @amount = ( self.amount / CONVERSION_RATE_BITCOIN) * CONVERSION_RATE_USD #convert from BITCOIN -> EUR -> USD
        @currency = "BITCOIN"
      end
      
      @amount = @amount.round(2) #round off to cents
      return self  #return money object with converted values
    end
      
  end #end convert_to
  
  
    
end
  

