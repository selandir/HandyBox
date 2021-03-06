class FolderController < ApplicationController

  before_action :authenticate_user!
  
  def index
    render :json => folder_hash(withdraw_root_folder)
  end

  def show
    render :json => folder_hash([Folder.find(params[:id])])
  end

  def new

  end

  def create
    
  end

  def edit
    
  end

  def update
    
  end
  
  def delete

  end

  def withdraw_root_folder
    if current_user.is_admin?
      list = []
      User.all.each { |u| list << u.folder if !u.folder.nil?}
      return list
    else
      return [current_user.folder]
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

end