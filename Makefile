TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = discover

DEBUG = 0

THEOS_PACKAGE_SCHEME = rootless

PACKAGE_VERSION = 1.1
PACKAGE_NAME = com.huami.xhstranslator

THEOS_TOOLCHAIN_PATH = /Users/huami/Library/Developer/Toolchains/Hikari_LLVM19.0.0git.xctoolchain
export THEOS_TOOLCHAIN_PATH

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = XHSTranslator

XHSTranslator_FILES = XHSTranslator.xm \
translateMgr.m

XHSTranslator_CFLAGS = -fobjc-arc
XHSTranslator_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk