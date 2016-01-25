require 'serverspec'

set :backend, :exec

describe port(4567) do
  it { should be_listening.on('0.0.0.0') }
end
