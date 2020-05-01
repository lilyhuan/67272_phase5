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
          my_stores = user.stores  
        #   my_assignments = Assignment.select { |ass| my_stores.include? (ass.store_id) }
        #   my_assignments.include? a.id
          my_assignments = Array.new
          my_stores.each { |my_store|
            my_assignments << my_store.assignments
          }
          my_assignments = my_assignments.flatten
          my_assignments.include? a
        end

        can :show, Employee do |e|
        #   my_employees = Employee.select { |emp| my_stores.include? (emp.store.id) }
        #   my_employees.include? e.id
            my_stores = user.stores
            my_employees = Array.new
            my_stores.each { |my_store|
                my_employees << my_store.employees
            }
            my_employees = my_employees.flatten
            my_employees.include? e
        end

        can :edit, Employee do |e|
            my_stores = user.stores
            my_employees = Array.new
            my_stores.each { |my_store|
                my_employees << my_store.employees
            }
            my_employees = my_employees.flatten
            my_employees.include? e
        end

        can :update, Employee do |e|
            my_stores = user.stores
            my_employees = Array.new
            my_stores.each { |my_store|
                my_employees << my_store.employees
            }
            my_employees = my_employees.flatten
            my_employees.include? e
        end
  
  
      elsif user.role? :employee
        can :index, Assignment

        # they can read their own assignment details
        can :show, Assignment do |a|  
          user.assignments.include? a
        end
  
        # they can read their own employee data
        can :show, Employee do |e|  
          user.id == e.id
        end

        can :edit, Employee do |e|  
            user.id == e.id
        end
  
        can :update, Employee do |e|  
            user.id == e.id
        end
        
      else
        # guests can only read animals covered (plus home pages)
        # can :read, Animal
      end
    end
  end
  