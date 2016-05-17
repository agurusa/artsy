
get '/' do
  erb :index
end

post '/sentence' do
  if request.xhr?
    sentence = params["sentence"].split(" ")
    colors = []
    sentence.each do |word|
      if Word.find_by(description: word)
        id = Word.find_by(description: word).color_id
        colors <<  Color.find_by(id: id)
      end
    end
    erb :'_color_list', layout: false, locals:{colors: colors}
  else
    redirect "/user/:id"
  end
end

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

