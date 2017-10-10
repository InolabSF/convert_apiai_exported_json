require 'json'
require 'csv'


# speech
speeches = []
  # read json
Dir.glob('json/intents/*.json').each do |filename|
  file = File.read(filename)
  json = JSON.parse(file)
  begin
    responses = json['responses']
    responses.each do |response|
      messages = response['messages']
      messages.each { |message| speeches.push(message['speech']) if message['speech'].is_a?(String) }
    end
  rescue Exception => e
    next
  end
end
  # write csv
CSV.open('csv/speech.csv', 'wb') do |csv|
  csv << ["文言"]
  speeches.each do |speech|
    csv << [speech]
  end
end


# entity
entities = []
  # read json
Dir.glob('json/entities/*.json').each do |filename|
  file = File.read(filename)
  json = JSON.parse(file)
  begin
    json.each do |j|
      value = j['value']
      synonyms = j['synonyms']
      next unless value.is_a?(String)
      next unless synonyms.is_a?(Array)
      entities.push([value] + synonyms)
    end
  rescue Exception => e
    next
  end
end
  # write csv
CSV.open('csv/entity.csv', 'wb') do |csv|
  csv << ["単語", "類語"]
  entities.each do |entity|
    csv << entity
  end
end
