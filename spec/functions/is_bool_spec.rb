require 'spec_helper'

describe 'is_bool' do
  
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params(true, false).and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params(true).and_return(true) }
  it { is_expected.to run.with_params(false).and_return(true) }
  it { is_expected.to run.with_params([1]).and_return(false) }
  it { is_expected.to run.with_params([{}]).and_return(false) }
  it { is_expected.to run.with_params([[]]).and_return(false) }
  it { is_expected.to run.with_params([true]).and_return(false) }
  it { is_expected.to run.with_params('true').and_return(false) }
  it { is_expected.to run.with_params('false').and_return(false) }
  context 'Checking for deprecation warning' do
    after(:context) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end 
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'should display a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
      scope.expects(:warning).with(includes('This method is deprecated'))
      is_expected.to run.with_params(true).and_return(true)
    end
    it 'should display no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = "false"
      scope.expects(:warning).with(includes('This method is deprecated')).never
      is_expected.to run.with_params(false).and_return(true)
    end
  end 
end

