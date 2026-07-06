#import <UIKit/UIKit.h>
#import <substrate.h>

// ============================
// UUID Management
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
// Floating Menu Controller
// ============================
@interface TiraathMenuController : UIViewController
@end

@implementation TiraathMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    // خلفية شبه شفافة للإغلاق عند الضغط خارج المنيو
    UIView *dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    dimView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
    dimView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [dimView addGestureRecognizer:tap];
    [self.view addSubview:dimView];

    // بطاقة المنيو
    CGFloat cardW = 270;
    CGFloat cardH = 220;
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    UIView *card = [[UIView alloc] initWithFrame:CGRectMake((screenW - cardW) / 2,
                                                             (screenH - cardH) / 2,
                                                             cardW, cardH)];
    card.backgroundColor = [UIColor colorWithWhite:0.13 alpha:0.97];
    card.layer.cornerRadius = 18;
    card.clipsToBounds = YES;
    [self.view addSubview:card];

    // UUID label
    NSString *uuid = getOrCreateUUID();
    NSString *shortUUID = [uuid substringToIndex:8];

    UILabel *uuidTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, cardW - 50, 18)];
    uuidTitle.text = @"المعرّف الحالي:";
    uuidTitle.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    uuidTitle.textColor = [UIColor whiteColor];
    uuidTitle.textAlignment = NSTextAlignmentRight;
    [card addSubview:uuidTitle];

    UILabel *uuidValue = [[UILabel alloc] initWithFrame:CGRectMake(15, 33, cardW - 50, 18)];
    uuidValue.text = [NSString stringWithFormat:@"...%@", shortUUID];
    uuidValue.font = [UIFont fontWithName:@"Courier" size:13];
    uuidValue.textColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
    uuidValue.textAlignment = NSTextAlignmentRight;
    [card addSubview:uuidValue];

    // زر info
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    infoBtn.frame = CGRectMake(cardW - 42, 15, 30, 30);
    if (@available(iOS 13.0, *)) {
        [infoBtn setImage:[[UIImage systemImageNamed:@"info.circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                 forState:UIControlStateNormal];
    } else {
        [infoBtn setTitle:@"ⓘ" forState:UIControlStateNormal];
    }
    infoBtn.tintColor = [UIColor whiteColor];
    [infoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:infoBtn];

    // فاصل
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, 65, cardW, 0.5)];
    sep1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
    [card addSubview:sep1];

    // زر: توليد معرّف جديد
    UIButton *genBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    genBtn.frame = CGRectMake(0, 65, cardW, 60);
    genBtn.tintColor = [UIColor whiteColor];

    UILabel *genLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cardW - 55, 60)];
    genLabel.text = @"توليد معرّف جديد وإعادة التشغيل";
    genLabel.font = [UIFont systemFontOfSize:14];
    genLabel.textColor = [UIColor whiteColor];
    genLabel.textAlignment = NSTextAlignmentRight;
    genLabel.userInteractionEnabled = NO;
    [genBtn addSubview:genLabel];

    if (@available(iOS 13.0, *)) {
        UIImageView *refreshIcon = [[UIImageView alloc] initWithFrame:CGRectMake(cardW - 45, 18, 22, 22)];
        refreshIcon.image = [[UIImage systemImageNamed:@"arrow.clockwise"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        refreshIcon.tintColor = [UIColor whiteColor];
        refreshIcon.userInteractionEnabled = NO;
        [genBtn addSubview:refreshIcon];
    }

    [genBtn addTarget:self action:@selector(generateAndRestart) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:genBtn];

    // فاصل
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, 125, cardW, 0.5)];
    sep2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
    [card addSubview:sep2];

    // زر: مسح البيانات
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.frame = CGRectMake(0, 125, cardW, 60);

    UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cardW - 55, 60)];
    clearLabel.text = @"مسح البيانات وتوليد معرّف جديد";
    clearLabel.font = [UIFont systemFontOfSize:14];
    clearLabel.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    clearLabel.textAlignment = NSTextAlignmentRight;
    clearLabel.userInteractionEnabled = NO;
    [clearBtn addSubview:clearLabel];

    if (@available(iOS 13.0, *)) {
        UIImageView *trashIcon = [[UIImageView alloc] initWithFrame:CGRectMake(cardW - 45, 18, 22, 22)];
        trashIcon.image = [[UIImage systemImageNamed:@"trash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        trashIcon.tintColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
        trashIcon.userInteractionEnabled = NO;
        [clearBtn addSubview:trashIcon];
    }

    [clearBtn addTarget:self action:@selector(clearAndRestart) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:clearBtn];

    // نص الحقوق
    UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(0, 195, cardW, 20)];
    copyright.text = @"© حقوق التراث ستور";
    copyright.font = [UIFont systemFontOfSize:10];
    copyright.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    copyright.textAlignment = NSTextAlignmentCenter;
    [card addSubview:copyright];
}

