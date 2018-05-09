//
//  AppDelegate.m
//  Lilian
//
//  Created by Joseph on 12/1/18.
//  Copyright © 2018 Joseph. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMobileAds;
#import "IQKeyboardManager.h"
#import "PangeaIO-Swift.h"
#import <ROXCore/ROXCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ROX setupWithKey:@"5aa24ea983ee1915fd7c4815"];
    // Override point for customization after application launch.
//    BTBlurredStatusBar *statusBar = [[BTBlurredStatusBar alloc] initWithStyle:UIBlurEffectStyleLight];
//    [self.window addSubview:statusBar];
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-4854696776225673~7204443500"];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
//    [[UILabel appearance] setFont:[UIFont fontWithName:@"OpenSans-Regular" size:17.0]];
    [self.window makeKeyAndVisible];
    
    // Set the UIViewController that will present an instance of UIAlertController
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    
    [[Harpy sharedInstance] setAppName:@"Everest X"];

    // Perform check for new version of your app
    [[Harpy sharedInstance] setPatchUpdateAlertType:HarpyAlertTypeOption];
    [[Harpy sharedInstance] setMinorUpdateAlertType:HarpyAlertTypeOption];
    [[Harpy sharedInstance] setMajorUpdateAlertType:HarpyAlertTypeForce];
    [[Harpy sharedInstance] setRevisionUpdateAlertType:HarpyAlertTypeSkip];
    [[Harpy sharedInstance] checkVersion];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (!url) {
        return NO;
    }
    NSString *URLString = [url absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:URLString forKey:@"URLSchemeReturn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", URLString);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Harpy sharedInstance] setPatchUpdateAlertType:HarpyAlertTypeOption];
    [[Harpy sharedInstance] setMinorUpdateAlertType:HarpyAlertTypeOption];
    [[Harpy sharedInstance] setMajorUpdateAlertType:HarpyAlertTypeForce];
    [[Harpy sharedInstance] setRevisionUpdateAlertType:HarpyAlertTypeSkip];
    [[Harpy sharedInstance] checkVersionDaily];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
