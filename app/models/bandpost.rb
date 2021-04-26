class Bandpost < ApplicationRecord
    has_one_attached :clip
    
    belongs_to :band
    belongs_to :song
    belongs_to :artist
    has_many :bandpostinstruments, dependent: :destroy
    has_many :instruments, through: :bandpostinstruments

    has_many :bandpostcomments, dependent: :destroy

end
