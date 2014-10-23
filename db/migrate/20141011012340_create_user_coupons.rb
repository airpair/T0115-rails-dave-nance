class CreateUserCoupons < ActiveRecord::Migration
  def change
    create_table :user_coupons do |t|
      t.belongs_to :user, index: true
      t.string :coupon

      t.timestamps

      t.index :coupon
    end
  end
end
