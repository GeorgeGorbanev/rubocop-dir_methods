# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/support"
require "rubocop/cop/naming/dir_methods"

RSpec.describe RuboCop::Cop::Naming::DirMethods, :config do
  include RuboCop::RSpec::ExpectOffense

  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new(
      "Naming/DirMethods" => {
        "dirs" => {
          "spec/dummy_app/controllers" => {
            "allowed_methods" => ["new", "create", "show", "edit", "update", "destroy"],
            "reason" => "We want to use the Rails RESTful routes"
          }
        }
      }
    )
  end

  context "when not configured dir given" do
    it "does not register an offense for valid public method names" do
      File.open("spec/dummy_app/models/sample_model.rb", "w") do |file|
        expect_no_offenses(<<~RUBY, file)
          class SampleModel
            def any_method_names_here
              # implementation
            end
          end
        RUBY
      end
    end
  end

  context "when all allowed and single not allowed methods given" do
    it "registers an offense for invalid public method names" do
      expect_offense(<<~RUBY, File.open("spec/dummy_app/controllers/sample_controller.rb", "w"))
        class SampleController
          def new
            # implementation
          end

          def create
            # implementation
          end

          def show
            # implementation
          end

          def edit
            # implementation
          end

          def update
            # implementation
          end

          def destroy
            # implementation
          end

          def invalid_method_name
          ^^^^^^^^^^^^^^^^^^^^^^^ Invalid public method name: invalid_method_name (reason: We want to use the Rails RESTful routes)
            # implementation
          end

          protected

          def valid_method_name
            # implementation
          end

          private

          def also_valid_method_name
            # implementation
          end
        end
      RUBY
    end
  end

  context "when all allowed and single not allowed methods in nested dir given" do
    it "registers an offense for invalid public method names" do
      expect_offense(<<~RUBY, File.open("spec/dummy_app/controllers/nested/sample_controller.rb", "w"))
        module Nested
          class SampleController
            def new
              # implementation
            end

            def create
              # implementation
            end

            def show
              # implementation
            end

            def edit
              # implementation
            end

            def update
              # implementation
            end

            def destroy
              # implementation
            end

            def invalid_method_name
            ^^^^^^^^^^^^^^^^^^^^^^^ Invalid public method name: invalid_method_name (reason: We want to use the Rails RESTful routes)
              # implementation
            end

            protected

            def valid_method_name
              # implementation
            end

            private

            def also_valid_method_name
              # implementation
            end
          end
        end
      RUBY
    end
  end

  context "when not allowed method with inline modifier given" do
    it "does not register an offense for valid private method names" do
      expect_no_offenses(<<~RUBY, File.open("spec/dummy_app/controllers/sample_controller.rb", "w"))
        class SampleController
          def new#{'            '}
            # implementation
          end#{'              '}
        #{'  '}
          protected def valid_method_name
            # implementation
          end
        #{'  '}
          private def also_valid_method_name
            # implementation
          end
        end
      RUBY
    end
  end
end
