# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := zlib
$(PKG)_WEBSITE  := https://zlib.net/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3
$(PKG)_CHECKSUM := 8a9ba2898e1d0d774eca6ba5b4627a11e5588ba85c8851336eb38de4683050a7
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://zlib.net/$($(PKG)_FILE)
$(PKG)_URL_2    := https://$(SOURCEFORGE_MIRROR)/project/libpng/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' CFLAGS=-fPIC ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    $(if $(BUILD_SHARED), $(MAKE_SHARED_FROM_STATIC) '$(1)/libz.a',)
endef
