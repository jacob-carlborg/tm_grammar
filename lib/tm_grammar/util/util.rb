module TmGrammar
  module Util
    module Util
      def enforce(object, error_message = nil, &block)
        if error_message.nil? && !block_given?
          raise 'No error message or block given'
        end

        raise error_message || block.call unless object
        object
      end
    end
  end
end
