# Add Merchant to Purchase Plan

Plan for adding merchant/store information to the Purchase model.

## Overview

Currently, purchases only store product, price, quantity, and payment information. There's no way to track where a purchase was made (e.g., "Supermercado Extra", "Mercado Livre", "Feira do Bairro").

This enhancement adds a `merchant` field to track the store/marketplace where each purchase was made.

## Current Model

```ruby
# app/models/purchase.rb
class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :card, optional: true
  has_many :payments, dependent: :destroy
end
```

## Requirements

### Functional Requirements

1. **Merchant field** - Store name of store/marketplace
2. **Location field** - Optional store address or neighborhood
3. **Suggestions** - Autocomplete from previous merchants
4. **Display** - Show merchant in purchase history

### UX Requirements

1. Text input with autocomplete from previous entries
2. Clear labeling (e.g., "Estabelecimento" or "Loja")
3. Optional location field for store address
4. Show merchant in purchases index and product show page

## Implementation Plan

### Phase 1: Database Migration

Create migration:

```ruby
# db/migrate/xxxx_add_merchant_to_purchases.rb
class AddMerchantToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :merchant, :string
    add_column :purchases, :location, :string
    add_index :purchases, :merchant
  end
end
```

### Phase 2: Model Updates

Update `Purchase` model:

```ruby
# app/models/purchase.rb
class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :card, optional: true
  has_many :payments, dependent: :destroy

  scope :by_merchant, ->(merchant) { where(merchant: merchant) }

  def self.popular_merchants(limit: 10)
    select(:merchant)
      .where.not(merchant: nil)
      .group(:merchant)
      .order('COUNT(*) DESC')
      .limit(limit)
      .pluck(:merchant)
  end
end
```

### Phase 3: Form Updates

Update purchase form:

```erb
<!-- app/views/purchases/_form.html.erb -->
<fieldset>
  <legend>Estabelecimento</legend>
  <div class="field">
    <%= f.label :merchant, 'Loja/Estabelecimento' %>
    <%= f.text_field :merchant,
          list: 'merchant-suggestions',
          autocomplete: 'off' %>
    <datalist id="merchant-suggestions">
      <% Purchase.popular_merchants.each do |merchant| %>
        <option value="<%= merchant %>">
      <% end %>
    </datalist>
  </div>

  <div class="field">
    <%= f.label :location, 'Endereço/Localidade' %>
    <%= f.text_field :location, placeholder: 'Opcional' %>
  </div>
</fieldset>
```

### Phase 4: Strong Parameters

Update controller:

```ruby
# app/controllers/purchases_controller.rb
def purchase_params
  params.require(:purchase).permit(
    :add_payment,
    :price,
    :purchase_at,
    :number_of_installments,
    :quantity,
    :card_id,
    :merchant,
    :location,
    payments_attributes: [:purchase_id, :due_amount, :due_at, :_destroy]
  )
end
```

### Phase 5: View Updates

Update purchases index:

```erb
<!-- app/views/purchases/index.html.erb -->
<table>
  <thead>
    <tr>
      <th>Data</th>
      <th>Produto</th>
      <th>Loja</th>      <!-- NEW -->
      <th>Valor</th>
    </tr>
  </thead>
  <tbody>
    <% @purchases.each do |purchase| %>
      <tr>
        <td><%= l(purchase.purchase_at, format: :default) %></td>
        <td><%= purchase.product.name %></td>
        <td><%= purchase.merchant || '-' %></td>  <!-- NEW -->
        <td><%= number_to_currency(purchase.price) %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

Update product show page:

```erb
<!-- app/views/products/show.html.erb -->
<table class="purchases-table">
  <thead>
    <tr>
      <th>Data</th>
      <th>Preço Unitário</th>
      <th>Qtd</th>
      <th>Total</th>
      <th>Cartão</th>
      <th>Loja</th>      <!-- NEW -->
    </tr>
  </thead>
  <tbody>
    <% @recent_purchases.each do |purchase| %>
      <tr>
        <td><%= l(purchase.purchase_at, format: :default) %></td>
        <td><%= number_to_currency(purchase.price) %></td>
        <td><%= purchase.quantity %></td>
        <td><%= number_to_currency(purchase.price * purchase.quantity) %></td>
        <td><%= purchase.card&.name || '-' %></td>
        <td><%= purchase.merchant || '-' %></td>  <!-- NEW -->
      </tr>
    <% end %>
  </tbody>
</table>
```

### Phase 6: Test Updates

Update factory:

```ruby
# spec/factories/purchases.rb
FactoryBot.define do
  factory :purchase do
    association :product
    association :card, factory: :card
    price { 10.00 }
    quantity { 1 }
    purchase_at { Date.today }
    merchant { "Supermercado #{Faker::Company.name}" }
    location { Faker::Address.neighborhood }
  end
end
```

Add model spec:

```ruby
# spec/models/purchase_spec.rb
describe 'merchant' do
  it { should have_db_column(:merchant).of_type(:string) }
  it { should have_db_column(:location).of_type(:string) }

  it 'scopes by merchant' do
    create(:purchase, merchant: 'Extra')
    create(:purchase, merchant: 'Mercado')
    create(:purchase, merchant: 'Extra')
    expect(described_class.by_merchant('Extra').count).to eq 2
  end

  it 'returns popular merchants' do
    3.times { create(:purchase, merchant: 'Extra') }
    2.times { create(:purchase, merchant: 'Pão de Açúcar') }
    1.times { create(:purchase, merchant: 'Mercado') }

    popular = described_class.popular_merchants(limit: 2)
    expect(popular).to eq ['Extra', 'Pão de Açúcar']
  end
end
```

## File Structure

```
app/
├── models/
│   └── purchase.rb (update)
├── controllers/
│   └── purchases_controller.rb (update strong_params)
└── views/
    ├── purchases/
    │   ├── _form.html.erb (add merchant fields)
    │   └── index.html.erb (add column)
    └── products/
        └── show.html.erb (add column)

db/
└── migrate/
    └── xxxx_add_merchant_to_purchases.rb (new)

spec/
├── factories/
│   └── purchases.rb (update)
└── models/
    └── purchase_spec.rb (add tests)
```

## Edge Cases

| Scenario | Handling |
|----------|----------|
| Empty merchant | Allow nil/empty, no validation |
| Very long merchant name | Limit to 255 chars (DB constraint) |
| Duplicate merchants with different cases | Case-insensitive comparison for suggestions |
| Same merchant different locations | Both fields are independent |

## Tasks Summary

| Task | Priority | Status |
|------|----------|--------|
| - [x] Create migration | High | Done |
| - [x] Add merchant/location to model | High | Done |
| - [x] Add popular_merchants scope | High | Done |
| - [x] Update strong parameters | High | Done |
| - [x] Update purchase form | High | Done |
| - [x] Update purchases index view | Medium | Done |
| - [x] Update purchase show view | Medium | Done |
| - [x] Product show view | Medium | N/A - not needed |
| - [x] Model specs | Medium | Done |

## Plan Status: COMPLETE ✅
