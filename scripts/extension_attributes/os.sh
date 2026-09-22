#!/usr/bin/env bash
#
# os_info.sh - Gathers system and OS info
# Suitable for standalone usage or as a Jamf / Monitoring script.

set -euo pipefail

echo "========================================="
echo "        SYSTEM & OS INFORMATION          "
echo "========================================="

# 1. Operating System & Version Details
echo "--- Operating System Details ---"
if [[ -f /etc/os-release ]]; then
    # Standard Linux os-release
    # shellcheck disable=SC1091
    source /etc/os-release
    echo "OS Name:       ${NAME:-Unknown}"
    echo "OS Version:    ${VERSION:-Unknown}"
    echo "OS ID:         ${ID:-Unknown}"
    echo "Like (Family): ${ID_LIKE:-Standalone}"
elif [[ "$(uname)" == "Darwin" ]]; then
    # macOS system details
    echo "OS Name:       macOS"
    echo "OS Version:    $(sw_vers -productVersion)"
    echo "Build Version: $(sw_vers -buildVersion)"
else
    echo "OS Name:       $(uname -s)"
    echo "OS Version:    $(uname -r)"
fi

# 2. Kernel & Architecture
echo -e "\n--- Kernel & Architecture ---"
echo "Kernel Name:    $(uname -s)"
echo "Kernel Release: $(uname -r)"
echo "Kernel Version: $(uname -v)"
echo "Architecture:   $(uname -m)"

# 3. Hostname & System Uptime
echo -e "\n--- Host System & Uptime ---"
echo "Hostname:       $(hostname)"
echo "Uptime:        $(uptime | sed 's/.*up \([^,]*\), .*/\1/')"

# 4. Hardware Resources
echo -e "\n--- Hardware Overview ---"
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS Hardware Details
    echo "CPU Model:      $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon / Unknown")"
    echo "CPU Cores:      $(sysctl -n hw.ncpu)"
    echo "Total RAM:      $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GB"
else
    # Linux Hardware Details
    echo "CPU Model:      $(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs || echo "Unknown")"
    echo "CPU Cores:      $(nproc --all 2>/dev/null || grep -c '^processor' /proc/cpuinfo)"
    if command -v free &>/dev/null; then
        echo "Total RAM:      $(free -h | awk '/^Mem:/ {print $2}')"
        echo "Available RAM:  $(free -h | awk '/^Mem:/ {print $7}')"
    fi
fi

# 5. Disk Usage
echo -e "\n--- Root Disk Usage ---"
df -h / | awk 'NR==2 {printf "Filesystem: %s | Total: %s | Used: %s (%s) | Free: %s\n", $1, $2, $3, $5, $4}'

echo "========================================="