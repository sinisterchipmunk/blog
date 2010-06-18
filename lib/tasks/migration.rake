namespace :auth do
  namespace :migrate do
    desc "Migrate from Authlogic to Sparkly Auth"
    task :authlogic => :environment do
      model = User
      
      table_name = model.table_name
      rows = %w(id crypted_password password_salt persistence_token)
      
      ActiveRecord::Base.connection.execute("SELECT #{rows.join(',')} FROM '#{table_name}';").each do |row|
        auth_type = model.name
        auth_id = row['id']
        sql = "INSERT INTO '#{Password.table_name}' (authenticatable_id, authenticatable_type, secret, salt) VALUES " +
                "('#{auth_id}', '#{auth_type}', '#{row['crypted_password']}', '#{row['password_salt']}');"
        ActiveRecord::Base.connection.execute(sql)
      end

      Password.all.each do |pw|
        pw.reset_persistence_token
        pw.reset_single_access_token
        pw.reset_perishable_token
        pw.save!
      end
      
      puts "Tables have been migrated."
    end
  end
end