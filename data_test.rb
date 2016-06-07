require "minitest/autorun"
require 'yaml'

describe "yaml" do
  it "检验 yaml 数据格式" do
    path = File.expand_path("../", __FILE__)
    Dir[File.join(path, "*.yml")].each do |yaml_file|
      p yaml_file
      yaml = YAML.load_file yaml_file
      yaml.is_a?(Array).must_equal true
      yaml.each do |item|
        p item
        item.is_a?(Hash).must_equal true

        ["essay", "multi_choice", "single_choice", "bool","file_upload"].include?(item["kind"]).must_equal true

        ["text", "md"].include?(item["content_format"]).must_equal true
        if item["content"].include?("`")
          (item["content_format"] == "md").must_equal true
        end

        item["content"].is_a?(String).must_equal true

        if item["kind"] == "essay"
          item.keys.count.must_equal 4
        end

        if item["kind"] == "multi_choice"
          item.keys.count.must_equal 5
          item["answer"].is_a?(Hash).must_equal true
          item["answer"]["choices"].is_a?(Array).must_equal true
          item["answer"]["corrects"].is_a?(Array).must_equal true
        end

        if item["kind"] == "single_choice"
          item.keys.count.must_equal 5
          item["answer"].is_a?(Hash).must_equal true
          item["answer"]["choices"].is_a?(Array).must_equal true
          item["answer"]["correct"].is_a?(String).must_equal true
        end

        if item["kind"] == "bool"
          item.keys.count.must_equal 5
          [true, false].include?(item["answer"]).must_equal true
        end

      end
    end
  end
end
