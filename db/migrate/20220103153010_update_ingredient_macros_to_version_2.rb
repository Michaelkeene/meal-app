# frozen_string_literal: true
class UpdateIngredientMacrosToVersion2 < ActiveRecord::Migration[7.0]

  def change
    update_view :ingredient_macros, version: 2, revert_to_version: 1
  end

end
