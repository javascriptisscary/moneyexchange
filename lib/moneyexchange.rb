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
    converted_money = money2.convert_to(self.currency)
    self.amount == converted_money.amount ? true : false #currency types now match, are the amounts equal? return true or false 
  end
  
  def > (money2)
    return true if (self.currency == money2.currency) && (self.amount > money2.amount) #same currency type, #greater than
    return false if (self.currency == money2.currency) && (self.amount < money2.amount) #same currency type, #not greater than
  end
  
  def < (money2)
    return true if (self.currency == money2.currency) && (self.amount < money2.amount) #same currency type, #less than
    return false if (self.currency == money2.currency) && (self.amount > money2.amount) #same currency type #not less than
  
  end
  
  def + (money2)
    return Money.new(self.currency, self.amount + money2) if money2.is_a? Numeric #if money2 is a simple integer, add it
    return Money.new(self.currency, self.amount + money2.amount) if (self.currency == money2.currency) #same currency type, add them and return new money object
     
    #if we get this far, currency types are different
    converted_money = money2.convert_to(self.currency) #convert money2 to match
    return Money.new(self.currency, self.amount + converted_money.amount)
  end

  def - (money2)
    return Money.new(self.currency, self.amount - money2) if money2.is_a? Numeric #if money2 is a simple float, subtract it
    return Money.new(self.currency, self.amount - money2.amount) if (self.currency == money2.currency) #same currency type, subtract the amounts and return new money object
  
    #if we get this far, currency types are different
    converted_money = money2.convert_to(self.currency) #convert money2 to match
    return Money.new(self.currency, self.amount - converted_money.amount)
  end
  
  def / (money2)
    return Money.new(self.currency, self.amount / money2 ) if money2.is_a? Numeric #if money2 is numeric, divide by it
      
    #if we get here, money2 is something other than a number. Error out
    raise "Only integers and floating numbers accepted for division of a money object."
  end
  
  def * (money2)
    return Money.new(self.currency, self.amount * money2 ) if money2.is_a? Numeric #if money2 is numeric, multiply by it
    
    #if we get here, money2 is something other than a number. Error out
    raise "Only integers and floating numbers are accepted for multiplication of a money object."
  end
  
  def convert_to(currency_type)
    currency_type.upcase!
    
    #unless currency type is either USD, EUR, BITCOIN... raise error
    return raise "#{currency_type} is an incorrect currency type" unless currency_type == "USD" || currency_type == "EUR" || currency_type == "BITCOIN"
    
    #Convert from USD
    if self.currency == "USD"
      if currency_type == "EUR"
        amount = ( self.amount / CONVERSION_RATE_USD)
      elsif currency_type == "BITCOIN"
        amount = ( self.amount / CONVERSION_RATE_USD) * CONVERSION_RATE_BITCOIN #convert from USD -> EUR -> BITCOIN
      end
      
      return Money.new(currency_type, amount.round(2))  #return new money object with converted values
    end
    
    #Convert from EUR
    if self.currency == "EUR"
      if currency_type == "USD"
        amount = (CONVERSION_RATE_USD * self.amount)
      elsif currency_type == "BITCOIN"
        amount = (CONVERSION_RATE_BITCOIN * self.amount)
      end
      
      return Money.new(currency_type, amount.round(2))  #return new money object with converted values
    end
    
    #Convert from BITCOIN
    if self.currency == "BITCOIN"
      if currency_type == "EUR"
        amount = ( self.amount / CONVERSION_RATE_BITCOIN)
      elsif currency_type == "USD"
        amount = ( self.amount / CONVERSION_RATE_BITCOIN) * CONVERSION_RATE_USD #convert from BITCOIN -> EUR -> USD
      end
      
      return Money.new(currency_type, amount.round(2))  #return new money object with converted values
    end
      
  end #end convert_to
  
  
    
end
  

