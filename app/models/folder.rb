class Folder
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree


  field :name, :type => String

  belongs_to :user
  has_many :item

  def size
    size = 0
    self.item.each { |f| size += f.attachment.size }
    self.children.each { |c| size += c.size }
    return size
  end

  def ancestors
    ancestors = []
    scope = self
    while !scope.nil?
      ancestors << {:name => scope.name, :id => scope.id}
      scope = scope.parent
    end
    return ancestors.reverse
  end

  def ancestors_path
    path = ""
    self.ancestors.each do |a|
      path += a[:name].gsub(" ", "_")
      path += "/"
    end
    return path
  end

  def is_empty?
    return children.empty? && item.empty?
  end

end
