#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// اللوغو (100×100 RGBA PNG مضغوط بصيغة Base64)
static NSString *kTiraathLogoB64 =
    @"iVBORw0KGgoAAAANSUhEUgAAAGQAAABjCAYAAABt56XsAAAAIGNIUk0AAHomAACAhAAA+gAAAIDo"
    @"AAB1MAAA6mAAADqYAAAXcJy6UTwAAAAGYktHRAAAAAAAAPlDu38AAAAJcEhZcwAACxIAAAsSAdLd"
    @"fvwAAAAHdElNRQfqBwYROzt8Hd7TAAAEknpUWHRSYXcgcHJvZmlsZSB0eXBlIHhtcAAASImdV1m2"
    @"6ygM/NcqegmAENjL8fXw1+e8z7f8rhKekthJbicnCQEhVWkCy99//8g/eMW+z6Jj7XSoXZlqKFOx"
    @"mktMgf/LWOaqXNMppRJLLktJxXRo87v0klIKcqjB5A+3WJcnCylkLUvFxhS0pFmDf5LOYUiBb0BI"
    @"UF50sJSz5PJkvy0SQ1cz3kEH2Fyqv9JcIZRmN1HTolF7vtMiGjRhIuF7akrwq7WHWsCuXZpogMsH"
    @"lmdEOReTqkUx0Tu1Hl6YgXAVgF8SbMMTRAhHPCg6v2snBym4roOqC1qOaT7cjTH8VyasrHtILboT"
    @"l/f2zjFkYF6Nyb01bIk10KHfmDpRcx+V31Hb9vwfaqF0hQoWhImjlaZ8afll+zNl+Yxhi0w26y5o"
    @"K1OnRIHVgfqPQP6WLPCrTvJSCgEJmMp4lAEFaQgbjYXKnIcLmkEvWeb8BTUd99QcWLhQAJWmJAAi"
    @"ptiu48GhScmr2BWhs3IL8EpHhOgTDL+jZK15hbmdhEoOj9autx27NrPyhd3+SoGb7VQ3s/Ldtmu6"
    @"a90NeaKPPMkrt0ckHF2Z2KPQFSf8Vv8uln12AAJ0VHQed/cHRR+ss3uZyzJIrAHEVWchKbQ2xVJC"
    @"AzvbudlybUj2mkcLh9M8b9gTm3cMnoL3shMej2p/lZZH8Rta+/bMbO9bdjvWPYbyaOdO8JMB6+SK"
    @"ECxUP1viE53uWvqyjTzY6b83I/fiN3ReOyTPtcio2SnQVvKvUnJXK496r9S+7wbeN5FzgubBWwVu"
    @"G4hYRRpgnOc2q3P9STyF1UDESWv5oYShk5elVYVHOaND8iBCVhua/bhvS94NUchch3CE/7RJQLIv"
    @"mfP4RBAFB02SU7ac4QfTnKN7JGO55IhRB690cM6EmYp5vgrXCC9jG15UjduCrJbxTfh+ZUjslIww"
    @"Ivpjk4ueVhoWd3FHmk2ZvHA/YPdA1GdTt50NuEBBY2Y0id7UUWNN1SRNGHAYQJG/0AORznHTZyPi"
    @"B2PmQWauNTPbP2v5hDwKxYCDIef5mZ6JuOCOksZghjgDzBaHAYyKEiFM776cBJ3krleGAA6lcwPp"
    @"eDoWW9ztnbsdCvFNByStonWl0Oq+4jOv7qwMOo9FJEe/Ys3MOHZzHl+eJLgf1N6Q2S1HrEXDE3Di"
    @"3RF0Oc8SiFyBY0dfg6GXtZBGcSztcERrq7yjhk0l/dc81foTMLo5xg7HdYZsdIoIjuCP+RWXvug1"
    @"rzQJPBKnLe1CCgq55Zab6DckGFeOZTtffao7lksbr8dgnep0mNjRn7DLW/BoJQ49smjwCx9jlKE6"
    @"P2OX78G/xy4fwPPx4CvXCwCzgpI7u6O7nYB5qsXvXS+/gX9Gv+Iv7KMsI7ltHDwO0PmumgtWf4wy"
    @"xbPe7yy4+du4Za49FSwYjptyIEh1Ol/Ctm7d2rLcdeubls8b7FAerhc3B+R+fm1Ph0QWrxWf33Js"
    @"QZ33OrMQC/peyevJ9bB6r07Owu+su3duiZ2onRXy0fL1yfL8WHwyntgAcWMLQ7ulPT+y+23+P7xq"
    @"naFlA8wCAAAAAW9yTlQBz6J3mgAAF6lJREFUeNrtnWlwHMd1x389s7u4QYAkiMVNggQJiuSCEg9R"
    @"lyWVRcpXRF0+VJYl2aoktmzFkRV/SKXKiZMPSZXjHJVKylXxKduyY0eSLckybYuOREbiTYKHQIAg"
    @"RBLESYAkLmJ3gZ3ufOiZ2dklIOJY7BKK/6qlFjO9PTPvP93v9evXrwUZRii0frJT2UAZsBxYbX+W"
    @"A5XAYmABkDXJb6PAINAPdABtwEn70wZ0A5GJfnjsWGNG5SEycdFQKAQYyYcNIAiEgFuAjcBKYAmQ"
    @"P9EPpgkJjAAXgFPAQWAPcAzosc8nFD927FjaZZNWQiZpDRXAbcCH0UQsZfI3P9WIAmfRxPwaeAvo"
    @"TC6UzlaTFkImICIL3QIeQhOxAvCl7aknRgw4jSbmBXQLinoLpIOYOSVkAiLygQ8CTwB3AUVz/oQz"
    @"wwDwBvB9YCe6q3Mxl8TMCSEbNmxgfNzyHsoB7gU+D9yJVtjzARHgTeBbwG+AsHPC7zc5dOhQyi+Y"
    @"ckKSWoUAbgWeAT6CJmY+Igy8Bvwz8DagnBOpbi0pJSSJjArgaeBJtJn6fkA/8B3g3/Ao/1SSkhJC"
    @"kogw0K3hr9GK+/2Ig8DX0a3GNZdTQYw52wqSyFgI/BXwD0BtWkWUXpQDH0UbKY3YuqW0NEhvb8+s"
    @"Kp4VIUlk3AD8B7qLmi9KezbIBu4A1qJJ6YPZkzJjQpLI2IruW2/LtJQygJVoE74VeBdmR8qMCHHI"
    @"EAIBfBrdMt7PXdS1sAS4B+gRghMwc1KmTYinZRjAF4B/4v1jRc0GBehB7xBwCFAzIWVahCSR8TRa"
    @"eRdkWhLXEbLR3dcIcIAZkDJlQhwylEIIwVPA3wN5mZbAdYgAWtkPKMVBIabXfU2JEK8CF4LPAN/k"
    @"Dy3jvRAAbheCDrR7f8qkXJOQJGvqQ2gFvijTTzwPkIV2G51Ae5GnRMp7EtLQsN785zq0abs00086"
    @"j5CP9lbsQk+MEQy+NynvOQehXBcai4FvAPUzuSulFFLKmfz0uoMQAsOY1uRlPVp2jwL9HplOXP9k"
    @"JzxdlYlW4F+dyQMopSgoKGTLLVvIyc62j4F2mAo8jlOco5Oc8paIn/KWSXoakXzQrlMI597ilTjf"
    @"hX1SoRB4v4MwDFpbT9N8ssktNw18A/hLwILJ/V4TtpCGhgaUcqTCdvR4Y0ZQSlEaLOWrzz5LUXER"
    @"SnlbyqRSn6Qyj3y93yc6561eTHItTznnRZioqFL6hM/n57kf/piTTU1Mnw++AOwFXgRFQ0MDR48e"
    @"nRohSrlXqwG+hu4LZwwhhP2QKv63KxAxgfAmIMJTVL+uk5R3q9YnhV1WFxdX1+Xe49XH4lwKlFIo"
    @"pabbXXmRb8vyEIhzk3VdV9WeNPh7BmiYDRnOk1mWZcsh/nDK8xoq5w6V5k1/nHLeqtTVb6/SxxXJ"
    @"9XrrVPFrOMeIf3Rd8friV7O7KwFSytnqwgZbpkaSrCcnxIO7gMdnTYb9WIZh6K5B2f21ip9Trl5I"
    @"oOiqOhLKOb9XIJWM12eTKez/XJI8rVE5xHro8JLlvRYKpP170zRnojuS8bgt2wmR0GV5GMsHvkKK"
    @"ghCUgljMYnw8hpQWTh8S73WSFcNE/UqiYlC2y8ARknIuZP/PUhIpFVJamiBDeK4TV9QkXRm7BQuP"
    @"MpFK2T1uUiubGYps2e4HRkKh9QkKfjKz96Nol/qsIYSgu7ubr/3N3xIIBPTDxk/Gy5HcJrzHlOeY"
    @"/ZYrhenz8eRnn2DtmtXEYhaOCSWl4rkfPc/RxkabeOG5lprYIEi+qP075S2voKurC2HMupVstWX8"
    @"X8knXEI8rWMB2iIIpIqQ0SsjHNi3JxXVJd68z8d9H/sIitXE1bgm68Tx4+x68w18vllPil71PLNQ"
    @"7A4CaBnvAAa9rWSiFvIhdARhSh/CNFMrGNB9uiJulsZbj0QIgc9nzsl1U4Rb0LJOaCUGJLhIctFK"
    @"JyWtIx1QMq43HBNNSnV1/3f9IYCWdS7EOTDiDwPAFrTreB4hbi0pFbee1DxgBC3rLRDnwNsZCuBh"
    @"ZjkInCs4/jDLspIsHZE0bvE+jobzOyllKqykVCIfLXP3Zn0eZV4NbMv0HXrhCNDn81O4oICSxSUU"
    @"GAM96J8tGZBiYSWN6hcBfwx8kRS77zOIDuDfgf8ELjoHU0GEg5QuY0vqwsLoiLzfo9Og1jJ/xyyD"
    @"6MzTX0bHUYWdE6kkA+awO0lqLT60H+zz6LTaaU8JNUMMoV3m30L7o9zY51QT4WBO+/d16xqS/UjO"
    @"hr2PoYkJzqTeNKAHTcRzwNvo9RuA9kAfP350pvVeE2lRuBPs12cCa9C7iN5nf095yNE0EQbeAV4G"
    @"fml/94ajzFmr8CKtFtBEGykCC4FNwL3oKJeVpG+v9mH02r5daJP9AHApuVA6iHCQMZP0PcipBzaj"
    @"SboBPfpfwOxz04+hlXMnOnjjANo8bybDJHiR8THC2rUNCVmnPTDRpnMNutWsQqfjrkJngS5Cz8lk"
    @"EbcWLXR/P4oeqPYC59EbzLegW8M5tMlqJV9QSsWJE3OnH6aC/wMjXk8D9oCGwgAAA65lWElmTU0A"
    @"KgAAAAgACAESAAMAAAABAAEAAAEaAAUAAAABAAAAbgEbAAUAAAABAAAAdgEoAAMAAAABAAIAAAEx"
    @"AAIAAAAIAAAAfgEyAAIAAAAUAAAAhgE7AAIAAAAHAAAAmodpAAQAAAABAAAAogAAAAAAAABIAAAA"
    @"AQAAAEgAAAABUGljc2FydAAyMDI2OjA3OjA2IDIwOjM4OjYxAGhhbThkMQAAAAWQAwACAAAAFAAA"
    @"AOSgAQADAAAAAQABAACgAgAEAAAAAQAABQqgAwAEAAAAAQAABQOkMAACAAACtQAAAPgAAAAAMjAy"
    @"NjowNzowNiAyMDozODo2MQB7ImlzX3N0aWNrZXJfbW9kaWZpZWQiOnRydWUsImlzX3JlbWl4Ijpm"
    @"YWxzZSwidWlkIjoiMTg1QzJCRUQtNTRBNy00MTZBLTgwOEMtMTc0MzM2NkE3RkRCIiwicHJlbWl1"
    @"bV9zb3VyY2VzIjpbXSwic291cmNlIjoib3RoZXIiLCJzdGlja2VyX2lkIjoiOTg5RTZEQkUtMzIx"
    @"Ri00QTUxLThCQzUtQkJDMEVCQzZCNThEIiwibGFzdF90b29sIjoidG9vbF9zaGFwZV9jcm9wIiwi"
    @"c291cmNlX3NpZCI6IkVCNTlFMEJGLUJBRjAtNEI4My1COTJELTNFREZDNjAxRjIwNl8xNzgzMzU5"
    @"Mzk4Mjc3Iiwib3JpZ2luIjoiZ2FsbGVyeSIsInRyYW5zcGFyZW5jeV92YWx1ZSI6eyJtYXhfYWxw"
    @"aGEiOjEsIm1pbl9hbHBoYSI6MCwib3BhY2l0eTkwIjp7InBlcmNlbnRhZ2UiOjIxLjQ5MTM1NTg5"
    @"NTk5NjA5NCwib3BhcXVlX2JvdW5kcyI6eyJ5IjowLCJ3IjoxMjkwLCJ4IjowLCJoIjoxMjgzfX0s"
    @"Im9wYWNpdHkwIjp7InBlcmNlbnRhZ2UiOjIxLjI2MzUxMTY1NzcxNDg0NCwib3BhcXVlX2JvdW5k"
    @"cyI6eyJ5IjowLCJ3IjoxMjkwLCJ4IjowLCJoIjoxMjgzfX0sIm9wYWNpdHk5OSI6eyJwZXJjZW50"
    @"YWdlIjoyMS41MzIyNjA4OTQ3NzUzOTEsIm9wYXF1ZV9ib3VuZHMiOnsieSI6MCwidyI6MTI5MCwi"
    @"eCI6MCwiaCI6MTI4M319fSwiZnRlX3NvdXJjZXMiOltdLCJ1c2VkX3NvdXJjZXMiOiJ7XCJ2ZXJz"
    @"aW9uXCI6MSxcInNvdXJjZXNcIjpbXX0ifQAARG8E3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyNi0w"
    @"Ny0wNlQxNzo1NDowOCswMDowMMzte6wAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjYtMDctMDZUMTc6"
    @"NTQ6MDgrMDA6MDC9sMMQAAAAKHRFWHRkYXRlOnRpbWVzdGFtcAAyMDI2LTA3LTA2VDE3OjU5OjU4"
    @"KzAwOjAwV7tnGwAAABJ0RVh0ZXhpZjpBcnRpc3QAaGFtOGQxGnwZSAAAAZR6VFh0ZXhpZjpDYW1l"
    @"cmFPd25lck5hbWUAACiRpZLZjtsgGIXfheswYl9yZ7y8RFMh6pAEjbeCPU0U5d2LPZNWleammis4"
    @"P+d8P9sdhGTTHNpXH20/HsMp+CPYz3Hxu3Up+j5cwf7kupQLS8hrACteElNXkLNCQoZFARVSJcSS"
    @"USpEIZvKgB2Y1uzS2zQusfUJ7L9934F3kSHjfPExu569N7JWuhaVqSEluIGs4BgqU3JoTIlqUwrD"
    @"VZUznUuzncexy5F1sOniJm/bOE7g2cKmjVgbrmtkGmiKBkFmFIVGkwrSumpKgXBDkLBYKkq5ploR"
    @"KTNhjOEchpw+u67z8ZZLc3RDmlz0Q3uzb65b8hnuoHdX67rp4sAe70AfhqdCGTK5Nsw3jVbj5POW"
    @"htmdc4zgF6Yx5VxprrVAmm3mn4u3P8ZlOKY1cNsYvzKX6Dy5bvKySkUfjz/0z+BEUI6x4FJiptgX"
    @"4Fp/QueUEIGUZlJyqvF/0zP+NPt/P8WS/PFvBdwP4M3HFMbhsN7r4eNF02F1P8DjNw7P0AZtXXnX"
    @"AAAAEXRFWHRleGlmOkNvbG9yU3BhY2UAMQ+bAkkAAAAhdEVYdGV4aWY6RGF0ZVRpbWUAMjAyNjow"
    @"NzowNiAyMDozODo2MV+bf7EAAAApdEVYdGV4aWY6RGF0ZVRpbWVPcmlnaW5hbAAyMDI2OjA3OjA2"
    @"IDIwOjM4OjYxzBeXdwAAABN0RVh0ZXhpZjpFeGlmT2Zmc2V0ADE2MiUYjiEAAAAZdEVYdGV4aWY6"
    @"UGl4ZWxYRGltZW5zaW9uADEyOTAV2J+jAAAAGXRFWHRleGlmOlBpeGVsWURpbWVuc2lvbgAxMjgz"
    @"LDEksAAAABV0RVh0ZXhpZjpTb2Z0d2FyZQBQaWNzYXJ0o11EpQAAAZZ6VFh0ZXhpZkVYOkNhbWVy"
    @"YU93bmVyTmFtZQAAKJGlktmO2yAYhd+F6zBiX3JnvLxEUyHqkASNt4I9TRTl3Ys9k1aV5qaaKzg/"
    @"53w/2x2EZNMc2lcfbT8ewyn4I9jPcfG7dSn6PlzB/uS6lAtLyGsAK14SU1eQs0JChkUBFVIlxJJR"
    @"KkQhm8qAHZjW7NLbNC6x9Qnsv33fgXeRIeN88TG7nr03sla6FpWpISW4gazgGCpTcmhMiWpTCsNV"
    @"lTOdS7Odx7HLkXWw6eImb9s4TuDZwqaNWBuua2QaaIoGQWYUhUaTCtK6akqBcEOQsFgqSrmmWhEp"
    @"M2GM4RyGnD67rvPxlktzdEOaXPRDe7NvrlvyGe6gd1fruuniwB7vQB+Gp0IZMrk2zDeNVuPk85aG"
    @"2Z1zjOAXpjHlXGmutUCabeafi7c/xmU4pjVw2xi/MpfoPLlu8rJKRR+PP/TP4ERQjrHgUmKm2Bfg"
    @"Wn9C55QQgZRmUnKq8X/TM/40+38/xZL88W8F3A/gzccUxuGw3uvh40XTYXU/wOM3Ds/QBh+WMwIA"
    @"AAApdEVYdHBob3Rvc2hvcDpEYXRlQ3JlYXRlZAAyMDI2LTA3LTA2VDIwOjM4OjYxgKtkPQAAABJ0"
    @"RVh0dGlmZjpPcmllbnRhdGlvbgAxt6v8OwAAABB0RVh0eG1wOkNvbG9yU3BhY2UAMQUOyNEAAAAX"
    @"dEVYdHhtcDpDcmVhdG9yVG9vbABQaWNzYXJ0cPSIZQAAACJ0RVh0eG1wOk1vZGlmeURhdGUAMjAy"
    @"Ni0wNy0wNlQyMDozODo2MT4PdXAAAAAYdEVYdHhtcDpQaXhlbFhEaW1lbnNpb24AMTI5MIbLb3MA"
    @"AAAYdEVYdHhtcDpQaXhlbFlEaW1lbnNpb24AMTI4M78i1GAAAAAASUVORK5CYII=";

