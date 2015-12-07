//
//  BaseViewController.h
//  Kode
//
//  Created by Gaurang on 08/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController {
    
}

@property (nonatomic, strong) UIAlertView *alertView;
// UI
- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message;
-(void) showLoaderWithTitle:(NSString*)title;
- (void)showMessage:(NSString*)message;
- (void)showAlertMessageWithOk:(NSString*)message;
- (void)showMessage:(NSString*)message withTitle:(NSString*) title;
-(void) removeLoader;

@end
