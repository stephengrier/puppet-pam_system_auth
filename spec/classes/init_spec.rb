require 'spec_helper'
describe 'pam_system_auth' do

  context 'with defaults for all parameters' do
    it { should contain_class('pam_system_auth') }
  end
end
