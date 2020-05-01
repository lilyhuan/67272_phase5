class Ability
    include CanCan::Ability
  
    def initialize(user)
      # set user to new User if not logged in
      user ||= Employee.new # i.e., a guest user
      
      # set authorizations for different user roles
      if user.role? :admin
        # they get to do it all
        can :manage, :all
        
      elsif user.role? :manager
        # can manage shifts and shiftjobs
        can :manage, Shift
        can :manage, ShiftJob
        
        can :index, Store
        can :index, Assignment
        can :index, Employee
  
  
        # they can read their own store
        can :show, Store do |s|  
          my_stores = user.stores.map(&:id)
          my_stores.include? s.id
        end
  
        # they can show assignments belonging to their store
        can :show, Assignment do |a|
          my_stores = user.stores.map(&:id)  
          my_assignments = Assignment.select { |ass| my_stores.include? (ass.store_id) }
          my_assignments.include? a.id
        end

        can :show, Employee do |e|
          my_employees = Employee.select { |emp| my_stores.include? (emp.store.id) }
          my_employees.include? e.id
        end

        can :edit, Employee do |e|
          my_employees = Employee.select { |emp| my_stores.include? (emp.store.id) }
          my_employees.include? e.id
        end

        can :update, Employee do |e|
          my_employees = Employee.select { |emp| my_stores.include? (emp.store.id) }
          my_employees.include? e.id
        end
  
  
      elsif user.role? :employee
        # they can read their own data
        can :show, Owner do |this_owner|  
          user.owner == this_owner
        end
  
        # they can see lists of pets and visits (controller filters automatically)
        can :index, Pet
        can :index, Visit
  
        # they can read their own pets' data
        can :show, Pet do |this_pet|  
          my_pets = user.owner.pets.map(&:id)
          my_pets.include? this_pet.id 
        end
  
        # they can read their own visits' data
        can :show, Visit do |this_visit|  
          my_visits = user.owner.visits.map(&:id)
          my_visits.include? this_visit.id 
        end
  
        
      else
        # guests can only read animals covered (plus home pages)
        # can :read, Animal
      end
    end
  end
  