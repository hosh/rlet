# This is ActiveSupport::Concern, taken from
# https://github.com/rails/rails/blob/6794e92b204572d75a07bd6413bdae6ae22d5a82/activesupport/lib/active_support/concern.rb
#
# If ActiveSupport::Concern is loaded, it will use that instead
#
# Rails license:
#   https://github.com/rails/rails/blob/6794e92b204572d75a07bd6413bdae6ae22d5a82/activesupport/MIT-LICENSE

module RLet
  module Concern
    def self.extended(base) #:nodoc:
      base.instance_variable_set("@_dependencies", [])
    end

    def append_features(base)
      if base.instance_variable_defined?("@_dependencies")
        base.instance_variable_get("@_dependencies") << self
        return false
      else
        return false if base < self
        @_dependencies.each { |dep| base.send(:include, dep) }
        super
        base.extend const_get("ClassMethods") if const_defined?("ClassMethods")
        base.class_eval(&@_included_block) if instance_variable_defined?("@_included_block")
      end
    end

    def included(base = nil, &block)
      if base.nil?
        @_included_block = block
      else
        super
      end
    end
  end
end

Concern = if defined?(ActiveSupport) and defined?(ActiveSupport::Concern)
            ActiveSupport::Concern
          else
            RLet::Concern
          end
