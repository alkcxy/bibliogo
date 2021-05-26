module SettingsHelper

    def day_of_quarantine_in_setting
        day_of_quarantine_in_setting = Setting.where(key: "quarantine").first
        day_of_quarantine = day_of_quarantine_in_setting ? day_of_quarantine_in_setting.value.to_i + 1 : 10
    end
end
