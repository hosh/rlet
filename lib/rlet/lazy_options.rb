# Include this module when you want to have a hash initializer. This
# allows you to build let() definitions derived from what gets passed
# into the initializer
#
# For example:
#
# class Task
#   include Let
#   include RLet::LazyOptions
#
#   let(:name) { options[:name] }
# end
#
# t = Task.new name: 'MyTask'
# t.name
# => 'MyTask'

module RLet
  module LazyOptions
    extend Concern

    included do
      attr_reader :options

      def initialize(opts = {})
        @options = opts
      end
    end

  end
end
