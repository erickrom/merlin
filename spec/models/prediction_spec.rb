require 'spec_helper'

describe Prediction do
  describe "associations" do
    it { should belong_to :tournament }
    it { should belong_to :match }
    it { should belong_to :user }
  end
end
