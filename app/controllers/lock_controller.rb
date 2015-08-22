require 'lockitron'
require 'session_helper'

class LockController < ApplicationController
  include SessionHelper
  include BulbHelper

  before_action :logged_in_user

  def index
    @locks = all_locks
  end

  def view
    @lock = lock_json(lock_by_id(params[:id]))
  end

  def update
    id = params[:id]
    set_lock_by_id(id, params[:lock])
    redirect_to "/locks/#{id}"
  end

  private

  def logged_in_user
    if current_user.nil?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    elsif current_user.api_token.nil?
      flash[:danger] = 'Insufficient permissions'
      redirect_to '/'
    end
  end

  def all_locks
    @user ||= lock_user("")
    locks = @user.locks.collect do |lock|
      lock_json(lock)
    end
  end

  def lock_by_id(id)
    @user ||= lock_user("")
    @user.locks.select { |l| l.uuid == id }.first
  end

  def set_lock_by_id(id, to_lock)
    update_lock(lock_by_id(id), to_lock)
  end
end
