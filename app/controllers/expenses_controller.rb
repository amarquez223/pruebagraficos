class ExpensesController < ApplicationController
	def index
		@expenses = Expense.all.order(date: :desc)
		@column_data = Expense.types.keys.map do |type|
			{ name: type.capitalize, data: Expense.where(type: type).group_by_week(:date).sum(:amount) }
		end
	end
end
