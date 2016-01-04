module PrivatePlease
  module Utils
    class TwoLevelStack
      def push(value)
        @cell_2 = @cell_1
        @cell_1 = value
      end

      def curr; @cell_1 end
      def prev; @cell_2 end
    end
  end
end
