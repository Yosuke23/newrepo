class AddIndexesToAuthorizationsProviderUid < ActiveRecord::Migration[5.1]
  def change
  	add_index :authorizations, [:provider, :uid], unique: true
  end
end
