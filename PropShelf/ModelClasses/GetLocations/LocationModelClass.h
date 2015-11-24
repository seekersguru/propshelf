//
//  LocationModelClass.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationModelClassDelegate <NSObject>

-(void)didGetCitiesSuccessfully:(NSMutableArray *)citiesArray;
-(void)didGetCitiesFailed:(ASIHTTPRequest *)therequest;

-(void)didGetLocationsSuccessfullyArray:(NSMutableArray *)locationsArray;
-(void)didGetLocationsSuccessfullyDict:(NSMutableDictionary *)locationsDict;
-(void)didGetLocationsFailed:(ASIHTTPRequest *)therequest;

@end

@interface LocationModelClass : NSObject

@property (nonatomic,strong) id<LocationModelClassDelegate>delegate;
@property (nonatomic,strong) ASINetworkQueue *nsqueue;

-(void)getCitiesRequest;
-(void)getLocationRequest:(NSString *)selectedCity;

@end
