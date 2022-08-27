# frozen_string_literal: true
class UserTargetsPresenter < EdiblePresenters::Base

  def initialize(user)
    @user = user
    @targets = user.targets
  end

  def name
    "Today's Target"
  end

  def edit_path
    Rails
      .application
      .routes
      .url_helpers
      .edit_user_targets_path(@user)
  end

  def dom_id
    ActionView::RecordIdentifier.dom_id(
      @user,
      :target_macros
    )
  end

  # you cannot delete totals
  def deletable?
    false
  end

  private

  attr_reader :targets

  def stats_for_macro(macro)
    targets.fetch(macro) do
      raise NoMethodError, 'macro accessor not set'
    end
  end

end
