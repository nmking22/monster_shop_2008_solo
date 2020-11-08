# Monster Shop Solo Whiteboarding

## Basics
1. Full CRUD functionality for discounts
1. Need new discount migration
1. Need functionality for discount auto-apply when quantity conditions are met

## Relationships
1. Discounts -> Merchant: One Merchant has many Discounts
1. Discounts -> ItemOrders? One Discount has many item_orders

## Discount Migration
1. percentage:float (or integer)
1. quantity_threshold:integer
1. Merchant foreign key
1. For item_orders: add discount foreign key

## Testing
1. Discounts CRUD
1. Discounts auto-apply
1. Multiple Discounts
1. Check that multiple discounts are functioning properly (only the greatest discount is applied)
1. Discounts only affect their associated merchants
1. Discounts only work when the item quantity threshold is met on ONE item (a discount is not applied when a user reaches the quantity threshold between many items)
1. Final discounted prices appear
