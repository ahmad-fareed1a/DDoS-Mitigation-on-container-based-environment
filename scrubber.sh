
# Start your rate limiting script
/usr/local/bin/rate_limit.sh &

# Start your dynamic blacklisting script in the background
/usr/local/bin/dynamic_blacklist.sh &

# Implement iptables rules for filtering suspicious TCP/UDP flags (modify as needed)
iptables -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST SYN,ACK,FIN,RST -j DROP

# Drop packets with the specified HTTP User-Agent header
iptables -A INPUT -m string --algo kmp --string "User-Agent: hping3" -j DROP

# Forward traffic to the destination web container's IP (will be replaced with the web-container IP )
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 172.18.0.2:80
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 172.18.0.2:443

# Log dropped packets due to dynamic blacklisting
iptables -A INPUT -j LOG --log-prefix "DROPPED: " --log-level 7
