class Item < ActiveRecord::Base
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  belongs_to :sale
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  validates_uniqueness_of :title
  scope :top, -> { all.limit(10) }

  def self.random_items
    RandomItemsGenerator.generate(all)
  end

  def final_price
    if sale && sale.active?
      price * price_adjustment
    else
      price
    end
  end

  private

  def price_adjustment
    (100 - sale.discount) * 0.01
  end
end
