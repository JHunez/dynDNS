# I have a web server running at home with a DNS name. But I have not a static public IP. This how I change my DNS name.
# TO DO LIST : create more variable in order to adapt the script easily and publish here 

# I check my public IP. https://api.myip.com/ give you a json response. Some regex get the IP. 
realip=$(curl https://api.myip.com/ | grep -Po '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

# Then I get what IP give me my dns provider for my web server. here :  example.thing
dnsip=$(dig example.thing +short @ns.provider.com)

# if the 2 values aren't the same do something !
if [[ $dnsip != $realip ]]
then
# Some log
echo "$(date) : Public IP change to : $realip" > /somedirectory/logs/dyndns.log
echo "Using DNS Provider API : " >> /somedirectory/logs/dyndns.log

# construct of the API request. You have to check with your DNS provider how to do that. 
# The API call it self
curl -X PUT -k -H 'Authorization: Apikey SomeAPIKey' -H 'Content-Type: application/json' -i 'https://provider.api.com/' --data '{ "rrset_values" : ["'$realip'"] }' >> /somedirectory/logs/dyndns.log
fi
