execute 'add apt-key for stack' do
  user 'root'

  command <<-END
    wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/debian/fpco.key | apt-key add -
  END
end

remote_file '/etc/apt/sources.list.d/fpco.list' do
  user 'root'
  content 'deb http://download.fpcomplete.com/debian/jessie stable main'
end

execute 'apt update' do
  user 'root'
end

package 'stack'
