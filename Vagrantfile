require 'yaml'

#If your Vagrant version is lower than 1.5, you can still use this provisioning
#by commenting or removing the line below and providing the config.vm.box_url parameter,
#if it's not already defined in this Vagrantfile. Keep in mind that you won't be able
#to use the Vagrant Cloud and other newer Vagrant features.
Vagrant.require_version ">= 1.5"

# Check to determine whether we're on a windows or linux/os-x host,
# later on we use this to launch ansible in the supported way
# source: https://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable? exe
        }
    end
    return nil
end

Vagrant.configure("2") do |config|

    settings = YAML.load_file 'server/dev/ansible/vars/all.yml'

    config.vm.provider :virtualbox do |v|
        v.name = settings['server']['name']
        v.customize [
            "modifyvm", :id,
            "--memory", 1024,
            "--natdnshostresolver1", "on",
            "--cpus", 1,
        ]
    end

    config.vm.box = "debian/contrib-jessie64"
    
    config.vm.network :private_network, ip: "192.168.168.163"
    config.vm.network "forwarded_port", guest: 80, host: 8084
    config.vm.network "forwarded_port", guest: 3306, host: 33068 
    config.vm.network "forwarded_port", guest: 6001, host: 6003
    config.ssh.forward_agent = true

    config.vm.boot_timeout = 1200
    config.vm.provision :shell, path: "server/dev/ansible/ansible.sh", args: ["default"]
    #config.vm.synced_folder "./", "/vagrant", mount_options: ["dmode=777", "fmode=777"]
    #config.vm.synced_folder "./", settings['nginx']['source_folder']


module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

if OS.mac?
    config.vm.synced_folder "./", "/var/www", mount_options: ["dmode=777", "fmode=777"]
end

end
