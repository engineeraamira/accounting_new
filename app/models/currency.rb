class Currency < ApplicationRecord
    validates_presence_of :name_ar, :name_en, :rate, :code
end
