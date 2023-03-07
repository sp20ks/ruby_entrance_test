# frozen_string_literal: true

require 'date'

# module period
module Periods
  # главный метод
  def self.chain_correct?(start, str)
    start_date = start.split('.').map(&:to_i).reverse
    periods = str.select! { |date| check(date) }.nil? ? str.map { |date| convert_to_arr(date) } : nil
    return false if periods.nil? || start_date.nil?
    return false if (start_date <=> periods[0]).eql?(-1)

    offset = start_date[2]
    periods.each do |per|
      return false unless compare(start_date, per)

      curr = case per.length
             when 1
               get_annually(start_date)
             when 2
               get_monthly(start_date, offset)
             when 3
               get_daily(start_date)
             end
      offset = curr[2] if per.length.eql?(3)
      start_date = curr
    end
    true
  end

  # метод добавления периода в конец цепочки
  def self.add(start, chain, type)
    last = type_pf_period(start.split('.').map(&:to_i).reverse, convert_to_arr(chain.last))
    case type
    when "annually"
      chain << last[0].to_s
    when "monthly"
      chain << "#{last[0]}M#{last[1]}"
    when "daily"
      chain << "#{last[0]}M#{last[1]}D#{last[2]}"
    end
  end

  # вспомогательный метод
  def self.type_pf_period(start, period)
    case period.length
    when 1
      start[0] = period[0]
      get_annually(start)
    when 2
      period << start[2]
      get_monthly(period)
    when 3
      get_daily(period)
    end
  end

  # проверка на совпадение крайних дат двух периодов (-1 - не совпадают)
  def self.compare(arr1, arr2)
    if arr1.length > arr2.length then !(arr1 <=> arr2).eql?(-1)
    elsif arr1.length < arr2.length
      !(arr2 <=> arr1).eql?(-1)
    else
      arr1.eql? arr2
    end
  end

  # проверка на корректность даты
  def self.check(inp_date)
    /((((\A\d{4}\z)|(\A\d{4}\z))|(\A\d{4})M(\d{1})D(\d{1,2}\z))|(\A\d{4}M\d{1,2}\z))/.match?(inp_date)
  end

  # перевод периода в массив [год, месяц, день]
  def self.convert_to_arr(inp_date)
    inp_date.gsub(/[DM]/, ' ').split.map(&:to_i)
  end

  # возвращают период в виде массива [начальная дата, конечная дата]. даты представляют из себя массивы
  def self.get_daily(arr)
    end_per = Date.new(arr[0], arr[1], arr[2]).next_day
    [end_per.year, end_per.month, end_per.day]
  end

  def self.get_monthly(arr, offset)
    return [arr[0], arr[1] + 1, offset] if Date.valid_date?(arr[0], arr[1] + 1, offset)

    end_per = Date.new(arr[0], arr[1], arr[2]).next_month
    [end_per.year, end_per.month, end_per.day]
  end

  def self.get_annually(arr)
    end_per = Date.new(arr[0], arr[1], arr[2]).next_year
    [end_per.year, end_per.month, end_per.day]
  end
end
