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
