class ExpensesController < ApplicationController
	def index
		@expenses = Expense.all.order(date: :desc)
	end
end
