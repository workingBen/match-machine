require 'spec_helper'

describe MachineController do

  describe "GET 'setup'" do
    it "returns http success" do
      get 'setup'
      response.should be_success
    end
  end

  describe "GET 'run'" do
    it "returns http success" do
      get 'run'
      response.should be_success
    end
  end

  describe "GET 'matches'" do
    it "returns http success" do
      get 'matches'
      response.should be_success
    end
  end

end
