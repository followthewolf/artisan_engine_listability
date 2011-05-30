module ArtisanEngine
  module Listability
    module HasListability
      
      def self.included( base )
        base.extend ClassMethods
      end
      
      module ClassMethods
        
        def has_listability( options = {} )
          
          class_eval <<-function
            def self.list_scope
              "#{ options[ :within ] }"
            end
          function
          
          class_eval do
            before_create   :add_to_bottom_of_list
            before_destroy  :promote_subordinates
            
            if options[ :within ] and options[ :within ].to_class.column_names.include?( "position" )
              scope_class  = options[ :within ]
              scoped_class = self
              
              scope         :in_position, lambda {
                              joins( scope_class ).
                              order( "#{ scope_class.to_plural_s }.position ASC" ).
                              order( "#{ scoped_class.to_plural_s }.position ASC" )
                            }
            else
              scope         :in_position, order( "position ASC" )
            end
            
          end
          
          include ArtisanEngine::Listability::HasListability::InstanceMethods
        end
        
      end

      module InstanceMethods
        
        def usurp( details = {} )
          promote_subordinates
          
          self.position = details[ :position ]
          self.save
          
          usurp_position_and_demote_subordinates
          
          self
        end
        
        private
                
          def add_to_bottom_of_list
            if list_scope.blank?
              self.class.any? ? add_at_lowest_position : self.position = 1
            else
              add_at_lowest_position_in_scope
            end
          end

          def add_at_lowest_position
            self.position = self.class.order( "position ASC" )
                                      .last.position + 1
          end
          
          def add_at_lowest_position_in_scope
            lowest_sibling = self.class.where( scope_condition )
                                       .order( "position ASC" )
                                       .last
              
            lowest_sibling ? self.position = lowest_sibling.position + 1 : self.position = 1
          end
          
          def promote_subordinates
            self.class.where( scope_condition )
                      .update_all( "position = position - 1", "position > #{ self.position }" )
          end
          
          def usurp_position_and_demote_subordinates
            self.class.where( scope_condition )
                      .update_all( "position = position + 1", "id != #{ self.id } AND position >= #{ self.position }" )
          end
          
          def scope_condition
            return "" if list_scope.blank?

            scope_string = "#{ list_scope }_id"
            scope_sym    = :"#{ list_scope }_id"

            "#{ scope_string } = #{ self.send( scope_sym ) }"
          end
          
          def list_scope
            self.class.list_scope
          end
      end
      
    end
  end
end