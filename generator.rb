require 'erb'
require 'json'

# Models
model_template = File.read('templates/model.swift.erb')
models = JSON.parse(File.read('models.json'))

puts 'Generating...'
puts 'Models:'

models.each do |model| 
	@model = model
	model_file = File.new('gen/models/' + @model['name'] + '.swift','w')
	model_file.write(ERB.new(model_template).result)
	puts '- ' + @model['name'].capitalize
end

# Controllers
controllers = JSON.parse(File.read('controllers.json'))

puts 'Controllers:'

controllers.each do |controller|
	@ctrl = controller
	controller_template = File.read('templates/controller.swift.erb')
	controller_file = File.new('gen/controllers/' + @ctrl['name'].capitalize + 'Controller.swift', 'w')
	controller_file.write(ERB.new(controller_template).result)
	puts '- ' + @ctrl['name'].capitalize + 'Controller'
end

puts 'Networking:'

networking = JSON.parse(File.read('network.json'))

networking.each do |network|
	@net = network

	request_provider_template = File.read('templates/request_provider.swift.erb')
	request_provider_file = File.new('gen/network/' + @net['name'].capitalize + 'RequestProvider.swift','w')
	request_provider_file.write(ERB.new(request_provider_template).result)
	puts '- ' + @net['name'].capitalize + 'RequestProvider'

	router_template = File.read('templates/router.swift.erb')
	router_file = File.new('gen/network/' + @net['name'].capitalize + 'Router.swift', 'w')
	router_file.write(ERB.new(router_template).result)
	puts '- ' + @net['name'].capitalize + 'Router'
	
end