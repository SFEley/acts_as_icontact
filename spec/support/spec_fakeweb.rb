require 'rubygems'
require 'fakeweb'

FakeWeb.allow_net_connect = false
i = "https://app.sandbox.icontact.com/icp"
ic = "#{i}/a/111111/c/222222"

# Resources (this one's a fake stub for pure testing)
FakeWeb.register_uri(:get, "#{ic}/resources?limit=500", :body => %q<{"resources":[{"foo":"bar","resourceId":"1","too":"bar"},{"foo":"aar","resourceId":"2"},{"foo":"far","resourceId":"3"},{"foo":"car","resourceId":"4"},{"foo":"dar","resourceId":"5"},{"foo":"ear","resourceId":"6"},{"foo":"gar","resourceId":"7"},{"foo":"har","resourceId":"8"},{"foo":"iar","resourceId":"9"},{"foo":"jar","resourceId":"10"},{"foo":"kar","resourceId":"11"},{"foo":"yar","resourceId":"12"}],"total":12,"limit":20,"offset":0}>)
FakeWeb.register_uri(:get, "#{ic}/resources?limit=1", :body => %q<{"resources":[{"foo":"bar","resourceId":"1","too":"bar"}],"total":12,"limit":1,"offset":0}>)
FakeWeb.register_uri(:get, "#{ic}/resources?limit=5", :body => %q<{"resources":[{"foo":"bar","resourceId":"1"},{"foo":"aar","resourceId":"2"},{"foo":"far","resourceId":"3"},{"foo":"car","resourceId":"4"},{"foo":"dar","resourceId":"5"}],"total":12,"limit":5,"offset":0}>)
FakeWeb.register_uri(:get, "#{ic}/resources?limit=500&offset=5", :body => %q<{"resources":[{"foo":"ear","resourceId":"6"},{"foo":"gar","resourceId":"7"},{"foo":"har","resourceId":"8"},{"foo":"iar","resourceId":"9"},{"foo":"jar","resourceId":"10"},{"foo":"kar","resourceId":"11"},{"foo":"yar","resourceId":"12"}],"total":12,"limit":20,"offset":5}>)
FakeWeb.register_uri(:get, "#{ic}/resources?offset=5&limit=5", :body => %q<{"resources":[{"foo":"ear","resourceId":"6"},{"foo":"gar","resourceId":"7"},{"foo":"har","resourceId":"8"},{"foo":"iar","resourceId":"9"},{"foo":"jar","resourceId":"10"}],"total":12,"limit":5,"offset":5}>)
FakeWeb.register_uri(:get, "#{ic}/resources?offset=10&limit=5", :body => %q<{"resources":[{"foo":"kar","resourceId":"11"},{"foo":"yar","resourceId":"12"}],"total":12,"limit":5,"offset":10}>)
FakeWeb.register_uri(:get, "#{ic}/resources/1", :body => %q<{"resource":{"foo":"bar","resourceId":"1","too":"sar"}}>)
FakeWeb.register_uri(:post, "#{ic}/resources/1", :body => %q<{"resource":{"foo":"bar","resourceId":"1","too":"sar"}}>)
FakeWeb.register_uri(:post, "#{ic}/resources/2", :body => %q<{"resource":{},"warnings":["You did not provide a foo. foo is a required field. Please provide a foo","This was not a good record"]}>)
FakeWeb.register_uri(:post, "#{ic}/resources/3", :status => ["400","Bad Request"], :body => %q<{"errors":["You did not provide a clue. Clue is a required field. Please provide a clue"]}>)

# Time
FakeWeb.register_uri(:get, "#{i}/time", :body => %q<{"time":"2009-07-13T01:28:18-04:00","timestamp":1247462898}>)

