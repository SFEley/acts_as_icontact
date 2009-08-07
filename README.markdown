ActsAsIcontact
==============
ActsAsIcontact connects Ruby applications with the [iContact e-mail marketing service][1] using the iContact API v2.0.  Building on the [RestClient][2] gem, it offers three significant feature sets:

* Simple, consistent access to all resources in the iContact API; 
* A simple command-line client; and
* Automatic synchronizing between ActiveRecord models and iContact contact lists for Rails applications.

Prerequisites
-------------
You'll need the following to use this gem properly:

1. **Ruby 1.9:** Yes, we know, many other gems still only work in 1.8. But ActsAsIcontact makes use of a few 1.9.1 features for efficiency, such as fiber-based Enumerators to step through large collections without instantiating a thousand objects at once.  It's _possible_ that this might work in 1.8.7 if you install the **JSON** gem and `require 'enumerator'` explicitly -- but the author hasn't tested it.  If you need it to work in 1.8, speak up.  Or better yet, make it work and submit a patch.

2. **Rails 2.1 or higher:** _(If using Rails integration)_ We use ActiveRecord's 'dirty fields' feature that first appeared in 2.1 to determine whether iContact needs updating.  If you're on a version of Rails older than this, it's probably worth your while to update anyway.

3. **Other gems:** This gem requires the [RestClient][2], [ActiveSupport][3] and [Bond][4] gems in order to work.  Simply doing a `gem install` _should_ install these dependencies as well.

Setting Up
----------
Using ActsAsIcontact is easy, but going through iContact's authorization process requires jumping a couple of hoops.  Here's how to get going quickly:

1. Install the gem.

       $ sudo gem install acts_as_icontact

2. _Optional but recommended:_ Go to <http://sandbox.icontact.com> and sign up for an iContact Sandbox account. This will let you test your app without risk of blowing away your production mailing lists.

3. Enable the ActsAsIcontact gem for use with your iContact account. The URL and credentials you'll use are different between the sandbox and production environments:  
  
     * **Sandbox:** Go to <http://app.sandbox.icontact.com/icp/core/externallogin> and enter `Ml5SnuFhnoOsuZeTOuZQnLUHTbzeUyhx` for the Application Id. Choose a password for ActsAsIcontact that's different from your account password.  
  
     * **PRODUCTION:** Go to <http://app.icontact.com/icp/core/externallogin> and enter `IYDOhgaZGUKNjih3hl1ItLln7zpAtWN2` for the Application Id. Choose a password for ActsAsIcontact that's different from your account password.
  
4. Set your _(sandbox, if applicable)_ account username and the password you just chose for API access. See the next section for how to specify these.

5. Rinse and repeat with production credentials when you're ready to move out of the sandbox environment.  For more information, consult the [iContact API developer documentation][5].

Authentication
--------------
ActsAsIcontact already knows iContact's URL and its own Application Id, so the only things you need to tell it are your username, password, and whether you want to access the production or sandbox environments.  There are three simple ways to do that:

1. Set the environment variables `ICONTACT_MODE`, `ICONTACT_USERNAME`, and `ICONTACT_PASSWORD`.  The `ICONTACT_MODE` environment variable should have a value of either ___production___ or ___sandbox___.

2. Create a directory called **.icontact** under your home directory and place a YAML file in it titled **config.yml**:
        ---
        mode: production
        username: my_username
        password: my_password
    This hidden directory is also used for the command line client's history file, and future versions of ActsAsIcontact may use it for caching.
    
3. You can explicitly set them anywhere in your code with calls to the Config module (note that the mode is a symbol, not a string):  

        require 'rubygems'
        require 'acts_as_icontact'
    
        ActsAsIcontact::Config.mode = :sandbox
        ActsAsIcontact::Config.username = "my_sandbox_username"
        ActsAsIcontact::Config.password = "my_api_password"  
  
    If you're using Rails, the recommended approach is to require the gem with `config.gem 'acts_as_icontact'` in your **config/environment.rb** file, and then set up an initializer (i.e. **config/initializers/acts\_as\_icontact.rb**) with the above code.  See more about Rails below.

