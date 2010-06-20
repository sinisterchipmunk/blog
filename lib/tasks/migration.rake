namespace :auth do
  namespace :migrate do
    desc "Migrate from Authlogic to Sparkly Auth"
    task :authlogic => :environment do
      require 'console_app'
      
      Auth.reset_configuration!
      Auth.configuration.behaviors = []
      reload!
      Auth.kick!

      model = User
      model.instance_eval do
        has_many :passwords, :as => :authenticatable
      end
      
      class UnenforcedPasswordModel < ActiveRecord::Base
        set_table_name Password.table_name
        belongs_to :authenticatable, :polymorphic => true
      end
            
      model.all.each do |record|
        #record.instance_eval { has_many :passwords, :as => :authenticatable }
        
        unless record.attributes['crypted_password'].blank? # skip those users registered AFTER migration
          record.passwords.destroy_all
          
          password = UnenforcedPasswordModel.new(:authenticatable => record)
          password.save(false)
          password.update_attribute(:secret, record.attributes['crypted_password'])
          password.update_attribute(:salt, record.attributes['password_salt'])
          
          if password.secret != record.attributes['crypted_password']
            raise "Passwords don't match"
          end
          
          if record.attributes.keys.include?('persistence_token')
            password.update_attribute(:persistence_token, record.attributes['persistence_token'])
          else
            password.update_attribute(:persistence_token, Auth::Token.new.to_s)
          end
  
          if record.attributes.keys.include?('single_access_token')
            password.update_attribute(:single_access_token, record.attributes['single_access_token'])
          else
            password.update_attribute(:single_access_token, Auth::Token.new.to_s)
          end
  
          if record.attributes.keys.include?('perishable_token')
            password.update_attribute(:perishable_token, record.attributes['perishable_token'])
          else
            password.update_attribute(:perishable_token, Auth::Token.new.to_s)
          end
          
          password.save!
        end
      end

      puts "Tables have been migrated."
    end
  end
end
