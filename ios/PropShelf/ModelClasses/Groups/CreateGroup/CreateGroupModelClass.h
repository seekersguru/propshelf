//
//  CreateGroupModelClass.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CreateGroupModelClassDelegate <NSObject>

-(void)didCreateGroupSuccessfully:(NSString *)message;
-(void)didCreateGroupFailed:(ASIHTTPRequest *)therequest;

-(void)didGetGroupUserSuccessfully:(NSMutableArray *)userArray;
-(void)didGetGroupUserFailed:(ASIHTTPRequest *)therequest;

@end

@interface CreateGroupModelClass : NSObject

@property (nonatomic,strong) id<CreateGroupModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)createGroupRequest:(NSMutableDictionary *)dict;
-(void)getGroupUserRequest:(int)groupId;

@end
