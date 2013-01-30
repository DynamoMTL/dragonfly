# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dragonfly"
  s.version = "0.9.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Evans"]
  s.date = "2013-01-30"
  s.description = "Dragonfly is a framework that enables on-the-fly processing for any content type.\n  It is especially suited to image handling. Its uses range from image thumbnails to standard attachments to on-demand text generation."
  s.email = "mark@new-bamboo.co.uk"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".rspec",
    ".yardopts",
    "Gemfile",
    "History.md",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "config.ru",
    "docs.watchr",
    "dragonfly.gemspec",
    "extra_docs/Analysers.md",
    "extra_docs/Caching.md",
    "extra_docs/Configuration.md",
    "extra_docs/Couch.md",
    "extra_docs/DataStorage.md",
    "extra_docs/Encoding.md",
    "extra_docs/ExampleUseCases.md",
    "extra_docs/GeneralUsage.md",
    "extra_docs/Generators.md",
    "extra_docs/Heroku.md",
    "extra_docs/ImageMagick.md",
    "extra_docs/Index.md",
    "extra_docs/MimeTypes.md",
    "extra_docs/Models.md",
    "extra_docs/Mongo.md",
    "extra_docs/Processing.md",
    "extra_docs/Rack.md",
    "extra_docs/Rails2.md",
    "extra_docs/Rails3.md",
    "extra_docs/ServingRemotely.md",
    "extra_docs/Sinatra.md",
    "extra_docs/URLs.md",
    "features/images.feature",
    "features/no_processing.feature",
    "features/rails.feature",
    "features/steps/common_steps.rb",
    "features/steps/dragonfly_steps.rb",
    "features/steps/rails_steps.rb",
    "features/support/env.rb",
    "features/support/setup.rb",
    "fixtures/rails/files/app/models/album.rb",
    "fixtures/rails/files/app/views/albums/new.html.erb",
    "fixtures/rails/files/app/views/albums/show.html.erb",
    "fixtures/rails/files/config/initializers/dragonfly.rb",
    "fixtures/rails/files/features/manage_album_images.feature",
    "fixtures/rails/files/features/step_definitions/helper_steps.rb",
    "fixtures/rails/files/features/step_definitions/image_steps.rb",
    "fixtures/rails/files/features/step_definitions/web_steps.rb",
    "fixtures/rails/files/features/support/paths.rb",
    "fixtures/rails/files/features/text_images.feature",
    "fixtures/rails/template.rb",
    "irbrc.rb",
    "lib/dragonfly.rb",
    "lib/dragonfly/active_model_extensions.rb",
    "lib/dragonfly/active_model_extensions/attachment.rb",
    "lib/dragonfly/active_model_extensions/attachment_class_methods.rb",
    "lib/dragonfly/active_model_extensions/class_methods.rb",
    "lib/dragonfly/active_model_extensions/instance_methods.rb",
    "lib/dragonfly/active_model_extensions/validations.rb",
    "lib/dragonfly/analyser.rb",
    "lib/dragonfly/analysis/file_command_analyser.rb",
    "lib/dragonfly/analysis/image_magick_analyser.rb",
    "lib/dragonfly/app.rb",
    "lib/dragonfly/config/heroku.rb",
    "lib/dragonfly/config/image_magick.rb",
    "lib/dragonfly/config/rails.rb",
    "lib/dragonfly/configurable.rb",
    "lib/dragonfly/cookie_monster.rb",
    "lib/dragonfly/core_ext/array.rb",
    "lib/dragonfly/core_ext/hash.rb",
    "lib/dragonfly/core_ext/object.rb",
    "lib/dragonfly/data_storage.rb",
    "lib/dragonfly/data_storage/couch_data_store.rb",
    "lib/dragonfly/data_storage/file_data_store.rb",
    "lib/dragonfly/data_storage/mongo_data_store.rb",
    "lib/dragonfly/data_storage/s3data_store.rb",
    "lib/dragonfly/encoder.rb",
    "lib/dragonfly/encoding/image_magick_encoder.rb",
    "lib/dragonfly/function_manager.rb",
    "lib/dragonfly/generation/image_magick_generator.rb",
    "lib/dragonfly/generator.rb",
    "lib/dragonfly/has_filename.rb",
    "lib/dragonfly/hash_with_css_style_keys.rb",
    "lib/dragonfly/image_magick/analyser.rb",
    "lib/dragonfly/image_magick/config.rb",
    "lib/dragonfly/image_magick/encoder.rb",
    "lib/dragonfly/image_magick/generator.rb",
    "lib/dragonfly/image_magick/processor.rb",
    "lib/dragonfly/image_magick/utils.rb",
    "lib/dragonfly/image_magick_utils.rb",
    "lib/dragonfly/job.rb",
    "lib/dragonfly/job_builder.rb",
    "lib/dragonfly/job_definitions.rb",
    "lib/dragonfly/job_endpoint.rb",
    "lib/dragonfly/loggable.rb",
    "lib/dragonfly/middleware.rb",
    "lib/dragonfly/processing/image_magick_processor.rb",
    "lib/dragonfly/processor.rb",
    "lib/dragonfly/rails/images.rb",
    "lib/dragonfly/railtie.rb",
    "lib/dragonfly/response.rb",
    "lib/dragonfly/routed_endpoint.rb",
    "lib/dragonfly/serializer.rb",
    "lib/dragonfly/server.rb",
    "lib/dragonfly/shell.rb",
    "lib/dragonfly/simple_cache.rb",
    "lib/dragonfly/temp_object.rb",
    "lib/dragonfly/url_attributes.rb",
    "lib/dragonfly/url_mapper.rb",
    "lib/dragonfly/utils.rb",
    "samples/DSC02119.JPG",
    "samples/a.jp2",
    "samples/beach.jpg",
    "samples/beach.png",
    "samples/egg.png",
    "samples/round.gif",
    "samples/sample.docx",
    "samples/taj.jpg",
    "samples/white pixel.png",
    "spec/dragonfly/active_model_extensions/model_spec.rb",
    "spec/dragonfly/active_model_extensions/spec_helper.rb",
    "spec/dragonfly/analyser_spec.rb",
    "spec/dragonfly/analysis/file_command_analyser_spec.rb",
    "spec/dragonfly/app_spec.rb",
    "spec/dragonfly/configurable_spec.rb",
    "spec/dragonfly/cookie_monster_spec.rb",
    "spec/dragonfly/core_ext/array_spec.rb",
    "spec/dragonfly/core_ext/hash_spec.rb",
    "spec/dragonfly/data_storage/couch_data_store_spec.rb",
    "spec/dragonfly/data_storage/file_data_store_spec.rb",
    "spec/dragonfly/data_storage/mongo_data_store_spec.rb",
    "spec/dragonfly/data_storage/s3_data_store_spec.rb",
    "spec/dragonfly/data_storage/shared_data_store_examples.rb",
    "spec/dragonfly/function_manager_spec.rb",
    "spec/dragonfly/has_filename_spec.rb",
    "spec/dragonfly/hash_with_css_style_keys_spec.rb",
    "spec/dragonfly/image_magick/analyser_spec.rb",
    "spec/dragonfly/image_magick/encoder_spec.rb",
    "spec/dragonfly/image_magick/generator_spec.rb",
    "spec/dragonfly/image_magick/processor_spec.rb",
    "spec/dragonfly/job_builder_spec.rb",
    "spec/dragonfly/job_definitions_spec.rb",
    "spec/dragonfly/job_endpoint_spec.rb",
    "spec/dragonfly/job_spec.rb",
    "spec/dragonfly/loggable_spec.rb",
    "spec/dragonfly/middleware_spec.rb",
    "spec/dragonfly/routed_endpoint_spec.rb",
    "spec/dragonfly/serializer_spec.rb",
    "spec/dragonfly/server_spec.rb",
    "spec/dragonfly/shell_spec.rb",
    "spec/dragonfly/simple_cache_spec.rb",
    "spec/dragonfly/temp_object_spec.rb",
    "spec/dragonfly/url_attributes.rb",
    "spec/dragonfly/url_mapper_spec.rb",
    "spec/functional/deprecations_spec.rb",
    "spec/functional/image_magick_app_spec.rb",
    "spec/functional/model_urls_spec.rb",
    "spec/functional/remote_on_the_fly_spec.rb",
    "spec/functional/shell_commands_spec.rb",
    "spec/functional/to_response_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/argument_matchers.rb",
    "spec/support/image_matchers.rb",
    "spec/support/simple_matchers.rb",
    "spec/test_imagemagick.ru",
    "tmp/.gitignore",
    "yard/handlers/configurable_attr_handler.rb",
    "yard/setup.rb",
    "yard/templates/default/fulldoc/html/css/common.css",
    "yard/templates/default/layout/html/layout.erb",
    "yard/templates/default/module/html/configuration_summary.erb",
    "yard/templates/default/module/setup.rb"
  ]
  s.homepage = "http://github.com/markevans/dragonfly"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Ideal gem for handling attachments in Rails, Sinatra and Rack applications."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.2.1"])
      s.add_development_dependency(%q<cucumber-rails>, ["~> 1.3.0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.5.2"])
      s.add_development_dependency(%q<fog>, [">= 0"])
      s.add_development_dependency(%q<github-markup>, [">= 0"])
      s.add_development_dependency(%q<mongo>, [">= 0"])
      s.add_development_dependency(%q<couchrest>, ["~> 1.0"])
      s.add_development_dependency(%q<rack-cache>, [">= 0"])
      s.add_development_dependency(%q<rails>, ["~> 3.2.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<redcarpet>, ["~> 1.0"])
      s.add_development_dependency(%q<bluecloth>, [">= 0"])
      s.add_development_dependency(%q<bson_ext>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<cucumber>, ["~> 1.2.1"])
      s.add_dependency(%q<cucumber-rails>, ["~> 1.3.0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 1.5.2"])
      s.add_dependency(%q<fog>, [">= 0"])
      s.add_dependency(%q<github-markup>, [">= 0"])
      s.add_dependency(%q<mongo>, [">= 0"])
      s.add_dependency(%q<couchrest>, ["~> 1.0"])
      s.add_dependency(%q<rack-cache>, [">= 0"])
      s.add_dependency(%q<rails>, ["~> 3.2.0"])
      s.add_dependency(%q<rspec>, ["~> 2.5"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<redcarpet>, ["~> 1.0"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<multi_json>, ["~> 1.0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<cucumber>, ["~> 1.2.1"])
    s.add_dependency(%q<cucumber-rails>, ["~> 1.3.0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 1.5.2"])
    s.add_dependency(%q<fog>, [">= 0"])
    s.add_dependency(%q<github-markup>, [">= 0"])
    s.add_dependency(%q<mongo>, [">= 0"])
    s.add_dependency(%q<couchrest>, ["~> 1.0"])
    s.add_dependency(%q<rack-cache>, [">= 0"])
    s.add_dependency(%q<rails>, ["~> 3.2.0"])
    s.add_dependency(%q<rspec>, ["~> 2.5"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<redcarpet>, ["~> 1.0"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end

