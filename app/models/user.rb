class User < ActiveRecord::Base
  has_many :reports

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true

  def total_balance
    positive = reports.reduce(0) { |a, e| e.balance[:sign] ? a + e.balance[:time] : a }
    negative = reports.reduce(0) { |a, e| !e.balance[:sign] ? a + e.balance[:time] : a }

    if positive >= negative
      { time: positive - negative, sign: true }
    else
      { time: negative - positive, sign: false }
    end
  end
end
