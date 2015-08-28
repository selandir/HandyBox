class Api::ApiController < ApplicationController

  respond_to :json
 
  before_action :authenticate

  def index
    render :json => @user.to_json
  end

  def withdraw_root_folder
    if @user.is_admin?
      list = []
      User.all.each { |u| list << u.folder if !u.folder.nil?}
      return list
    else
      return [@user.folder]
    end
  end

  def folder_hash(main_folder)
    hash_array = []
    main_folder.each do |folder|
      ret_hash = {
        :id => folder.id.to_s,
        :name => folder.name,
        :is_directory => true,
        :size => folder.size,
        :children => folder_hash(folder.children),
        :items => item_hash(folder.item)
      }
      hash_array << ret_hash
    end
    return hash_array
  end
  
  def item_hash(items)
    hash_array = []
    items.each do |item|
      ret_hash = {
        :id => item.id.to_s,
        :name => item.name,
        :is_directory => false,
        :extension => 'undefined', #TODO
        :size => item.size
      }
      hash_array << ret_hash
    end
    return hash_array
  end

  private
 
  def authenticate
    api_key = request.headers['api-key'].to_s
    @user = User.where(:api_key => api_key).first if api_key

    unless @user
      head status: :unauthorized
    end
  end

end
