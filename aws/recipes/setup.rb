[
  'task-japanese',
  'vim',
  'git',
  'tmux',
  'silversearcher-ag',
  'unison',
  'make',
].each do|package_name|
  package(package_name) { action :install }
end

# Setup dot-files

## ssh key installation

file '.ssh/known_hosts' do # required to sync dot-files repository
  content File.read('ssh/known_hosts')
end

file '.ssh/id_rsa' do # required to sync dot-files repository
  content File.read('ssh/id_rsa-git')
end

## end

git 'dot-files' do
  user 'admin' # Debian on EC2's default user
  repository node[:dot_files_repository]
end

execute 'configure dot-files' do
  user 'admin'
  not_if 'grep --silent -e "dot-files/bash.sh" .bashrc'
  command 'dot-files/install.sh sh'
end

execute 'install neobundle' do
  user 'admin'
  not_if 'test -d .vim/bundle/neobundle.vim'
  command 'cd && wget -O - "https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh" | sh -'
end

#end

file '/etc/sysctl.d/01-fs.inotify.max_user_watches.conf' do
  content "fs.inotify.max_user_watches=100000\n"
end
