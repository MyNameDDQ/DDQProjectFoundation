//
//  DDQNavigationController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQNavigationController.h"

#import <objc/runtime.h>

@interface DDQNavigationController ()<UIGestureRecognizerDelegate> {
    
    id _systemEdgePanDelegate;
    UIViewController *_rootViewController;
    UIStatusBarStyle _barStyle;
}

@end

@implementation DDQNavigationController

DDQExcptionName const DDQInvalidArgumentException = @"DDQExcption.invalidArgument";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return _barStyle;
}

- (UIViewController *)nav_rootViewController {
    
    return _rootViewController;
}

- (UIStatusBarStyle)nav_barStyle {
    
    return _barStyle;
}

#pragma mark - Init
- (instancetype)initWithRootViewControllerClass:(Class)controllerClass FromNib:(BOOL)nib {
    
    if (![controllerClass isSubclassOfClass:[UIViewController class]]) {
        
        NSException *navExc = [NSException exceptionWithName:DDQInvalidArgumentException reason:@"必须是UIViewController即其子类" userInfo:nil];
        [navExc raise];
    }
    
    UIViewController *rootController = nil;
    if (nib) {
        rootController = [[controllerClass alloc] initWithNibName:NSStringFromClass(controllerClass) bundle:nil];
    } else {
        rootController = [[controllerClass alloc] init];
    }
    _rootViewController = rootController;
    self = [super initWithRootViewController:rootController];
    
    if (!self) return nil;
    return self;
}

#pragma mark - Custom Method IMP
- (void)nav_updateNavgationStatusBarStyle:(UIStatusBarStyle)barStyle {
    
    _barStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end

