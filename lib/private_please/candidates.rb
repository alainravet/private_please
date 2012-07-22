module PrivatePlease
  class Candidates

    def self.reset_candidates
      @@candidates        = Hash.new{ [] }
    end
    reset_candidates

    def self.candidates       ; @@candidates        end

  end
end