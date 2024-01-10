.PHONEY: test

#RUNTIME_ID=$(shell xcrun simctl list runtimes | grep iOS | cut -d ' ' -f 7 | tail -1)

DEVICE_ID=$(shell xcrun simctl list devices 'iOS' --json | jq '.devices | with_entries( select(.key|contains("iOS"))) | .[] | [ .[].name ] | map( select(contains("iPhone")) ) | sort | .[0] ' | jq -r)

TARGET=aarch64-apple-ios

build:
	cargo build --target $(TARGET)

build-macos:
	cargo build --target aarch64-apple-darwin

boot-sim:
	@echo DEVICE ID: $(DEVICE_ID)
	xcrun simctl list devices
	xcrun simctl list devices booted | grep iPhone || xcrun simctl boot "$(DEVICE_ID)"

test: boot-sim
	cargo dinghy --platform auto-ios-x86_64 test

bundle:
	cargo bundle --format ios --target $(TARGET) --release

.EXPORT_ALL_VARIABLES:
LLVM_CONFIG_PATH=$(shell brew --prefix llvm)/bin/llvm-config
