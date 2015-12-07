//
//  GroupSearch.h
//  PropShelf
//
//  Created by Gaurang Patel on 12/7/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchGroupClassDelegate <NSObject>

-(void)didSearchGroupSuccessfully:(NSMutableArray *)responseArray;
-(void)didSearchGroupFailed:(ASIHTTPRequest *)therequest;

@end

@interface GroupSearch : NSObject

@property (nonatomic,strong) id<SearchGroupClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)searchGroupRequest:(NSMutableDictionary *)payloadDict;

@end
