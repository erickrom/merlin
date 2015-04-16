require 'rails_helper'

describe AppSetting do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:value) }
end
