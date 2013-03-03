#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git"

git node[:dotfiles][:home] + "/dotfiles" do
  repository "https://github.com/deflis/dotfiles.git"
  reference "master"
  enable_submodules true

  user node[:dotfiles][:user]
  group node[:dotfiles][:group]
  action :sync
end

package "zsh"
package "vim"
package "subversion"

case node[:platform]
  when "ubuntu", "debian"
  package "openssh-server"
  package "byobu"
  package "build-essential"
  package "curl"
end

[".zshrc", ".vimrc", ".vim", ".zsh", ".gvimrc"].each do |fn|
  link node[:dotfiles][:home] + "/" + fn do
    to node[:dotfiles][:home] + "/dotfiles/" + fn
  end
end

bash "NeoBundleInstall" do
  user node[:dotfiles][:user]
  cwd node[:dotfiles][:home]
  code "test -f .vimrc && vim -e -s -u ~/.vimrc -c 'NeoBundleInstall' -c 'qall!' | exit 0"
end

bash "NeoBundleUpdate" do
  user node[:dotfiles][:user]
  cwd node[:dotfiles][:home]
  code "test -f .vimrc && vim -e -s -u ~/.vimrc -c 'NeoBundleUpdate' -c 'qall!' | exit 0"
end

bash "chsh" do
  cwd node[:dotfiles][:home]
  code "which zsh && chsh -s $(which zsh) " + node[:dotfiles][:user]
end
