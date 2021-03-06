include config.mk

SRC_IN = $(shell find $(SRC_DIR) -type f -name '*'$(SRC_EXT) -printf '%P ')
_HTML_OUT = $(patsubst %index$(SRC_EXT), $(OUT_DIR)/%index.html, $(SRC_IN))
HTML_OUT = $(patsubst %$(SRC_EXT), $(OUT_DIR)/%/index.html, $(_HTML_OUT))

ASSETS_IN = $(shell find $(SRC_DIR) -type f '!' -name '*'$(SRC_EXT) -printf '%P ')
ASSETS_OUT = $(patsubst %, $(OUT_DIR)/%, $(ASSETS_IN))

INCLUDES_IN = $(shell find $(INCLUDES_DIR) -type f -printf '%P ')
INCLUDES_OUT = $(patsubst %, $(OUT_DIR)/%, $(INCLUDES_IN))

all: html assets
html: $(HTML_OUT)
assets: $(INCLUDES_OUT) $(ASSETS_OUT)

$(OUT_DIR)/index.html: $(SRC_DIR)/index$(SRC_EXT) $(HEADER_FILES) $(FOOTER_FILES)
	@echo -e "\e[1mBuilding $<\e[0m"
	mkdir -p $(@D)
	cat $(HEADER_FILES) > $@
	$(SRC_CONVERTER) $< >> $@
	cat $(FOOTER_FILES) >> $@

$(OUT_DIR)/%index.html: $(SRC_DIR)/%index$(SRC_EXT) $(HEADER_FILES) $(FOOTER_FILES)
	@echo -e "\e[1mBuilding $<\e[0m"
	mkdir -p $(@D)
	cat $(HEADER_FILES) > $@
	$(SRC_CONVERTER) $< >> $@
	cat $(FOOTER_FILES) >> $@

$(OUT_DIR)/%/index.html: $(SRC_DIR)/%$(SRC_EXT) $(HEADER_FILES) $(FOOTER_FILES)
	@echo -e "\e[1mBuilding $<\e[0m"
	mkdir -p $(@D)
	cat $(HEADER_FILES) > $@
	$(SRC_CONVERTER) $< >> $@
	cat $(FOOTER_FILES) >> $@

$(OUT_DIR)/%: $(INCLUDES_DIR)/%
	@echo -e "\e[1mCopying $<\e[0m"
	mkdir -p $(@D)
	cp $< $@

$(OUT_DIR)/%: $(SRC_DIR)/%
	@echo -e "\e[1mCopying $<\e[0m"
	mkdir -p $(@D)
	cp $< $@

clean:
	rm -r $(OUT_DIR)

.PHONY: all html assets clean
