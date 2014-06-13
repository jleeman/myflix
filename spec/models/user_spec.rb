require 'rails_helper.rb'

describe User do
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:password)}
  it { should validate_presence_of(:full_name)}

  it "password must be greater than five characters" do
    u = User.create(email: "joshleeman@gmail.com", password: "abc", full_name: "Josh Leeman")
    expect(User.count).to eq(0)
  end

  it "email must be unique" do
    u = User.create(email: "joshleeman@gmail.com", password: "abcdef", full_name: "Josh Leeman")
    u2 = User.create(email: "joshleeman@gmail.com", password: "abcdef", full_name: "Josh Leeman")
    expect(User.count).to eq(1)
  end
end