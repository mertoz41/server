class InstrumentsController < ApplicationController
    def index
        instruments = Instrument.all
        render json: {instruments: instruments}
    end
end
