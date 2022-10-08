class Api::V1::MessagesController < ApplicationController

  #TODO
  # Add proper validation over the record creation after passing to queue
  # Add proper validation over record update

  # GET /messages?app_token={application_token} Get all Messages related to single application
  def index
    if !params[:app_token]
      return json_response({message: 'please provide application token' }, :not_found)
    end
    @messages = Message
                  .joins(chat: :application)
                  .where(applications: {token: params[:app_token]})
                  .all
                  .to_json(except: [:id, :chats_id])

    json_response(@messages,:ok)
  end

  # POST /messages/ message Create
  # body {
  #    app_token={application_token}
  #    chat_number={chat_number}
  #     message_body={message_body}
  # }

  def create
    @message = Message.new
    @message.chat = getChatByNumberAndToken(params[:app_token], params[:chat_number])
    @message.messages = params[:message_body]
    @message.message_number = getMessageNumber(params[:app_token], params[:chat_number])

    if !@message.valid?
      raise ActiveRecord::RecordInvalid.new(@message)
    else

      # Increase Created messages numbers
      $redis.incr("total_messages_number$#{params[:app_token]}$#{params[:chat_number]}")

      Publisher.publish('chatapi.message', @message.to_json)
      json_response({message_number: @message.message_number}, :created)
    end
  end

  # GET /messages/{message_number}?app_token={application_token}&chat_number={chat_number}
  # Get all Messages related to single application and chat

  def show
    if !params[:app_token] || !params[:chat_number]
      return json_response({message: 'please provide application token and chat number' }, :not_found)
    end
    @message = getMessage(params[:app_token], params[:chat_number], params[:message_number])
    json_response(@message.to_json(except: [:id, :applications_id, :chats_id]))
  end

  # PUT /messages/{message_number} message update
  # body {
  #    app_token={application_token}
  #    chat_number={chat_number}
  #     message_body={message_body}
  # }

  def update
    @message = getMessage(params[:app_token], params[:chat_number], params[:message_number])

    @message.update(messages: params[:message_body])
    json_response({message_number: params[:message_number]}, :ok)
  end

  # private
  def message_prams
    params.permit(:app_token, :chat_number, :message_body, :message_number)
  end

  def getChatByNumberAndToken(app_token, chat_number)
    Chat.joins(:application)
        .find_by(chats: {chat_number: chat_number},
               applications: {token: app_token})
  end

  def getMessage(app_token, chat_number, message_number)
    Message.joins(:chat => :application)
           .where(
             applications: {token: app_token},
             chats: {chat_number: chat_number},
             message_number: message_number
           ).first
  end

  def getMessageNumber(app_token, chat_number)
    $redis.incr("message_chat_token_counter$#{app_token}$#{chat_number}")
  end


end