#!/bin/bash

# The current PHP Version of the machine
CURRENT_VERSION=$(php -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d".")

# New version of PHP to apply
NEW_VERSION=$1

# Check that script has root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Check that the new version of PHP was send
if [ -z ${NEW_VERSION} ]; then 
    echo "You have to send the new version of PHP"
    exit 2
fi

# Disable current version of PHP in Apache
a2dismod php${CURRENT_VERSION}

# Enable new version of PHP in Apache
a2enmod php${NEW_VERSION}

# Enable globally new version of PHP
update-alternatives --set php /usr/bin/php${NEW_VERSION}

# Restart Apache
systemctl restart apache2
/etc/init.d/apache2 reload

echo -e "All done, bye!"   
