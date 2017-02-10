require 'rails_helper'

RSpec.feature "Photo uploads" do
  context "Host" do
    before do
      Fog.mock!
      Fog::Mock.delay = 0
      service = Fog::Storage.new({
        provider: 'Google',
        google_storage_access_key_id: ENV['GOOGLE_STORAGE_ACCESS_KEY_ID'],
        google_storage_secret_access_key: ENV['GOOGLE_STORAGE_SECRET_ACCESS_KEY']
      })
      service.directories.create(:key => 'photo-of-the-day')
    end

    scenario "uploads a photo for a couch" do
      couch = create :couch
      host  = couch.host
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(host)

      visit new_user_couch_photo_path(host, couch)

      fill_in "Title", with: "My photo title"
      fill_in "Caption", with: "My photo caption"
      fill_in "Date", with: "2015-12-29"
      attach_file "photo[image]", Rails.root + "spec/fixtures/dummy.png"
      click_button "Upload"

      expect(current_path).to eq(photo_path(Photo.last))
    end
  end
end