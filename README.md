# chequeo

Chequeo provides a framework for running checkups on your application. The goal of checkups is to detect problems in your application and take actions to alert or repair  the issue.

This could be sending an alert to Slack, a text message, hitting a webhook URL or logging out the alert to a database.

## Inspiration

After struggeling internally to deal with building health checks into our system and hearing a wonderful talk at RailsConf 2018 by Ryan Laughlin ([Video](http://confreaks.tv/videos/railsconf2018-the-doctor-is-in-using-checkups-to-find-bugs-in-production)) I decided it would be a good idea to build a library to make checkups easier.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'galactic-senate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install galactic-senate
    
Generate a config file into your initializers directory.

    $ rails generate chequeo:install

### Processor
In order to run the checkups we need a processor. Currently we have a standalone daemon that manages the jobs.

#### Standalone

 

