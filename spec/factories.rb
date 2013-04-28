FactoryGirl.define do
  factory :user do
    fullname     "Michael Hartl"
    username     "mhartl"
    email    "michael@example.com"
    password "myfoobar"
    password_confirmation "myfoobar"
  end

  factory :app do
    title "Example App"
    content "Example App Description"
    user
  end
end