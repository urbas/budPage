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

## Working in production mode

When executing `rake`, do the following:

```bash
RAILS_ENV=production rake <your command>
```