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
    p item
    kind  = item["kind"]
    point = item["points"][0]
    tongji_info[point][kind][:count] += 1
    tongji_info[point][kind][:items] << item
  end
end

all_count     = 0
single_choice = 0
multi_choice  = 0
essay         = 0
file_upload   = 0

points.each do |point|
  p "--------------- 知识点：#{point}"
  kinds.each do |kind|
    if kind == "single_choice"
      single_choice += tongji_info[point][kind][:count]
    end
    if kind == "multi_choice"
      multi_choice += tongji_info[point][kind][:count]
    end
    if kind == "essay"
      essay += tongji_info[point][kind][:count]
    end
    if kind == "file_upload"
      file_upload += tongji_info[point][kind][:count]
    end

    all_count += tongji_info[point][kind][:count]
    p "#{kind}: #{tongji_info[point][kind][:count]}"
  end
end


p "~~~~~~~~~~~~~~~~~"

p "single_choice: #{single_choice}"
p "multi_choice: #{multi_choice}"
p "essay: #{essay}"
p "file_upload: #{file_upload}"
p "all_count: #{all_count}"
