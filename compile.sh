#!/bin/bash

source default_config.sh

if [ -f custom_config.sh ]; then
	source custom_config.sh
fi

echo $system
echo $standards
