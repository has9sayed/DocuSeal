class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy, :duplicate]

  def index
    @templates = current_user.templates.order(created_at: :desc)
  end

  def show
  end

  def new
    @template = current_user.templates.new
  end

  def create
    @template = current_user.templates.new(template_params)

    if @template.save
      redirect_to @template, notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @template.update(template_params)
      redirect_to @template, notice: 'Template was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to templates_url, notice: 'Template was successfully deleted.'
  end

  def duplicate
    new_template = @template.duplicate
    if new_template.persisted?
      redirect_to new_template, notice: 'Template was successfully duplicated.'
    else
      redirect_to @template, alert: 'Failed to duplicate template.'
    end
  end

  private

  def set_template
    @template = current_user.templates.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:name, :description, :template_file, :is_public)
  end
end 