
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
    images=[]
    xapp_token = 'JvTPWe4WsQO-xqX6Bts49j-QZvef3rUVGlOeA86rqr9_dHYzUZwWISbG_ftSl3HzYYrFuYKNgW6Z0DLZlRM4tGRvmb9n8ZVNExt7l0kbt7Szds4vZ8MOu5dd6GKTXpLVMkZqVo8Z0mXj690oVy2zQeHr5RnQ6Zv6-zwa_FsXrSNpZj5jT0p8dBHvGwcjuecUXUAmPMWPrvl8IUvUIH5GhhXVMlfTsi3cMWDR5qiWgCc='

    api = Hyperclient.new('https://api.artsy.net/api') do |api|
      api.headers['Accept'] = 'application/vnd.artsy-v2+json'
      api.headers['X-Xapp-Token'] = xapp_token
      api.connection(default: false) do |conn|
        conn.use FaradayMiddleware::FollowRedirects
        conn.use Faraday::Response::RaiseError
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter :net_http
      end
    end
    p "made it"

    art_hash = api.artist(id: "andy-warhol")["_links"].to_s
    images << art_hash["thumbnail"].to_s
    erb :'_image_thumbnails', layout: false, locals:{images: images}
  else
    redirect "/user/:id"
  end
end

get '/test' do

  response = Unirest.get "https://apicloud-colortag.p.mashape.com/tag-url.json?palette=simple&sort=relevance&url=http%3A%2F%2Fapicloud.me%2Fassets%2Fcolortag%2Fimage1.jpg",
  headers:{
    "X-Mashape-Key" => "ByM2wdIs7kmsheb14zyThpYddUukp196gLRjsnLtcS2Fn2ojUg",
    "Accept" => "application/json"
  }
  p "hello!!!"
  p response.body

end
