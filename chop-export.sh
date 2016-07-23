#!/bin/bash

# Export completed videos to Rackspace Cloud Files
# Requires installation of turbolift, and environmental variables. Set them in bash profile, or here. Keep them secret.
# OS_USERNAME=RACKSPACE USERNAME
# OS_API_KEY=RACKSPACE_APIKEY
# OS_RAX_AUTH=RACKSPACE_DATACENTER

# positional arguments

clip_path=$1
container=$2

echo "Let's upload these files. Shipping them off to your container named $container."

turbolift --internal -u $OS_USERNAME -a $OS_API_KEY --os-rax-auth $OS_RAX_AUTH upload -s $clip_path -c $container
