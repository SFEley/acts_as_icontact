require 'rubygems'
require 'fakeweb'

FakeWeb.allow_net_connect = false

# Resources (this one's a fake stub for pure testing)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources", :body => %q<{"resources":[{"foo":"bar","resourceId":"1","too":"bar"},{"foo":"aar","resourceId":"2"},{"foo":"far","resourceId":"3"},{"foo":"car","resourceId":"4"},{"foo":"dar","resourceId":"5"},{"foo":"ear","resourceId":"6"},{"foo":"gar","resourceId":"7"},{"foo":"har","resourceId":"8"},{"foo":"iar","resourceId":"9"},{"foo":"jar","resourceId":"10"},{"foo":"kar","resourceId":"11"},{"foo":"yar","resourceId":"12"}],"total":12,"limit":20,"offset":0}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources?limit=5", :body => %q<{"resources":[{"foo":"bar","resourceId":"1"},{"foo":"aar","resourceId":"2"},{"foo":"far","resourceId":"3"},{"foo":"car","resourceId":"4"},{"foo":"dar","resourceId":"5"}],"total":12,"limit":5,"offset":0}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources?offset=5", :body => %q<{"resources":[{"foo":"ear","resourceId":"6"},{"foo":"gar","resourceId":"7"},{"foo":"har","resourceId":"8"},{"foo":"iar","resourceId":"9"},{"foo":"jar","resourceId":"10"},{"foo":"kar","resourceId":"11"},{"foo":"yar","resourceId":"12"}],"total":12,"limit":20,"offset":5}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources?offset=5&limit=5", :body => %q<{"resources":[{"foo":"ear","resourceId":"6"},{"foo":"gar","resourceId":"7"},{"foo":"har","resourceId":"8"},{"foo":"iar","resourceId":"9"},{"foo":"jar","resourceId":"10"}],"total":12,"limit":5,"offset":5}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources?offset=10&limit=5", :body => %q<{"resources":[{"foo":"kar","resourceId":"11"},{"foo":"yar","resourceId":"12"}],"total":12,"limit":5,"offset":10}>)
FakeWeb.register_uri(:post, "https://app.beta.icontact.com/icp/resources/1", :body => %q<{"resource":{"foo":"bar","resourceId":"1","too":"sar"}}>)
FakeWeb.register_uri(:post, "https://app.beta.icontact.com/icp/resources/2", :body => %q<{"resource":{},"warnings":["You did not provide a foo. foo is a required field. Please provide a foo","This was not a good record"]}>)
FakeWeb.register_uri(:post, "https://app.beta.icontact.com/icp/resources/3", :status => ["400","Bad Request"], :body => %q<{"errors":["You did not provide a clue. Clue is a required field. Please provide a clue"]}>)

# Time
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/time", :body => %q<{"time":"2009-07-13T01:28:18-04:00","timestamp":1247462898}>)

# Accounts
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/a", :body => %q<{"accounts":[{"billingStreet":"","billingCity":"","billingState":"","billingPostalCode":"","billingCountry":"","city":"Testville","accountId":"111111","companyName":"","country":"United States","email":"bob@example.org","enabled":1,"fax":"","firstName":"Bob","lastName":"Tester","multiClientFolder":"0","multiUser":"0","phone":"","postalCode":"12345","state":"TN","street":"123 Test Street","title":"","accountType":"0","subscriberLimit":"250000"}],"total":1,"limit":20,"offset":0}>)

# Clients
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/a/111111/c", :body => %q<{"clientfolders":[{"clientFolderId":"222222","logoId":null,"emailRecipient":"bob@example.org"}],"total":1}>)
