require 'pry/commands/ls/interrogateable'
require 'pry/commands/ls/methods_helper'

class Pry
  class Command::Ls < Pry::ClassCommand
    class SelfMethods < Pry::Command::Ls::Formatter

      include Pry::Command::Ls::Interrogateable
      include Pry::Command::Ls::MethodsHelper

      def initialize(interrogatee, no_user_opts, opts)
        @interrogatee = interrogatee
        @no_user_opts = no_user_opts
      end

      def output_self
        methods = all_methods(true).select do |m|
          m.owner == @interrogatee && grep.regexp[m.name]
        end
        heading = "#{ Pry::WrappedModule.new(@interrogatee).method_prefix }methods"
        output_section(heading, format(methods))
      end

      private

      def correct_opts?
        @no_user_opts && interrogating_a_module?
      end

    end
  end
end
