class ExpensesController < ApplicationController
	def index
		@start_date = params[:start].try(:to_date) || 30.days.ago.to_date
		@end_date = params[:end].try(:to_date) || Date.current

		range = (@start_date..@end_date)

		@expenses = Expense.where(date: range).order(date: :desc)
		@column_data = Expense.types.keys.map do |type|
			{ name: type.capitalize, data: group_by_period(Expense.where(type: type), range).sum(:amount) }
		end

		@pie_chart = Expense.where(date: range).group(:type).sum(:amount)
	end


	private
	def group_by_period(data, range)
		diff = @end_date - @start_date
		if diff < 31
			data.group_by_day(:date, range: range, format: "%b %d")
		elsif diff < 91
			data.group_by_week(:date, range: range, format: Proc.new { |date| format_week_label(date) })
		else
			data.group_by_month(:date, range: range, format: "%b %Y")
		end
	end

	def format_week_label(date)
		start_date = date.to_date
		end_date = start_date + 6
		label = "#{start_date.strftime('%b %d')} - "
		label += start_date.month == end_date.month ? end_date.strftime('%d') : end_date.strftime('%b %d')
	end
end
