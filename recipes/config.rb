node[:dotfiles][:users].each do |username|
  user_info = Etc.getpwnam(username)
  home_dir = user_info.dir
  group_name = Etc.getgrgid(user_info.gid).name
  
  git home_dir + "/dotfiles" do
    repository "https://github.com/deflis/dotfiles.git"
    reference "master"
    enable_submodules true
  
    user username
    group group_name
    action :sync
  end
  
  [".zshrc", ".vimrc", ".vim", ".zsh", ".gvimrc"].each do |fn|
    link home_dir + "/" + fn do
      to home_dir + "/dotfiles/" + fn
      user username
      group group_name
    end
  end
  
  bash "NeoBundleInstall" do
    user username
    cwd home_dir
    code "test -f .vimrc && vim -e -s -u ~/.vimrc -c 'NeoBundleInstall' -c 'qall!' | exit 0"
  end
  
  bash "NeoBundleUpdate" do
    user username
    cwd home_dir
    code "test -f .vimrc && vim -e -s -u ~/.vimrc -c 'NeoBundleUpdate' -c 'qall!' | exit 0"
  end
  
  if !user_info.shell.include?("zsh") then 
    bash "chsh" do
      cwd home_dir
      code "which zsh && chsh -s $(which zsh) " + username
    end
  end
end
