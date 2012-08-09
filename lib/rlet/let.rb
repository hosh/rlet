require 'rlet/concern'

module Let
  extend Concern

  module ClassMethods
    def let(name, &block)
      define_method(name) do
        __memoized[name] ||= instance_eval(&block)
      end
      protected(name)
    end
  end

  # Implementation based on Rspec let()
  #   https://github.com/rspec/rspec-core/blob/07be957b7f69447bf59ffe3ede9530436e6267ee/lib/rspec/core/let.rb
  # Copyright of RSpec:
  #   https://github.com/rspec/rspec-core/blob/07be957b7f69447bf59ffe3ede9530436e6267ee/License.txt

  private

  def __memoized # :nodoc:
    @__memoized ||= {}
  end
end
