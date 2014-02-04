require 'spec_helper'

describe Tournament do
  it { should respond_to(:name) }

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :league }
  end
end
