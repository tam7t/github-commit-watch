# github-commit-watch
Bad people watch github for leaked credentials and developers sometimes make mistakes. SSH keys, private certificates, API secrets. `github-commit-watch` helps your organization monitor developers' public commits for these mistakes.

`github-commit-watch` provides continuous monitoring with email alerts, is easy to configure, and has no database requirements.

## Install
* Clone the repo `git clone git@github.com:tam7t/github-commit-watch.git`
* Install dependencies `bundle install`
* Obtain a [github authentication token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
* Optionally, setup a [mailgun](http://www.mailgun.com/) account

## Run
The `check-org.rb` script is useful for occasional usage.

```bash
$ bundle exec ruby check-org.rb --help
Usage: check-org.rb [options]
    -l, --login NAME                 github username
    -t, --token TOKEN                github auth token
    -n, --number NUM                 number of events to load per user
    -o, --organization NAME          organization to monitor
    -f, --from ID                    only look at events since this id
```

The `watch-org.rb` script is a long running process that will check for new commits
every 10 minutes and is configured using these environment variables:

```
GITHUB_LOGIN - github username
GITHUB_PASSWORD - github auth token
GITHUB_ORGANIZATION - orgnization to monitor
EVENTS - number of events to load per user
MAILGUN_TOKEN - mailgun authentication token
FROM - address to send alerts from
DOMAIN - domain to send email from
TO - email address to receive alerts
SUBJECT - email subject line to use on alerts
```

A `Dockerfile` and `Procfile` are provided to make it easy to deploy to IaaS systems.

Custom signatures can be added by modifying the `check-org.rb` or `watch-org.rb` files.

## Todo
* Verify assumption that event ids increasing
* Support gists
* Support organization > 100 members

## Similar projects
* https://github.com/michenriksen/gitrob
* https://github.com/jfalken/github_commit_crawler
* https://github.com/veorq/blueflower
