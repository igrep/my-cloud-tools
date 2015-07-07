[
  'task-japanese',
  'vim',
  'git',
  'tmux',
  'silversearcher-ag',
  'make',
  # GHC Dependencies
  #'libgmp-dev',
  #'gcc',
  # end
  'python2.7', # Dependency of dropbox-cli
].each do|package_name|
  package(package_name) { action :install }
end

directory '/opt/tmp/' do
  action :create
  user 'root'
end

# Setup Haskell
execute 'install stack' do
  not_if 'stack --version'

  command <<-END
  wget -qO - https://github.com/commercialhaskell/stack/releases/download/v#{node[:stack_version]}/stack-#{node[:stack_version]}-x86_64-linux.gz \
    | gunzip --stdout > /usr/local/bin/stack && \
  chmod 0755 /usr/local/bin/stack
  END
end

#end

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

execute 'install dropbox daemon' do
  not_if 'test -d .dropbox-dist/'
  user 'admin'
  command 'cd && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - '
end

directory('bin/'){ user 'admin' }

execute 'install dropbox-cli' do
  user 'admin'
  not_if 'test -x bin/dropbox.py'
  command '
    cd bin && \
    wget https://www.dropbox.com/download?dl=packages/dropbox.py -O dropbox.py && \
    chmod 0755 dropbox.py
  '
end

# This is just a memo
execute 'configure dropbox by dropbox-cli' do
  user 'admin'
  command 'dropbox.py help'
end
