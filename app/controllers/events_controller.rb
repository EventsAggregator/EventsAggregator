class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    @events = Predicthq.getEvents(params[:q], params[:start_date], params[:end_date], params[:current_location], params[:loc], params[:category])
    @events2 = Ticketmaster.getEvents(params[:q], params[:start_date], params[:end_date], params[:current_location], params[:loc], params[:category])

    key = params[:q].to_s.present? ? "#{params[:q].capitalize()}, " : ""
    if params[:current_location].to_i == 0 then
      luogo = params[:loc].to_s.present? ? "in #{params[:loc]} " : ""
    else
      luogo = params[:loc].to_s.present? ? "in #{Geocoder.search(params[:loc]).first.city} " : ""
    end
    categ = params[:category].to_s.present? ? "regarding #{params[:category]} " : ""
    if params[:start_date].to_s.present? || params[:end_date].to_s.present? then int= "on the date " else int="" end
    da = params[:start_date].to_s.present? ? "from #{params[:start_date]} " : ""
    fino = params[:end_date].to_s.present? ? "to #{params[:end_date]} " : ""
    @cerco = key+luogo+categ+int+da+fino
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by(event_id: params[:id]) or not_found
    end

    def not_found
      # raise ActionController::RoutingError.new('Not Found')
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end    

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:event_id, :organizer_id, :coordinates)
    end
end
