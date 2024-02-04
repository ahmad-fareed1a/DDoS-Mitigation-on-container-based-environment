
# Allow established connections
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow HTTP (port 80) traffic
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Limit the number of connections per IP
iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 32 -j REJECT --reject-with tcp-reset

# Rate limit incoming HTTP requests
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 1 --hitcount 10 -j DROP


# Rate limit incoming requests to 10 requests per minute on port 80
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

# Rate limit incoming requests to 10 requests per minute on port 443
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

# Reject all other incoming traffic
iptables -A INPUT -j REJECT