static NSString *tiraathGetUUID(void) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ud stringForKey:@"TiraathFakeUUID"];
    if (!uuid || uuid.length < 36) {
        uuid = [[NSUUID UUID] UUIDString];
        [ud setObject:uuid forKey:@"TiraathFakeUUID"];
        [ud synchronize];
    }
    return uuid;
}

static void tiraathNewUUID(void) {
    [[NSUserDefaults standardUserDefaults]
        setObject:[[NSUUID UUID] UUIDString] forKey:@"TiraathFakeUUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(closeMenu)]];

    CGRect scr = [UIScreen mainScreen].bounds;
    // ارتفاع البطاقة يأخذ بعين الاعتبار السطرين للمعرّف الكامل
    CGFloat cw = MIN(scr.size.width - 60, 290), ch = 273;
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(
        (scr.size.width - cw) / 2,
        (scr.size.height - ch) / 2,
        cw, ch)];
    card.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.13 alpha:0.97];
    card.layer.cornerRadius = 18;
    card.clipsToBounds = YES;
    [card addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    [self.view addSubview:card];

    // نقرأ المعرّف مرة واحدة ونعرضه في مكانين — يضمن التطابق دائماً
    NSString *uuid = tiraathGetUUID();

    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(cw - 170, 15, 155, 18)];
    t1.text = @"المعرّف الحالي:";
    t1.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    t1.textColor = [UIColor whiteColor];
    t1.textAlignment = NSTextAlignmentRight;
    [card addSubview:t1];

    // *** إصلاح #1: نعرض المعرّف الكامل (لا المقتطع) ليكون مطابقاً لشاشة المعلومات ***
    UILabel *t2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 35, cw - 16, 36)];
    t2.text = uuid;                              // المعرّف الكامل
    t2.font = [UIFont fontWithName:@"Courier" size:11];
    t2.textColor = [UIColor colorWithRed:0.35 green:0.75 blue:1 alpha:1];
    t2.textAlignment = NSTextAlignmentCenter;
    t2.numberOfLines = 2;
    t2.adjustsFontSizeToFitWidth = YES;
    t2.minimumScaleFactor = 0.7;
    [card addSubview:t2];

    UIButton *ib = [UIButton buttonWithType:UIButtonTypeSystem];
    ib.frame = CGRectMake(8, 12, 32, 32);
    if (@available(iOS 13, *)) {
        [ib setImage:[[UIImage systemImageNamed:@"info.circle"]
            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:0];
        ib.tintColor = [UIColor whiteColor];
    }
    [ib addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:ib];

    CGFloat y = 80; // أسفل منطقة المعرّف الممتدة

    [card addSubview:[self sep:CGRectMake(0, y, cw, 0.5)]]; y += 0.5;
    [card addSubview:[self row:CGRectMake(0, y, cw, 60)
        title:@"توليد معرّف جديد وإعادة التشغيل"
        color:[UIColor whiteColor]
        icon:@"arrow.clockwise"
        sel:@selector(doGenerate)]]; y += 60;

    [card addSubview:[self sep:CGRectMake(0, y, cw, 0.5)]]; y += 0.5;
    [card addSubview:[self row:CGRectMake(0, y, cw, 60)
        title:@"مسح البيانات وتوليد معرّف جديد"
        color:[UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1]
        icon:@"trash"
        sel:@selector(doClear)]]; y += 60;

    [card addSubview:[self sep:CGRectMake(0, y, cw, 0.5)]]; y += 0.5;
    [card addSubview:[self row:CGRectMake(0, y, cw, 48)
        title:@"قناة التراث ستور على تليغرام"
        color:[UIColor colorWithRed:0.2 green:0.6 blue:1 alpha:1]
        icon:@"paperplane.fill"
        sel:@selector(openTelegram)]];

    UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(0, ch - 22, cw, 18)];
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
    UILabel *l = [[UILabel alloc] initWithFrame:
        CGRectMake(50, 0, f.size.width - 60, f.size.height)];
    l.text = t;
    l.font = [UIFont systemFontOfSize:14];
    l.textColor = c;
    l.textAlignment = NSTextAlignmentRight;
    l.numberOfLines = 2;
    l.userInteractionEnabled = NO;
    [btn addSubview:l];
    if (@available(iOS 13, *)) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:
            CGRectMake(12, (f.size.height - 24) / 2, 24, 24)];
        iv.image = [[UIImage systemImageNamed:icon]
            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iv.tintColor = c;
        iv.userInteractionEnabled = NO;
        [btn addSubview:iv];
    }
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)closeMenu {
    gMenuWindow.hidden = YES;
    gMenuWindow = nil;
}

