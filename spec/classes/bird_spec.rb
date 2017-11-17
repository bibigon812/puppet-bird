require 'spec_helper'

describe 'bird' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_service('bird')
          .with_enable(true)
          .with_hasrestart(true)
          .with_hasstatus(true)
          .that_subscribes_to(['Package[bird]', 'Concat[/etc/bird.conf]'])
      }

      it {
        is_expected.to contain_package('bird')
      }

      it {
        is_expected.to contain_concat('/etc/bird.conf')
          .that_requires('Package[bird]')
      }

      it {
        is_expected.to contain_concat__fragment('bird_conf_10_global')
          .with_content(<<-EOS
#
# Managed by Puppet in the rp_env environment
#

router id 172.16.254.254
EOS
          )
      }
    end
  end
end
