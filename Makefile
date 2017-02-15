EXECUTABLE = set-simulator-location
PREFIX ?= /usr/local/bin
SRCS = $(wildcard Sources/*.swift)

$(EXECUTABLE): $(SRCS)
	swiftc \
		-static-stdlib \
		-O -whole-module-optimization \
		-o $(EXECUTABLE) \
		-sdk $(shell xcrun --sdk macosx --show-sdk-path) \
		-target x86_64-macosx10.10 \
		$(SRCS)
