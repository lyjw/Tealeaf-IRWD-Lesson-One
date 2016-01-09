# Quiz: Lesson 1

## 1. What is the value of a after the below code is executed? 

a = 1
b = a
b = 3

# a = 1

## 2. What's the difference between an Array and a Hash? 

# An array is an ordered list of objects organized by indices.
# A hash stores elements in key-value pairs. 
# Hash values are referenced by key (which can be any type of object), whilst array elements are referenced by index (integers) only.

## 3. Every Ruby expression returns a value. Say what value is returned in the below expressions: 

arr = [1, 2, 3, 3] # -> [1, 2, 3, 3]
[1, 2, 3, 3].uniq # -> [1, 2, 3] (arr = [1, 2, 3, 3] )
[1, 2, 3, 3].uniq! # -> [1, 2, 3] (arr = [1, 2, 3] )

## 4. What's the difference between the map and select methods for the Array class? Give an example of when you'd use one versus the other. 

# The map method iterates through each element in an array and applies the given expression to each element, then returns a new array of the modified elements. (Transformation - the code in the block should return a transformed value)

# The select method iterates through each element of an array and returns the elements that meet the given expression. (Selection - the code in the block should return a boolean)

arr = [1, 2, 3, 4]
arr.map { |x| x + 2 } # -> [3, 4, 5, 6]
arr.select { |x| x % 2 == 0 } # -> [2, 4]

## 5. Say you wanted to create a Hash. How would you do so if you wanted the hash keys to be String objects instead of symbols? 

# By using hash rockets to create key-value pairs, i.e. 
hsh = {"One" => 1, "Two" => 2}

## 6. What is returned? 

x = 1
x.odd? ? "no way!" : "yes, sir!"

# -> "no way!" , becuase x.odd? evaluates to true.

## 7. What is x? 

x = 1

3.times do
  x += 1
end

puts x

# x = 4

## 8. What is x? 

3.times do
  x += 1
end

puts x

# Error! x does not exist (has not been declared as a local variable) and thus, has a value of nil. When the times method calls it, a NoMethodError is thrown because the '+' method cannot be applied to nil. 