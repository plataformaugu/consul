class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]
  has_orders %w[most_voted newest oldest], only: :show
  skip_authorization_check

  # GET /quizzes
  def index
    if current_user.is_individual.nil?
      redirect_to root_path
    end
    @quizzes = Quiz.all
    redirect_to root_path
  end

  # GET /quizzes/1
  def show
    redirect_to root_path
  end

  # GET /quizzes/new
  def new
    if current_user.is_individual.nil?
      redirect_to root_path
    end
    @quiz = Quiz.new
    @title = ''
    
    if params[:type].present?
      unless ['1', '2', '3'].include? params[:type]
        redirect_to root_path
      end

      @type = params[:type].to_i
      if @type == 1
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        unless params[:chapter].present?
          redirect_to root_path
        else
          if Tag.category.where(id: params[:chapter].to_i).exists?
            @chapter = Tag.category.find(params[:chapter].to_i)
            @title = 'Diagnósticos de acción por tema'
            @options = get_options_by_chapter(@chapter.name)
          else
            redirect_to root_path
          end
        end
      end
      if @type == 2
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        if params[:chapter].present?
          redirect_to root_path
        else
          @title = 'Sugerencias de mecanismos de monitoreo'
        end
      end
      if @type == 3
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        unless params[:chapter].present?
          redirect_to root_path
        else
          if Tag.category.where(id: params[:chapter].to_i).exists?
            @chapter = Tag.category.find(params[:chapter].to_i)
            @title = 'Sugerencias de acciones por tema'
          else
            redirect_to root_path
          end
        end
      end
    else
      redirect_to root_path
    end
  end

  # GET /quizzes/1/edit
  def edit
    redirect_to root_path
  end

  # POST /quizzes
  def create
    new_params = quiz_params
    new_params['user'] = current_user

    if quiz_params['quiz_type'] == '1'
      new_params['q1'] = params['quiz']['q1'] == 'Otro' ? params['quiz']['q5'] : params['quiz']['q1']
      new_params['q2'] = params['quiz']['q2']
      new_params['q3'] = params['quiz']['q3']
      new_params['q4'] = params['q4'].present? ? params['q4'].join(', ') : ''
      new_params.delete('q5')

      if new_params['tag_id'].present? and Tag.category.exists?(id: new_params['tag_id'].to_i)
        @quiz = Quiz.new(new_params)

        if @quiz.save
          @title_text = 'Diagnóstico enviado correctamente'
          @send_text = 'Ir a la página de diagnósticos'
          @send_path = chapters_proposals_path
          @show_next_button = true
          @chapter = new_params['tag_id']
          @type = new_params['quiz_type']
          render :success
        else
          render :new
        end
      else
        render :new
      end
    elsif quiz_params['quiz_type'] == '2'
      new_params['q3'] = params['q3'].present? ? params['q3'].join(', ') : ''
      @quiz = Quiz.new(new_params)

      if @quiz.save
        @title_text = 'Monitoreo enviado correctamente'
        @send_text = 'Enviar otro monitoreo'
        @send_path = monitoring_quizzes_path
        @chapter = nil
        @type = new_params['quiz_type']
        render :success
      else
        render :new
      end
    elsif quiz_params['quiz_type'] == '3'
      @quiz = Quiz.new(new_params)

      if @quiz.save
        @title_text = 'Sugerencia enviada correctamente'
        @send_text = 'Enviar otra sugerencia'
        @send_path = proposals_path
        @chapter = new_params['tag_id']
        @type = new_params['quiz_type']
        render :success
      else
        render :new
      end
    else
      render :new
    end
  end

  # PATCH/PUT /quizzes/1
  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: 'Quiz was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /quizzes/1
  def destroy
    @quiz.destroy
    redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.'
  end

  def monitoring
    @quizzes = Quiz.all
    render :monitoring
  end

  def vote
    quiz_id = params['quiz_id']

    unless Vote.where(votable_type: "Quiz", votable_id: quiz_id.to_i, voter_id: current_user.id).exists?
      vote = Vote.new(votable_type: "Quiz", votable_id: quiz_id.to_i, voter_id: current_user.id, vote_weight: 1)
      vote.save
    else
      redirect root_path
    end
  end

  def is_user_allowed(quiz_type)
    count = Quiz.where(quiz_type: quiz_type).where(user_id: current_user.id).count

    if count >= 6
      return false
    else
      return true
    end
  end

  def set_invisible
    quiz_id = params['quiz_id']

    @quiz = Quiz.find(quiz_id.to_i)

    if @quiz.quiz_type == 1
      @quiz_type = 'diagnóstico'
    else
      @quiz_type = 'sugerencia'
    end

    Mailer.removed_content(@quiz.user.email, 'participación').deliver_later

    @quiz.visible = false
    @quiz.is_active = false
    @quiz.save
  end

  def invite_user
    Mailer.user_invite(params[:email]).deliver_later
  end

  def get_options_by_chapter(chapter)
    @options = []

    if chapter.downcase == 'Memoria, verdad, justicia y reparación'.downcase
      @options = [
        'Existencia de obstáculos legales que impiden el acceso a la verdad y justicia, como penas muy bajas y la aplicación de beneficios de reducción de condenas.',
        'Ausencia de políticas de protección a sitios de memoria sobre las violaciones de derechos humanos ocurridas durante la dictadura.',
        'Falta de medidas para la búsqueda e identificación de personas detenidas desaparecidas.',
        'Medidas de reparación insuficientes para las víctimas de violaciones de derechos humanos durante la dictadura.',
        'Insuficiencia de acceso a información en aspectos relevantes para el establecimiento de verdad y justicia, por situaciones como el secreto de los testimonios de informes Rettig y Valech, la falta de sistematización del estado de procesos judiciales y del estado de cumplimiento de sentencias.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Derechos Económicos, sociales, culturales y ambientales'.downcase
      @options = [
        'Los derechos laborales se ven afectados por brechas de género en el mercado laboral, problemas del sistema de seguridad social, precariedad del empleo informal, dificultades para el ejercicio de derechos sindicales, entre otros.',
        'Los derechos de salud se ven afectados por problemas de acceso a servicios básicos, deficiencias en la calidad de la atención, y falencias en infraestructura, entre otros.',
        'El derecho a la educación se ve afectado por las discriminaciones por causas socioeconómicas en el sistema educativo, brechas de calidad en el sistema, y problemas de infraestructura, entre otros.',
        'El derecho a la vivienda se ve afectado por el déficit habitacional, las condiciones de segregación y los desafíos del derecho a la vivienda adecuada en materia de calidad y acceso a servicios, entre otros.',
        'Dificultades de acceso a servicios de agua potable y el uso no sostenible del agua en la industria minera, entre otros.',
        'El derecho a un medio ambiente libre de contaminación se ve afectado por deficiencias normativas y falta de facultades de fiscalización a organismos públicos, entre otros.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Trata y tráfico de personas'.downcase
      @options = [
        'Insuficiencia de medidas preventivas de la trata de personas.',
        'Falta de mecanismos de protección integral a las víctimas, que les permita el pleno goce y ejercicio de sus derechos, especialmente en los ámbitos de la salud y de acceso a la justicia.',
        'Ausencia de mecanismos de identificación de víctimas de trata, por falta de un mecanismo independiente, con recursos suficientes para esta tarea.',
        'Falencias de la legislación penal de trata de personas, que no permiten investigar y sancionar todas las formas de trata y tráfico de personas, con penas suficientemente severas, y reparación integral de las víctimas.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Prevención de la tortura y violencia institucional'.downcase
      @options = [
        'Existencia de casos de tortura y otros tratos o penas crueles, inhumanos o degradantes a personas privadas de libertad en recintos penitenciarios.',
        'Existencia de casos de tortura y otros tratos o penas crueles, inhumanos o degradantes a personas internadas en residencias públicas o privadas, principalmente personas con discapacidad, personas mayores y niños, niñas y adolescentes.',
        'Falta de implementación del Mecanismo Nacional de Prevención de la Tortura, como institucionalidad que contribuya a la prevención de este fenómeno.',
        'Uso excesivo de la fuerza y prácticas de tortura por parte de fuerzas de orden y seguridad.',
        'Falta de políticas de investigación, sanción y reparación ante casos de violaciones de derechos humanos por parte de las policías.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Derechos Digitales'.downcase
      @options = [
        'Falta de regulación del uso de datos personales que realizan empresas e instituciones del Estado, lo que pone en riesgo el derecho a la privacidad.', 
        'Utilización de datos biométricos en casos de vigilancias ilegales y fines no consentidos.',
        'Ausencia de un marco normativo para evitar que el Big Data y el Data Mining generen peligro de difusión o tráfico de datos personales.',
        'Inequidad en acceso a internet o limitaciones a su uso, que generan restricciones al ejercicio de la libertad de expresión y al acceso a la información.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Acceso a la justicia'.downcase
      @options = [
        'Las barreras económicas, sociales, culturales y legales provocan desigualdad ante la ley, particularmente a grupos de población más vulnerable.',
        'Las Corporaciones de Asistencia Judicial (CAJ) requieren ampliar y mejorar su cobertura, para potenciar el acceso gratuito a servicios jurídicos.',
        'Existencia de barreras de acceso que impiden a las personas con discapacidad ejercer sus derechos ante los tribunales.',
        'La ausencia de medidas de pertinencia cultural dificulta a personas migrantes o personas de pueblos indígenas ejercer sus derechos ante los tribunales.',
        'Necesidad de ajustar el funcionamiento actual de los sistemas de justicia militar y de justicia civil a los estándares internacionales de derechos humanos.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas Mayores'.downcase
      @options = [
        'Casos de maltrato y violencia contra personas mayores, tanto en las residencias particulares como cuando se encuentran internados en establecimientos de larga estadía.',
        'Insuficiencia de políticas públicas para que las personas mayores mantengan sus capacidades, vivan con independencia y puedan tener acceso a los cuidados que requieren.',
        'Falta de mecanismos suficientes para que las personas mayores puedan acceder a información relevante, considerando su menor acceso a canales digitales de difusión.',
        'Incapacidad de acceder a servicios sociales básicos, como consecuencia de pensiones que no les permiten un bienestar material mínimo.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Mujeres'.downcase
      @options = [
        'Violencia contra las mujeres e inexistencia de políticas públicas suficientes para su prevención y abordaje.',
        'Baja participación política y pública de mujeres, como consecuencia de obstáculos estructurales y estereotipos de género.',
        'Brechas laborales y económicas entre hombres y mujeres, expresadas en diferencias de ingreso por igual trabajo, diferencias en inserción laboral, roles de género que reproducen las desigualdades en este plano, entre otras.',
        'Vigencia de normas que imponen modelos discriminatorios contra la mujer en el matrimonio, como la administración de la sociedad conyugal.',
        'Insuficiente cumplimiento de los derechos sexuales y reproductivos de las mujeres.',
        'Otro',
      ]
    end

    if chapter.downcase == 'LGBTIQ+'.downcase
      @options = [
        'Existencia de normativas utilizadas discriminatoriamente para detener y hostilizar a las personas por su orientación sexual o identidad de género, como la penalización de las relaciones sexuales consentidas entre personas menores de edad del mismo sexo, entre otras.',
        'Existencia de distinción y exclusión que impide a la población LGBTIQ+ ejercer parte de sus derechos civiles, como el matrimonio.',
        'Necesidad de visibilizar y atender la situación de los niños, niñas intersex, para garantizar sus derechos.',
        'Violencia contra la población LGBTIQ+ e inexistencia de políticas públicas suficientes para su prevención,  sanción y abordaje.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas con Discapacidad'.downcase
      @options = [
        'Cumplimiento insatisfactorio de medidas que permitan la accesibilidad universal en infraestructura, derechos económicos y sociales, acceso a información y otras áreas.',
        'Falta de ajustes de los procedimientos para hacer efectivo el acceso a la justicia de las personas con discapacidad y existencia de restricciones al ejercicio de la capacidad jurídica por el régimen de interdicción vigente.',
        'Prácticas constitutivas de tortura en establecimientos residenciales, como: psicosirugías, tratamientos electroconvulsivos, aislamientos, tratos vejatorios, entre otros.',
        'Falta de apoyos a las personas con discapacidad para que puedan vivir de manera independiente, con inclusión en sus comunidades.',
        'Existencia de un sistema educativo que funciona para las personas con discapacidad con un formato de educación especial, que segrega a estas personas, y dificulta sus proceso de inclusión.',
        'Persistencia de un modelo de salud con enfoque en la discapacidad y no con enfoque de derechos humanos, e insuficiencia de prestaciones de salud para personas con discapacidad en servicios como salud mental, ginecológicos, entre otros.',
        'Existencia de brechas en aspectos laborales que sufren las personas con discapacidad y sus personas cuidadoras, especialmente para mujeres y personas mayores, que se refleja en barreras de acceso al trabajo, en sus niveles de ingresos, entre otros.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Pueblos Indígenas y Tribales'.downcase
      @options = [
        'Marginación y discriminación histórica de los pueblos indígenas, derivadas de los procesos de conquista y ocupación territorial.',
        'Criminalización de la protesta social indígena con base en el anhelo de reivindicación territorial y cultural. Aplicación desproporcionada de métodos de persecución penal como la Ley Antiterrorista contra líderes indígenas, especialmente del Pueblo Mapuche.',
        'Uso desproporcionado e indiscriminado de la fuerza por parte de agentes policiales en procedimientos investigativos al interior de comunidades indígenas, que afecta especialmente a mujeres, personas mayores y niños, niñas y adolescentes.',
        'Falta de respuesta suficiente por parte del Estado para asegurar el derecho a usar y proteger los territorios ancestrales indígenas.',
        'Discriminación y desigualdad para la realización de derechos económicos, sociales y culturales, así como en los casos de conflictos socioambientales. ',
        'Falta del reconocimiento de los pueblos indígenas a nivel constitucional.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas Privadas de Libertad'.downcase
      @options = [
        'Hacinamiento y falta de condiciones mínimas en relación a infraestructura, equipamiento y funcionalidad de recintos penitenciarios.',
        'Existencia de prácticas que constituyen tratos crueles, inhumanos o degradantes.',
        'Precariedad de la red de salud a la que tienen acceso las personas privadas de libertad, particularmente en medicina especializada, con importantes brechas a lo largo del país.',
        'Insuficiencia en la protección de grupos especialmente vulnerables, con énfasis en mujeres, pueblos indígenas, niños, niñas y adolescentes, entre otros.',
        'Prácticas denigrantes durante la revisión de las personas que visitan a las personas privadas de libertad, incluyendo prácticas de desnudamientos a adultos/as y en algunos casos a niños, niñas y adolescentes.',
        'El sistema actual de justicia juvenil no cumple aún con estándares, recursos y mecanismos que protejan la integridad, el desarrollo y derechos de las y los adolescentes.',
        'Se requiere mejorar la oferta de educación, su calidad, oportunidad y adaptabilidad, para toda la población privada de libertad, y particularmente para quienes son adolescentes.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas Migrantes y Refugiadas'.downcase
      @options = [
        'Críticas a la nueva ley de migración y extranjería, en particular a los espacios de participación ciudadana en el nuevo servicio, la incertidumbre sobre el uso de los datos del Registro Nacional de Extranjeros y la forma en cómo se implementarán las visas consulares.',
        'Falta de políticas para la protección de derechos económicos, sociales y culturales para personas migrantes, especialmente en vivienda, salud y educación, que le permitan acceder a estos derechos sin discriminación por situación migratoria.',
        'Falta de armonización normativa plena entre el derecho nacional y el derecho internacional de los derechos humanos especialmente en lo relativo a la protección de los trabajadores migratorios y sus familiares.',
        'Falta de medidas para la protección de niños, niñas y adolescentes migrantes o hijos e hijas de migrantes.',
        'Falta de acceso efectivo al procedimiento de determinación de condición de refugiado sin prácticas de pre-admisibilidad.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Niños, niñas y adolescentes'.downcase
      @options = [
        'Inexistencia de medidas suficientes para que niños, niñas y adolescentes que viven en centros de acogida puedan potenciar y/o mantener lazos con su entorno familiar.',
        'Ausencia de medidas suficientes para la prevención, investigación y sanción de las situaciones de violencia y malos tratos contra niños, niñas y adolescentes.',
        'Brechas en sistema de asistencia sanitaria para niños, niñas y adolescentes, en materias de salud mental, rehabilitación en drogas y alcohol y educación sexual.',
        'No se garantiza el derecho a educación de calidad para todos los niños, niñas y adolescentes, por distintos problemas de nuestro sistema educativo, como la segregación y la baja calidad de sus resultados.',
        'Falta de mecanismos de participación de niños, niñas y adolescentes, para garantizar que sean escuchados en la adopción de todas las medidas que les afecten.',
        'Se deben adoptar medidas para erradicar el trabajo de infantil.',
        'Faltan medidas que garanticen la protección de los derechos   de niños, niñas y adolescentes que participen en procesos judiciales y la generación de un sistema especializado para su representación judicial.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Enfoque Basado en Derechos Humanos'.downcase
      @options = [
        'Baja existencia y efectividad de canales de denuncia administrativos, que sean conocidos por la comunidad, e incidan en el desarrollo de las políticas públicas.',
        'Baja incidencia en las  políticas públicas de los mecanismos de participación ciudadana actualmente implementados por las instituciones públicas.',
        'Necesidad de mejorar la normativa vigente para avanzar en procesos participativos más significativos.',
        'Falta de espacios de participación institucional para grupos de especial protección, particularmente en los casos de niños, niñas y adolescentes, y de pueblos indígenas.',
        'Falencias en la cantidad y/o calidad de la información producida por instituciones públicas, que permitan dar seguimiento a la situación de derechos humanos de la población.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Educación en Derechos Humanos'.downcase
      @options = [
        'Aunque hay esfuerzos por incorporar materias de derechos humanos en el currículo escolar, estos son aún insuficientes y suelen terminar como materias poco profundizadas.',
        'Brecha en estándar de formación en derechos humanos en fuerzas de orden y seguridad, tanto en los procesos formativos iniciales de las y los funcionarios, como en capacitaciones que reciban durante el ejercicio de sus funciones.',
        'Formación en derechos humanos en el Estado cuenta con distintos problemas que limitan su impacto, como falta de aplicación práctica de contenidos, baja participación de estamentos directivos, entre otros.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Sistemas internacionales de Derechos Humanos'.downcase
      @options = [
        'Necesidad de evaluar la ratificación, firma y retiro de reservas de tratados internacionales de derechos humanos que se encuentran pendientes.',
        'Necesidad de mejorar los mecanismos internos para el cumplimento de los compromisos internacionales adquiridos en el seno de los sistemas universal e interamericano de derechos humanos.',
        'Necesidad de que el Estado dé a conocer a la ciudadanía los tratados de derechos humanos que ha ratificado, las recomendaciones para su cumplimiento que ha recibido y establezca un  mecanismo de seguimiento de las recomendaciones, con participación ciudadana.',
        'Otro',
      ]
    end

    return @options
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quiz_params
      params.require(:quiz).permit(:name, :description, :user_id, :visible, :q1, :q2, :q3, :q4, :q5, :quiz_type, :tag_id)
    end
end
