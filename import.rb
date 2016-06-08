points_path = File.expand_path("../points/points.yml", __FILE__)

all_points = YAML.load_file points_path

all_count = 0
path = File.expand_path("../", __FILE__)

Dir[File.join(path, "*.yml")].each do |yaml_file|
  yaml = YAML.load_file yaml_file
  yaml.each do |item|
    all_count+=1
    p item

    point_name = item["points"][0]
    raise "#{point_name} 不是有效的知识点" if !all_points.include?(point_name)

    point = QuestionBank::Point.where(name: point_name).first
    if point.blank?
      point = QuestionBank::Point.create!(name: point_name)
    end

    QuestionBank::Question.create!(
      kind:    item["kind"],
      level:   1,
      content: item["content"],
      content_format: item["content_format"],
      answer: item["answer"],
      points: [point]
    )
  end
end

p "总数 #{all_count}"
