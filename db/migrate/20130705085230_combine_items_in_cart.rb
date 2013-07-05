class CombineItemsInCart < ActiveRecord::Migration
  def up
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # count the numbers of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove individual items
          cart.line_items.where(product_id: product_id).delete_all

          # replace with a single item
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    # Fine line items where quantity is more than 1
    LineItem.where("quantity>1").each do |line_item|
      # for each quantity create a single line item with quantity of 1
      line_item.quantity.times do
        LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
      end

      # remove original item
      line_item.destroy
    end
  end
end
