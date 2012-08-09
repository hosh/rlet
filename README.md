rlet
====

Ruby let(), class-based lexical scoping

Unlike ruby-let, or what is proposed here http://www.opensourcery.com/blog/zack-hobson/objectlet-ruby-0 
this does not actually mimic the let of functional programming. Instead, it controls scope idiomatic
to Ruby -- "everything is an object".

Here, let() defines a method in the class. The values are memoized. This allows for both
lazy-evaluation and class-based scoping.

This is based on RSpec let(). Tutorials and documentation are forthcoming.

INSTALLING
====

    gem install rlet

Or from bundler

    gem 'rlet'


USAGE
====

The gems contain two modules, Let and Concern. You can use them like so:

    require 'rlet'
    
    class ContactsController
      include Let
      include RestfulResource
    
      let(:model) { Contact }
    
      def show
        respond_with resource
      end
    end
    
    module RestfulResource
      extend Concern
    
      included do
        let(:resource) { model.find(id) }
        let(:id) { params[:id]
      end
    end


Concern is embedded from ActiveSupport. If ActiveSupport::Concern is loaded, it will use that. This
allows one to use concerns without having ActiveSupport as a dependency.
