# rlet

This library provides RSpec-style let() declartions for lazy evaluation, concerns, and
a few functional operators.

Unlike ruby-let, this does not actually mimic the let of functional programming. Here,
`let()` defines a method in the class. The values are memoized. This allows for both
lazy-evaluation and class-based scoping.

By defining methods for lazy evaluation and grouping them into concerns, you can create
mixins that can be shared across multiple objects. Lazy-eval lends itself to functional
programming, so a small refinment is made available for use.

## INSTALLING

    gem install rlet

Or from bundler

    gem 'rlet'


## USAGE

### Let and Concern

The gems contain two modules, Let and Concern. You can use them like so:

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
        let(:id) { params[:id] }
      end
    end

Normally, you want to expose the methods as public methods. Sometimes,
you want to use protected methods. You can do so with `letp`:

    class ContactsController
      include Let
      include RestfulResource

      letp(:model) { Contact }

      def show
        respond_with resource
      end
    end

    module RestfulResource
      extend Concern

      included do
        letp(:resource) { model.find(id) }
        letp(:id) { params[:id] }
      end
    end


This is useful for Rails installation that still have dynamically inferred routes.

In Version 0.8.1+ both: let() and letp() return the name of the resource, there if you want to privatize let ruby 2.1+ you can do

    class ContactsController
      include Let
      include RestfulResource

      private let(:model) { Contact }
    end

or in Rails, for the lazy

    class ContactsController
      include Let
      include RestfulResource

      helper_method letp(:model) { Contact }
    end

Concern is embedded from ActiveSupport. If ActiveSupport::Concern is loaded, it will use that. This
allows one to use concerns without having ActiveSupport as a dependency.

Additionally, to expose `let()` with instance variables for use in templates, you can use `expose`

    require 'rlet'
    require 'rlet/expose'

    class ContactsController
      include Let
      include RLet::Expose
      include RestfulResource

      let(:model) { Contact }

      expose :resource, only: :show

      def show
        respond_with resource
      end
    end

    module RestfulResource
      extend Concern

      included do
        let(:resource) { model.find(id) }
        let(:id) { params[:id] }
      end
    end

***DEPRECATION NOTICE*** Expose is not needed in Rails. Use `helper_method` instead

### LazyOptions

One pattern that comes up is creating a class which takes an option as an initializer, and then
using `let()` to define values based on those options.

For example:

    module Intentions
      class Promise
        include Let
        extend Intentions::Concerns::Register

        attr_reader :identifier, :promiser, :promisee, :body, :metadata

        let(:identifier) { Digest::SHA2.new.update(to_digest.inspect).to_s }
        let(:sign)       { metadata[:sign] }
        let(:scope)      { metadata[:scope] }
        let(:timestamp)  { Time.now.utc }
        let(:salt)       { rand(100000) }

        def initialize(_promiser, _promisee, _body, _metadata = {})
          @promiser = _promiser.freeze
          @promisee = _promisee.freeze
          @body     = _body.freeze
          @metadata = _metadata.freeze
          self
        end

        def to_h
          to_digest.merge(identifier: identifier)
        end

        def to_digest
          {
            promiser:  promiser,
            promisee:  promisee,
            body:      body,
            metadata:  metadata,
            timestamp: timestamp,
            salt:      salt
          }
        end

      end
    end

We can refactor into:

    module Intentions
      class Promise
        include Let
        extend Intentions::Concerns::Register

        attr_reader :options

        let(:promiser)   { options[:promiser] }
        let(:promisee)   { options[:promisee] }
        let(:body)       { options[:body] }
        let(:metadata)   { options[:metadata] }

        let(:identifier) { Digest::SHA2.new.update(to_digest.inspect).to_s }
        let(:sign)       { metadata[:sign] }
        let(:scope)      { metadata[:scope] }
        let(:timestamp)  { Time.now.utc }
        let(:salt)       { rand(100000) }

        def initialize(_options = {})
          @options = _options
        end

        def to_h
          to_digest.merge(identifier: identifier)
        end

        def to_digest
          {
            promiser:  promiser,
            promisee:  promisee,
            body:      body,
            metadata:  metadata,
            timestamp: timestamp,
            salt:      salt
          }
        end

      end
    end

This pattern occurs so frequently that `rlet` now includes a `LazyOptions` concern.

    module Intentions
      class Promise
        include Let
        include RLet::LazyOptions
        extend Intentions::Concerns::Register

        let(:promiser)   { options[:promiser] }
        let(:promisee)   { options[:promisee] }
        let(:body)       { options[:body] }
        let(:metadata)   { options[:metadata] }

        let(:identifier) { Digest::SHA2.new.update(to_digest.inspect).to_s }
        let(:sign)       { metadata[:sign] }
        let(:scope)      { metadata[:scope] }
        let(:timestamp)  { Time.now.utc }
        let(:salt)       { rand(100000) }

        def to_h
          to_digest.merge(identifier: identifier)
        end

        def to_digest
          {
            promiser:  promiser,
            promisee:  promisee,
            body:      body,
            metadata:  metadata,
            timestamp: timestamp,
            salt:      salt
          }
        end

      end
    end

### Functional Operators

Lazy-eval lends itself well to functional patterns. However, Ruby doesn't include many
built-in operators for working with higher order functions. `rlet` includes a refinment (Ruby 2.0+)
that adds in some operators.

Currently, only two are supported: `|` which composes right, and `*` which composes left.

The best example is when working with [Intermodal](https://github.com/intermodal/intermodal) presenters:

    require 'rlet/functional'

    module SomeApi
      module API
        class V1_0 < Intermodal::API
          using RLet::Functional

          self.default_per_page = 25

          map_data do
            attribute = ->(field) { ->(r) { r.send(field) } }
            helper    = ->(_method) { ActionController::Base.helpers.method(_method) }

            presentation_for :book do
              presents :id
              presents :price,    with: attribute.(:price) | helper.(:number_to_currency)
            end
          end
        end
      end
    end
