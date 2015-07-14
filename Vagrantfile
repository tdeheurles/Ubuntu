# -*- mode: ruby -*-
# vi: set ft=ruby :

#$imagename = "ubuntu/vivid64"
$imagename = "box/pug-vivid-minimal-x64-virtualbox.box"
$vm_memory = 6000
$vm_cpus   = 2
$username  = "tdeheurles"
$useremail = "tdeheurles@gmail.com"
$hostname  = "vmubuntu"
$privateip = "172.16.16.10"


# PREPARATION
# ===========
CONFIG = File.join(File.dirname(__FILE__), "config/vagrant_config.rb")
MOUNT_POINTS = YAML::load_file('config/synced_folders.yaml')

required_plugins = %w(vagrant-winnfsd)
required_plugins.each do |plugin|
  need_restart = false
  unless Vagrant.has_plugin? plugin
    system "vagrant plugin install #{plugin}"
    need_restart = true
  end
  exec "vagrant #{ARGV.join(' ')}" if need_restart
end


# CREATION
# ========
Vagrant.configure(2) do |config|
  # Preparing box
  config.ssh.insert_key     = false
  config.ssh.forward_agent  = true
  config.vm.box             = $imagename
  config.vm.network         :private_network, ip: $privateip
  #config.vm.hostname  = $hostname    # using provision as a bug workaround
  config.vm.provider :virtualbox do |vb|
    vb.gui                    = true
    vb.check_guest_additions  = false
    vb.functional_vboxsf      = false

    # http://www.virtualbox.org/manual/ch08.html
    vb.customize ["modifyvm", :id, "--memory", "#{$vm_memory}"]
    vb.customize ["modifyvm", :id, "--cpus", "#{$vm_cpus}"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    # vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--vram", "56"]
    # vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end


  # SHARE FOLDERS
  # ==============
  #system "echo Sharing folders"
  begin
    MOUNT_POINTS.each do |mount|
      mount_options = ""
      disabled = false
      nfs =  true
      if mount['mount_options']
        mount_options = mount['mount_options']
      end
      if mount['disabled']
        disabled = mount['disabled']
      end
      if mount['nfs']
        nfs = mount['nfs']
      end
      if File.exist?(File.expand_path("#{mount['source']}"))
        if mount['destination']
          config.vm.synced_folder "#{mount['source']}", "#{mount['destination']}",
            id: "#{mount['name']}",
            disabled: disabled,
            mount_options: ["#{mount_options}"],
            nfs: nfs
        end
      end
    end
  rescue
  end

  # PROVISION
  # =========
  installationScriptUrl="https://raw.githubusercontent.com/tdeheurles/docs/master/linux/InstallationScripts"

  config.vm.provision :shell,
                      inline: "hostnamectl set-hostname #{$hostname}"

  config.vm.provision :shell, path: "#{installationScriptUrl}/git.sh",
                      args: [$username, $useremail],
                      privileged: false,
                      keep_color: true

  config.vm.provision :shell, path: "#{installationScriptUrl}/oh-my-zsh.sh",
                      args: ["vagrant"],
                      privileged: false,
                      keep_color: true

  config.vm.provision :shell,
                      inline: "sudo reboot",
                      privileged: true

end
