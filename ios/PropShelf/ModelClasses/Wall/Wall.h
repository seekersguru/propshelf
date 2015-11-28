//
//  Wall.h
//  PropShelf
//
//  Created by Gaurang Patel on 11/2/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetWallModelClassDelegate <NSObject>

-(void)didGetWallSuccessfully:(NSMutableArray *)wallArray;
-(void)didGetWallFailed:(ASIHTTPRequest *)therequest;

@end

@interface Wall : NSObject {
    
}

@property (nonatomic,strong) id<GetWallModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)getWallRequest:(int)limit;

@end
