# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "dashboard"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.provider :vmware_fusion do |v, override|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = 2
    v.vmx["cpuid.coresPerSocket"] = 1
    override.vm.box = "precise64_vmware"
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
  end

  config.vm.network :private_network, ip: "192.168.50.93"

  if config.respond_to?(:qa)
    config.qa.app_directory = "/rl/product/capture/apps/capture_dashboard/current"
    config.qa.run_as = "appuser"
  end

  config.vm.provision "puppet" do |puppet|
    # puppet.options = "--verbose --debug"
    puppet.facter = {
      "service"      => "capture_dashboard",
      "vagrant_user" => "vagrant",
      "vagrant_home" => "/home/vagrant"
    }
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "capture_dashboard.pp"
  end
end
