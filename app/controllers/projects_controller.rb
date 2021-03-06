class ProjectsController < AdminController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
      @user = Project.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new
    @category_options_select = Category.where(user_id: current_user.id)
  end

  # GET /projects/1/edit
  def edit
     @category_options_select = Category.where(user_id: current_user.id)
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        @project_user = ProjectUser.create(user_id: current_user.id, project_id: @project.id)
         
        format.html { redirect_to project_user_path(current_user.id), notice: "Projeto (#{@project.title}) cadastrado com sucesso!" }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to  project_user_path(current_user.id), notice: "Projeto (#{@project.title}) atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    #@project_user = ProjectUser.destroy.find_by project: (@project.id)
    
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :text, :delivery_date, :creation_date, :category_id)
    end
    
    def project_user_params
      params.require(:project_user).permit(:user_id, :project_id)
    end
end
