#!/bin/sh
myvar1=`system_profiler SPAirPortDataType | grep -e "Current Wireless Network:" | awk '{print $4}'`
myvar2=`system_profiler SPAirPortDataType | grep -e "Wireless Channel:" | awk '{print $3}'`

echo "Airport : $myvar1 - $myvar2"