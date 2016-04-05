class AddMemberTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :member_type, :integer, default: 2 # 1: Admin User, 2: App User (Refer to User::MEMBER_TYPE)
  end
end
