# frozen_string_literal: true

require 'calnet_helper'
require 'rails_helper'
require 'stub_helper'

RSpec.describe 'Dataloads' do
  context 'with Unauthorized users' do
    it 'returns a forbidden response' do
      get data_loads_path
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'with Authorized users' do
    before do
      login_as_patron('3032640236')
    end

    it 'returns a success response' do
      get data_loads_path

      expect(response).to have_http_status(:success)
    end

    it 'shows all dataloads' do
      create_dataload(num: '1')
      create_dataload(num: '2')

      get data_loads_path

      expect(response.body).to include('Dataload 1' && 'Dataload 2')
    end

    it 'does not show archived dataloads' do
      create_dataload(num: '1')
      create_dataload(num: '2', archived: true)

      get data_loads_path

      expect(response.body).not_to include('Dataload 2')
    end
  end
end
