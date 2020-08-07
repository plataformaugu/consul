require_dependency Rails.root.join("app", "models", "verification", "residence").to_s

class Verification::Residence
  validate :postal_code_in_madrid


  def postal_code_in_madrid
    return true
    # errors.add(:postal_code, I18n.t("verification.residence.new.error_not_allowed_postal_code")) unless valid_postal_code?
  end

  # private

  #  def valid_postal_code?
  #    postal_code =~ /^7/
  #  end
end
