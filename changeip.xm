#import <UIKit/UIKit.h>
#import <substrate.h>

// ============================
// UUID
// ============================
static NSString *getOrCreateUUID() {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:@"TiraathFakeUUID"];
    if (!uuid) {
        uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"TiraathFakeUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return uuid;
}

static void generateNewUUID() {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"TiraathFakeUUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// ============================
// Global window reference
// ============================
static UIWindow *gFloatingWindow = nil;
static UIWindow *gMenuWindow = nil;
static BOOL gCreated = NO;

// ============================
// Menu View Controller
// ============================
@interface TiraathMenu : UIViewController
@end

@implementation TiraathMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];

    CGFloat w = 270, h = 215;
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;

    UIView *card = [[UIView alloc] initWithFrame:CGRectMake((sw-w)/2, (sh-h)/2, w, h)];
    card.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.14 alpha:0.97];
    card.layer.cornerRadius = 18;
    card.clipsToBounds = YES;
    card.userInteractionEnabled = YES;
    UITapGestureRecognizer *blockTap = [[UITapGestureRecognizer alloc] init];
    [card addGestureRecognizer:blockTap];
    [self.view addSubview:card];

    // UUID header
    NSString *uuid = getOrCreateUUID();
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(w-15-180, 15, 180, 18)];
    title.text = @"المعرّف الحالي:";
    title.textAlignment = NSTextAlignmentRight;
    title.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    title.textColor = [UIColor whiteColor];
    [card addSubview:title];

    UILabel *uuidLbl = [[UILabel alloc] initWithFrame:CGRectMake(w-15-180, 35, 180, 18)];
    uuidLbl.text = [NSString stringWithFormat:@"...%@", [uuid substringToIndex:8]];
    uuidLbl.textAlignment = NSTextAlignmentRight;
    uuidLbl.font = [UIFont fontWithName:@"Courier" size:13];
    uuidLbl.textColor = [UIColor colorWithRed:0.35 green:0.75 blue:1.0 alpha:1.0];
    [card addSubview:uuidLbl];

    // Info button
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    infoBtn.frame = CGRectMake(10, 12, 32, 32);
    if (@available(iOS 13, *)) {
        UIImage *img = [[UIImage systemImageNamed:@"info.circle"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [infoBtn setImage:img forState:UIControlStateNormal];
    } else {
        [infoBtn setTitle:@"ⓘ" forState:UIControlStateNormal];
    }
    infoBtn.tintColor = [UIColor whiteColor];
    [infoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:infoBtn];

    // Separator
    UIView *s1 = [[UIView alloc] initWithFrame:CGRectMake(0, 63, w, 0.5)];
    s1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.12];
    [card addSubview:s1];

    // Generate button
    UIButton *genBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    genBtn.frame = CGRectMake(0, 63, w, 60);
    [genBtn addTarget:self action:@selector(doGenerate) forControlEvents:UIControlEventTouchUpInside];

    UILabel *genLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, w-60, 60)];
    genLbl.text = @"توليد معرّف جديد وإعادة التشغيل";
    genLbl.font = [UIFont systemFontOfSize:14];
    genLbl.textColor = [UIColor whiteColor];
    genLbl.textAlignment = NSTextAlignmentRight;
    genLbl.numberOfLines = 2;
    genLbl.userInteractionEnabled = NO;
    [genBtn addSubview:genLbl];

    if (@available(iOS 13, *)) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 24, 24)];
        iv.image = [[UIImage systemImageNamed:@"arrow.clockwise"]
                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iv.tintColor = [UIColor whiteColor];
        iv.userInteractionEnabled = NO;
        [genBtn addSubview:iv];
    }
    [card addSubview:genBtn];

    // Separator
    UIView *s2 = [[UIView alloc] initWithFrame:CGRectMake(0, 123, w, 0.5)];
    s2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.12];
    [card addSubview:s2];

    // Clear button
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.frame = CGRectMake(0, 123, w, 60);
    [clearBtn addTarget:self action:@selector(doClear) forControlEvents:UIControlEventTouchUpInside];

    UILabel *clearLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, w-60, 60)];
    clearLbl.text = @"مسح البيانات وتوليد معرّف جديد";
    clearLbl.font = [UIFont systemFontOfSize:14];
    clearLbl.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    clearLbl.textAlignment = NSTextAlignmentRight;
    clearLbl.numberOfLines = 2;
    clearLbl.userInteractionEnabled = NO;
    [clearBtn addSubview:clearLbl];

    if (@available(iOS 13, *)) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 24, 24)];
        iv.image = [[UIImage systemImageNamed:@"trash"]
                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iv.tintColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
        iv.userInteractionEnabled = NO;
        [clearBtn addSubview:iv];
    }
    [card addSubview:clearBtn];

    // Copyright
    UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, w, 20)];
    copy.text = @"© حقوق التراث ستور";
    copy.font = [UIFont systemFontOfSize:10];
    copy.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    copy.textAlignment = NSTextAlignmentCenter;
    [card addSubview:copy];
}

