
 CALLBACK_URL = "http://localhost:9393/oauth/callback"
 # WORD_COUNT = "banana"
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

    # set of emotions
    @emotions = []
    @emotion_counts = Hash.new(0)

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
        # p "word associated with that color"
         # puts individual word arrays into the collection word array
        @collection_word_array << word_array
    end
    @collection_word_array.flatten!

    # gives weight to each word based on the weight of the color in the collection
    @collection_word_array.each do |word|
        @word_counts[word.description] += 1
        @emotions << word.emotions
    end

    @emotions.flatten!

    @emotions.each do |emotion|
        @emotion_counts[emotion.description] += 1
    end

    @sorted_emotion_count = @emotion_counts.sort_by{|emotion, count| -count}

    @sorted_word_count = @word_counts.sort_by{|word, count| -count}
    # ten_percent = (@sorted_word_count.count * 0.1).to_i
    p @sorted_word_count = @sorted_word_count[0..20]

    # WORD_COUNT = @sorted_word_count
    erb :"/colors/index"
end

get '/pie' do
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

    # set of emotions
    @emotions = []
    @emotion_counts = Hash.new(0)

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
        # p "word associated with that color"
         # puts individual word arrays into the collection word array
        @collection_word_array << word_array
    end
    @collection_word_array.flatten!

    # gives weight to each word based on the weight of the color in the collection
    @collection_word_array.each do |word|
        @word_counts[word.description] += 1
        @emotions << word.emotions
    end

    @emotions.flatten!

    @emotions.each do |emotion|
        @emotion_counts[emotion.description] += 1
    end

    @sorted_emotion_count = @emotion_counts.sort_by{|emotion, count| -count}

    return @sorted_emotion_count.to_json

end

