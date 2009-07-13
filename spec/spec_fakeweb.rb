require 'rubygems'
require 'fakeweb'

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/time", :body => %q<{"time":"2009-07-13T01:28:18-04:00","timestamp":1247462898}>)
FakeWeb.register_uri(:get, "https://app.beta.icontact.com/icp/a", :body => %q<{"accounts":[{"billingStreet":"","billingCity":"","billingState":"","billingPostalCode":"","billingCountry":"","city":"Testville","accountId":"111111","companyName":"","country":"United States","email":"bob@example.org","enabled":1,"fax":"","firstName":"Bob","lastName":"Tester","multiClientFolder":"0","multiUser":"0","phone":"","postalCode":"12345","state":"TN","street":"123 Test Street","title":"","accountType":"0","subscriberLimit":"250000"}],"total":1,"limit":20,"offset":0}>)
