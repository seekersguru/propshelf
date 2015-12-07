//
//  Profile.h
//  PropShelf
//
//  Created by Gaurang Patel on 12/4/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetLoggedInUserProfileModelClassDelegate <NSObject>

-(void)didGetLoggedInUserProfileSuccessfully:(NSMutableDictionary *)responseDict;
-(void)didGetLoggedInUserProfileFailed:(ASIHTTPRequest *)therequest;

-(void)didUpdateProfileSuccessfully:(NSMutableDictionary *)responseDict;
-(void)didUpdateProfileFailed:(ASIHTTPRequest *)therequest;

@end

@interface Profile : NSObject

@property (nonatomic,strong) id<GetLoggedInUserProfileModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)getLoggedInUserProfile;
-(void)updateProfile:(NSMutableDictionary *)payloadDict;

@end
