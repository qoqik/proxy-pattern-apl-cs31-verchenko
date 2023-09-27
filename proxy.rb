class Account
  attr_reader :balance

  def initialize(balance = 0)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end

  def transaction_history
    @transaction_history ||= []
  end

  def add_transaction(description, amount)
    transaction_history << "#{description}: #{amount} dollars"
  end

  def print_transaction_history
    puts "Transaction History for this account:"
    transaction_history.each { |transaction| puts transaction }
  end
end

class AccessDeniedError < StandardError
  def initialize
    super("Access denied")
  end
end

class ProtectionProxy
  def initialize(accname, access_key)
    @accname = accname
    @access_key = access_key
  end

  def showbalance
    check_access
    puts "Balance: #{@accname.balance}"
  end

  def deposit(amount)
    check_access
    if amount <= 0
      puts "Wrong amount"
    else
      @accname.deposit(amount)
      puts "Successful. The account was replenished by #{amount}. Current balance - #{@accname.balance}"
      @accname.add_transaction("deposit", amount)
    end
  end

  def withdraw(amount)
    check_access
    if amount <= 0
      puts "Incorrect amount"
    elsif amount > @accname.balance
      puts "Not enough money (available to withdraw : #{@accname.balance})"
    else
      @accname.withdraw(amount)
      @accname.add_transaction("withdraw", amount)
      puts "Successful. #{amount} withdrawn from the account. #{@accname.balance} left"
    end
  end

  private

  def check_access
    if @access_key.start_with?("owner")
      puts "Access granted"
    else
      raise AccessDeniedError
    end
  end
end

test1 = ProtectionProxy.new(user1 = Account.new(100), "owner_key")
test2 = ProtectionProxy.new(user2 = Account.new(100), "regular_key")

test1.deposit(100)
test1.withdraw(30)
test1.withdraw(150)
test1.withdraw(70)
test1.deposit(30)
user1.print_transaction_history


test2.deposit(150)