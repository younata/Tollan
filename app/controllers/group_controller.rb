require 'Huey'

def as_int(str)
  return str.to_i if str =~ /\A\d+\Z/
  str
end

class GroupController < ApplicationController
  def index
  end

  def show
  end

  def create
  end

  def update
  end
end
