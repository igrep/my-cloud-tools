execute 'upgrade packages' do
  user 'root'
  command <<-END
  apt-get -y update && \
  apt-get -y upgrade
  END
end

execute 'upgrade stack' do
  user 'root'
  # NOTE: From notice in a mail of Haskell Cafe:
  # [normally just 'stack upgrade' will suffice, but due to my flub in the last release we ended up with a stack-9.9.9 on hackage which can't be removed (see https://github.com/haskell/hackage-server/issues/382), and you have to get the stack version that knows to ignore it first]
  # so I'll remove the first command after upgrading
  command 'stack upgrade --git && stack upgrade'
end