- (void)showInfo {
    NSString *uuid = getOrCreateUUID();
    UIAlertController *a = [UIAlertController
        alertControllerWithTitle:@"هوية الجهاز (UUID)"
        message:[NSString stringWithFormat:
            @"معرّف جهازك النشط حالياً هو:\n\n%@\n\nهذا المعرّف يخفي البصمة الحقيقية لجهازك لتجاوز حظر الأجهزة على انستقرام. توليد معرّف جديد سيمنحك هوية جديدة كلياً.\n\n© حقوق التراث ستور", uuid]
        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"نسخ المعرّف"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *x) {
            [UIPasteboard generalPasteboard].string = uuid;
        }]];
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً"
        style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)doGenerate {
    generateNewUUID();
    [self dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4*NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{ exit(0); });
}

- (void)doClear {
    [[NSUserDefaults standardUserDefaults]
        removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    generateNewUUID();
    [self dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4*NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{ exit(0); });
}

- (void)dismiss {
    gMenuWindow.hidden = YES;
    gMenuWindow = nil;
}

@end

// ============================
// Floating Button
// ============================
@interface TiraathFloat : UIViewController
@end

@implementation TiraathFloat

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 52, 52);
    btn.layer.cornerRadius = 26;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.85];
    btn.layer.borderColor = [UIColor colorWithRed:0.25 green:0.65 blue:1.0 alpha:0.9].CGColor;
    btn.layer.borderWidth = 2;

    UILabel *ic = [[UILabel alloc] initWithFrame:btn.bounds];
    ic.text = @"🌐";
    ic.textAlignment = NSTextAlignmentCenter;
    ic.font = [UIFont systemFontOfSize:26];
    ic.userInteractionEnabled = NO;
    [btn addSubview:ic];

    [btn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(onDrag:)];
    [btn addGestureRecognizer:pan];

    [self.view addSubview:btn];
}

- (void)onTap {
    if (gMenuWindow) {
        gMenuWindow.hidden = YES;
        gMenuWindow = nil;
        return;
    }

    UIWindow *mw = nil;
    if (@available(iOS 13, *)) {
        if (gFloatingWindow.windowScene) {
            mw = [[UIWindow alloc] initWithWindowScene:gFloatingWindow.windowScene];
        }
    }
    if (!mw) mw = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    mw.frame = [UIScreen mainScreen].bounds;
    mw.windowLevel = UIWindowLevelAlert + 90;
    mw.backgroundColor = [UIColor clearColor];
    mw.rootViewController = [[TiraathMenu alloc] init];
    mw.hidden = NO;
    gMenuWindow = mw;
}

- (void)onDrag:(UIPanGestureRecognizer *)g {
    CGPoint d = [g translationInView:g.view.superview];
    CGRect f = gFloatingWindow.frame;
    CGSize s = [UIScreen mainScreen].bounds.size;
    f.origin.x = MAX(0, MIN(f.origin.x + d.x, s.width  - f.size.width));
    f.origin.y = MAX(40, MIN(f.origin.y + d.y, s.height - f.size.height - 20));
    gFloatingWindow.frame = f;
    [g setTranslation:CGPointZero inView:g.view.superview];
}

@end

// ============================
// UUID Hook
// ============================
%hook UIDevice
- (NSUUID *)identifierForVendor {
    return [[NSUUID alloc] initWithUUIDString:getOrCreateUUID()];
}
%end

// ============================
// Create window when app is active
// ============================
static void createWindow() {
    if (gCreated) return;
    gCreated = YES;

    UIWindow *win = nil;
    if (@available(iOS 13, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] &&
                scene.activationState == UISceneActivationStateForegroundActive) {
                win = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
                break;
            }
        }
    }
    if (!win) {
        win = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
    }

    win.frame = CGRectMake(20, 200, 52, 52);
    win.windowLevel = UIWindowLevelStatusBar + 200;
    win.backgroundColor = [UIColor clearColor];
    win.rootViewController = [[TiraathFloat alloc] init];
    win.hidden = NO;
    gFloatingWindow = win;
}

%hook UIApplication
- (void)applicationDidBecomeActive:(UIApplication *)app {
    %orig;
    dispatch_async(dispatch_get_main_queue(), ^{ createWindow(); });
}
%end
