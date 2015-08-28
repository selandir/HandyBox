class Item 
  include Mongoid::Document
  include Mongoid::Timestamps

  before_destroy :delete_attachment_from_hdd
  
  mount_uploader :attachment, FileboxUploader

  field :name
  belongs_to :folder

  validates :attachment, presence: true
  
  def ancestors_path
    path = "" #{folder.name.gsub(" ", "_")}"
    self.folder.ancestors.each do |a|
      path += a[:name].gsub(" ", "_")
      path += "/"
    end
    return path
  end

  def filename
    self.attachment.instance_variable_get('@file').filename if !self.attachment.instance_variable_get('@file').nil?
  end

  def name
    return filename
  end
  
  def is_image?
    [".png",".jpg",".gif",".bmp", "tiff", "jpeg", ".psd"].include?(self.filename[-4..-1].downcase)
  end

  def size
    self.attachment.size
  end
  
  private
  
  def delete_attachment_from_hdd
    File.delete(self.attachment.url)
  end
  
end
