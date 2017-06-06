require './test/test_helper'

class PantryTest < Minitest::Test

  def test_pantry_exists
    pantry = Pantry.new
    assert_instance_of Pantry, pantry
  end

  def test_pantry_has_empty_stock
    pantry = Pantry.new
    assert_empty pantry.stock
  end

  def test_pantry_has_no_cheese_yet
    pantry = Pantry.new
    assert_nil pantry.stock_check("Cheese")
  end

  def test_pantry_can_stock_something
    pantry = Pantry.new
    pantry.restock("Cheese", 20)
    assert_equal pantry.stock_check("Cheese"), 20
  end

  def test_pantry_can_stock_something_again
    pantry = Pantry.new
    pantry.restock("Cheese", 20)
    pantry.restock("Cheese", 10)
    assert_equal pantry.stock_check("Cheese"), 30
  end

  def test_pantry_can_stock_more_than_one_thing
    pantry = Pantry.new
    pantry.restock("Cheese", 20)
    pantry.restock("Cheese", 10)
    pantry.restock("Noodles", 10)
    assert_equal pantry.stock_check("Cheese"), 30
    assert_equal pantry.stock_check("Noodles"), 10
    assert_equal pantry.stock.count, 2
  end

  def test_pantry_can_convert_small_amounts_to_milliunits
    pantry = Pantry.new
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cayenne", 0.025)
    pantry.convert_units(r)
    assert_equal r.ingredients["Cayenne"], 25
  end

  def test_pantry_can_convert_large_amounts_to_centiunits
    pantry = Pantry.new
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Flour", 500)
    pantry.convert_units(r)
    assert_equal r.ingredients["Flour"], 5
  end

  def test_pantry_will_not_convert_amounts_between_1_and_100
    pantry = Pantry.new
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cheese", 75)
    pantry.convert_units(r)
    assert_equal r.ingredients["Cheese"], 75
  end

  def test_pantry_can_convert_more_than_one_ingredient
    pantry = Pantry.new
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Flour", 500)
    r.add_ingredient("Cheese", 75)
    r.add_ingredient("Cayenne", 0.025)
    pantry.convert_units(r)
    assert_equal r.ingredients["Flour"], 5
    assert_equal r.ingredients["Cheese"], 75
    assert_equal r.ingredients["Cayenne"], 25
  end

  def test_pantry_has_shopping_list
    pantry = Pantry.new
    assert_instance_of Hash, pantry.shopping_list
  end

  def test_pantry_shopping_list_is_empty
    pantry = Pantry.new
    assert_empty pantry.shopping_list
  end

  def test_pantry_can_add_to_shopping_list
    pantry = Pantry.new
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Flour", 500)
    pantry.add_to_shopping_list(r)
    assert_equal pantry.shopping_list.count, 1
    assert_equal pantry.shopping_list["Flour"], 500
  end

  def test_pantry_can_add_more_than_one_thing_to_shopping_list
    pantry = Pantry.new
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Flour", 500)
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Cayenne", 0.025)
    pantry.add_to_shopping_list(r)
    assert_equal pantry.shopping_list.count, 3
    assert_equal pantry.shopping_list["Flour"], 500
    assert_equal pantry.shopping_list["Cheese"], 20
    assert_equal pantry.shopping_list["Cayenne"], 0.025
  end

  def test_pantry_can_add_more_than_one_recipe_to_shopping_list
    pantry = Pantry.new
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Flour", 500)
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Cayenne", 0.025)

    pantry.add_to_shopping_list(r)

    r2 = Recipe.new("Spaghetti")
    r2.add_ingredient("Noodles", 10)
    r2.add_ingredient("Sauce", 10)
    r2.add_ingredient("Cheese", 5)

    pantry.add_to_shopping_list(r2)

    assert_equal pantry.shopping_list.count, 5

    assert_equal pantry.shopping_list["Flour"], 500
    assert_equal pantry.shopping_list["Cheese"], 25
    assert_equal pantry.shopping_list["Cayenne"], 0.025
    assert_equal pantry.shopping_list["Noodles"], 10
    assert_equal pantry.shopping_list["Sauce"], 10
  end

  def test_print_shopping_list
    pantry = Pantry.new

    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Flour", 500)
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Cayenne", 0.025)

    pantry.add_to_shopping_list(r)

    r2 = Recipe.new("Spaghetti")
    r2.add_ingredient("Spaghetti Noodles", 10)
    r2.add_ingredient("Cheese", 5)
    r2.add_ingredient("Sauce", 10)

    pantry.add_to_shopping_list(r2)

    assert_equal pantry.print_shopping_list, "* Flour: 500\n* Cheese: 25\n* Cayenne: 0.025\n* Spaghetti Noodles: 10\n* Sauce: 10"
  end

  def test_print_shopping_list_with_different_input_order
    pantry = Pantry.new

    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cayenne", 0.025)
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 500)
    pantry.add_to_shopping_list(r)

    r2 = Recipe.new("Spaghetti")
    r2.add_ingredient("Sauce", 10)
    r2.add_ingredient("Cheese", 5)
    r2.add_ingredient("Spaghetti Noodles", 10)

    pantry.add_to_shopping_list(r2)

    assert_equal pantry.print_shopping_list, "* Cayenne: 0.025\n* Cheese: 25\n* Flour: 500\n* Sauce: 10\n* Spaghetti Noodles: 10"
  end



end
