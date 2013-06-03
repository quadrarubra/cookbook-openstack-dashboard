require_relative "spec_helper"

describe "openstack-dashboard::server" do
  before do
    ::Chef::Recipe.any_instance.stub(:memcached_servers).
      and_return ["hostA:port", "hostB:port"]
    ::Chef::Recipe.any_instance.stub(:db_password).with("horizon").
      and_return "test-pass"
  end

  # Fedora doesn't seem to be supported by fauxhai.

  #describe "fedora" do
  #  before do
  #    @chef_run = ::ChefSpec::ChefRunner.new ::FEDORA_OPTS
  #    @chef_run.converge "openstack-dashboard::server"
  #  end

  #  it "executes restore-selinux-context" do
  #    pending "TODO: how to properly test this"
  #  end

  #  it "removes default virtualhost" do
  #    pending "TODO"
  #  end
  #end
end
