# spec/models/user_spec.rb

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user) # Using Factory Bot to create a User instance
      expect(user).to be_valid
    end
  end
end
