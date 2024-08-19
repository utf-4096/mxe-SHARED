# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mbedtls
$(PKG)_WEBSITE  := https://www.trustedfirmware.org/projects/mbed-tls/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.0
$(PKG)_CHECKSUM := 3ecf94fcfdaacafb757786a01b7538a61750ebd85c4b024f56ff8ba1490fcd38
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://github.com/Mbed-TLS/$(PKG)/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/ \
        -DMBEDTLS_FATAL_WARNINGS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

