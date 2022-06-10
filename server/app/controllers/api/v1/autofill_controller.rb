class Api::V1::AutofillController < ApplicationController

def index
    render json: {name: 'vardas', surname: 'pavarde', country: 'lietuva'}
end

end