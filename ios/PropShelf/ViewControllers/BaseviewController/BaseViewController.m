//
//  BaseViewController.m
//  Kode
//
//  Created by Gaurang on 08/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
 
    SvGifView *_gifView;
}

@end

@implementation BaseViewController

@synthesize alertView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) showLoaderWithTitle:(NSString*)title
{
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [alertView removeFromSuperview];
        alertView = nil;
    }
    
    alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(139.5, 75.5);
    [alertView addSubview:activityIndicator];
    
    [alertView show];
    
    [_gifView startGif];
}

-(void) removeLoader
{
    [_gifView stopGif];
    
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
        [alertView removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"PS-Loader" withExtension:@"gif"];
    
    _gifView = [[SvGifView alloc] initWithCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height /2) fileURL:fileUrl];
    _gifView.backgroundColor = [UIColor clearColor];
    _gifView.contentMode = UIViewContentModeCenter;
    _gifView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_gifView];*/
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"Low Memory Warning IN BaseViewController");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - Show Alert View

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    
    UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView1 show];
    alertView1 = nil;
}

- (void)showMessage:(NSString*)message {
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [alertView removeFromSuperview];
        
        alertView = nil;
    }
    
    alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(removeLoader) withObject:nil afterDelay:2];
}

- (void)showMessage:(NSString*)message withTitle:(NSString*) title {
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [alertView removeFromSuperview];
        
        alertView = nil;
    }

    alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(removeLoader) withObject:nil afterDelay:2];
}

- (void)showAlertMessageWithOk:(NSString*)message {
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [alertView removeFromSuperview];
        
        alertView = nil;
    }

    alertView=[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self removeLoader];
}

@end
