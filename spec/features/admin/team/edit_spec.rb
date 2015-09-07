require "rails_helper"

feature 'admin sees team show page', %{
} do
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }

  scenario "signed in admin edits team" do
    sign_in_as(admin)
    visit admin_team_path(team)
    click_link "Edit Team"
    fill_in "Name", with: "Admin Overlords"
    check "Enrolling"
    click_button "Update Team"

    expect(page).to have_content("Team Updated!")
    expect(page).to have_content("Admin Overlords")
    expect(page).to have_content("Currently Enrolling")
  end

  scenario "signed in admin fills in invalid information" do
    sign_in_as(admin)
    visit admin_team_path(team)
    click_link "Edit Team"
    fill_in "Name", with: ""
    check "Enrolling"
    click_button "Update Team"

    expect(page).to have_content("Team Not Updated")
    expect(page).to have_content("Name can't be blank")
    expect(page.has_checked_field? "Enrolling").to eq(true)
  end

  scenario "non-admin user cannot see page" do
    sign_in_as(user)
    visit edit_admin_team_path(team)

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end

  scenario "unauthenitcated user cannot see page" do
    visit edit_admin_team_path(team)

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end
end
