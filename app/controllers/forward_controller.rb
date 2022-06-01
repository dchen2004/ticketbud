class ForwardController < ApplicationController
  before_action :set_short_link

  def show
    redirect_to @short_link.destination_url
  end

  private

  def set_short_link
    @short_link = ShortLink.find_by! slug: params[:slug]
  end
end
