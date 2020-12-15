#!/bin/bash

# I have a web server running at home with a DNS name. But I have not a static public IP. This how I change my DNS name.
# The API call here is specific to my dns provider. Check yours before testing ! (and yelling at me)

# Variables :
## obviously the name of my web server
domainNameTested="toto.exemple.org"
domainName="exemple.org"
## the server who gives me the IP actualy bind whith my $domainNameTested
NSserver="NS.dnsprovider.com"
## where the log is save + name of the log
logPath="/some/logdir/"
logName="DynDNS.log"
log=$logPath$logName

## This is the tricky part : My dns provider's API aks a API key and a url.
## Your's will be diffrent !
APIkey="AGoogAPIKey"
APIurl="https://api.dnsprovider.com/$domainName/record/toto"  

# I check my public IP. https://api.myip.com/ give you a json response. Some regex get the IP.
realip=$(curl https://api.myip.com/ | grep -Po '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

# Then I get what IP give me my dns provider for my web server
dnsip=$(dig $domainNameTested +short @$NSserver)

# The Content part of the API call. here JSON because my DNS provider request it
# Be careful whit the quotes and the escapes charaters. Use and abuse of echo $data to be sure it is a JSON compliant content.
data="{\"items\":[{\"rrset_type\":\"A\",\"rrset_values\":[\"$realip\"]}]}"

# if the 2 values aren't the same do something !
if [[ $dnsip != $realip ]] 
then
echo "$(date) : Public IP update to $realip" >> $log
# The API call it self. You have to check with your DNS provider how to do that.
curl -X PUT -k -H "Authorization: Apikey $APIkey" -H 'Content-Type: application/json' -i "$APIurl" --data $data >> $log
else
echo "$(date) : Public IP ( $realip ) is the same as the DNS record $domainNameTested" >> $log
fi

# Add some empty line. Be pretty, you deserve it
printf '\n\n\n' >> $log
