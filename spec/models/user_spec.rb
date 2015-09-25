require_relative '../../app/models/user'

describe Models::User do

  let!(:user) do
    described_class.create(email: 'test@test.com', password: 'secret1234',
                password_confirmation: 'secret1234')
  end

  it 'authenticates when given a valid email address and password' do
    authenticated_user = described_class.authenticate(user.email, user.password)
    expect(authenticated_user).to eq user
  end

  it 'does not authenticate when given an incorrect password' do
    expect(described_class.authenticate(user.email, 'wrong_stupid_password')).to be_nil
  end

end
