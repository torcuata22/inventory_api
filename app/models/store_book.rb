class StoreBook < ApplicationRecord
  t.references :store, null: false, foreign_key: true
  t.references :book, null: false, foreign_key: true
end
