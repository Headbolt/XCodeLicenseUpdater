#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	XCodeLicenseUpdater.sh
#	https://github.com/Headbolt/XCodeLicenseUpdater
#
#   This Script is designed for use in JAMF as an Extension Attribute
#
#   - This script will ...
#		Determine the version of App installed, if present
#		Determine the version of the XCode User License Agreed to
#		Compare the 2 and update the license if required
#
###############################################################################################################################################
#
# HISTORY
#
#	Version: 1.2 - 28/03/2025
#
#	28/03/2025 - V1.0 - Created by Headbolt
#
#	28/03/2025 - V1.1 - Updated by Headbolt
#							Updated to include better reporting
#
#	28/03/2025 - V1.2 - Updated by Headbolt
#							Updated to include extra checking
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
ScriptVer=v1.2
ScriptName="Application | XCode License Updater"
ExitCode=0
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Script Start Function
#
ScriptStart(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd
/bin/echo Starting Script '"'$ScriptName'"'
/bin/echo Script Version '"'$ScriptVer'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Gather Information Function
#
InfoGather(){
#
XcodeVers=$(defaults read "/Applications/xcode.app"/Contents/version CFBundleShortVersionString 2>/dev/null) # Extracts the Version from the APP
if [[ -n "$XcodeVers" ]] # Check result, if blank set it to 0
	then
		/bin/echo "App Ver = $XcodeVers"
	else
		/bin/echo 'App Missing'
		XcodeVers="0"
fi
#
License=$(sudo defaults read "/Library/Preferences/com.apple.dt.Xcode.plist" IDEXcodeVersionForAgreedToGMLicense 2>/dev/null) # Extracts License Version
if [[ -n "$License" ]] # Check result, if blank set it to 0
	then
		/bin/echo "License Ver = $License"
	else
		/bin/echo 'License Missing'
		License="0"
fi
#
}
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
exit $ExitCode
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
# 
# Begin Processing
#
###############################################################################################################################################
#
ScriptStart
#
/bin/echo 'Checking current details'
/bin/echo # Outputting a Blank Line for Reporting Purposes
InfoGather
#
if [[ "$XcodeVers" == "0" ]] # Check App Present
	then
		SectionEnd
    	/bin/echo 'App Missing - Nothing To Do'
	else
		SectionEnd
		if [[ "$License" == "0" ]] # Check License Present
			then
				/bin/echo 'App Present but License Missing - Applying License'
				/bin/echo 'Running Command "'/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept'"'
				/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept
				/bin/echo # Outputting a Blank Line for Reporting Purposes
                /bin/echo 'Running First Launch'
				/bin/echo 'Running Command "'/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -runFirstLaunch'"'
				/bin/echo # Outputting a Blank Line for Reporting Purposes
                /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -runFirstLaunch
				SectionEnd
				/bin/echo 'Re-Checking current details'
				/bin/echo # Outputting a Blank Line for Reporting Purposes
				InfoGather
			else
				if [[ "$License" < "$XcodeVers" ]] # Check if License Version is older than the App Version
					then
						/bin/echo 'License Update Needed - Removing Current License'
						/bin/echo 'Running Command "'rm /Library/Preferences/com.apple.dt.Xcode.plist'"'
						rm /Library/Preferences/com.apple.dt.Xcode.plist
						/bin/echo # Outputting a Blank Line for Reporting Purposes
                        /bin/echo 'License Update Needed - Applying License'
						/bin/echo 'Running Command "'/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept'"'
						/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept
						SectionEnd
						/bin/echo 'Re-Checking current details'
						/bin/echo # Outputting a Blank Line for Reporting Purposes
						InfoGather
				fi
		fi
fi
#
SectionEnd
ScriptEnd
