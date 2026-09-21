#!/bin/bash
#
# Jamf Pro Extension Attribute: reports the macOS version.
# Wire this up as a jamfpro_extension_attribute resource pointing at this
# script's content, or paste it into the EA's script field.

osVersion=$(sw_vers -productVersion)

echo "<result>${osVersion}</result>"

exit 0
