# frozen_string_literal: true
class FoodsController < ApplicationController

  before_action :set_food, only: %i[show edit update destroy]

  # GET /foods or /foods.json
  def index
    @foods = Food.all.order('created_at desc')
  end

  def filter
    query = SearchQuery.new(params[:search])
    query.search_only_in_model(Food)
    search = Search::PerformSearchCommand.perform(search_query: query)
    @foods = if search.success?
              Food.where(id: search.value!.select(:searchable_id))
            else
              Food.all.order('created_at desc')
            end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
                 "foods", partial: "foods/foods", locals: {foods: @foods }
               )
      end
    end
  end

  # GET /foods/1 or /foods/1.json
  def show; end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit; end

  # POST /foods or /foods.json
  def create
    @food = Food.new(food_params)

    respond_to do |format|
      if @food.save
        Search::CreateSearchEntryCommand.perform(searchable_object: @food)
        format.html { redirect_to foods_url, notice: 'Food was successfully created.' }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1 or /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        Search::UpdateSearchEntryCommand.perform(searchable_object: @food)
        format.html { redirect_to food_url(@food), notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1 or /foods/1.json
  def destroy
    @food.destroy

    respond_to do |format|
      format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_food
    @food = Food.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def food_params
    params.require(:food).permit(:fat, :carbs, :fibre, :protein, :calories, :name)
  end

end
