class Moderation::PollsController < Moderation::BaseCustomController
  def approve
    if params['selected_ids'].any?
      Poll.where(id: params['selected_ids']).update(approved_at: Time.now)

      if params['selected_ids'].length > 1
        flash[:notice] = 'Las consultas fueron marcadas como aprobadas.'
      else
        flash[:notice] = 'La consulta fue marcada como aprobada.'
      end

      redirect_to moderation_polls_path
    end
  end

  private
    def readable_model
      'consulta'
    end

    def resource_model
      Poll
    end

    def get_records
      Poll.where.not("starts_at <= :time", time: Time.current).where(approved_at: nil)
    end
end
