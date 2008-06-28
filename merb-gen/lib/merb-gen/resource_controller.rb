module Merb::Generators
  
  class ResourceControllerGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a resource generator
    DESC
    
    option :testing_framework, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    
    first_argument :name, :required => true
    
    # add controller and view templates for each of the four big ORM's
    [:none, :activerecord, :sequel, :datamapper].each do |orm|
    
      template "controller_#{orm}".to_sym, :orm => orm do
        source("controller_#{orm}.rbt")
        destination("app/controllers/#{file_name}.rb")
      end
    
      [:index, :show, :edit, :new].each do |view|
        file "view_#{view}_#{orm}".to_sym, :orm => orm do
          source("views_#{orm}/#{view}.html.erb")
          destination("app/views/#{file_name}/#{view}.rb")
        end
      end
    
    end
    
    template :helpers do
      source("helpers.rbt")
      destination("app/helpers/#{file_name}_helper.rb")
    end
    
    def controller_modules
      chunks[0..-2]
    end
    
    def controller_class_name
      chunks.last
    end
    
    def test_class_name
      controller_class_name + "Test"
    end
    
    def file_name
      controller_class_name.snake_case
    end
    
    def source_root
      File.join(super, 'resource_controller')
    end
    
    protected
    
    def chunks
      name.gsub('/', '::').split('::').map { |c| c.camel_case }
    end
    
  end
  
  add :resource_controller, ResourceControllerGenerator
  
end