# Accounts
FakeWeb.register_uri(:get, "#{i}/a?limit=1", :body => %q<{"accounts":[{"billingStreet":"","billingCity":"","billingState":"","billingPostalCode":"","billingCountry":"","city":"Testville","accountId":"111111","companyName":"","country":"United States","email":"bob@example.org","enabled":1,"fax":"","firstName":"Bob","lastName":"Tester","multiClientFolder":"0","multiUser":"0","phone":"","postalCode":"12345","state":"TN","street":"123 Test Street","title":"","accountType":"0","subscriberLimit":"250000"}],"total":1,"limit":20,"offset":0}>)
FakeWeb.register_uri(:get, "#{i}/a?limit=500", :body => %q<{"accounts":[{"billingStreet":"","billingCity":"","billingState":"","billingPostalCode":"","billingCountry":"","city":"Testville","accountId":"111111","companyName":"","country":"United States","email":"bob@example.org","enabled":1,"fax":"","firstName":"Bob","lastName":"Tester","multiClientFolder":"0","multiUser":"0","phone":"","postalCode":"12345","state":"TN","street":"123 Test Street","title":"","accountType":"0","subscriberLimit":"250000"}],"total":1,"limit":20,"offset":0}>)

# Clients
FakeWeb.register_uri(:get, "#{i}/a/111111/c?limit=1", :body => %q<{"clientfolders":[{"clientFolderId":"222222","logoId":null,"emailRecipient":"bob@example.org"}],"total":1}>)
FakeWeb.register_uri(:get, "#{i}/a/111111/c?limit=500", :body => %q<{"clientfolders":[{"clientFolderId":"222222","logoId":null,"emailRecipient":"bob@example.org"}],"total":1}>)

# Contacts
FakeWeb.register_uri(:get, "#{ic}/contacts?limit=1&status=total&firstName=John&lastName=Test", :body => %q<{"contacts":[{"email":"john@example.org","firstName":"John","lastName":"Test","status":"normal","contactId":"333333","createDate":"2009-07-24 01:00:00"}]}>)
FakeWeb.register_uri(:post, "#{ic}/contacts", :body => %q<{"contacts":[{"email":"john@example.org","firstName":"John","lastName":"Smith","status":"normal","contactId":"333444","createDate":"2009-07-24 01:00:00","street":"","street2":"","prefix":"","suffix":"","fax":"","phone":"","city":"","state":"","postalCode":"","bounceCount":0,"custom_field":"","test_field":"","business":""},{"email":"john@example.org","firstName":"John","lastName":"Test","status":"normal","contactId":"333333","createDate":"2009-07-24 01:00:00"}]}>)
FakeWeb.register_uri(:get, "#{ic}/contacts/333444", :body => %q<{"contact":{"email":"john@example.org","firstName":"John","lastName":"Smith","status":"normal","contactId":"333444","createDate":"2009-07-24 01:00:00","street":"","street2":"","prefix":"","suffix":"","fax":"","phone":"","city":"","state":"","postalCode":"","bounceCount":0,"custom_field":"","test_field":"","business":""}}>)
FakeWeb.register_uri(:get, "#{ic}/contacts/333333", :body => %q<{"contact":{"email":"john@example.org","firstName":"John","lastName":"Test","status":"normal","contactId":"333333","createDate":"2009-07-24 01:00:00"}}>)

# Contact History
FakeWeb.register_uri(:get, "#{ic}/contacts/333333/actions?limit=500", :body => %q<{"actions":[{"actionType":"EditFields","actionTime":"2009-08-01T16:02:44-0400","actor":"407118","details":{"email":"susan_smith@example.org"}},{"actionType":"EditFields","actionTime":"2009-08-01T16:02:13-0400","actor":"407118","details":{"firstName":"Susan","lastName":"Smith","custom_test":"hello 4"}},{"actionType":"EditSubscription","actionTime":"2009-08-01T16:00:31-0400","actor":"407118","details":{"listId":"174137","newStatus":"normal"}},{"actionType":"AddContact","actionTime":"2009-08-01T16:00:30-0400","actor":"407118","details":[]}],"limit":50,"offset":0,"total":4}>)
FakeWeb.register_uri(:get, "#{ic}/contacts/333333/actions?limit=1", :body => %q<{"actions":[{"actionType":"EditFields","actionTime":"2009-08-01T16:02:44-0400","actor":"407118","details":{"email":"susan_smith@example.org"}},{"actionType":"EditFields","actionTime":"2009-08-01T16:02:13-0400","actor":"407118","details":{"firstName":"Susan","lastName":"Smith","custom_test":"hello 4"}},{"actionType":"EditSubscription","actionTime":"2009-08-01T16:00:31-0400","actor":"407118","details":{"listId":"174137","newStatus":"normal"}},{"actionType":"AddContact","actionTime":"2009-08-01T16:00:30-0400","actor":"407118","details":[]}],"limit":50,"offset":0,"total":4}>)

