class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string      :provider
      t.string      :uid
      t.string      :name
      t.string      :email
      t.string      :oauth_token
      t.string      :oauth_refresh_token
      t.datetime    :oauth_expires_at
      t.references  :user,                  index: true

      t.timestamps null: false
    end
  end
end
