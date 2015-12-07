//
//  AppDelegate.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/13/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)addWallView;
-(void)addChatScreen:(NSMutableDictionary *)dataDict;
-(void)addMainStoryBoard;

@end

