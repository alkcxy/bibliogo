module ApplicationHelper
    def quarantine_duration
        10.days
    end

    def quarantine_date
        quarantine_duration.ago.to_formatted_s(:bibliogo)
    end

    def loan_date
        0.days.ago.to_formatted_s(:bibliogo)
    end

    def loan_from(loan)
        if loan.actual_return
            quarantine_duration.since(loan.actual_return)
        else
            quarantine_duration.since(loan.expected_return)
        end
    end
end
