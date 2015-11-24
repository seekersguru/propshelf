//
//  LocationModelClass.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "LocationModelClass.h"

@implementation LocationModelClass

@synthesize delegate;

@synthesize nsqueue;

#pragma mark - Get Cities Request Method

-(void)getCitiesRequest {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *citiesUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Cities_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:citiesUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:GET];
    
    NSLog(@"Get Cities URL :- %@", citiesUrl);
    
    [request setDidFinishSelector:@selector(didFinishWithGetCitiesRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetCitiesRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Get Cities Request Delegate Method

-(void)didFinishWithGetCitiesRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Get Cities Status Code:- %d",request.responseStatusCode);
    NSLog(@"Get Cities response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            [delegate didGetCitiesSuccessfully:[[responseDict objectForKey:@"json"] mutableCopy]];
        }
    }
    else {
        
        [delegate didGetCitiesFailed:request];
    }
}

-(void)didFailWithGetCitiesRequest:(ASIHTTPRequest *)request
{
    [delegate didGetCitiesFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

#pragma mark - Get Location Request Method

-(void)getLocationRequest:(NSString *)selectedCity {
    
    if (self.nsqueue == nil) {
        self.nsqueue = [[ASINetworkQueue alloc] init];
    }
    
    NSURL *locationsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PRODUCTION_BASE_URL, Locations_URL]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:locationsUrl];
    [request setDelegate:self];
    [request setPropShelfHeaders];
    [request setRequestMethod:POST];
    
    NSString* postString = [NSString stringWithFormat:Get_Location_Payload, selectedCity];
    
    NSLog(@"Get Locations Post String:- %@", postString);
    NSLog(@"Get Locations URL :- %@", locationsUrl);
    
    [request appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDidFinishSelector:@selector(didFinishWithGetLocationsRequest:)];
    [request setDidFailSelector:@selector(didFailWithGetLocationsRequest:)];
    
    [self.nsqueue addOperation:request];
    [self.nsqueue go];
}

#pragma mark - Get Locations Request Delegate Method

-(void)didFinishWithGetLocationsRequest:(ASIHTTPRequest *)request
{
    NSLog(@"Get Locations Status Code:- %d",request.responseStatusCode);
    NSLog(@"Get Locations response :- %@",request.responseString);
    
    NSError *error = [request error];
    
    if ((request.responseStatusCode >= 200 && request.responseStatusCode <= 210) && !error)
    {
        NSMutableDictionary *responseDict = [NSJSONSerialization
                                             JSONObjectWithData:request.responseData //1
                                             
                                             options:kNilOptions
                                             error:&error];
        
        if (responseDict != nil) {
            
            if ([[responseDict objectForKey:@"sublocs"] mutableCopy] == nil) {
                
                [delegate didGetLocationsSuccessfullyDict:responseDict];
            }
            else {
                
                [delegate didGetLocationsSuccessfullyArray:[[responseDict objectForKey:@"sublocs"] mutableCopy]];
            }
        }
    }
    else {
        
        [delegate didGetLocationsFailed:request];
    }
}

-(void)didFailWithGetLocationsRequest:(ASIHTTPRequest *)request
{
    [delegate didGetLocationsFailed:request];
    
    NSLog(@"In ::Error:- %@",request.error.description);
}

@end