Using the API
-------------
Whether or not you're using Rails, retrieving and modifying iContact resources is simple.  The gem autodiscovers your account and client folder IDs (you only have one of each unless you're an 'agency' account), so you can jump straight to the good parts:

     contacts = ActsAsIcontact::Contact.find(:all)  # => <#ActsAsIcontact::ResourceCollection>
     c = contacts.first    # => <#ActsAsIcontact.Contact>
     c.firstName           # => "Bob"
     c.lastName            # => "Smith"
     c.email               # => "bob@example.org"
     c.lastName = "Smith-Jones"   # Bob gets married and changes his name
     c.save                # => true
     history = c.actions   # => <#ActsAsIcontact::ResourceCollection>
     a = history.first     # => <#ActsAsIcontact::Action>
     a.actionType          # => "EditFields"
  
  
### Nesting
The interface is deliberately as "ActiveRecord-like" as possible, with methods linking resources that are either nested in iContact's URLs or logically related.  Messages have a Message#bounces method.  Lists have `List#subscribers` to list the Contacts subscribed to them, and Contacts have `Contact#lists`.  Read the [documentation][5] for each class to find out what you can do:

* ActsAsIcontact::Account
  * ActsAsIcontact::ClientFolder
* ActsAsIcontact::Contact
  * ActsAsIcontact::History _(documented as "Contact History")_
* ActsAsIcontact::Message
  * ActsAsIcontact::Bounce
  * ActsAsIcontact::Click
  * ActsAsIcontact::Open
  * ActsAsIcontact::Unsubscribe
  * ActsAsIcontact::Statistics
* ActsAsIcontact::List
  * ActsAsIcontact::Segment
      * ActsAsIcontact::Criterion  _(documented as "Segment Criteria")_
* ActsAsIcontact::Subscription
* ActsAsIcontact::Campaign
* ActsAsIcontact::CustomField
* ActsAsIcontact::Send
* ActsAsIcontact::Upload
* ActsAsIcontact::User
  * ActsAsIcontact::Permission
* ActsAsIcontact::Time

### Searching
Searches are handled using the same query options that iContact accepts, but with a syntax based on ActiveRecord.  At this time, special searches (i.e. _gte_, _bet_ etc.) are not yet supported.  Fields requiring dates must be given a string corresponding to the ISO8601 timestamp (e.g. `2006-09-16T14:30:00-06:00`); proper date/time conversion will happen soon.  See the [iContact developer docs][5] for available search options.

The following class methods are offered (using the Message class as an example):

#### Message.first

Returns a single Message.  With no parameters, it returns the first Message in iContact's system, which may be arbitrary.  You can specify one or more search parameters as an options hash (note the Ruby 1.9 syntax):
    Message.first(messageType: "welcome")  # => The first welcome message
    Message.first(orderby: "createDate:desc")  # => Most recent message
    
If no records can be found matching the parameters, the **first** method returns nil.
    
#### Message.all

