TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ChangeIP
ChangeIP_FILES = changeip.m
ChangeIP_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/tweak.mk
