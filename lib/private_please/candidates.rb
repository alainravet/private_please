module PrivatePlease
  class Candidates

    def self.reset_candidates
      @@candidates                = Hash.new{ [] }
      @@inside_called_candidates  = Hash.new{ [] }
    end
    reset_candidates

    def self.candidates               ; @@candidates                end
    def self.inside_called_candidates ; @@inside_called_candidates  end
  end
end