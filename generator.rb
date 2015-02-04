require 'erb'
require 'json'
require 'yaml'
require 'fileutils'

TEMPLATES_DIR = "templates/"
GENERATED_DIR = "gen/"

# Cleaning

FileUtils::rm_rf GENERATED_DIR
puts 'Clean...'
FileUtils::mkdir_p GENERATED_DIR
FileUtils::mkdir_p GENERATED_DIR + 'models/'
FileUtils::mkdir_p GENERATED_DIR + 'controllers/'
FileUtils::mkdir_p GENERATED_DIR + 'network/'
FileUtils::mkdir_p GENERATED_DIR + 'view_controllers/'

# Load Templates

model_template = File.read('templates/model.swift.erb')
controller_template = File.read('templates/controller.swift.erb')
request_provider_template = File.read('templates/request_provider.swift.erb')
table_view_controller_template = File.read('templates/table_view_controller.swift.erb')

# Load Config files
resources = YAML.load(File.read('resources.yml'))

# Models

puts 'Generating...'
puts 'Models:'

resources.each do |resource| 
	@model = resource
	model_file = File.new('gen/models/' + @model['name'] + '.swift','w+')
	model_file.write(ERB.new(model_template).result)
	puts '- ' + @model['name'].capitalize
end

# Controllers

puts 'Controllers:'

resources.each do |resource|
	@ctrl = resource
	controller_file = File.new('gen/controllers/' + @ctrl['name'].capitalize + 'Controller.swift', 'w+')
	controller_file.write(ERB.new(controller_template).result)
	puts '- ' + @ctrl['name'].capitalize + 'Controller'
end

puts 'Networking:'

resources.each do |resource|
	@net = resource
	request_provider_file = File.new('gen/network/' + @net['name'].capitalize + 'RequestProvider.swift','w+')
	request_provider_file.write(ERB.new(request_provider_template).result)
	puts '- ' + @net['name'].capitalize + 'RequestProvider'
	
end

puts 'ViewControllers:'

resources.each do |resource|
	@vc = resource
	if @vc["methods"]["all"]
		vc_file = File.new('gen/view_controllers/' + @vc['name'].capitalize + 'TableViewController.swift','w+')
		vc_file.write(ERB.new(table_view_controller_template).result)
		puts '- ' + @vc['name'].capitalize + 'TableViewController'
	end
end


