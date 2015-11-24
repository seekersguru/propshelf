//
//  AppDelegate.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/13/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "AppDelegate.h"

#import "WallViewController.h"

#import <FacebookSDK/FacebookSDK.h>

#import <GooglePlus/GooglePlus.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <linkedin-sdk/LISDK.h>

#import "ChatViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set app's client ID for |GPPSignIn| and |GPPShare|.
    [GPPSignIn sharedInstance].clientID = GOOGLE_PLUS_ID;

    // Override point for customization after application launch.
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    if ([Common getCurrentSessionId] != nil) {

        [self addWallView];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //NSLog(@"%@",sourceApplication);
    
    if ([[FBSDKApplicationDelegate sharedInstance] application:application
                                                       openURL:url
                                             sourceApplication:sourceApplication
                                                    annotation:annotation
         ]) {
        return YES;
    }
    else if ([GPPURLHandler handleURL:url
                    sourceApplication:sourceApplication
                           annotation:annotation]) {
        
        return YES;
    }
    else if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)addWallView {
    
    [self.window removeFromSuperview];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WallStoryboard" bundle:nil];
    WallViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Wall"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:245.0/225 green:65.0/225 blue:62.0/225 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:16]
                                                           }];
    
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
}

-(void)addChatScreen:(NSString *)threadId titleStr:(NSString *)navTitle {

    [self.window removeFromSuperview];
    
    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"WallStoryboard" bundle:nil];
    WallViewController *viewController1 = [storyboard1 instantiateViewControllerWithIdentifier:@"Wall"];
    
    UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"ChatStoryboard" bundle:nil];
    ChatViewController *viewController2 = [storyboard2 instantiateViewControllerWithIdentifier:@"Chat"];
    viewController2.threadIdStr = threadId;
    viewController2.isCameFromWall = NO;
    viewController2.propertyStr = navTitle;

    NSArray *stack = [NSArray arrayWithObjects:viewController1, viewController2, nil];

    UINavigationController* navigation = [[UINavigationController alloc] init];
    navigation.viewControllers = stack;

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:245.0/225 green:65.0/225 blue:62.0/225 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:16]
                                                           }];
    
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
}

@end
