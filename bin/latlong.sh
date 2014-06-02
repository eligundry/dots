#!/bin/bash

# Default lat-long values in case of no internet

lat='41.1506'
long='-81.3611'

json=$(curl -s http://www.telize.com/geoip)

if [[ $json != "" ]]; then
	lat=$(echo "$json" | jsawk 'return this.latitude')
	long=$(echo "$json" | jsawk 'return this.longitude')
fi


xf()
{
	xflux -l $lat -g $long
}

rs()
{
	redshift -l $lat:$long
}

if [[ -z $# ]]; then
	echo -l $lat -g $long
fi

case "$1" in
	'xflux')
		xf
	;;
	'redshift')
		rs
	;;
esac
