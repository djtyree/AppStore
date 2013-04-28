require 'spec_helper'

describe User do
    
  before do
  	@user = User.new(fullname: "Example User", email: "user@example.com", username: "euser",
  					password: "myfoobar", password_confirmation: "myfoobar")
  end


  subject { @user }

  it { should respond_to(:fullname) }
  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:apps) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.fullname = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.fullname = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end
  
  describe "when password is not present" do
  	before { @user.password = @user.password_confirmation = " " }
  	it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "app associations" do

    before { @user.save }
    let!(:older_apps) do 
      FactoryGirl.create(:app, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_apps) do
      FactoryGirl.create(:app, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right apps in the right order" do
      @user.apps.should == [newer_apps, older_apps]
    end

    it "should destroy associated apps" do
      apps = @user.apps.dup
      @user.destroy
      apps.should_not be_empty
      apps.each do |app|
        App.find_by_id(app.id).should be_nil
      end
    end
  end
end
