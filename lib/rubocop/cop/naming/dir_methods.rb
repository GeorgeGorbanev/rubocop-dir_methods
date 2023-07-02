# frozen_string_literal: true

module RuboCop
  module Cop
    module Naming
      class DirMethods < Base
        include RuboCop::Cop::DefNode

        MODIFIERS = [:public, :protected, :private].freeze

        def on_def(node)
          node_visibility_modifier = visibility_modifier(node)
          return if node_visibility_modifier != :public

          file_path = current_file_path(node)
          _, dir_config = dir_config(file_path)
          return if dir_config.nil? || dir_config["allowed_methods"].include?(node.method_name.to_s)

          add_offense(node, message: offense_message(node, dir_config))
        end

        private

        def current_file_path(node)
          src_path = node.location.expression.source_buffer.name

          if src_path.start_with?("/")
            project_path = Pathname.new(File.expand_path(".")).realpath
            Pathname.new(src_path).relative_path_from(project_path).to_s
          else
            src_path
          end
        end

        def dir_config(file_path)
          cop_config.fetch("dirs", {}).find do |config|
            file_path.start_with?(config.first)
          end
        end

        def visibility_modifier(node)
          node.left_siblings.reverse.each do |sibling_node|
            if inline_modifier?(sibling_node)
              return sibling_node
            elsif parent_modifier?(sibling_node)
              return sibling_node.method_name
            end
          end

          :public
        end

        def inline_modifier?(node)
          MODIFIERS.include?(node)
        end

        def parent_modifier?(node)
          node.respond_to?(:method_name) && MODIFIERS.include?(node.method_name)
        end

        def offense_message(node, dir_config)
          message = "Invalid public method name: #{node.method_name}"
          message += " (reason: #{dir_config['reason']})" if dir_config["reason"]
          message
        end
      end
    end
  end
end
