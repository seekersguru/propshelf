//
//  GetGroupsModelClass.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetGroupsModelClassDelegate <NSObject>

-(void)didGetGroupsSuccessfully:(NSMutableArray *)groupArray;
-(void)didGetGroupsFailed:(ASIHTTPRequest *)therequest;

-(void)didJoinUnJoinGroupSuccessfully;
-(void)didJoinUnJoinGroupFailed:(ASIHTTPRequest *)therequest;

-(void)didGroupDeletedSuccessfully;
-(void)didGroupDeletedFailed:(ASIHTTPRequest *)therequest;

@end

@interface GetGroupsModelClass : NSObject

@property (nonatomic,strong) id<GetGroupsModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)getGroupsRequest:(int)pageNumber;
-(void)joinUnJoinGroupRequest:(int)groupId url:(NSString *)url;
-(void)deleteGroupRequest:(int)groupId;

@end
