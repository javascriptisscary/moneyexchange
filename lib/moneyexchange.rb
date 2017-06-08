require "moneyexchange/version"

class Money
  
  #obviously in some real iteration of this gem,conversions rates would change, but they will be constant in this example
  CONVERSION_RATE_USD = 1.11.freeze
  CONVERSION_RATE_BITCOIN = 0.0047.freeze

  
  def initialize(currency, amount)
    @currency = currency
    @amount = amount
  end
  
  def currency
    @currency
  end
  
  def amount
    @amount      
  end
  
  def ==(money2)
    return true if (self.currency == money2.currency) && (self.amount == money2.amount) #same currency type, same amount. #equal
    return false if (self.currency == money2.currency) && (self.amount != money2.amount) #same currency type, but different amount. #not equal
     
    #if we get this far, currency types are different.
    self.currency == "EUR" ? self.convert_to(money2.currency) : money2.convert_to(self.currency)  #convert whichever one that is not "EUR"
    
    #currency types now match, are the amounts equal? return true or false 
    self.amount == money2.amount ? true : false
  end
  
  #conversions
  def convert_to(currency_type)
    currency_type.upcase!
    
    if currency_type == "USD"
      @amount = (CONVERSION_RATE_USD * self.amount)
      @currency = "USD"
      
    elsif currency_type == "BITCOIN"
      @amount = (CONVERSION_RATE_BITCOIN * self.amount)
      @currency = "BITCOIN"
    
    else
      return raise "#{currency_type} is an incorrect currency type"
    end
    
    @amount = @amount.round(2) #round off to cents
    return self  #return money object with converted values
  end
  
  
    
end
  

