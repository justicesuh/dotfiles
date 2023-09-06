#!/bin/sh

echo "Generating a new SSH key..."
ssh-keygen -t ed25519 -C $1 -f ~/.ssh/id_ed25519 -q -N ""
echo "Copying public key to clipboard..."
echo $(pbcopy < ~/.ssh/id_ed25519.pub)

