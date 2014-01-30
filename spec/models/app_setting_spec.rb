require 'spec_helper'

describe AppSetting do
  it { should respond_to(:name) }
  it { should respond_to(:value) }
end
