TARGET := iphone:clang:latest:11.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Notistory

$(TWEAK_NAME)_FILES = Hook.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = CoreServices
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = UserNotificationKit

include $(THEOS_MAKE_PATH)/tweak.mk
