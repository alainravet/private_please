module PrivatePlease

  module Extension

    def private_please(*methods_to_observe)
      parameterless_call = methods_to_observe.empty?
      klass = self

      if parameterless_call
        klass.send :include, PrivatePlease::AllBelow

      else
        PrivatePlease::Instrumentor.instrument_methods_for_pp_observation(klass, methods_to_observe)
      end
    end

  end

end
