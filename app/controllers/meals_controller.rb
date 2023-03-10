# frozen_string_literal: true
class MealsController < ApplicationController

  before_action :set_meal, only: %i[show edit update destroy]

  # GET /meals or /meals.json
  def index
    @meals = Meal.all
  end

  def filter
    query = SearchQuery.new(params[:search])
    query.search_only_in_model(Meal)
    search = Search::PerformSearchCommand.perform(search_query: query)
    @meals = if search.success?
              Meal.where(id: search.value!.select(:searchable_id))
            else
              Meal.all.order('created_at desc')
            end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
                 "meals", partial: "meals/meals", locals: {meals: @meals }
               )
      end
    end
  end

  # GET /meals/1 or /meals/1.json
  def show; end

  # GET /meals/new
  def new
    @meal = Meal.new
  end

  # GET /meals/1/edit
  def edit; end

  # POST /meals or /meals.json
  def create
    @meal = Meal.new(meal_params)

    respond_to do |format|
      if @meal.save
        Search::CreateSearchEntryCommand.perform(searchable_object: @meal)
        format.html { redirect_to meal_url(@meal), notice: 'Meal was successfully created.' }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meals/1 or /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        Search::UpdateSearchEntryCommand.perform(searchable_object: @meal)
        format.html { redirect_to meal_url(@meal), notice: 'Meal was successfully updated.' }
        format.json { render :show, status: :ok, location: @meal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1 or /meals/1.json
  def destroy
    @meal.destroy

    respond_to do |format|
      format.html { redirect_to meals_url, notice: 'Meal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meal
    @meal = Meal.includes(ingredients: :food).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def meal_params
    params.require(:meal).permit(:name, :recipe)
  end

end
