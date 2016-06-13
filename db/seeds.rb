  def parse(file)
    File.open(file).readlines.each do |line|

      color = /(?<=\bColour=)(\w+)/.match(line).to_s
      grouped_words = /^.*(?=\sColour)/.match(line).to_s
      word_array = (grouped_words).scan(/(\w+)/).flatten
      if !Color.find_by(name: color) && color!="None"
        Color.create(name: color)
      end
      word_array.each do |word|
        unless color == "None"
          new_word = Word.create(description: word, color_id: Color.find_by(name:color).id)
        end
      end
    end
  end


parse("db/NRC-Colour-Lexicon-v0.92/NRC-color-lexicon-senselevel-v0.92.txt")
