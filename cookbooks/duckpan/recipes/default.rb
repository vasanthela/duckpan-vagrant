#
# Cookbook Name:: duckpan
# Recipe:: default
#

include_recipe 'perl'
include_recipe 'git'

execute "sudo apt-get -y install perl-doc"  # required by duckpan

# download the duckpan install script
execute "su -l vagrant -c 'wget -L http://duckpan.com/install.pl -O duckpan-install.pl'"

# run the duckpan install script for the first time
#   modifies .bashrc to set PERL environment variables
#   installs local::lib and App::cpanminus
execute "duckpan_install_first" do
	# need to run command as user vagrant
  command	"su -l vagrant -c 'perl duckpan-install.pl'"

	# first run of duckpan-install.pl returns 1
	# with error asking to re-login and rerun the script
  returns 1
end

# run the duckpan script a second time
#   installs App::DuckPAN
execute "duckpan_install_again" do
	# need to run command as user vagrant
  # only by invoking command through bash does .bashrc gets sourced properly
  # .bashrc sets important PERL environment variables for duckpan
  command	"su -l vagrant -c 'bash -l -i -c \"perl duckpan-install.pl\"'"
end
