json.extract! loan, :id, :date, :expected_return, :actual_return, :place, :reader, :created_at, :updated_at, :book
json.url loan_url(loan, format: :json)
