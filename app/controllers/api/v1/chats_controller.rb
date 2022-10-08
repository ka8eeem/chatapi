class Api::V1::ChatsController < ApplicationController

  #TODO
  # Add proper validation over the record creation after passing to queue
  # Add proper validation over record update

  # GET /chats?app_token{application_token}
  def index
      if !params[:app_token]
        return json_response({message: 'please provide application token' }, :not_found)
      end
    @chats = Chat.joins(:application)
                 .where(applications: {token: params[:app_token]})
                 .all
                 .to_json(except: [:id, :applications_id])
    json_response(@chats,:ok)
  end

  # POST /chats create chat
  # body {
  #     app_token={application_token}
  #     chat_users={string}
  # }
  def create
    @app = Application.find_by!(:token => params[:app_token])
    @chat = Chat.new
    @chat.chat_users = params[:chat_users]
    @chat.application = @app

    if !@chat.valid?
      raise ActiveRecord::RecordInvalid.new(@chat)
    end

    @chat.chat_number = getChatNumber(params[:app_token])

    # Increase Created chat numbers
    $redis.incr("total_chats_number$#{params[:app_token]}")

    Publisher.publish('chatapi.chat', @chat.to_json)
    json_response({chat_number: @chat.chat_number}, :created)
  end

  # GET /chats/{chat_number}?app_token={application_token} show single chat
  def show
    if !params[:app_token]
      return json_response({message: 'please provide application token' }, :not_found)
    end
    @chat = getChatByNumberAndToken(params[:app_token], params[:chat_number])
    json_response(@chat.to_json(:except => [:id, :applications_id]))
  end

  # PUT /chats/{chat_number} update chat
  # body {
  #     app_token={application_token}
  #     chat_users={string}
  # }
  def update
    @chat = getChatByNumberAndToken(params[:app_token], params[:chat_number])
    if @chat.blank?
      return json_response({message: 'please provide application token'}, :not_found)
    end
    @chat.update(chat_users: params[:chat_users])

    json_response({chat_number: params[:chat_number]}, :ok)
  end

  # private
  def chats_prams
    params.permit(:app_token, :chat_number, :chat_users)
  end

  def getChatByNumberAndToken(app_token, chat_number)
      Chat.joins(:application)
        .where(chats: {chat_number: chat_number},
               applications: {token: app_token})
  end
  def getChatNumber(app_token)
    $redis.incr("chat_token_counter$#{app_token}")
  end

end