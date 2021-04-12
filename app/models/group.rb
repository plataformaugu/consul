class Group < ApplicationRecord
    has_many :group_users

    def users
        @new_results = []
        @results = GroupUser.where(group_id: self.id)
        @results.each do |user|
            if User.where(email: user.email).exists?
                @new_user = User.where(email: user.email)
            else
                @new_user = User.where(email: '120391203912039123012931023120', username: 'x@x@x@x@x#x$x%x^x&')
            end

            if @new_user.exists?
                @new_user = @new_user.first
                @new_results.append({
                    'name': @new_user.name,
                    'email': @new_user.email,
                    'exists': true
                })
            else
                @new_results.append({
                    'name': user.name,
                    'email': user.email,
                    'exists': false
                })
            end
        end

        return @new_results
    end
end
