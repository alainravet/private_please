module  PrivatePlease::Report

  class Table

    def initialize(col_1, col_2)
      @col_1, @col_2 = col_1, col_2

      prepare_data
    end

  #----------------------------------------------------------------------------
  # QUERIES:
  #----------------------------------------------------------------------------

    attr_reader :col_1,
                :col_2,
                :rows,
                :longest_value_length

    def empty?
      col_1.empty? && col_2.empty?
    end

  #----------------------------------------------------------------------------
  # COMMANDS:
  #----------------------------------------------------------------------------

    # none (immutable)

  #----------------------------------------------------------------------------
  private

    def prepare_data
      @longest_value_length = [col_1 + col_2].flatten.map(&:length).max || 0

      # pad whichever column is shorter
      @col_1[@col_2.length-1] ||= nil  unless @col_2.empty?
      @col_2[@col_1.length-1] ||= nil  unless @col_1.empty?

      @rows = @col_1.zip(@col_2)
    end

  end
end
