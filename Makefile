TARGET := iphone:clang:latest:7.0
ARCHS := armv7 arm64 arm64e
#INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Notificator

Notificator_FILES = Listener.x
Notificator_LIBRARIES = activator
Notificator_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += notificatorprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
