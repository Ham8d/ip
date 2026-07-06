TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ChangeIP
ChangeIP_FILES = changeip.xm
ChangeIP_FRAMEWORKS = UIKit
# تجاهل تحذيرات الأكواد القديمة لضمان نجاح التجميع
ChangeIP_CFLAGS = -Wno-deprecated-declarations

include $(THEOS)/makefiles/tweak.mk
