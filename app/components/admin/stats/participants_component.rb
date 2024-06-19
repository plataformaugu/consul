class Admin::Stats::ParticipantsComponent < ApplicationComponent
  def initialize(users)
    @users = users
  end

  private
    def users_count
      @users.count
    end

    def users_male_count
      @users.male.count
    end

    def users_female_count
      @users.female.count
    end

    def users_other_gender_count
      @users.count - (@users.male.count + @users.female.count)
    end

    def users_ranges
      return [
        [16, 19],
        [20, 24],
        [25, 29],
        [30, 34],
        [35, 39],
        [40, 44],
        [45, 49],
        [50, 54],
        [55, 59],
        [60, 64],
        [65, 69],
        [70, 74],
        [75, 79],
        [80, 84],
        [85, 89],
        [90, 300]
      ]
    end

    def users_by_age_range
      current_users_count = @users.count

      users_ranges.to_h do |start, finish|
        count = @users.between_ages(start, finish).count
        range_description = I18n.t("stats.age_range", start: start, finish: finish)

        if finish > 200
          range_description = I18n.t("stats.age_more_than", start: start)
        end

        [
          "#{start} - #{finish}",
          {
            range: range_description,
            count: count,
            percentage: PercentageCalculator.calculate(count, current_users_count)
          }
        ]
      end
    end
end
