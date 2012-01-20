#
# Cookbook Name:: repo
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

module RightScale
  module Repo
    class Ssh_key
     KEYFILE = "/tmp/gitkey"

       # Add ssh key and exec script
     def create(ssh_key)
       Chef::Log.warn("Creating ssh key")

       keyfile = nil
       keyname = ssh_key
       if "#{keyname}" != ""
         keyfile = KEYFILE
         system("echo -n '#{keyname}' > #{keyfile}")
         system("chmod 700 #{keyfile}")
         system("echo 'exec ssh -oStrictHostKeyChecking=no -i #{keyfile} \"$@\"' > #{keyfile}.sh")
         system("chmod +x #{keyfile}.sh")
       end

        ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      end

     # Delete SSH key & clear GIT_SSH
      def delete
        Chef::Log.warn "Deleting ssh key "
         keyfile = KEYFILE
        if keyfile != nil
          system("rm -f #{keyfile}")
          system("rm -f #{keyfile}.sh")
        end
      end

=begin
      def capistrano_pull(destination,repository,revision)
        destination = "/tmp/repo"

        Chef::Log.warn("Creating dir")

        Chef::Resource::Directory.new "/tmp/repo123123/shared/" do
          recursive true
          action :create
        end

        Chef::Resource::Deploy.new destination do
          repo "#{repository.chomp}"
          revision revision
          #user node[:tomcat][:app_user]
          enable_submodules true
          migrate false
          create_dirs_before_symlink %w{}
          symlink_before_migrate({})
          symlinks({})
          shallow_clone true
          action :deploy
          #restart_command "touch tmp/restart.txt" #"/etc/init.d/tomcat6 restart"
        end

      end
=end
    end
  end
end