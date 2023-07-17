# TARGET = iphone:clang:latest:13.0
TARGET = iphone:clang:13.3:10.0

INSTALL_TARGET_PROCESSES = Notistory

include $(THEOS)/makefiles/common.mk

# APPLICATION_NAME = Notistory

# $(APPLICATION_NAME)_FILES = $(wildcard *.m)
# $(APPLICATION_NAME)_FRAMEWORKS = UIKit CoreGraphics
# $(APPLICATION_NAME)_CFLAGS = -fobjc-arc

# include $(THEOS_MAKE_PATH)/application.mk

XCODEPROJ_NAME = Notistory
$(XCODEPROJ_NAME)_XCODE_SCHEME = Notistory
$(XCODEPROJ_NAME)_CODESIGN_FLAGS = -Sentitlements.xml
$(XCODEPROJ_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/xcodeproj.mk
