class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  # 仮想の属性を作成
  attr_accessor :remember_token
  before_save {self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  
  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
            format: { with: VALIDATE_EMAIL_REGEX },
            uniqueness: true 
  validates :affiliation, length: { in: 2..30 }, allow_blank: true
  validates :basic_work_time, presence: true
  validates :work_time, presence: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end
  #Model読み込み、DB登録
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      user.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
      user.save
    end
  end
  
  # 渡された文字列のハッシュを返します
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストを一致すればtrueを返します。
  def authenticated?
    # ダイジェストが存在しない場合はfalseを返して終了
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄します
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    [
      "name", "email", "affiliation","employee_number","uid", 
      "basic_work_time","designated_work_start_time","designated_work_end_time",
      "password", "password_confirmation"
    ]
  end
  
end