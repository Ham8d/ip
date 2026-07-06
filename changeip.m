#import <UIKit/UIKit.h>
#import <substrate.h>

// إنشاء جاف لعمل Hook على معرّف الجهاز (IDFV) كمثال لتخطي الحظر
%hook UIDevice

- (NSUUID *)identifierForVendor {
    // هنا نقوم بتوليد UUID جديد أو جلب المعرّف العشوائي المحفوظ سابقاً
    NSString *savedUUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"CustomFakeUUID"];
    if (!savedUUID) {
        savedUUID = @"4ABEF3F0-E8B6-4807-AA98-D3F2CA40B763"; // المعرّف الافتراضي
        [[NSUserDefaults standardUserDefaults] setObject:savedUUID forKey:@"CustomFakeUUID"];
    }
    return [[NSUUID alloc] initWithUUIDString:savedUUID];
}

%end

// دالة لإظهار التنبيه (Alert) الموضح في صورك عند تشغيل التطبيق
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
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

// نقطة انطلاق الدايلب عند حقنه داخل التطبيق
%ctor {
    %init;
    
    // الانتظار حتى يتم تحميل واجهة التطبيق بالكامل ثم إظهار التنبيه
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        showCustomAlert();
    }];
}
