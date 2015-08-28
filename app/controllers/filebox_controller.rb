class FileboxController < ApplicationController

  #before_action :authenticate_user!, :except => [:index, :login]

  def index
    redirect_to login_path and return if !user_signed_in?
    create_root_folder_if_missing
    withdraw_items
    @folder_list = @root_folder
    @file = Item.new
    @folders = folder_hash(withdraw_root_folder)
  end 

  def create
    withdraw_items
    new_file = @root_folder.first.item.new()
    if !params[:item].nil?
      create_file(new_file)
    end
    
    if new_file.save
      redirect_to filebox_index_path, :notice => "Dodano"
    else
      redirect_to filebox_index_path, :alert => "Nie dodano"
    end
  end

  def withdraw_items
    @root_folder = withdraw_root_folder
    @folder = folder_hash(@root_folder)
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
        :items => []
      }
      hash_array << ret_hash
    end
    return hash_array
  end
  
  def item_hash(item)
    ret_hash = {
      :id => item.id.to_s,
      :name => item.name,
      :is_directory => false,
      :size => item.size,
      :children => []
    }
    return ret_hash
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

  def create_root_folder_if_missing
    current_user.create_root_folder if current_user.folder.nil?
  end

  def create_file(new_file)
    new_file.attachment = params[:item][:attachment]
    new_file.name = new_file.filename
  end

  def download_file
    file = Folder.find(params[:folder_id]).item.find(params[:item_id])
    send_file file.attachment.url
  end

  def show_image
    file  = Folder.find(params[:folder_id]).item.find(params[:item_id])
    if file.is_image?
      url = file.attachment.url
      send_file url, :type => 'image/jpeg', :disposition => 'inline'
    end
  end 

  def delete_item
    file  = current_user.folder.item.find(params[:item_id])
    delete_attachment_from_hdd(file)
    if file.delete
      render :json => {:notice => "Ok"}
    else
      render :json => {:notice => "Nope."}
    end
  end

  def delete_attachment_from_hdd(file)
    File.delete(file.attachment.url) if File.exist? file.attachment.url
  end

  def get_folders_and_items
    @folder = Folder.find(params[:folder_id])
    folder = @folder # testowo
    return_hash = {}

    return_hash[:id] = folder.id.to_s
    return_hash[:name] = folder.name
    return_hash[:type] = "dir"
    return_hash[:ext] = false
    return_hash[:size] = folder.size
    return_hash[:items] = []
    #@folder.each do |folder|
      folder.item.each do |item|
        item_hash = {}
        item_hash[:id] = item.id.to_s
        item_hash[:name] = item.name
        item_hash[:type] = "file"
        item_hash[:ext] = "image" if item.is_image?
        item_hash[:ext] = "unknown" if !item.is_image?
        item_hash[:size] = item.size
        return_hash[:items] << item_hash
      end
    #end
    render :json => folder_hash(withdraw_root_folder)
  end

end
