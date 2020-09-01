class CensusCaller
  def call(document_type, document_number, date_of_birth, postal_code)
    if Setting["feature.remote_census"].present?
      # response = RemoteCensusApi.new.call(document_type, document_number, date_of_birth, postal_code)
    else
      response = CensusApi.new.call(document_type, document_number)
    end
    response
  end
end
