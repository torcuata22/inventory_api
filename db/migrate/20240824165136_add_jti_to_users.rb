class AddJtiToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :jti, :string, null: false, default: ''


    # Update existing users with a unique jti value, validate: false so it bypasses password validation
    User.all.each do |user|
      user.update_columns(jti: SecureRandom.uuid)
    end

    add_index :users, :jti, unique: true
  end
end
