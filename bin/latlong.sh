#!/bin/bash

# Default lat-long values in case of no internet

lat='41.1506'
long='-81.3611'

json=$(curl -s http://www.telize.com/geoip)

if [[ $json != "" ]]; then
	lat=$(echo "$json" | jsawk 'return this.latitude')
	long=$(echo "$json" | jsawk 'return this.longitude')
fi

echo $lat:$long
