class FoodsController < ApplicationController
  before_filter :require_current_food, :only => :show

  def show
    render :json => current_food
  end


  private

  def require_current_food
    render_not_found unless current_food
  end

  def current_food
    @current_food ||= Food.from_upc(params[:id])
  end
end
