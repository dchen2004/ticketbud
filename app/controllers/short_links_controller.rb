class ShortLinksController < ApplicationController
  before_action :set_short_link, except: %i(index new create)

  def index
    @short_links = ShortLink.all
  end

  def new
    @short_link = ShortLink.new
  end

  def create
    @short_link = ShortLink.new(short_link_params)
    if @short_link.save
      redirect_to root_path, notice: 'The ShortLink has been created.'
    else
      flash.now[:alert] = full_error_messages
      render :new
    end
  end

  def update
    if @short_link.update(short_link_params)
      redirect_to short_link_path(@short_link),
        notice: 'The ShortLink has been updated.'
    else
      flash.now[:alert] = full_error_messages
      render :edit
    end
  end

  def destroy
    @short_link.destroy
    redirect_to root_path, notice: 'The ShortLink has been destroyed.'
  end

  private

  def set_short_link
    @short_link = ShortLink.find params[:id]
  end

  def short_link_params
    params.require(:short_link).permit(:slug, :destination_url)
  end

  def full_error_messages
    @short_link.errors.full_messages.join ', '
  end
end
