json.extract! post, :id, :author, :content, :points, :numcomments, :created_at, :updated_at
json.url post_url(post, format: :json)
