class Reservation < ApplicationRecord
  MAX_WEEKDAYS = 5
  RESERVATION_MONTHS_AHEAD = 1

  belongs_to :user
  belongs_to :item
  has_one :room

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :start_date_from_tomorrow
  validate :dates_within_reservation_period
  validate :end_date_within_limit
  validate :no_overlapping_reservation

  def date_range
    (start_date..end_date).to_a
  end

  def self.weekday_count(start_date, end_date)
    (start_date..end_date).count { |d| d.on_weekday? }
  end

  def self.overlapping?(item, start_date, end_date, exclude_reservation_id: nil)
    scope = item.reservations.where("end_date >= ? AND start_date <= ?", start_date, end_date)
    scope = scope.where.not(id: exclude_reservation_id) if exclude_reservation_id.present?
    scope.exists?
  end

  def self.reserved_dates_for_item(item, from: Date.current, to: Date.current >> RESERVATION_MONTHS_AHEAD)
    reservations = item.reservations.where("end_date >= ? AND start_date <= ?", from, to)
    reservations.flat_map { |r| (r.start_date..r.end_date).to_a }.select { |d| d >= from && d <= to }.map(&:to_s).uniq
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    if end_date < start_date
      errors.add(:end_date, "は開始日以降の日付を指定してください。") 
    end
  end

  def start_date_from_tomorrow
    return if start_date.blank?
    if start_date < Date.current + 1
      errors.add(:start_date, "は当日および過去の日付は選択できません。翌日以降を指定してください。")
    end
  end

  def dates_within_reservation_period
    limit = Date.current >> RESERVATION_MONTHS_AHEAD
    if start_date.present? && start_date > limit
      errors.add(:start_date, "は1ヶ月先までで指定してください。")
    end
    if end_date.present? && end_date > limit
      errors.add(:end_date, "は1ヶ月先までで指定してください。")
    end
  end

  def end_date_within_limit
    return if start_date.blank? || end_date.blank?
    return if end_date < start_date

    count = self.class.weekday_count(start_date, end_date)
    if count > MAX_WEEKDAYS
      errors.add(:end_date, "は土日を除いて#{MAX_WEEKDAYS}日以内で指定してください。")
    end
    if count.zero?
      errors.add(:base, "土日のみの期間は選択できません。")
    end
  end

  def no_overlapping_reservation
    return if start_date.blank? || end_date.blank? || item_id.blank?
    return if end_date < start_date

    if self.class.overlapping?(item, start_date, end_date, exclude_reservation_id: id)
      errors.add(:base, "この期間は既に予約が入っています。")
    end
  end
end
