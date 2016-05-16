sentence = "I am sad"
array = sentence.split(" ")
array.each do |word|
  if Word.find_by(description: word)
    id = Word.find_by(description: word).color_id
    Color.find_by(id: id).name
  end
end


