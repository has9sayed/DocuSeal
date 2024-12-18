class SignaturesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :sign, :decline]
  before_action :set_signature, only: [:show, :sign, :decline]

  def index
    @signatures = current_user.signatures.order(created_at: :desc)
  end

  def show
    # Public access for signing
  end

  def create
    @document = current_user.documents.find(params[:document_id])
    @signature = @document.signatures.new(signature_params)
    @signature.user = current_user

    if @signature.save
      redirect_to @document, notice: 'Signature request was successfully created.'
    else
      redirect_to @document, alert: 'Failed to create signature request.'
    end
  end

  def sign
    if @signature.sign(params[:signature_data])
      redirect_to @signature, notice: 'Document was successfully signed.'
    else
      redirect_to @signature, alert: 'Failed to sign document.'
    end
  end

  def decline
    if @signature.update(status: :declined, decline_reason: params[:decline_reason])
      redirect_to @signature, notice: 'Document signing was declined.'
    else
      redirect_to @signature, alert: 'Failed to decline document.'
    end
  end

  private

  def set_signature
    @signature = Signature.find_by!(signing_token: params[:signing_token])
  end

  def signature_params
    params.require(:signature).permit(:email, :name)
  end
end 