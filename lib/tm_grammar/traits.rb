module TmGrammar
  # This class represents a collection of grammar traits.
  #
  # A trait is a piece or fragment of a grammar. It can be included anywhere in
  # a grammar either to create reusable parts for the grammar or for structural
  # purposes.
  class Traits
    # Registers a trait for later inclusion in a grammar.
    #
    # @example
    #   trait = lambda do
    #     rule 'identifier' do
    #        name 'support.other.identifier.foo'
    #        match '[_\p{L}](?:[_\p{L}\d])*'
    #     end
    #   end
    #
    #   TmGrammar::Traits.register_trait(:identifier, trait)
    #
    # @param name [Symbol, String] the name of the trait. The name is used later
    # to include the trait in a grammar.
    #
    # @param block [Proc] the content of the trait
    def self.register_trait(name, block)
      @traits ||= {}
      @traits[name.to_sym] = block
    end

    # Returns the content of the trait of the given name.
    #
    # @example
    #   trait = TmGrammar::Traits.retrieve_trait(:identifier)
    #
    # @param name [Symbol, String] the name of the trait to retrieve
    #
    # @return [Proc] the content of the trait
    def self.retrieve_trait(name)
      @traits[name.to_sym]
    end
  end
end
