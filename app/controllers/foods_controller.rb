class FoodsController < ApplicationController

  def show
    render :json => Food.from_upc(params[:id])
  end
end
