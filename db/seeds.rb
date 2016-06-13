  def emotional_parse(file)
    File.open(file).readlines.each do |line|
      association = line.scan(/(\w+)/).flatten
      word = line.scan(/(\w+)/).flatten[0]
      emotion = line.scan(/(\w+)/).flatten[1]
      # if the association isn't 0 and the emotion doesn't already exist in the database,
      if association[2]!= "0"
        the_emotion = nil
        the_word = nil
        if Emotion.find_by(description: emotion)
          the_emotion = Emotion.find_by(description: emotion)
        else
        # create that new emotion
          the_emotion = Emotion.create(description: emotion)
        end
        # if the word doesn't already exist in the database,
        if Word.find_by(description: word)
          the_word = Word.find_by(description: word)
        else
        # add the word
          the_word = Word.create(description: word)
        end
        # create the relationship
        Relationship.create(emotion_id: the_emotion.id, word_id: the_word.id)
      end
    end
  end
  def color_parse(file)
    File.open(file).readlines.each do |line|

      color = /(?<=\bColour=)(\w+)/.match(line).to_s
      grouped_words = /^.*(?=\sColour)/.match(line).to_s
      word_array = (grouped_words).scan(/(\w+)/).flatten
      if !Color.find_by(name: color) && color!="None"
        Color.create(name: color)
      end
      word_array.each do |word|
        unless color == "None" || !Word.find_by(description: word)
          existing_word = Word.find_by(description: word)
          existing_word.update(color_id: Color.find_by(name:color).id)
        end
      end
    end
  end

emotional_parse("db/NRC-Colour-Lexicon-v0.92/NRC-emotion-lexicon-wordlevel-alphabetized-v0.92.txt")
color_parse("db/NRC-Colour-Lexicon-v0.92/NRC-color-lexicon-senselevel-v0.92.txt")
