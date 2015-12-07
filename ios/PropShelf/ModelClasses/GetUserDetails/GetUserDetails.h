//
//  GetUserDetails.h
//  PropShelf
//
//  Created by Gaurang Patel on 12/4/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetUserDetailsModelClassDelegate <NSObject>

-(void)didGetUserDetailsSuccessfully:(NSMutableDictionary *)userArray;
-(void)didGetUserDetailsFailed:(ASIHTTPRequest *)therequest;

@end

@interface GetUserDetails : NSObject

@property (nonatomic,strong) id<GetUserDetailsModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)getUserDetailsRequest:(NSString *)userId;

@end
