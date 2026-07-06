#import <UIKit/UIKit.h>
#import <substrate.h>

static NSString *tiraathGetUUID() {
    @try {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ud stringForKey:@"TiraathFakeUUID"];
        if (!uuid || uuid.length < 36) {
            uuid = [[NSUUID UUID] UUIDString];
            [ud setObject:uuid forKey:@"TiraathFakeUUID"];
            [ud synchronize];
        }
        return uuid;
    } @catch (...) {
        return @"4ABEF3F0-E8B6-4807-AA98-D3F2CA40B763";
    }
}

static void tiraathNewUUID() {
    @try {
        [[NSUserDefaults standardUserDefaults]
            setObject:[[NSUUID UUID] UUIDString] forKey:@"TiraathFakeUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } @catch (...) {}
}

static UIWindow *gBtnWindow  = nil;
static UIWindow *gMenuWindow = nil;
static BOOL      gDone       = NO;
@interface TiraathMenuVC : UIViewController
@end
@implementation TiraathMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *bg = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(closeMenu)];
    [self.view addGestureRecognizer:bg];

    CGRect scr = [UIScreen mainScreen].bounds;
    CGFloat cw = MIN(scr.size.width - 60, 290), ch = 255;
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(
        (scr.size.width-cw)/2, (scr.size.height-ch)/2, cw, ch)];
    card.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.13 alpha:0.97];
    card.layer.cornerRadius = 18;
    card.clipsToBounds = YES;
    [card addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    [self.view addSubview:card];

    NSString *uuid = tiraathGetUUID();

    // UUID title
    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(cw-170, 15, 155, 18)];
    t1.text = @"المعرّف الحالي:";
    t1.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    t1.textColor = [UIColor whiteColor];
    t1.textAlignment = NSTextAlignmentRight;
    [card addSubview:t1];

    // UUID value
    UILabel *t2 = [[UILabel alloc] initWithFrame:CGRectMake(cw-170, 35, 155, 18)];
    t2.text = [NSString stringWithFormat:@"...%@", [uuid substringToIndex:8]];
    t2.font = [UIFont fontWithName:@"Courier" size:13];
    t2.textColor = [UIColor colorWithRed:0.35 green:0.75 blue:1 alpha:1];
    t2.textAlignment = NSTextAlignmentRight;
    [card addSubview:t2];

    // Info button
    UIButton *ib = [UIButton buttonWithType:UIButtonTypeSystem];
    ib.frame = CGRectMake(8, 12, 32, 32);
    if (@available(iOS 13,*)) {
        [ib setImage:[[UIImage systemImageNamed:@"info.circle"]
            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:0];
        ib.tintColor = [UIColor whiteColor];
    }
    [ib addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:ib];

    CGFloat y = 62;
    // صف 1
    [card addSubview:[self sep:CGRectMake(0,y,cw,0.5)]]; y+=0.5;
    [card addSubview:[self row:CGRectMake(0,y,cw,60) title:@"توليد معرّف جديد وإعادة التشغيل"
        color:[UIColor whiteColor] icon:@"arrow.clockwise" sel:@selector(doGenerate)]]; y+=60;
    // صف 2
    [card addSubview:[self sep:CGRectMake(0,y,cw,0.5)]]; y+=0.5;
    [card addSubview:[self row:CGRectMake(0,y,cw,60) title:@"مسح البيانات وتوليد معرّف جديد"
        color:[UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1] icon:@"trash"
        sel:@selector(doClear)]]; y+=60;
    // صف 3 — تليغرام
    [card addSubview:[self sep:CGRectMake(0,y,cw,0.5)]]; y+=0.5;
    [card addSubview:[self row:CGRectMake(0,y,cw,48) title:@"قناة التراث ستور على تليغرام"
        color:[UIColor colorWithRed:0.2 green:0.6 blue:1 alpha:1] icon:@"paperplane.fill"
        sel:@selector(openTelegram)]];

    // حقوق
    UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(0, ch-22, cw, 18)];
    copy.text = @"© حقوق التراث ستور";
    copy.font = [UIFont systemFontOfSize:10];
    copy.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    copy.textAlignment = NSTextAlignmentCenter;
    [card addSubview:copy];
}

- (UIView *)sep:(CGRect)f {
    UIView *v = [[UIView alloc] initWithFrame:f];
    v.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    return v;
}

- (UIButton *)row:(CGRect)f title:(NSString *)t color:(UIColor *)c
              icon:(NSString *)icon sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = f;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(50,0,f.size.width-60,f.size.height)];
    l.text = t; l.font = [UIFont systemFontOfSize:14]; l.textColor = c;
    l.textAlignment = NSTextAlignmentRight; l.numberOfLines = 2; l.userInteractionEnabled = NO;
    [btn addSubview:l];
    if (@available(iOS 13,*)) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(12,(f.size.height-24)/2,24,24)];
        iv.image = [[UIImage systemImageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iv.tintColor = c; iv.userInteractionEnabled = NO;
        [btn addSubview:iv];
    }
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)closeMenu { gMenuWindow.hidden = YES; gMenuWindow = nil; }