Returns a collection of Messages matching the search parameters.  The _limit_ and _offset_ parameters are important here; if no _limit_ is provided, a default limit of 500 records is used.  (That default is also the maximum, at the request of iContact's technical staff.)

The collection is an object of type ResourceCollection, and it acts both as an array and an enumerator.  For efficiency, individual Message objects are instantiated only when you access them.  
    Message.all(messageType: "confirmation")  # => All confirmation messages (up to 500)
    Message.all(limit: 20)  # => The first 20 messages
    Message.all(limit: 20, offset: 40)  # => Messages 41-60
    Message.all(offset:500)  # => Messages 501-1000
    
    # Example of collection iteration
    @messages = Message.all  # => Assigns the first 500 messages to @messages
    @messages.count  # => Number of messages
    @messages[11]    # => Twelfth message in the collection (arrays are 0-based)
    @messages.first  # => First message
    @messages.next   # => Second message
    @messages.next   # => Third message (et cetera)
    
If no records can be found matching the parameters, the **all** method returns nil.

#### Message.find

Like its ActiveRecord role model, #find has several behaviors depending on its parameter list:

    Message.find(:first, messageType: "welcome")  # => Identical to Message.first(messageType: "welcome")
    Message.find(:all, limit: 20)  # => Identical to Message.all(limit: 20)
    Message.find(7)  # => Single Message found with messageId of 7
    Message.find("foo")  # => Single Message found with subject of "foo"

The _integer_ and _string_ parameter modes warrant some explanation.  Passing an integer to **find** on most resource classes will do a primary key lookup.  So Accounts will match on the accountId, Contacts will match on the contactId, etc.  The integer variant is unsupported for the CustomField and Subscription classes, which use string-based primary keys.

Passing a string to **find** on most resource classes will do a single-record search based on the field most likely to be unique and important:

* **Account:** userName
* **Campaign:** name
* **ClientFolder:** name
* **Contact:** email
* **CustomField:** customFieldId _(primary key)_
* **List:** name
* **Message:** subject
* **Segment:** name
* **Subscription:** subscriptionId _(primary key)_
* **User:** userName

If no records can be found using **find**, the _:first_ and _:all_ variants will return nil (just like **first** and **all**).  The _integer_ and _string_ variants will return an exception, on the assumption that you knew exactly what you were looking for and expected it to be there.  (I.e., matching the behavior of ActiveRecord.)


### Updating

Again, think ActiveRecord.  When you initialize an object, you can optionally pass it a hash of values:

    c = Contact.new(:firstName => "Bob", 
                    :lastName => "Smith-Jones", 
                    :email => "bob@example.org")
    c.address = "123 Test Street"

Each resource object has a **#save** method which returns true or false.  If false, the **#error** method contains the reply back from iContact about what went wrong.  (Which may or may not be informative, but we can't tell you more than they do.)  There's also a **#save!** method which throws an exception on failure instead of returning false.

Nested resources can be created using the **build\_foo** method (which returns an object but doesn't save it right away) or **create\_foo** method (which does save it upon creation).  The full panoply of ActiveRecord association methods are not implemented yet.  (Hey, we said it was AR-_like._)

The **#delete** method on each object works as you'd expect, assuming iContact allows deletes on that resource.  Resource collections containing the resource are not updated, however, so you may need to requery.

Multiple-record updates are not implemented at this time.

Rails Integration
-----------------
The _real_ power of ActsAsIcontact is its automatic syncing with ActiveRecord.  At this time this feature is focused entirely on Contacts.  

### Activation
First add the line `config.gem 'acts_as_icontact'` to your **config/environment.rb** file.  Then create an initializer (e.g. **config/initializers/acts\_as\_icontact.rb**) and set it up with your username and password.  If applicable, you can give it both the sandbox _and_ production credentials:

    module ActsAsIcontact
      case Config.mode
			when :sandbox
        Config.username = my_sandbox_username
        Config.password = my_sandbox_password
      when :production
        Config.username = my_production_username
        Config.password = my_production_password
      end
    end

If ActsAsIcontact detects that it's running in a Rails app, the default behavior is to set the mode to `:production` if RAILS\_ENV is equal to "production" and `:sandbox` if RAILS\_ENV is set to anything else.  (Incidentally, if you're _not_ in a Rails app but running Rack, the same logic applies for the RACK\_ENV environment variable.)

Finally, enable one of your models to synchronize with iContact with a simple declaration:

    class Person < ActiveRecord::Base
      acts_as_icontact
    end
  
There are some options, of course; we'll get to those in a bit.

### What Happens
When you call the `acts_as_icontact` method in an ActiveRecord class declaration, the gem does several useful things:

1. Creates callbacks to post changes to iContact's API after a record is saved or deleted.
2. Defines an `icontact_sync!` method to pull the contact's data _from_ iContact and make any changes.
3. Defines other methods such as `icontact_lists` and `icontact_history` to make related data accessible.
4. If an `icontact_status` field exists, creates named scopes on the model class for each iContact status.  _(Pending)_

### Options
Option values and field mappings can be passed to the `acts_as_icontact` declaration to set default behavior for the model class.

`list` -- _The name or ID number of a list to subscribe new contacts to automatically_  
`lists` -- _Like `list` but takes an array of names or numbers; new contacts will be subscribed to all of them_  
`exception_on_failure` -- _If true, throws an ActsAsIcontact::SyncError when synchronization fails.  Defaults to false._  

A note about failure: problems with synchronization are always logged to the standard Rails log.  For most applications, however, updating iContact is a secondary consideration; if a new user is registering, you _probably_ don't want exceptions bubbling up and the whole transaction rolling back just because of a transient iContact server outage.  So exceptions are something you have to deliberately enable.

### Field Mappings
You can add contact integration to any ActiveRecord model that tracks an email address.  (If your model _doesn't_ include email but you want to use iContact with it, you are very, very confused.)

Any fields that are named the same as iContact's personal information fields, or custom fields you've previously declared, will be autodiscovered.  Otherwise you can map them:

    class Customer < ActiveRecord::Base
      acts_as_icontact :lists => ['New Customers', 'All Users']  # Puts new contact on two lists
                       :firstName => :given_name, # Key is iContact field, value is Rails field
                       :lastName => :family_name,
                       :street => :address1,
                       :street2 => :address2,
                       :rails_id => :id  # Custom field created in iContact
                       :preferred_customer => :preferred? # Custom field
    end

A few iContact-specific fields are exceptions, and have different autodiscovery names to avoid collisions with other attributes in your application:

`icontact_id` -- _Corresponds to `contactId` in iContact.  Highly recommended._  
`icontact_status` -- _Corresponds to `status` in iContact._  
`icontact_created` -- _Corresponds to `createDate` in iContact._
`icontact_bounces` -- _Corresponds to `bounceCount` in iContact._

You are welcome to create these fields in your model or omit them.  However, we _strongly_ recommend that you either include the `icontact_id` field to track iContact's primary key in your application, or map your own model's primary key to a custom field in iContact.  You can also do both for two-way associations.  If you don't establish a relationship with at least one ID, ActsAsIcontact will resort to using the email address for lookups -- which will be a problem if the email address changes.

### Lists
The reason to add contacts to iContact is to put them on mailing lists.  We know this.  The `default_list` option (see above) is one way to do it automatically.  The following methods are also defined on the model for your convenience:

`icontact_lists` -- _An array of List objects to which the contact is currently subscribed_
`icontact_subscribe(list)` -- _Given a list name or ID number, subscribes the contact to that list immediately_
`icontact_unsubscribe(list)` -- _Given a list name or ID number, unsubscribes the contact from that list_


### Why Just Contacts?
iContact's interface is really quite good at handling pretty much every other resource.  Campaigns, segments, etc. can usually stand alone.  It's less likely that you'll need to keep copies of them in your Rails app.  But contacts are highly entangled.  If you're using iContact to communicate with your app's users or subjects, you'll want to keep iContact up-to-date when they change.  And if someone bounces or unsubscribes in iContact, odds are good you'll want to know about it.  So this is the strongest point of coupling and the highest priority feature.  (Lists will likely come next, followed by messages.)

Copyright
---------
Copyright (c) 2009 Stephen Eley. See LICENSE for details.

[1]: http://icontact.com "iContact"
[2]: http://rest-client.heroku.com "Rest-Client"
[3]: http://as.rubyonrails.org/ "ActiveSupport"
[4]: http://tagaholic.me/bond "Bond"
[5]: http://developer.icontact.com/ "iContact Developer Portal"
