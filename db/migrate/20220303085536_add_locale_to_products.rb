class AddLocaleToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :locale, :string
  end
end