- (void)showInfo {
    // *** يقرأ من نفس المصدر (NSUserDefaults) كما تفعل البطاقة → دائماً متطابقان ***
    NSString *uuid = tiraathGetUUID();
    UIAlertController *a = [UIAlertController
        alertControllerWithTitle:@"هوية الجهاز (UUID)"
        message:[NSString stringWithFormat:
            @"معرّف جهازك النشط حالياً هو:\n\n%@\n\n"
            "هذا المعرّف يخفي البصمة الحقيقية لجهازك "
            "لتجاوز حظر الأجهزة على انستقرام.\n\n© حقوق التراث ستور", uuid]
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
    tiraathNewUUID();
    [self closeMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{ exit(0); });
}

- (void)doClear {
    [[NSUserDefaults standardUserDefaults]
        removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    tiraathNewUUID();
    [self closeMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{ exit(0); });
}

- (void)openTelegram {
    NSURL *url = [NSURL URLWithString:@"https://t.me/turath_st/"];
    if (@available(iOS 10, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end

@interface TiraathBtnVC : UIViewController
@end
@implementation TiraathBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 52, 52);
    // *** إصلاح #2: لا خلفية، لا حواف، لا زوايا مستديرة — اللوغو فقط ***
    btn.backgroundColor = [UIColor clearColor];

    NSData *logoData = [[NSData alloc]
        initWithBase64EncodedString:kTiraathLogoB64
        options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *logoImage = [UIImage imageWithData:logoData];
    [btn setImage:logoImage forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn.imageView.layer setMasksToBounds:YES];

    [btn addTarget:self action:@selector(tapped)
        forControlEvents:UIControlEventTouchUpInside];
    [btn addGestureRecognizer:[[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(dragged:)]];
    [self.view addSubview:btn];
}

- (void)tapped {
    if (gMenuWindow && !gMenuWindow.hidden) {
        gMenuWindow.hidden = YES;
        gMenuWindow = nil;
        return;
    }
    UIWindow *mw = nil;
    if (@available(iOS 13, *))
        mw = [[UIWindow alloc] initWithWindowScene:
            (UIWindowScene *)gBtnWindow.windowScene];
    if (!mw)
        mw = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mw.frame = [UIScreen mainScreen].bounds;
    mw.windowLevel = UIWindowLevelAlert + 90;
    mw.backgroundColor = [UIColor clearColor];
    mw.rootViewController = [[TiraathMenuVC alloc] init];
    mw.hidden = NO;
    gMenuWindow = mw;
}

- (void)dragged:(UIPanGestureRecognizer *)g {
    CGPoint d = [g translationInView:self.view];
    CGRect f = gBtnWindow.frame;
    CGSize s = [UIScreen mainScreen].bounds.size;
    f.origin.x = MAX(0, MIN(f.origin.x + d.x, s.width - 52));
    f.origin.y = MAX(44, MIN(f.origin.y + d.y, s.height - 80));
    gBtnWindow.frame = f;
    [g setTranslation:CGPointZero inView:self.view];
}

@end

static NSUUID *(*orig_IDFV)(id, SEL) = NULL;

static NSUUID *hook_IDFV(id self, SEL _cmd) {
    return [[NSUUID alloc] initWithUUIDString:tiraathGetUUID()];
}

static void installSwizzle(void) {
    Class cls = objc_getClass("UIDevice");
    if (!cls) return;
    SEL sel = sel_registerName("identifierForVendor");
    Method m = class_getInstanceMethod(cls, sel);
    if (!m) return;
    orig_IDFV = (NSUUID *(*)(id, SEL))method_getImplementation(m);
    method_setImplementation(m, (IMP)hook_IDFV);
}

static void tiraathCreateWindow(void) {
    if (gDone) return;
    gDone = YES;

    UIWindow *win = nil;
    if (@available(iOS 13, *)) {
        for (UIScene *sc in [UIApplication sharedApplication].connectedScenes) {
            if ([sc isKindOfClass:[UIWindowScene class]] &&
                sc.activationState == UISceneActivationStateForegroundActive) {
                win = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)sc];
                break;
            }
        }
    }
    if (!win)
        win = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];

    win.frame = CGRectMake(20, 220, 52, 52);
    win.windowLevel = UIWindowLevelStatusBar + 300;
    win.backgroundColor = [UIColor clearColor];
    win.rootViewController = [[TiraathBtnVC alloc] init];
    win.hidden = NO;
    gBtnWindow = win;
}

__attribute__((constructor))
static void tiraathInit(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        installSwizzle();
    });
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationDidBecomeActiveNotification
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *n) {
                    tiraathCreateWindow();
                }];
}
