#!/bin/bash
apt_update() {
	local LOG_PATH=$1
	
	## Verify the device is recognised by adb debugging
	# read device id using adb
	adb_devices=$(adb devices)
	device_id="${adb_devices:25:8}"
	
	# Determine which os is selected.
	if [ "$OS_CHOICE" == "fairphone_os" ]; then
		os_filepath="$FAIRPHONE_OS_FILEPATH"
		os_url="$FAIRPHONE_OS_URL"
		expected_md5_of_os_zip="$FAIRPHONE_OS_MD5"
	elif [ "$OS_CHOICE" == "fairphone_open" ]; then
		os_filepath="$FAIRPHONE_OPEN_FILEPATH"
		os_url="$FAIRPHONE_OPEN_URL"
		expected_md5_of_os_zip="$FAIRPHONE_OPEN_MD5"
	elif [ "$OS_CHOICE" == "lineage_os" ]; then
		os_filepath="$LINEAGEOS_FILEPATH"
		os_url="$LINEAGEOS_URL"
		expected_md5_of_os_zip="$LINEAGEOS_MD5"
	fi
	
	# break if device id is found and contains 8 characters
	if [ ${#device_id} -eq 8 ]; then 
	
		# enable sideloading
		enable_sideloading=$(adb shell twrp sideload)
		#echo $enable_sideloading > "${ENABLE_SIDELOADING_DATA_PATH}"
		#read -p "Starting the sideloading" sink
		echo "Starting the sideloading, please be patient, we will let you know once the sideloading is completed." >&2
		
		sleep 20
		
		sideload_lineage=$(sudo adb sideload $os_filepath)
		#read -p "(<press enter when read>)The output of the sideload lineage command is:$sideload_lineage" sink
		echo "The output of the sideload lineage command is:$sideload_lineage" >&2
		
		# TODO: refactor to Sideload_os_data_path
		echo $sideload_lineage > "${SIDELOAD_LINEAGE_DATA_PATH}"
		
		sleep 20
		#read -p "Now starting exit sideloading<press enter>" sink
		echo "Now starting exit sideloading." >&2
		
		
		#exit_sideloading=$(sudo adb sideload /dev/null)
		#echo "The output of the sideload lineage command is:$exit_sideloading." >&2
		#sleep 20
		
		# TODO: format data before reboot
		#wipe_data=$(adb shell twrp wipe data)
		#echo $wipe_data > "${WIPE_DATA_PATH}"
		#echo "The output of the post-sideloading  wiping of data is:$wipe_data" >&2
		#sleep 20
		
		#wipe_cache=$(adb shell twrp wipe cache)
		#echo $wipe_cache > "${WIPE_CACHE_PATH}"
		#echo "The output of the post-sideloading  wiping of cache is:$wipe_cache" >&2
		#sleep 20
		
		#wipe_dalvik=$(adb shell twrp wipe dalvik)
		#echo $wipe_dalvik > "${WIPE_DALVIK_PATH}"
		#echo "The output of the post-sideloading wiping of dalvik is:$wipe_cache" >&2
		#sleep 20
		
		# This removes the operating system (that was just sideloaded).
		#wipe_system=$(adb shell twrp wipe system)
		#echo $wipe_system > "${WIPE_SYSTEM_PATH}"
		#read -p "<press enter when read>The output of the post-sideloading wiping of system is:$wipe_system" sink
		
		#read -p "LAST CHANCE TO INSPECT THE INSTALLATION LOG ON THE PHONE" sink
		
		echo "Now going to reboot the system." >&2
		
		
		if [ "$OS_CHOICE" == "fairphone_open" ]; then
			echo "Post sideloading factory reset for fairphone_open" >&2
			# perform a factory reset
			# Source: https://android.stackexchange.com/questions/175885/how-to-factory-reset-android-using-adb
			## Almost bricks the device
			#reboot_bootloader=$(adb reboot bootloader)
			#echo "Reboot bootloader command output is:$reboot_bootloader" >&2
			#echo $reboot_bootloader > "${LOG_PATH}"
			#echo "waiting 30 seconds.." >&2
			#sleep 20
			#read -p "Please press <enter> once the device is in fastboot mode." sink
			## TODO: implement loop that checks if the device is in fastboot mode
			#fastboot_erase_userdata=$(fastboot erase userdata)
			#echo "fastboot_erase_userdata command output is:$fastboot_erase_userdata" >&2
			#
			#fastboot_erase_cache=$(fastboot erase cache)
			#echo "fastboot_erase_cache command output is:$fastboot_erase_cache" >&2
			#
			#fastboot_reboot=$(fastboot reboot)
			#echo " command output is:$fastboot_erase_cache" >&2
			
			format_data=$(adb shell twrp format data)
			echo "The output of command format_data is:$format_data" >&2
			
			final_adb_reboot=$(adb reboot)
			echo $final_adb_reboot > "${FINAL_ADB_REBOOT_PATH}"
		fi
		if [ "$OS_CHOICE" == "lineage_os" ]; then
			echo "Post sideloading reboot for lineage_os" >&2
			final_adb_reboot=$(adb reboot)
			echo $final_adb_reboot > "${FINAL_ADB_REBOOT_PATH}"
		fi
		
		
	else
		exit 0
	fi
	echo "The installation of the other operating system is now completed. Please wait 10 minutes for the new OS to boot and start up for the first time." >&2
	echo "PLEASE DISCONNECT THE PHONE FROM THE COMPUTER." >&2
}
apt_update "$@"
