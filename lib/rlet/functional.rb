# This module requires refinements (Ruby 2.1+)
#
# To use this module, specify it with the using keyword:
#
# class StreamProcessor
#   include Let
#   using RLet::Functional
#
#   let(:user)      { User.create (minimum | with_photos).() }
#   let(:minimum)   { { username: 'user', password: 'password' } }
#   let(:with_nick) { ->(x) { x.merge(nick: 'Breaker') } }
# end

module RLet
  module Functional
    module Compose
      def *(other)
        Proc.new { |x| call(other.call(x)) }
      end
      def |(other)
        Proc.new { |x| other.call(call(x)) }
      end
    end

    refine Proc do
      include Compose
    end

    refine Method do
      include Compose
    end
  end
end
