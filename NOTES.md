## Rails Commands
* RAILS_ENV=production rails c
* rails credentials:edit --environment production

## Rails Assets
* Issue with loading CSS files: had to do rails assets:clobber ; rails assets:precompile

## Rails Migrations
* rails db:migrate VERSION=0 cascade=true
  * rails db:migrate:primary

## Git
* git diff --stat $(git hash-object -t tree /dev/null)
* git tag <tagname>