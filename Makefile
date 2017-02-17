EXECUTABLE = set-simulator-location
ARCHIVE = $(EXECUTABLE).tar.gz
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

.PHONY: install
install: $(EXECUTABLE)
	install $(EXECUTABLE) "$(PREFIX)"

.PHONY: archive
archive: $(EXECUTABLE)
	tar --create --preserve-permissions --gzip --file $(ARCHIVE) $(EXECUTABLE)
	@shasum -a 256 $(EXECUTABLE)
	@shasum -a 256 $(ARCHIVE)

.PHONY: clean
clean:
	rm -rf $(EXECUTABLE) $(ARCHIVE)

.PHONY: uninstall
uninstall:
	rm "$(PREFIX)/$(EXECUTABLE)"
