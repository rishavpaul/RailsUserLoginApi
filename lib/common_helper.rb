module CommonHelper
  class << self
    def ensure_presence_of(*args)
      args.each do |arg|
        return false if arg.blank?
      end
      true
    end

    def log(type, message)
      Rails.logger.info type + " " + message
    end
  end
end
