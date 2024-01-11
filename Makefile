.PHONEY: test

DEVICE_ID?=$(shell xcrun simctl list devices 'iOS' --json | jq '.devices | with_entries( select(.key|contains("iOS"))) | .[] | [ .[].name ] | map( select(contains("iPhone")) ) | sort | .[0] ' | jq -r)
BOOTED_SIM=$(shell xcrun simctl list devices --json | jq -r '.devices | to_entries | map(select( .key | contains("iOS") )) | sort_by(.key) | reverse | .[0].value | map(select( (.name|contains("${DEVICE_ID}")) and .state == "Booted" ) ) | sort_by(.name) | .[0].name')

TARGET?=aarch64-apple-ios-sim

build:
	@echo TARGET: ${TARGET}
	cargo build --target ${TARGET}

run-example:
	cargo run --example accelerometer

build-macos:
	cargo build --target aarch64-apple-darwin

boot-sim:
	@echo DEVICE ID: ${DEVICE_ID}, BOOTED: ${BOOTED_SIM}
ifeq ($(BOOTED_SIM),null)
	@echo BOOTING SIM: ${DEVICE_ID}
	xcrun simctl boot "${DEVICE_ID}"
endif

test-sim: boot-sim
	@echo DEVICE ID: ${DEVICE_ID}
	cargo dinghy --platform auto-ios-aarch64-sim --device "${DEVICE_ID}" test
	xcrun simctl shutdown "${DEVICE_ID}"

bundle:
	cargo bundle --format ios --target ${TARGET} --release

.EXPORT_ALL_VARIABLES:
LLVM_CONFIG_PATH=$(shell brew --prefix llvm)/bin/llvm-config
