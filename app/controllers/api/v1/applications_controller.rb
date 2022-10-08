class Api::V1::ApplicationsController < ApplicationController

  # GET /applications
  def index
    @apps = Application.all.as_json(:except => :id)
    json_response(@apps,:ok)
  end

  # POST /applications create
  def create
    @app = Application.new
    @app.name = params[:name]
    @app.token = SecureRandom.urlsafe_base64(nil, false) + (Time.now.to_i.to_s)

    if !@app.valid?
      json_response({}, :bad_request)
    else
      Publisher.publish('chatapi.application', @app.to_json)
      json_response({app_token: @app.token}, :created)
    end
  end

  # GET /applications/{token} show single app
  def show
    @app = Application.find_by!(token: params[:token])
    json_response(@app.to_json(:except => :id))
  end

  # PUT /applications/{token} update app
  def update
    @app = Application.find_by!(token: params[:token])
    @app.update(
      name: params[:name]
    )
      json_response({app_token: @app.token}, :ok)
  end

  # private
  def linked_app_prams
    params.permit(:token, :name)
  end
end
