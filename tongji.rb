require 'yaml'
points_path = File.expand_path("../points/points.yml", __FILE__)

points = YAML.load_file points_path

kinds = %w{
  single_choice
  multi_choice
  bool
  essay
  file_upload
}

tongji_info = {}
points.each do |point|
  tongji_info[point] = {}
  kinds.each do |kind|
    tongji_info[point][kind] = {
      count: 0,
      items: []
    }
  end
end


path = File.expand_path("../", __FILE__)
Dir[File.join(path, "*.yml")].each do |yaml_file|
  yaml = YAML.load_file yaml_file
  yaml.each do |item|
    next if item["points"].nil?
    next if item["points"][0].nil?

    kind  = item["kind"]
    point = item["points"][0]
    tongji_info[point][kind][:count] += 1
    tongji_info[point][kind][:items] << item
  end
end


points.each do |point|
  p "--------------- 知识点：#{point}"
  kinds.each do |kind|
    p "#{kind}: #{tongji_info[point][kind][:count]}"
  end
end
