# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    gon.current_user = current_user || nil
  end
end
