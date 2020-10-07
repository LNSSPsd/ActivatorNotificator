TARGET := iphone:clang:latest:7.0
ARCHS := armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NotificatorPrefs

NotificatorPrefs_FILES = NCTRootListController.m NCTSenderSetViewController.m
NotificatorPrefs_FRAMEWORKS = UIKit
NotificatorPrefs_PRIVATE_FRAMEWORKS = Preferences
NotificatorPrefs_INSTALL_PATH = /Library/PreferenceBundles
NotificatorPrefs_CFLAGS = -fobjc-arc
NotificatorPrefs_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/bundle.mk
