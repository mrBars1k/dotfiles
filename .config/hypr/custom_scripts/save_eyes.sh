#!/bin/bash

if pgrep hyprsunset > /dev/null; then
	pkill hyprsunset
else
	hyprsunset -t 3000 &
fi
