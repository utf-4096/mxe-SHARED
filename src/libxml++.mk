# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxml++
$(PKG)_WEBSITE  := https://libxmlplusplus.sourceforge.io/
$(PKG)_DESCR    := libxml2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.40.1
$(PKG)_CHECKSUM := 4ad4abdd3258874f61c2e2a41d08e9930677976d303653cd1670d3e9f35463e9
$(PKG)_SUBDIR   := libxml++-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml++-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libxml++/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glibmm libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libxml++/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CXX="$(TARGET)-g++" ./configure \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)

    # A fix similar to the one in coin.mk: add -lkernelbase to provide __chkstk, the Windows stack probe function.
    # The most likely cause  of libtool missing it is that __chkstk only guards large stack frames (>1 memory page).
    # See: https://stackoverflow.com/questions/8400118/what-is-the-purpose-of-the-chkstk-function
    $(SED) -i 's,^postdeps="-,postdeps="-lkernelbase -,g' '$(1)/libtool'
    
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
