feature 'adding tags' do

  scenario 'I can add a single tag to a new link' do
    visit '/links/new'
    fill_in 'url',   with: 'https://makersacademy.com/'
    fill_in 'title', with: 'Makers Academy'

    fill_in 'tag', with: 'education'

    click_button 'Create link'
    link = Link.first
    expect(link.tags).to include('education')
  end
end
