require 'spec_helper'

describe 'Team' do
  before do
    @team = Team.create(:name => "Winning Team")
  end
  it 'can slug the team name' do
    expect(@team.slug).to eq("winning-team")
  end

  it 'can find a team based on the slug' do
    slug = @team.slug
    expect(Team.find_by_slug(slug).name).to eq("Winning Team")
  end

end