- (void)showInfo {
    NSString *uuid = tiraathGetUUID();
    UIAlertController *a = [UIAlertController
        alertControllerWithTitle:@"هوية الجهاز (UUID)"
        message:[NSString stringWithFormat:
            @"معرّف جهازك النشط حالياً هو:\n\n%@\n\n"
            "هذا المعرّف يخفي البصمة الحقيقية لجهازك "
            "لتجاوز حظر الأجهزة على انستقرام.\n\n© حقوق التراث ستور", uuid]
        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"نسخ المعرّف"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *x){
            [UIPasteboard generalPasteboard].string = uuid; }]];
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً"
        style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)doGenerate {
    tiraathNewUUID(); [self closeMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.3*NSEC_PER_SEC)),
        dispatch_get_main_queue(),^{ exit(0); });
}

- (void)doClear {
    @try { [[NSUserDefaults standardUserDefaults]
        removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    } @catch(...){}
    tiraathNewUUID(); [self closeMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.3*NSEC_PER_SEC)),
        dispatch_get_main_queue(),^{ exit(0); });
}

- (void)openTelegram {
    NSURL *url = [NSURL URLWithString:@"https://t.me/turath_st/"];
    if (@available(iOS 10,*)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else { [[UIApplication sharedApplication] openURL:url]; }
}
@end
@interface TiraathBtnVC : UIViewController
@end
@implementation TiraathBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,0,52,52);
    btn.layer.cornerRadius = 26; btn.clipsToBounds = YES;
    btn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.85];
    btn.layer.borderColor = [UIColor colorWithRed:0.25 green:0.65 blue:1 alpha:0.9].CGColor;
    btn.layer.borderWidth = 2;
    UILabel *ic = [[UILabel alloc] initWithFrame:btn.bounds];
    ic.text = @"🌐"; ic.textAlignment = NSTextAlignmentCenter;
    ic.font = [UIFont systemFontOfSize:26]; ic.userInteractionEnabled = NO;
    [btn addSubview:ic];
    [btn addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(dragged:)];
    [btn addGestureRecognizer:pan];
    [self.view addSubview:btn];
}

- (void)tapped {
    if (gMenuWindow && !gMenuWindow.hidden) {
        gMenuWindow.hidden = YES; gMenuWindow = nil; return;
    }
    @try {
        UIWindow *mw = nil;
        if (@available(iOS 13,*))
            mw = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)gBtnWindow.windowScene];
        if (!mw) mw = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        mw.frame = [UIScreen mainScreen].bounds;
        mw.windowLevel = UIWindowLevelAlert + 90;
        mw.backgroundColor = [UIColor clearColor];
        mw.rootViewController = [[TiraathMenuVC alloc] init];
        mw.hidden = NO;
        gMenuWindow = mw;
    } @catch (NSException *e) {}
}

- (void)dragged:(UIPanGestureRecognizer *)g {
    CGPoint d = [g translationInView:self.view];
    CGRect f = gBtnWindow.frame;
    CGSize s = [UIScreen mainScreen].bounds.size;
    f.origin.x = MAX(0, MIN(f.origin.x+d.x, s.width-52));
    f.origin.y = MAX(44, MIN(f.origin.y+d.y, s.height-80));
    gBtnWindow.frame = f;
    [g setTranslation:CGPointZero inView:self.view];
}
@end

// Hook تزوير UUID
%hook UIDevice
- (NSUUID *)identifierForVendor {
    @try { return [[NSUUID alloc] initWithUUIDString:tiraathGetUUID()]; }
    @catch (...) { return %orig; }
}
%end

// إنشاء النافذة العائمة
static void tiraathCreateWindow() {
    if (gDone) return;
    gDone = YES;
    @try {
        UIWindow *win = nil;
        if (@available(iOS 13,*)) {
            for (UIScene *sc in [UIApplication sharedApplication].connectedScenes) {
                if ([sc isKindOfClass:[UIWindowScene class]] &&
                    sc.activationState == UISceneActivationStateForegroundActive) {
                    win = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)sc];
                    break;
                }
            }
        }
        if (!win) win = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,52,52)];
        win.frame = CGRectMake(20, 220, 52, 52);
        win.windowLevel = UIWindowLevelStatusBar + 300;
        win.backgroundColor = [UIColor clearColor];
        win.rootViewController = [[TiraathBtnVC alloc] init];
        win.hidden = NO;
        gBtnWindow = win;
    } @catch (NSException *e) { gDone = NO; }
}

%ctor {
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationDidBecomeActiveNotification
                    object:nil queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *n){ tiraathCreateWindow(); }];
}
