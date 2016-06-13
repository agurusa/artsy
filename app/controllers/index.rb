
 CALLBACK_URL = "http://localhost:9393/oauth/callback"
 WORD_COUNT = "banana"
get '/' do
  erb :index
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/colors/index"
end

get "/colors/index" do

    # Get access to user's instagram photos
    client = Instagram.client(:access_token => session[:access_token])
    # All the photos that belong to that user
    @media = client.user_recent_media
    # All the colors from the collection of images, not unique.
    @all_image_colors = []

    # All the words associated with the collection, not unique.
    @collection_word_array = []

    # weighted colors from the collection, sets default value of hash key to be 0
    @word_counts = Hash.new(0)

    # unique set of words in the collection
    @descriptions = []

    @media.each do |media_item|
        # colors from an individual image
        image_colors = []

        # queries the ColorTag API to find dominant colors in each photo
        color_tag_url= ("https://apicloud-colortag.p.mashape.com/tag-url.json?palette=simple&sort=relevance&url=" + media_item.images.thumbnail.url)
        header = {headers:{
          "X-Mashape-Key" => ENV['COLOR_TAG_SECRET'],
          "Accept" => "application/json"
        }}
        result = HTTParty.get(color_tag_url, header)
        result["tags"].each do |pair|
            image_colors << pair["label"]
        end
        @all_image_colors << image_colors
    end

    @all_image_colors.flatten!

    # finds words associated with all the colors
    @all_image_colors.each do |color|
        word_array = []
        # if the color exists in the database...
        if Color.find_by(name: color.downcase)
            # gather the words associated with that color
            word_array << Color.find_by(name: color.downcase).words
        end
        p "word associated with that color"
         # puts individual word arrays into the collection word array
        @collection_word_array << word_array
    end
    @collection_word_array.flatten!

    # gives weight to each word based on the weight of the color in the collection
    @collection_word_array.each do |word|
        @word_counts[word.description] += 1
    end

    @sorted_word_count = @word_counts.sort_by{|word, count| -count}
    # ten_percent = (@sorted_word_count.count * 0.1).to_i
    @sorted_word_count = @sorted_word_count[0..20]

    WORD_COUNT = @sorted_word_count
    p "done with main function"
    erb :"/colors/index"
end

get '/pie' do
      # Get access to user's instagram photos
    client = Instagram.client(:access_token => session[:access_token])
    # All the photos that belong to that user
    @media = client.user_recent_media
    @media2 = @media[0..2]
    # All the colors from the collection of images, not unique.
    @all_image_colors = []

    # All the words associated with the collection, not unique.
    @collection_word_array = []

    # weighted colors from the collection, sets default value of hash key to be 0
    @word_counts = Hash.new(0)

    # unique set of words in the collection
    @descriptions = []

    @media2.each do |media_item|
        # colors from an individual image
        image_colors = []

        # queries the ColorTag API to find dominant colors in each photo
        color_tag_url= ("https://apicloud-colortag.p.mashape.com/tag-url.json?palette=simple&sort=relevance&url=" + media_item.images.thumbnail.url)
        header = {headers:{
          "X-Mashape-Key" => ENV['COLOR_TAG_SECRET'],
          "Accept" => "application/json"
        }}
        result = HTTParty.get(color_tag_url, header)
        result["tags"].each do |pair|
            image_colors << pair["label"]
        end
        @all_image_colors << image_colors
    end

    @all_image_colors.flatten!

    # finds words associated with all the colors
    @all_image_colors.each do |color|
        word_array = []
        # if the color exists in the database...
        if Color.find_by(name: color.downcase)
            # gather the words associated with that color
            word_array << Color.find_by(name: color.downcase).words
        end
        p "word associated with that color"
         # puts individual word arrays into the collection word array
        @collection_word_array << word_array
    end
    @collection_word_array.flatten!

    # gives weight to each word based on the weight of the color in the collection
    @collection_word_array.each do |word|
        @word_counts[word.description] += 1
    end

    @sorted_word_count = @word_counts.sort_by{|word, count| -count}
    # ten_percent = (@sorted_word_count.count * 0.1).to_i
    @sorted_word_count = @sorted_word_count[0..20]

    return @sorted_word_count.to_json
end

# post '/sentence' do
#   if request.xhr?
#     sentence = params["sentence"].split(" ")
#     colors = []
#     sentence.each do |word|
#       if Word.find_by(description: word)
#         id = Word.find_by(description: word).color_id
#         colors <<  Color.find_by(id: id)
#       end
#     end
#     erb :'_color_list', layout: false, locals:{colors: colors}
#   else
#     redirect "/user/:id"
#   end
# end

get '/artwork' do
  if request.xhr?
    # Implement this feature eventually. This returns images of famous artwork
    # images=[]
    # xapp_token = 'JvTPWe4WsQO-xqX6Bts49j-QZvef3rUVGlOeA86rqr9_dHYzUZwWISbG_ftSl3HzYYrFuYKNgW6Z0DLZlRM4tGRvmb9n8ZVNExt7l0kbt7Szds4vZ8MOu5dd6GKTXpLVMkZqVo8Z0mXj690oVy2zQeHr5RnQ6Zv6-zwa_FsXrSNpZj5jT0p8dBHvGwcjuecUXUAmPMWPrvl8IUvUIH5GhhXVMlfTsi3cMWDR5qiWgCc='

    # api = Hyperclient.new('https://api.artsy.net/api') do |api|
    #   api.headers['Accept'] = 'application/vnd.artsy-v2+json'
    #   api.headers['X-Xapp-Token'] = xapp_token
    #   api.connection(default: false) do |conn|
    #     conn.use FaradayMiddleware::FollowRedirects
    #     conn.use Faraday::Response::RaiseError
    #     conn.request :json
    #     conn.response :json, content_type: /\bjson$/
    #     conn.adapter :net_http
    #   end
    # end
    # art_hash = api.artist(id: "andy-warhol")["_links"].to_s
    # p art_hash["thumbnail"].to_s
    # # images << art_hash["artworks"].to_s

    # # url= ("https://apicloud-colortag.p.mashape.com/tag-url.json?palette=simple&sort=relevance&url=" + images[0])
    # # header = {headers:{
    # #   "X-Mashape-Key" => "jxvCR3fmeSmsh1grreghVm68xDtWp1d790ejsnasPwsbzIqBTP",
    # #   "Accept" => "application/json"
    # # }}
    # # result = HTTParty.get(url, header)
    # # image_colors = []
    # # result["tags"].each do |pair|
    # #   image_colors << pair["label"]
    # # end
    # # p image_colors



    # erb :'_image_thumbnails', layout: false, locals:{images: images}

  else
    redirect "/user/:id"
  end
end

