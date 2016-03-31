# DEPRECATED: Use helper_method instead
# Include this module if you want to expose methods as instance
# variables for Rails templates
#
# Since let variables are not exposed to the view,
# this allows ou to define instance variables to pass
# to the view.
#
# Example:
#   class UsersController < ActiveController::Base
#     include RLet::Expose
#     include RLet::Let
#
#     let(:user) { current_user }
#     expose :user  # Assigns @user = self.user
#
#   end
#
# Other examples:
#
#   expose :user, :options
#   expose :user, only: [ :create, :show ]
#   expose :user, :options, except: :destroy
#
# You can also use this in ApplicationController:
#
# require 'rlet/let'
# require 'rlet/expose'
#
# class ApplicationController < ActionController::Base
#    include RLet::Let
#    include RLet::Expose
# end
#
#
# Considerations:
#
# This is implemented using a before_filter. So when you expose an
# rlet, it will -always- be evaluated. Be careful of what you expose
# and which controller actions to expose it to.
module RLet
  module Expose
    extend Concern

    module ClassMethods
      #   expose :user
      #   expose :user, :options
      #   expose :user, only: [ :create, :show ]
      #   expose :user, :options, except: :destroy
      def expose(*lvars)
        options = lvars.last.is_a?(Hash) ? lvars.pop : {}
        lvars.each do |lvar|
          self.before_filter(options) do |controller|
            controller.instance_eval do
              self.instance_variable_set("@#{lvar}", self.send(lvar))
            end
          end
        end
      end # expose

    end # ClassMethods
  end # Expose
end # RLet
