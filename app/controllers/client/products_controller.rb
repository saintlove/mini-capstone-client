class Client::ProductsController < ApplicationController
  def index
    client_params = {
                     search: params[:search],
                     sort_by: params[:sort_by],
                     sort_order: params[:sort_order],
                     category: params[:category]
                    }
    response = Unirest.get(
                           "http://localhost:3000/api/products",
                           parameters: client_params
                           )
    @products = response.body
    render 'index.html.erb'
  end

  def new
    @product = {}
    render 'new.html.erb'
  end

  def create
    @product = {
                   'name' => params[:name],
                   'price' => params[:price],
                   'description' => params[:description],
                   'supplier_id' => params[:supplier_id]
                  }

    response = Unirest.post(
                            "http://localhost:3000/api/products",
                            parameters: @product
                            )

    if response.code == 200
      flash[:success] = "Successfully created Product"
      redirect_to "/client/products/"
    elsif response.code == 401
      flash[:warning] = "You are not authorized to make a product"
      redirect_to "/"
      
    else
      @errors = response.body["errors"]
      render 'new.html.erb'
    end
  end

  def show
    product_id = params[:id]
    response = Unirest.get("http://localhost:3000/api/products/#{product_id}")
    @product = response.body
    render 'show.html.erb'
  end

  def edit
    response = Unirest.get("http://localhost:3000/api/products/#{params[:id]}")
    @product = response.body
    render 'edit.html.erb'
  end

  def update
    @product = {
                   'id' => params[:id],
                   'name' => params[:name],
                   'price' => params[:price],
                   'description' => params[:description],
                   'supplier_id' => params[:supplier_id],
                   'supplier' => {'id' => params[:supplier_id]}
                  }

    response = Unirest.patch(
                            "http://localhost:3000/api/products/#{params[:id]}",
                            parameters: @product
                            )

    if response.code == 200
      flash[:success] = "Successfully updated Product"
      redirect_to "/client/products/#{params[:id]}"
    elsif response.code == 401
      flash[:warning] = "You are not authorized to update a product"
      redirect_to "/"
      
    else
      @errors = response.body['errors']
      render 'edit.html.erb'
    end
  end

  def destroy
      response = Unirest.delete("http://localhost:3000/api/products/#{params['id']}")
      flash[:success] = "Successfully destroyed product"
      redirect_to "/client/products"
    else
      flash[:warning] = "You are not authorized to delete a product"
      redirect_to "/"
    end
  end
  