class ScenariosController < ProjectManagerController
  before_action :set_scenario, only: [:show, :edit, :update, :destroy]

  # GET /scenarios
  # GET /scenarios.json
  def index
    options_for_select
    @scenarios = Scenario.where(project_id: current_project.id)
  end

  # GET /scenarios/1
  # GET /scenarios/1.json
  def show
    set_current_scenario
    @step_scenarios = StepScenario.where(scenario_id: current_scenario.id)
  end

  # GET /scenarios/new
  def new
    @scenario = Scenario.new
    options_for_select
  end

  # GET /scenarios/1/edit
  def edit
    options_for_select
  end

  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)
    @scenario.project_id = current_project.id

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to scenarios_path, notice: "Cenário (#{@scenario.name}) cadastrado com sucesso!" }
        format.json { render :show, status: :created, location: @scenario }
      else
        format.html { render :new }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to scenarios_path, notice: "Cenário (#{@scenario.name}) atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    @scenario.destroy
    respond_to do |format|
      format.html { redirect_to scenarios_url, notice: 'Scenario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def report
    @scenarios = Scenario.where(project_id: current_project.id)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ScenarioPdf.new(@scenarios)
        send_data pdf.render, filename: "cenario.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  private
    #Options UseCase for selection
    def options_for_select
      @usecase_options_select = UseCase.where(project_id: current_project.id)
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scenario_params
      params.require(:scenario).permit(:name, :description, :scenario_type, :use_case_id)
    end
end
