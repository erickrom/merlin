require 'spec_helper'

describe League do
  it { should respond_to(:name) }
  it { should respond_to(:external_id) }
  it { should respond_to(:year) }
  it { should respond_to(:group_code) }
  it { should respond_to(:playoff) }
  it { should respond_to(:current_round) }
  it { should respond_to(:total_group) }
  it { should respond_to(:total_rounds) }
  it { should respond_to(:flag_url_path) }
end
