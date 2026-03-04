# Get the stats
# Memory: Fedora's free -h output
mem=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

# Disk: Usage of /
disk=$(df -h / | awk '/\// {print $3 "/" $2 " (" $5 ")"}' | head -n 1)

# Battery: capacity percentage
bat=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "N/A")

# Date/Time: formatted exactly like the screenshot
date_time=$(date "+%a, %b %d - %I:%M %p")

# Print the final line (this is what swaybar shows)
echo "mem: $mem | disk: $disk | bat: $bat% | $date_time"
