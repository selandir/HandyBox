module ApplicationHelper

  def retrieve_json_data(src)
    resp = JSON.parse(open(src).read)
    return resp
  end

end
