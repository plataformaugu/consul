class Admin::CensusRecordsController < Admin::BaseController
  before_action :set_census_record, only: [:show, :edit, :update, :destroy]

  NOTICE_TEXT = "El %{name} fue %{action} correctamente."

  def index
    @census_records = CensusRecord.search(params[:search])
    @census_records = Kaminari.paginate_array(@census_records).page(params[:page])
  end

  def new
    @census_record = CensusRecord.new
  end

  def edit
  end

  def create
    @census_record = CensusRecord.new(census_record_params)

    if @census_record.save
      redirect_to admin_census_records_path, notice: NOTICE_TEXT % {name: 'registro', action: 'creado'}
    else
      render :new
    end
  end

  def update
    if @census_record.update(census_record_params)
      redirect_to admin_census_records_path, notice: NOTICE_TEXT % {name: 'registro', action: 'actualizado'}
    else
      render :edit
    end
  end

  def destroy
    @census_record.destroy
    redirect_to admin_census_records_path, notice: NOTICE_TEXT % {name: 'registro', action: 'eliminado'}
  end

  def import
  end

  def load_csv
    records = CSV.foreach(params['file'], headers: true).map(&:to_h)

    if records.empty?
      redirect_to import_admin_census_records_path, alert: "El archivo está vacío."
      return
    end

    if !records.any? {|row| row.key?('rut')}
      redirect_to import_admin_census_records_path, alert: 'Debe existir una columna llamada "rut".'
      return
    end

    existing_document_numbers = CensusRecord.all.pluck(:document_number)

    records = records.map { |row| {"document_number" => row['rut'].gsub(/[^a-z0-9]+/i, "").upcase} }
    records = records.uniq
    records = records.select { |row| !existing_document_numbers.include?(row['document_number'])}
    
    if records.empty?
      redirect_to import_admin_census_records_path, alert: 'No hay nuevos registros para insertar.'
      return
    end

    records = records.map { |row| {"document_number" => row["document_number"], "created_at" => Time.now, "updated_at" => Time.now} }

    records.each_slice(250) do |records_slice|
      CensusRecord.insert_all(records_slice)
    end

    redirect_to import_admin_census_records_path, notice: "Se insertaron #{records.length()} registros."
  end

  private
    def set_census_record
      @census_record = CensusRecord.find(params[:id])
    end

    def census_record_params
      params.require(:census_record).permit(:document_number)
    end
end
