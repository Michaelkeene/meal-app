# frozen_string_literal: true
module EdiblePresenters
  class IngredientPresenter < EdiblePresenters::Base

    def initialize(ingredient)
      @ingredient = ingredient
      @food = ingredient.food
    end

    delegate :name, to: :food
    delegate :grams, to: :ingredient

    def edit_path
      url_helper
        .edit_meal_ingredient_path(ingredient, meal_id: ingredient.meal.id)
    end

    def destroy_path
      url_helper
        .meal_ingredient_path(ingredient, meal_id: ingredient.meal_id)
    end

    def dom_id(prefix = nil)
      ActionView::RecordIdentifier.dom_id(
        @ingredient,
        prefix
      )
    end

    private

    attr_reader :food, :ingredient

    def stats_for_macro(macro)
      ratio * food.send(macro)
    end

    def ratio
      ingredient.grams / 100
    end

  end
end
