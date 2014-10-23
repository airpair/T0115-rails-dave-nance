class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :user, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
