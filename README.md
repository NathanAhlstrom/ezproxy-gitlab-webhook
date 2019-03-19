
## Prerequisites  

1. Install [nodejs](https://nodejs.org/) 
2. and the nodejs [forever](https://www.npmjs.com/package/forever) module: 

``` bash
	$ [sudo] npm install -g forever
```

## Installation

1. Clone this repository to a Linux virtual machine to /opt/ezproxy-webhook.

``` bash
	$ [sudo] git clone https://github.com/NathanAhlstrom/ezproxy-gitlab-webhook.git /opt/ezproxy-webhook
```

2. Configure by updating /opt/ezproxy-webhook/config.js to include your webhook token, repository names, etc.
3. Setup Apache to proxy these webhook requests:

``` apache
ProxyRequests Off
<Proxy *>
        Order deny,allow
        Deny from all

        # allow from localhost
        Allow from 127.0.0.1

        #
        # allow from gitlab.example.com
        #
        Allow from gitlab.example.com
	# your gitlab servers IP address here.
        Allow from 10.1.1.1
</Proxy>

ProxyPass /hooks        http://localhost:9000/hooks
ProxyPassReverse /hooks http://localhost:9000/hooks
```

4. On your Linux/BSD/Unix flavor set this webhook service to run on startup.
