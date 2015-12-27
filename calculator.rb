def say(str)
  puts "=> #{str}"
end

def is_a_number?(num)
  num =~ /\d/
end

def invalid_number(num)
  puts "#{num} is not a valid number. Please try again:"
end

loop do

  say "What would you like to do?
  \t1) Add \n\t2) Subtract \n\t3) Multiply \n\t4) Divide"
  calculate = gets.chomp

  case calculate

  when "1", "2", "3", "4"

    loop do

      say "The first number is:"
      num1 = gets.chomp

      loop do

        if is_a_number?(num1) == nil
          invalid_number(num1)
          num1 = gets.chomp
        else
          break
        end

      end

      say "The second number is:"
      num2 = gets.chomp

      loop do

        if is_a_number?(num2) == nil
          invalid_number(num2)
          num2 = gets.chomp
        else
          break
        end

      end

      if is_a_number?(num1) && is_a_number?(num2)
        
        case calculate
        when "1"
          result = num1.to_f + num2.to_f
          operator = "+"
        when "2"
          result = num1.to_f - num2.to_f
          operator = "-"
        when "3"
          result = num1.to_f * num2.to_f
          operator = "x"
        else
          result = num1.to_f / num2.to_f
          operator = "÷"
        end

        calculation = "#{num1} #{operator} #{num2}"
        say "#{calculation} = #{result}"
        break
      end

    end

  else
    puts "That is not a valid option.\n\n"
    redo
  end

  puts "-----------------------------------------------"
  say "Would you like to make another calculation? \n
  \t1) Yes\n\t2) No"
  again = gets.chomp

  loop do

    case again
    when "1", "Yes", "2", "No"
      break
    else 
      say "Please enter 1) Yes / 2) No"
      again = gets.chomp
    end

  end

  break if again == "2"

end