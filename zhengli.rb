require 'yaml'
require 'fileutils'
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
    p item
    kind  = item["kind"]
    point = item["points"][0]
    tongji_info[point][kind][:count] += 1
    tongji_info[point][kind][:items] << item
  end
end


FileUtils.mkdir_p(File.expand_path("../zhengli", __FILE__))
all_count = 0
items = []
points.each do |point|
  kinds.each do |kind|
    items += tongji_info[point][kind][:items]
  end
end
IO.write(File.expand_path("../zhengli/zhengli.yml", __FILE__), items.to_yaml)
