module ApplicationHelper
    def quarantine_duration
        10.days
    end

    def quarantine_date
        quarantine_duration.ago
    end

    def loan_date
        0.days.ago
    end

    def loan_from_raw(loan_date)
        if !loan_date.blank?
            quarantine_duration.since(loan_date)
        end
    end

    def loan_from(date_of_loan)
        I18n.l quarantine_duration.since(date_of_loan), format: :short
    end
end