#  Lists
FakeWeb.register_uri(:get, "#{ic}/lists?limit=1&name=First%20Test", :body => %q<{"lists":[{"listId":"444444","name":"First Test","emailOwnerOnChange":"0","welcomeOnManualAdd":"0","welcomeOnSignupAdd":"0","welcomeMessageId":"555555","description":"Just a test list."}]}>)
FakeWeb.register_uri(:get, "#{ic}/lists/444444", :body => %q<{"list":{"listId":"444444","name":"First Test","emailOwnerOnChange":"0","welcomeOnManualAdd":"0","welcomeOnSignupAdd":"0","welcomeMessageId":"555555","description":"Just a test list."}}>)

# Message
#### Test welcome message for List association
FakeWeb.register_uri(:get, "#{ic}/messages/555555", :body => %q<{"message":{"messageId":"555555","subject":"Welcome!","messageType":"welcome","textBody":"Welcome to the Test List!","htmlBody":"<p>Welcome to the <b>Test List</b>!</p>","createDate":"20090725 14:55:12","campaignId":"777777"}}>)
#### Test confirmation message
FakeWeb.register_uri(:get, "#{ic}/messages/555666", :body => %q<{"message":{"messageId":"555666","subject":"Confirm!","messageType":"confirmation","textBody":"Please confirm your subscription.","htmlBody":"<p>Please confirm your subscription.</p>","createDate":"20090727 14:55:12","campaignId":"777777"}}>)
#### Searches from campaignId
FakeWeb.register_uri(:get, "#{ic}/messages?limit=500&campaignId=777777", :body => %q<{"messages":[{"messageId":"555555","subject":"Welcome!","messageType":"welcome","textBody":"Welcome to the Test List!","htmlBody":"<p>Welcome to the <b>Test List</b>!</p>","createDate":"20090725 14:55:12","campaignId":"777777"},{"messageId":"555666","subject":"Confirm!","messageType":"confirmation","textBody":"Please confirm your subscription.","htmlBody":"<p>Please confirm your subscription.</p>","createDate":"20090727 14:55:12","campaignId":"777777"}],"count":2}>)
FakeWeb.register_uri(:get, "#{ic}/messages?limit=500&campaignId=777777&messageType=welcome", :body => %q<{"messages":[{"messageId":"555555","subject":"Welcome!","messageType":"welcome","textBody":"Welcome to the Test List!","htmlBody":"<p>Welcome to the <b>Test List</b>!</p>","createDate":"20090725 14:55:12","campaignId":"777777"}],"count":1}>)
#### Test message for associations originating from Message spec
FakeWeb.register_uri(:get, "#{ic}/messages?limit=1&subject=Test%20Message", :body => %q<{"messages":[{"messageId":"666666","subject":"Test Message","messageType":"normal","textBody":"Hi there!\nThis is just a test.","htmlBody":"<p><b>Hi there!</b></p><p>This is just a <i>test.</i></p>","createDate":"20090725 14:53:33","campaignId":"777777"}]}>)

# Message Bounces
FakeWeb.register_uri(:get, "#{ic}/messages/666666/bounces?limit=500", :body => %q<{"bounces":[{"contactId":"333333","bounceTime":"2008-04-15T12:05:00-04:00"},{"contactId":"333333","bounceTime":"2008-04-16T12:05:00-04:00"}],"total":2,"limit":500,"offset":0}>)

# Message Clicks
FakeWeb.register_uri(:get, "#{ic}/messages/666666/clicks?limit=500", :body => %q<{"clicks":[{"contactId":"333333","clickTime":"2008-04-17T12:07:00-04:00","clickLink":"http://www.yahoo.com"},{"contactId":"333333","clickTime":"2008-04-17T12:07:30-04:00","clickLink":"http://google.com"}],"total":2,"limit":500,"offset":0}>)

