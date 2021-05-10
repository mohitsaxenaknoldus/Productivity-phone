#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source test/helper.sh
source src/hardcoded_variables.txt
source src/helper.sh

mkdir -p src/logs

# Method that executes all tested main code before running tests.
setup() {
	# print test filename to screen.
	if [ "${BATS_TEST_NUMBER}" = 1 ];then
		echo "# Testfile: $(basename ${BATS_TEST_FILENAME})-" >&3
	fi
	
	# Declare filenames of files that perform commands
	declare -a arr=(
		"custom_install_get_twrp"
		"custom_install_reboot_bootloader_1"
		#"custom_install_reboot_bootloader_2"
		"custom_install_flash_twrp"
	)
                	
	# Loop through files that perform commands
	for i in "${arr[@]}"
	do
		# run main functions that perform some commands
		run_main_functions "$i"
	done
}

@test "Verifying the twrp md5 is as expected after flashing." {
	
	# Read out the md5 checksum of the downloaded social package.
	md5_of_social_package=$(sudo md5sum "$TWRP_FILEPATH")
	
	# Extract actual md5 checksum from the md5 command response.
	md5_of_social_package_head=${md5_of_social_package:0:32}
	
	# Assert the measured md5 checksum equals the hardcoded md5 checksum of the expected file.
	assert_equal "$md5_of_social_package_head" "$TWRP_MD5"
}


@test "Checking if adb devices is enabled after fastboot reboot after flashing." {
	sleep 10
	actual_result=$(adb devices)
	assert_equal "${actual_result:0:24}" "List of devices attached"
	assert_equal "${actual_result:34:6}" "device"
}