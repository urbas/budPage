## Initial setup

* Make sure your ruby has SSL certificates: http://stackoverflow.com/a/27298259/974531
* Then run the following commands:

```bash
gem install bundler rake
bundle install
rake db:create db:migrate db:seed
npm install bower -g
rake bower:install
```

Import the main directory within IntelliJ Ultimate as a Ruby project.

## Development

### Cleaning the development database

```bash
rake db:drop db:create db:migrate
```

### Re-populating the development database with sample data

```bash
rake db:truncate db:seed
```

### Testing

```bash
RAILS_ENV=test rake db:drop db:create db:migrate
rake test
# or to run just tests in a single file
rake test test/models/user_test.rb
```

## Production

```bash
RAILS_ENV=production rake db:drop db:create db:migrate
```

## Installing rbenv

Follow: https://github.com/sstephenson/rbenv#installation

Install the ruby-build plugin.

Now install bundler:

    gem install bundler

Install ze nice things:

    sudo apt-get install libpq-dev

Now install ze gems:

    bundle install