# Send a notice to a Chatwork group (http://chatwork.com/).

CONTACT_DEPS[:chatwork] = ['chatwork']
CONTACT_DEPS[:chatwork].each do |d|
  require d
end

module God
  module Contacts
    class Chatwork < Contact
      class << self
        attr_accessor :access_token, :group_id, :user_id
      end

      def valid?
        valid = true
        valid &= complain("Attribute 'access_token' must be specified", self) unless arg(:access_token)
        valid &= complain("Attribute 'group_id' must be specified", self) unless arg(:group_id)
        valid &= complain("Attribute 'user_id' must be specified", self) unless arg(:user_id)
        valid
      end

      attr_accessor :access_token, :group_id, :user_id

      def notify(message, time, priority, category, host)
        ::ChatWork.access_token = arg(:access_token)
        ::ChatWork::Message.create(room_id: arg(:group_id), body: "Hello, ChatWork!#{host}, #{category}")

        self.info = "sent message to chatwork"
      rescue => e
        applog(nil, :info, "failed to send chatwork: #{e.message}")
        applog(nil, :debug, e.backtrace.join("\n"))
      end
    end
  end
end