# Message Opens
FakeWeb.register_uri(:get, "#{ic}/messages/666666/opens?limit=500", :body => %q<{"opens":[{"contactId":"333333","openTime":"2008-04-17T12:06:00-04:00"},{"contactId":"333444","bounceTime":"2008-04-17T12:06:15-04:00"}],"total":2,"limit":500,"offset":0}>)

# Message Statistics
FakeWeb.register_uri(:get, "#{ic}/messages/666666/statistics", :body => %q<{"statistics":{"bounces":2,"delivered":3,"unsubscribes":0,"opens":{"unique":2,"total":2},"clicks":{"unique":2,"total":2},"forwards":0,"comments":0,"complaints":0}}>)


# CustomField
FakeWeb.register_uri(:get, "#{ic}/customfields?limit=500", :body => %q<{"customfields":[{"privateName":"test_field","publicName":"Test Field","displayToUser":"0","fieldType":"text"},{"privateName":"custom_field","publicName":"This is for the Rails integration specs","displayToUser":1,"fieldType":"text"}],"total":2}>)
FakeWeb.register_uri(:get, "#{ic}/customfields/test_field", :body => %q<{"customfield":{"privateName":"test_field","publicName":"Test Field","displayToUser":"0","fieldType":"text"}}>)

# Subscription
FakeWeb.register_uri(:get, "#{ic}/subscriptions/444444_333333", :body => %q<{"subscription":{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333333,"listId":444444, "subscriptionId":"444444_333333"}}>)
FakeWeb.register_uri(:get, "#{ic}/subscriptions/444444_333444", :body => %q<{"subscription":{"status":"normal","addDate":"2009-07-27T15:37:38-04:00","contactId":333444,"listId":444444, "subscriptionId":"444444_333444"}}>)
FakeWeb.register_uri(:get, "#{ic}/subscriptions?limit=500", :body => %q<{"subscriptions":[{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333333,"listId":444444, "subscriptionId":"444444_333333"},{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333333,"listId":444444, "subscriptionId":"444444_333333"}],"total":2}>)
FakeWeb.register_uri(:get, "#{ic}/subscriptions?limit=500&listId=444444", :body => %q<{"subscriptions":[{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333444,"listId":444444, "subscriptionId":"444444_333444","confirmationMessageId":555666},{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333333,"listId":444444, "subscriptionId":"444444_333333"}],"total":1}>)
FakeWeb.register_uri(:get, "#{ic}/subscriptions?limit=1&contactId=333444", :body => %q<{"subscriptions":[{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333444,"listId":444444, "subscriptionId":"444444_333333","confirmationMessageId":555666}]}>)
FakeWeb.register_uri(:get, "#{ic}/subscriptions?limit=500&contactId=333444", :body => %q<{"subscriptions":[{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333444,"listId":444444, "subscriptionId":"444444_333444","confirmationMessageId":555666}]}>)
FakeWeb.register_uri(:get, "#{ic}/subscriptions?limit=500&contactId=333333", :body => %q<{"subscriptions":[{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333333,"listId":444444, "subscriptionId":"444444_333333","confirmationMessageId":555666}]}>)
FakeWeb.register_uri(:post, "#{ic}/subscriptions", :body => %q<{"subscriptions":[{"status":"normal","addDate":"2009-07-27T15:36:37-04:00","contactId":333333,"listId":444444, "subscriptionId":"444444_333333","confirmationMessageId":555666}]}>)

# Campaign
FakeWeb.register_uri(:get, "#{ic}/campaigns?limit=1", :body => %q<{"campaigns":[{"campaignId":"777777","name":"Test Campaign","fromName":"Bob Smith","fromEmail":"bob@example.org","forwardToFriend":0,"subscriptionManagement":1,"clickTrackMode":1,"useAccountAddress":0,"archiveByDefault":0,"description":""}],"count":1}>)
FakeWeb.register_uri(:get, "#{ic}/campaigns/777777", :body => %q<{"campaign":{"campaignId":"777777","name":"Test Campaign","fromName":"Bob Smith","fromEmail":"bob@example.org","forwardToFriend":0,"subscriptionManagement":1,"clickTrackMode":1,"useAccountAddress":0,"archiveByDefault":0,"description":""}}>)