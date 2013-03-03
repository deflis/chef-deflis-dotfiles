package "git"

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
