  def parse(file)
    File.open(file).readlines.each do |line|
      color = /(?<=\bColour=)(\w+)/.match(line).to_s
      grouped_words = /^.*(?=\sColour)/.match(line).to_s
      word = /(\w+)/.match(grouped_words).to_s
      if !Color.find_by(name: color)
        new_color = Color.create(name: color)
      end
      new_word = Word.create(description: word, color_id: Color.find_by(name:color).id)
      # new_color << new_word Why doesn't this work..?
    end
  end


parse("db/NRC-Colour-Lexicon-v0.92/NRC-color-lexicon-senselevel-v0.92.txt")