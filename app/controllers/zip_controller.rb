class ZipController < ApplicationController

  def update
    new_zipcode = params[:zip_code]
    if new_zipcode.length == 5
      current_user.update(zip_code: new_zipcode)
      redirect_to :back
    else
      flash[:alert] = "Something went wrong with your zip code."
    end
  end

end