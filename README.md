# Beez

Simple, efficient ruby workers for [Zeebe](https://zeebe.io/) workflows.

Beez uses threads to handle many jobs at the same time in the same process. It
does not require Rails but will integrate tightly with Rails to start working
with workflows.

## Disclaimer

Beez is currently **not production ready**. It hasn't been tested under a
production application yet. Beside, the gem is missing all its specs at the
moment.

I'm working on this project on my free time. If you want to help, be my guest! I
love the concepts behind Zeebe, this is why I bootstraped this library.

Please bare with me while it matures.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beez'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beez

## Usage

The following guide assumes you already have the Zeebe stack up and running and
a workflow deployed. If not, please head to [Zeebe official documentation](https://docs.zeebe.io/).

We will be taking the classic Order Process workflows as an example.

![Order Process](https://docs.zeebe.io/getting-started/img/tutorial-3.0-complete-workflow.png)

### Rails

1. Create the workers anywhere you want in your Rails application:

```ruby
class InitiatePaymentWorker
  include ::Beez::Worker

  type "initiate-payment"

  def process(job)
    # do something
  end
end

class ShipWithInsuranceWorker
  include ::Beez::Worker

  type "ship-with-insurance"

  def process(job)
    # do something
  end
end

class ShipWithoutInsuranceWorker
  include ::Beez::Worker

  type "ship-without-insurance"

  def process(job)
    # do something
  end
end
```

*You can find the available properties of the `job` variable [here](https://github.com/zeebe-io/zeebe-client-ruby/blob/master/lib/zeebe/client/proto/gateway_pb.rb#L20-L32).*

2. Start Beez from the root of your Rails application:

```sh
bundle exec beez
```

That's it.

### Plain Ruby

You can skip loading the Rails application entirely by specifying workers within
a ruby file when starting Beez:

```sh
bundle exec beez -r ./workers.rb
```

*Check out our examples in `examples/` folder.*

### Zeebe Client

You can interact with Zeebe and your workflows directly from Beez:

```ruby
client = Beez.client

# Deploys a new version of the Order Process workflow
client.deploy_workflow(name: "order-process", type: :BPMN, definition: File.read('./bnmn/order-process.bpmn'))

# Creates a new Order Process workflow instance
client.create_workflow_instance(bpmnProcessId: "order-process", version: 1, variables: { orderId: "1234", orderValue: 94 }.to_json)

# Publishes a business message
client.publish_message(name: "payment-received", correlationKey: "1234")
```

*Check out all the available commands in `lib/beez/client.rb`.*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gottfrois/beez.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Thanks

I would like to thank you the authors and contributors behind
[Sidekiq](https://github.com/mperham/sidekiq) on which I have taken lots of good
ideas to build this gem.
