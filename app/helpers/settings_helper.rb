module SettingsHelper

    def day_of_quarantine_in_setting
        day_of_quarantine_in_setting = Setting.where(key: "quarantine").first
        day_of_quarantine = day_of_quarantine_in_setting ? day_of_quarantine_in_setting.value.to_i + 1 : 10
    end

    def day_of_expected_return_in_setting
        day_of_expected_return_in_setting = Setting.where(key: "expected_return").first
        day_of_expected_return = day_of_expected_return_in_setting ? day_of_expected_return_in_setting.value.to_i.days + 1 : 1.month
    end
end
