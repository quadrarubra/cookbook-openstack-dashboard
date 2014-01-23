# encoding: UTF-8
require_relative 'spec_helper'

describe 'openstack-dashboard::server' do

  describe 'suse' do

    let(:runner) { ChefSpec::Runner.new(SUSE_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    include_context 'non_redhat_stubs'
    include_context 'dashboard_stubs'

    context 'mysql backend' do

      include_context 'mysql_backend'

      it 'installs mysql packages when mysql backend is configured' do
        expect(chef_run).to upgrade_package('python-mysql')
      end
    end

    context 'postgresql backend' do

      include_context 'postgresql_backend'
      let(:file) { chef_run.template('/srv/www/openstack-dashboard/openstack_dashboard/local/local_settings.py') }

      it 'installs packages' do
        expect(chef_run).to upgrade_package('openstack-dashboard')
      end

      it 'installs postgresql packages' do
        expect(chef_run).to upgrade_package('python-psycopg2')
      end

      it 'creates local_settings.py' do
        expect(chef_run).to render_file(file.name).with_content('autogenerated')
      end

      it 'creates .blackhole dir with proper owner' do
        dir = '/srv/www/openstack-dashboard/openstack_dashboard/.blackhole'
        expect(chef_run.directory(dir).owner).to eq('root')
      end

      it 'does not execute openstack-dashboard syncdb by default' do
        cmd = 'python manage.py syncdb --noinput'
        expect(chef_run).not_to run_execute(cmd).with(
        cwd: '/srv/www/openstack-dashboard',
        environment: {
          'PYTHONPATH' => '/etc/openstack-dashboard:' \
                          '/srv/www/openstack-dashboard:' \
                          '$PYTHONPATH'
          }
          )
      end
    end

    it 'has group write mode on file with attribute defaults' do
      file = chef_run.file('/srv/www/openstack-dashboard/openstack_dashboard/local/.secret_key_store')
      expect(file.owner).to eq('wwwrun')
      expect(file.group).to eq('www')
    end
  end
end
