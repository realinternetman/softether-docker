#!/bin/bash

HUB_NAME=$1
VPN_CMD=${@:2}
vpncmd /SERVER localhost /ADMINHUB:$HUB_NAME /CMD $VPN_CMD