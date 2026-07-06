#import <UIKit/UIKit.h>
#import <substrate.h>

// عمل Hook على معرّف الجهاز (IDFV)
%hook UIDevice

- (NSUUID *)identifierForVendor {
    NSString *savedUUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"CustomFakeUUID"];
    if (!savedUUID) {
        savedUUID = @"4ABEF3F0-E8B6-4807-AA98-D3F2CA40B763"; // المعرّف الافتراضي
        [[NSUserDefaults standardUserDefaults] setObject:savedUUID forKey:@"CustomFakeUUID"];
    }
    return [[NSUUID alloc] initWithUUIDString:savedUUID];
}

%end

// دالة إظهار التنبيه المتوافقة مع الأنظمة الجديدة والقديمة
void showCustomAlert() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"هوية الجهاز (UUID)" 
                                                                       message:@"محرّف جهازك النشط حالياً هو:\n\n4ABEF3F0-E8B6-4807-AA98-D3F2CA40B763\n\nهذا المعرّف يخفي البصمة الحقيقية لجهازك لتجاوز الحظر." 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"نسخ المعرّف" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [UIPasteboard generalPasteboard].string = @"4ABEF3F0-E8B6-4807-AA98-D3F2CA40B763";
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:copyAction];
        [alert addAction:okAction];
        
        // جلب النافذة النشطة بأمان (iOS 13+)
        UIWindow *keyWindow = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
        
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

// نقطة انطلاق الدايلب
%ctor {
    %init;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        showCustomAlert();
    }];
}
