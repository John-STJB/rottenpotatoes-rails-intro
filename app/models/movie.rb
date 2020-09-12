class Movie < ActiveRecord::Base
    # Person.pluck(:id, :name)
    # SELECT people.id, people.name FROM people
    # => [[1, 'David'], [2, 'Jeremy'], [3, 'Jose']]
    def self.all_ratings
        
        self.pluck(:rating).uniq
        
    end
end
