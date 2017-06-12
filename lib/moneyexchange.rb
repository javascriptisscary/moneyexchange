require "moneyexchange/version"

class Money
  attr_accessor :currency, :amount
  
  #obviously in some real iteration of this gem,conversions rates would change, but they will be constant in this example
  CONVERSION_RATE_USD = 1.11.freeze
  CONVERSION_RATE_BITCOIN = 0.0047.freeze

  def initialize(currency, amount)
    validate_currency(currency)
    validate_amount(amount)
    
    @currency = currency
    @amount = amount
  end
  
  def inspect
    "#{self.amount} #{self.currency}"
  end
  
  def same_currency(money1, money2)
    if money1.currency == money2.currency
      money2 #currency types the same, no need to convert
    else
      money2.convert_to(money1.currency) #return converted money2 to match so we can compare
    end
  end
  
  def ==(money2)
    money2 = same_currency(self, money2)
    self.amount == money2.amount ? true : false
  end
  
  def > (money2)
    money2 = same_currency(self, money2)
    self.amount > money2.amount ? true : false
  end
  
  def < (money2)
    money2 = same_currency(self, money2)
    self.amount < money2.amount ? true : false
  end
  
  def + (money2)
    return Money.new(self.currency, self.amount + money2 ) if money2.is_a? Numeric #if money2 is numeric, add by it and return
    money2 = same_currency(self, money2)
    Money.new(self.currency, self.amount + money2.amount)
  end

  def - (money2)
    return Money.new(self.currency, self.amount - money2 ) if money2.is_a? Numeric #if money2 is numeric, subtract by it and return
    money2 = same_currency(self, money2)
    Money.new(self.currency, self.amount - money2.amount)
  end
  
  def / (money2)
    return Money.new(self.currency, self.amount / money2 ) if money2.is_a? Numeric
      
    #if we get here, money2 is something other than a number. Error out
    raise "Only numerics are accepted for division of a money object."
  end
  
  def * (money2)
    return Money.new(self.currency, self.amount * money2 ) if money2.is_a? Numeric
    
    #if we get here, money2 is something other than a number. Error out
    raise "Only numerics are accepted for multiplication of a money object."
  end
  
  def convert_to(currency_type)
    validate_currency(currency_type)
    
    if self.currency == "USD" #Convert from USD
      if currency_type == "EUR"
        amount = ( self.amount / CONVERSION_RATE_USD)
      elsif currency_type == "BITCOIN"
        amount = ( self.amount / CONVERSION_RATE_USD) * CONVERSION_RATE_BITCOIN #convert from USD -> EUR -> BITCOIN
      end
    
    elsif self.currency == "EUR" #Convert from EUR
      if currency_type == "USD"
        amount = (CONVERSION_RATE_USD * self.amount)
      elsif currency_type == "BITCOIN"
        amount = (CONVERSION_RATE_BITCOIN * self.amount)
      end
    
    elsif self.currency == "BITCOIN" #Convert from BITCOIN
      if currency_type == "EUR"
        amount = ( self.amount / CONVERSION_RATE_BITCOIN)
      elsif currency_type == "USD"
        amount = ( self.amount / CONVERSION_RATE_BITCOIN) * CONVERSION_RATE_USD #convert from BITCOIN -> EUR -> USD
      end
  
    end
      
    return Money.new(currency_type, amount.round(2))  #return new money object with converted values  
      
  end #end convert_to
  
  private
  
  def validate_currency(currency)
    raise ArgumentError.new("Currency must be either USD, EUR, or BITCOIN") unless currency == "USD" || currency == "EUR" || currency =="BITCOIN"  
  end
  
  def validate_amount(amount)
    raise ArgumentError.new("Amount must be Numeric") unless amount.is_a? Numeric
  end
    
end
  

