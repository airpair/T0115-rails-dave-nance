class DropTransactionsAndUserCoupons < ActiveRecord::Migration
  def change
    drop_table :transactions
    drop_table :user_coupons
  end
end
