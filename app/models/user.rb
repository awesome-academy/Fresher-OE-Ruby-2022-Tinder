class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable,
         :lockable, :validatable
  include MatchPagesHelper

  belongs_to :country, optional: true

  enum type_of: {basic: 0, gold: 1}
  enum gender: {male: 0, female: 1}
  has_many :messages, dependent: :destroy, foreign_key: :user_send_id
  has_many :active_relationships, class_name: Relationship.name,
                                  foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
                                  foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_many :notifications, class_name: Notification.name,
                           foreign_key: :user_receive_id, dependent: :destroy
  has_many :send_notifications, class_name: Notification.name,
                           foreign_key: :user_send_id, dependent: :destroy

  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses

  delegate :name, to: :country, prefix: true, allow_nil: true

  ALLOWED_USER_PARAMS = [:name, :email, :password, :password_confirmation,
                         :date_of_birth, :gender, :country_id, :phone,
                         :facebook, :description,
                         {addresses_attributes: [:address]}].freeze

  before_save{email.downcase!}
  validates :name, presence: true

  validates :gender, presence: true

  validates :date_of_birth, presence: true

  validates :phone, format: {with: Settings.regex.phone}

  validates :description, length: {maximum: Settings.des.max}
  scope :by_gender,
        ->(gender){where(gender: gender.presence || Settings.gender.range)}

  scope :by_age,
        ->(max_age,
           min_age){where(date_of_birth: get_filter_range(min_age, max_age))}

  scope :by_place,
        ->(place){where(country_id: place.presence || Settings.place.range)}

  scope :exclude_id, ->(id){where.not(id: id)}

  scope :exclude_followed, ->(id){where.not(followed: id)}

  ransack_alias :name_email_create_at, :name_or_email_or_created_at

  ransacker :created_at do
    Arel.sql("date(created_at)")
  end

  def like other_user
    following << other_user
  end

  def like_each_other? other_user, current_user
    return unless following.include?(other_user) &&
                  followers.include?(other_user)

    ids = [other_user.id, current_user.id]
    relationship = Relationship.by_follower(ids).by_followed(ids)
    relationship.update_all(status: true)
    send_notification(current_user, other_user)
  end

  def unfollow other_user
    following.delete(other_user)
  end

  class << self
    def import_file file
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      User.check_header_excel_file_and_column_of_user(header)
      valid_users = []
      invalid_users = []
      (2..spreadsheet.last_row).each do |i|
        user = User.new(Hash[[header, spreadsheet.row(i)].transpose])
        if user.valid?
          valid_users << user
        else
          invalid_users << user
        end
      end
      raise "error from records" unless invalid_users.empty?

      User.import valid_users, validate: false,
                               batch_size: Settings.digits.batch_size
    end

    def open_spreadsheet file
      case File.extname(file.original_filename)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise I18n.t(".unknown_file_type", file: file.original_filename)
      end
    end

    def check_header_excel_file_and_column_of_user header
      @correct_column_of_user = %w(name date_of_birth gender facebook phone
                            description country_id email password
                            confirmed_at )
      return if header == @correct_column_of_user

      raise I18n.t(".column_invalid")
    end
  end

  def switch_role
    basic? ? gold! : basic!
  end

  private

  def send_notification current_user, other_user
    noti = create_notification(current_user, other_user)
    count = other_user.notifications.count
    NotificationRelayJob.perform_later(noti, count)
  end

  def create_notification current_user, other_user
    Notification.create(content: I18n.t(".content", name: other_user.name),
                        user_send_id: current_user.id,
                        user_receive_id: other_user.id,
                        is_read: false)
  end
end
