# frozen_string_literal: true
module Broadcasts
  class UpdateTodaysFood < ApplicationCommand

    def perform
      user.broadcast_replace_to(
        :todays_totals,
        target: UserTargetsPresenter.new(food_totals).dom_id,
        partial: 'edibles/row',
        locals: {
          edible: food_totals,
          no_quantity: true,
          no_header: true,
          presenter: UserTargetsPresenter
        }
      )
    end

    private

    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def food_totals
      @food_totals ||= Totals::MakeTotalFromCollection.perform(collection: user.todays_food, total_type: :food,
                                                               user: user)
    end

  end
end
