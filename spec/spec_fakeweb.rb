require 'rubygems'
require 'fakeweb'

FakeWeb.allow_net_connect = false

# Resources (this one's a fake stub for pure testing)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources", :body => %q<{"resources":[{"foo":"bar"},{"foo":"aar"},{"foo":"far"},{"foo":"car"},{"foo":"dar"},{"foo":"ear"},{"foo":"gar"},{"foo":"har"},{"foo":"iar"},{"foo":"jar"},{"foo":"kar"},{"foo":"yar"}],"total":12,"limit":20,"offset":0}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources?limit=5", :body => %q<{"resources":[{"foo":"bar"},{"foo":"aar"},{"foo":"far"},{"foo":"car"},{"foo":"dar"}],"total":13,"limit":5,"offset":0}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources?limit=5&offset=5", :body => %q<{"resources":[{"foo":"ear"},{"foo":"gar"},{"foo":"har"},{"foo":"iar"},{"foo":"jar"}],"total":12,"limit":5,"offset":5}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/resources?limit=5&offset=10", :body => %q<{"resources":[{"foo":"kar"},{"foo":"yar"}],"total":12,"limit":5,"offset":10}>)

# Time
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/time", :body => %q<{"time":"2009-07-13T01:28:18-04:00","timestamp":1247462898}>)

# Accounts
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/a", :body => %q<{"accounts":[{"billingStreet":"","billingCity":"","billingState":"","billingPostalCode":"","billingCountry":"","city":"Testville","accountId":"111111","companyName":"","country":"United States","email":"bob@example.org","enabled":1,"fax":"","firstName":"Bob","lastName":"Tester","multiClientFolder":"0","multiUser":"0","phone":"","postalCode":"12345","state":"TN","street":"123 Test Street","title":"","accountType":"0","subscriberLimit":"250000"}],"total":1,"limit":20,"offset":0}>)

# Clients
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/a/111111/c", :body => %q<{"clientfolders":[{"clientFolderId":"222222","logoId":null,"emailRecipient":"bob@example.org"}],"total":1}>)
