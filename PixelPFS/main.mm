#import <UIKit/UIKit.h>
#include <cmath>
#include <string>

// Pixel PFS - Native iOS prototype
// C++ gameplay state + UIKit rendering

struct GameState {
    bool playing = false;
    int health = 100;
    int ammo = 30;
    int score = 0;
    float playerX = 0.5f;
    float playerY = 0.5f;

    void start() {
        playing = true;
        health = 100;
        ammo = 30;
        score = 0;
    }

    void shoot() {
        if (playing && ammo > 0) {
            ammo--;
        }
    }

    void reload() {
        if (playing) ammo = 30;
    }
};

static GameState game;

@interface GameView : UIView
@end

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =
            [UIColor colorWithRed:0.06
                            green:0.08
                             blue:0.12
                            alpha:1];
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)drawText:(NSString *)text
               x:(CGFloat)x
               y:(CGFloat)y
            size:(CGFloat)size
           color:(UIColor *)color {

    NSDictionary *attrs = @{
        NSFontAttributeName:
            [UIFont boldSystemFontOfSize:size],
        NSForegroundColorAttributeName: color
    };

    [text drawAtPoint:CGPointMake(x, y)
      withAttributes:attrs];
}

- (void)fillRect:(CGRect)rect
           color:(UIColor *)color {

    [color setFill];
    UIRectFill(rect);
}

- (void)drawRect:(CGRect)rect {

    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;

    UIColor *white = UIColor.whiteColor;
    UIColor *green =
        [UIColor colorWithRed:0.35
                        green:0.92
                         blue:0.55
                        alpha:1];

    UIColor *dark =
        [UIColor colorWithRed:0.12
                        green:0.17
                         blue:0.19
                        alpha:1];

    if (!game.playing) {

        [self drawText:@"PIXEL PFS"
                     x:w * 0.07
                     y:h * 0.08
                  size:36
                 color:green];

        [self drawText:@"TACTICAL PIXEL FPS"
                     x:w * 0.07
                     y:h * 0.24
                  size:14
                 color:white];

        // Pixel soldier helmet
        CGFloat cx = w * 0.55;
        CGFloat cy = h * 0.25;

        [self fillRect:CGRectMake(cx, cy, 70, 24)
                 color:green];

        [self fillRect:CGRectMake(cx - 8, cy + 24, 86, 12)
                 color:dark];

        // Face
        [self fillRect:CGRectMake(cx + 10, cy + 36, 50, 40)
                 color:[UIColor colorWithRed:0.68
                                         green:0.53
                                          blue:0.38
                                         alpha:1]];

        // Tactical vest
        [self fillRect:CGRectMake(cx - 12, cy + 78, 94, 92)
                 color:green];

        [self fillRect:CGRectMake(cx + 14, cy + 88, 42, 65)
                 color:dark];

        // Rifle
        [self fillRect:CGRectMake(cx + 42, cy + 102, 110, 14)
                 color:UIColor.grayColor];

        [self fillRect:CGRectMake(cx + 75, cy + 116, 15, 30)
                 color:UIColor.grayColor];

        // Start button
        CGRect button =
            CGRectMake(w * 0.08, h * 0.70,
                       w * 0.34, 54);

        [self fillRect:button color:green];

        [self drawText:@"START GAME"
                     x:button.origin.x + 12
                     y:button.origin.y + 14
                  size:20
                 color:UIColor.blackColor];

        [self drawText:@"WAREHOUSE   SETTINGS"
                     x:w * 0.08
                     y:h * 0.90
                  size:13
                 color:white];

    } else {

        // Training-ground prototype
        [self fillRect:CGRectMake(0, h * 0.55,
                                  w, h * 0.45)
                 color:[UIColor colorWithRed:0.23
                                         green:0.29
                                          blue:0.22
                                         alpha:1]];

        [self drawText:@"PIXEL PFS | TRAINING"
                     x:20 y:20 size:18 color:green];

        NSString *status =
            [NSString stringWithFormat:
                @"HP: %d    AMMO: %d    SCORE: %d",
                game.health, game.ammo, game.score];

        [self drawText:status
                     x:20 y:48 size:15 color:white];

        // Crosshair
        CGFloat mx = w / 2;
        CGFloat my = h / 2;

        [self fillRect:CGRectMake(mx - 14, my, 10, 2)
                 color:white];

        [self fillRect:CGRectMake(mx + 4, my, 10, 2)
                 color:white];

        [self fillRect:CGRectMake(mx, my - 14, 2, 10)
                 color:white];

        [self fillRect:CGRectMake(mx, my + 4, 2, 10)
                 color:white];

        // Touch controls
        [self drawText:@"MOVE"
                     x:30 y:h - 65
                  size:20 color:white];

        [self drawText:@"RELOAD"
                     x:w - 210 y:h - 65
                  size:20 color:white];

        [self drawText:@"FIRE"
                     x:w - 100 y:h - 65
                  size:24 color:green];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {

    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;

    if (!game.playing) {
        if (p.y > h * 0.65 &&
            p.y < h * 0.88 &&
            p.x < w * 0.50) {
            game.start();
        }
    } else {
        if (p.y > h * 0.65) {
            if (p.x > w - 115) {
                game.shoot();
            } else if (p.x > w - 230) {
                game.reload();
            }
        }
    }

    [self setNeedsDisplay];
}

@end

@interface GameController : UIViewController
@end

@implementation GameController

- (void)loadView {
    self.view = [[GameView alloc]
        initWithFrame:UIScreen.mainScreen.bounds];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)
    supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end

@interface AppDelegate : UIResponder
    <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:
        (NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]
        initWithFrame:UIScreen.mainScreen.bounds];

    self.window.rootViewController =
        [[GameController alloc] init];

    [self.window makeKeyAndVisible];

    return YES;
}

@end

int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(
            argc,
            argv,
            nil,
            NSStringFromClass([AppDelegate class])
        );
    }
}
