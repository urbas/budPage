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

## Cleaning the development database

```bash
rake db:drop db:create db:migrate
```

## Re-populating the development database with sample data

```bash
rake db:truncate db:seed
```

## Working in production mode

When executing `rake`, do the following:

```bash
RAILS_ENV=production rake <your command>
```

For example, to create a production database, run

```bash
RAILS_ENV=production rake db:create db:migrate
```