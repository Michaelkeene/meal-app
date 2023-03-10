# frozen_string_literal: true
module EdiblePresenters
  class FoodConsumptionEventPresenter < Base

    attr_reader :grams

    def initialize(consumption_event)
      @food = consumption_event.food
      @grams = consumption_event.grams
      @consumption_event = consumption_event
    end

    def name
      food.name
    end

    def edit_path
      url_helper
        .edit_food_consumption_event_path(@consumption_event)
    end

    def destroy_path
      url_helper
        .food_consumption_event_path(@consumption_event)
    end

    def dom_id(prefix = nil)
      ActionView::RecordIdentifier.dom_id(
        @consumption_event,
        prefix
      )
    end

    private

    def stats_for_macro(macro)
      food.send(macro) * grams / 100
    end

    attr_reader :food

  end
end
