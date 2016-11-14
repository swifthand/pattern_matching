
PatternMatching.configure do |config|
  config.binding_helper = :H
end



include PatternMatching

def get_account_balance(fail: false)
  if fail
    [:error, "I literally can't even"]
  else
    "$1234.56"
  end
end

def foo(f)
  case Pattern(get_account_balance(fail: f))
  when Match(H.balance >> String)
    puts "Balance: #{H.balance}"
  when Match([:error, H.info])
    puts "Error: #{H.info}"
  end
end

foo(false)



def bar(f)
  my_bindings = PatternMatching::Bindings.new
  case Pattern(get_account_balance(fail: f))
  when Match(my_bindings.balance >> String)
    puts "Balance: #{my_bindings.balance}"
  when Match([:error, my_bindings.info])
    puts "Error: #{my_bindings.info}"
  end
end

bar(false)
