This is my recipe to make my development environment on an EC2 machine.

# Requirements

- Ruby
- Bundler
- Vagrant
- [vagrant-aws](https://github.com/mitchellh/vagrant-aws)
    - See the README for the details. Installing vagrant-aws is more complex than you think.

# Setup

```bash
$ vagrant up --provider=aws

$ bundle
$ bundle exec itamae ssh --vagrant recipes/setup.rb -y <your_node_yaml_path>
```

# Sync with Unison

TODO
