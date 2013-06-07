class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :require_operator
  before_filter :find_record, only: [:show, :edit, :update, :destroy]

  def index
    @o_all = get_records(params[:search])
  end

  def show
  end

  def new
    @o_single = Product.new
  end

  def create
    @o_single = Product.new(params[:product])
    if @o_single.save
    	redirect_to_index(t("successfully_created"))
    else
    	render :action => 'new'	
    end
  end

  def edit
  	render :action => 'new'
  end

  def update
    if @o_single.update_attributes(params[:product])
    	redirect_to_index(t("successfully_updated"))
    else
    	render :action => 'edit'	
    end
  end

  def destroy
    @o_single.destroy
    @o_all = get_records(params[:search])
  end

  private

  def get_records(search)
  	Product.search(search).order(sort_column + " " + sort_direction)
  end

  def sort_column
    Product.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def find_record
    begin
      @o_single = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @o_single = nil
    end
  end
  
  def redirect_to_index(msg)
    flash[:notice] = msg
    redirect_to products_path  	
  end
  
end
