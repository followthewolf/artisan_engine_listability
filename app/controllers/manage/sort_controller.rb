module Manage
  class SortController < Manage::BackController
    def sort
      type_sym   = params[ :type ].singularize.to_sym
      type_class = type_sym.to_class

      params[ type_sym ].each_with_index do |id, index|
        type_class.find( id ).
        usurp( :position => index + 1 )
      end

      render :nothing => true
    end
  end
end