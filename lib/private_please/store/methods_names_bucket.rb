# Associates and indexes classes (name) and some of their methods (names).
# Ex:
#   +-------------+---------------------------------------+
#   | class name  => 1+ methods names                     |
#   +-------------+---------------------------------------+
#   |    'Foo'    | MethodsNames.new('foo to_baz to_bar') |
#   |    'Bar'    | MethodsNames.new('qux')               |
#   +-------------+---------------------------------------+

module PrivatePlease
  class Store

    class MethodsNamesBucket < Hash

      alias_method :classes_names, :keys

    end

  end
end