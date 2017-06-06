class Pantry

  attr_reader :stock,
              :shopping_list

  def initialize
    @stock = {}
    @shopping_list = {}
  end

  def stock_check(ingredient)
    @stock[ingredient]
  end

  def restock(ingredient, amount)
    @stock[ingredient] += amount if @stock[ingredient].nil? == false
    @stock[ingredient] = amount if @stock[ingredient].nil?
  end

  def convert_units(recipe)
    recipe.ingredients.each do |ingredient, amount|
      recipe.ingredients[ingredient] = unit_conversion(amount)
    end
  end

  def unit_conversion(amount)
    amount = (amount * 1000).round if amount < 1
    amount = (amount / 100).round if amount > 100
    amount if (1..100).include? amount
  end

  def add_to_shopping_list(recipe)
    recipe.ingredients.each do |ingredient, amount|
      @shopping_list[ingredient] += amount if @shopping_list[ingredient].nil? == false
      @shopping_list[ingredient] = amount if @shopping_list[ingredient].nil?
    end
  end

  def print_shopping_list
    output_string = ""
    @shopping_list.each do |ingredient, amount|
      output_string += "* #{ingredient}: #{amount}\n"
    end
    puts output_string.strip
    output_string.strip
  end

end
