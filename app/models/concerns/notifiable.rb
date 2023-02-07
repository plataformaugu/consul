module Notifiable
  extend ActiveSupport::Concern

  def notifiable_title
    case self.class.name
    when "ProposalNotification"
      proposal.title
    when "Comment"
      commentable.title
    when "CustomNotification"
      case action
      when 'hide_comment'
        return "Tu comentario fue ocultado: \"#{model.constantize.with_hidden.find(model_id).body.truncate(24)}\""
      when 'reject_proposal'
        return "Tu propuesta no ha sido aceptada: \"#{model.constantize.with_hidden.find(model_id).title.truncate(24)}\""
      when 'reject_debate'
        return "Tu debate no ha sido aceptado: \"#{model.constantize.with_hidden.find(model_id).title.truncate(24)}\""
      end
    else
      title
    end
  end

  def notifiable_body
    body if attribute_names.include?("body")
  end

  def notifiable_available?
    case self.class.name
    when "ProposalNotification"
      check_availability(proposal)
    when "Comment"
      check_availability(commentable)
    when "CustomNotification"
      return true
    else
      check_availability(self)
    end
  end

  def check_availability(resource)
    resource.present? &&
      !(resource.respond_to?(:hidden?) && resource.hidden?) &&
      !(resource.respond_to?(:retired?) && resource.retired?)
  end

  def linkable_resource
    is_a?(ProposalNotification) ? proposal : self
  end
end
