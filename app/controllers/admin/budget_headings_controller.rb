class Admin::BudgetHeadingsController < Admin::BaseController
  include Admin::BudgetHeadingsActions

  def new
    @heading = @group.headings.new
  end

  def update
    if @heading.update(budget_heading_params)
      @heading.sector_ids = []

      if params['budget_heading']['sector_ids']

        params['budget_heading']['sector_ids'].each do |s|
          sector = Sector.find_by(name: s)
          @heading.sectors.append(sector)
        end
      else
        Sector.all.each do |s|
          @heading.sectors.append(s)
        end
      end

      if @heading.save
        flash[:notice] = "Actualizado correctamente."
        redirect_to edit_admin_budget_group_heading_path(@budget.id, @group.id, @heading.id)
      else
        render :edit
      end
    else
      render :edit
    end
  end

  private

    def headings_index
      admin_budget_path(@budget)
    end

    def new_action
      :new
    end
end