- (void)showInfo {
    NSString *uuid = getOrCreateUUID();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"هوية الجهاز (UUID)"
        message:[NSString stringWithFormat:@"معرّف جهازك النشط حالياً هو:\n\n%@\n\n© حقوق التراث ستور", uuid]
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"نسخ المعرّف"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
            [UIPasteboard generalPasteboard].string = uuid;
        }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"حسناً"
        style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)generateAndRestart {
    generateNewUUID();
    [self dismissMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{ exit(0); });
}

- (void)clearAndRestart {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    generateNewUUID();
    [self dismissMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{ exit(0); });
}

- (void)dismissMenu {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

// ============================
// Floating Button Controller
// ============================
@interface TiraathFloatingController : UIViewController
@property (nonatomic, strong) UIButton *floatingBtn;
@end

@implementation TiraathFloatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    self.floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingBtn.frame = CGRectMake(0, 0, 52, 52);
    self.floatingBtn.layer.cornerRadius = 26;
    self.floatingBtn.clipsToBounds = YES;
    self.floatingBtn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.88];
    self.floatingBtn.layer.borderColor = [UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:0.9].CGColor;
    self.floatingBtn.layer.borderWidth = 1.8;

    UILabel *iconLbl = [[UILabel alloc] initWithFrame:self.floatingBtn.bounds];
    iconLbl.text = @"🌐";
    iconLbl.textAlignment = NSTextAlignmentCenter;
    iconLbl.font = [UIFont systemFontOfSize:26];
    iconLbl.userInteractionEnabled = NO;
    [self.floatingBtn addSubview:iconLbl];

    [self.floatingBtn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:)];
    [self.floatingBtn addGestureRecognizer:pan];

    [self.view addSubview:self.floatingBtn];
}

- (void)onTap {
    TiraathMenuController *menu = [[TiraathMenuController alloc] init];
    menu.modalPresentationStyle = UIModalPresentationOverFullScreen;
    menu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    UIViewController *top = self;
    while (top.presentedViewController) top = top.presentedViewController;
    [top presentViewController:menu animated:YES completion:nil];
}

- (void)onDrag:(UIPanGestureRecognizer *)g {
    UIWindow *win = self.view.window;
    CGPoint delta = [g translationInView:g.view.superview];
    CGRect f = win.frame;
    f.origin.x += delta.x;
    f.origin.y += delta.y;

    // تقييد داخل الشاشة
    CGSize screen = [UIScreen mainScreen].bounds.size;
    f.origin.x = MAX(0, MIN(f.origin.x, screen.width - f.size.width));
    f.origin.y = MAX(50, MIN(f.origin.y, screen.height - f.size.height - 30));

    win.frame = f;
    [g setTranslation:CGPointZero inView:g.view.superview];
}

@end

// ============================
// Hook: تزوير UUID
// ============================
%hook UIDevice

- (NSUUID *)identifierForVendor {
    return [[NSUUID alloc] initWithUUIDString:getOrCreateUUID()];
}

%end

// ============================
// Constructor: تشغيل الزر العائم
// ============================
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{

        __block UIWindow *floatWin = nil;

        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    floatWin = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
                    break;
                }
            }
        }

        if (!floatWin) {
            floatWin = [[UIWindow alloc] initWithFrame:CGRectMake(20, 200, 52, 52)];
        } else {
            floatWin.frame = CGRectMake(20, 200, 52, 52);
        }

        floatWin.windowLevel = UIWindowLevelAlert + 100;
        floatWin.backgroundColor = [UIColor clearColor];
        floatWin.rootViewController = [[TiraathFloatingController alloc] init];
        floatWin.hidden = NO;

        // الاحتفاظ بالمرجع لمنع الحذف من الذاكرة
        static UIWindow *_keepAlive;
        _keepAlive = floatWin;
    });
}
