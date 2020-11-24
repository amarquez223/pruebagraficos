class ExpensesController < ApplicationController
	def index
		@start_date = params[:start].try(:to_date) || 30.days.ago.to_date
		@end_date = params[:end].try(:to_date) || Date.current

		range = (@start_date..@end_date)

		@expenses = Expense.where(date: range).order(date: :desc)
		@column_data = Expense.types.keys.map do |type|
			{ name: type.capitalize, data: Expense.where(type: type).group_by_day(:date, range: range).sum(:amount) }
		end

		@pie_chart = Expense.where(date: range).group(:type).sum(:amount)
	end
end
