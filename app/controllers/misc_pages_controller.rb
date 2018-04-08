# frozen_string_literal: true

class MiscPagesController < ApplicationController
  def about
    @contact_email = ENV["CONTACT_EMAIL"]
  end

  def home
    respond_to do |format|
      format.html
      format.json
    end
  end

  def details
  end
end
