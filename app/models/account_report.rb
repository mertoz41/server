class AccountReport < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :band, optional: true
end
