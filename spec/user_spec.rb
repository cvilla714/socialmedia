require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    u = User.new(email: 'zorro@onepiece.com', name: 'zorro', password: '123456')
    it 'should have a user' do
      u.name = nil
      expect(User.new).to_not be_valid
    end

    it 'should have a valid user' do
      expect(User.new(name: 'zorro', email: 'zorro@manga.com', password: '123456')).to be_valid
    end
  end
end
