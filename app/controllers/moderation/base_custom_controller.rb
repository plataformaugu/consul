class Moderation::BaseCustomController < Moderation::BaseController
  include ModerateActions

  def index
    @records = get_records
  end

  def reject
    if params['selected_ids'].any?
      params['selected_ids'].each do |id|
        record = resource_model.find(id)

        if send_email_to_author
          Mailer.reject_record(record.author, record.title, readable_model, pronoun_vowel).deliver_later
        end

        record.send(reject_method)
      end

      flash[:notice] = 'Los registros seleccionados fueron rechazados.'
      redirect_to controller: params['controller']
    end
  end

  private
    def send_email_to_author
      true
    end

    def pronoun_vowel
      'a'
    end

    def reject_method
      'destroy'
    end

    def readable_model
      raise NotImplementedError
    end

    def resource_model
      raise NotImplementedError
    end

    def get_records
      raise NotImplementedError
    end
end
