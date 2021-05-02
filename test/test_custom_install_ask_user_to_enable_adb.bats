#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source test/helper.sh
source src/hardcoded_variables.txt
source src/helper.sh

@test "Checking fastboot version response." {
	COMMAND_OUTPUT=$(adb devices)
	actual_result=$(adb devices)
	assert_equal "${actual_result:0:24}" "List of devices attached"
	assert_equal "${actual_result:34:6}" "device"
}
