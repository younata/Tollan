require 'Huey'

def as_int(str)
  return str.to_i if str =~ /\A\d+\Z/
  str
end

class GroupController < ApplicationController
  def index
    render :json => Huey::Group.all
  end

  def show
    id = as_int(params[:id])
    render :json => Huey::Group.find(id)
  end

  def create
  end

  def update
  end

  def delete
  end
end
