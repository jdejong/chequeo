# chequeo 
*Spanish for Check Ups!*

Chequeo provides a framework for running checkups on your application. The goal of checkups is to detect problems in your application and take actions to alert or repair  the issue.

This could be sending an alert to Slack, a text message, hitting a webhook URL or logging out the alert to a database.

## Inspiration

After struggeling internally to deal with building health checks into our system and hearing a wonderful talk at RailsConf 2018 by Ryan Laughlin ([Video](http://confreaks.tv/videos/railsconf2018-the-doctor-is-in-using-checkups-to-find-bugs-in-production)) I decided it would be a good idea to build a library to make checkups easier.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chequeo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chequeo
    
Generate a config file into your initializers directory.

    $ rails generate chequeo:install

### Processor
In order to run the checkups we need a processor. Currently we have a standalone daemon that manages the jobs.

#### Standalone


### Jobs
*Generator coming soon!*
#### Creating Jobs
In your models directory simply create a model file, say my_cool_new_checkup.rb and add the following into that file

```ruby
# frozen_string_literal: true
class MyCoolNewCheckup < Chequeo::HealthChecks::Base

  def process

  end

end
```
To implement your custom Job you will simply add code into the process method. In order to report back status there are several varaibale you can use to send back status to the worker. For example to send **errors** back to the worker simply add `@errors << "My error message I would like to include"`. And to pass **warnings** back to the worker you can add `@warnings << "Your warning message goes here"`. You can also add some text to the completion message by setting `@completion_text = "My Text"`. This allows you to send data to the notifications without having to do anything complex. On completion the worker will send any notifiations based on the notifications setup and the state of the job.

#### Scheduling Jobs
To schedule your job to run, you simply need to call `.schedule` in your initiailizer's configuration block. This is ment to mimic the job scheduling you are probably used to from Sidekiq or Resque. 

```ruby
Chequeo.configure do |config|
    config.schedule('*/1 * * * *', MyCoolNewCheckup)
end
```

You can also pass parameters by adding a 3rd parameter to your schedule method call. For example if you want to override the `on_completion` rule set by either the default, or your notification block you can specify this in the options hash of the job scheduling.

```ruby
Chequeo.configure do |config|
    config.schedule('*/1 * * * *', MyCoolNewCheckup, {rules: { on_completion: false } })
end
```

