//
//  SignInViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/13/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "SignInViewController.h"

#import <GooglePlus/GooglePlus.h>

#import <GoogleOpenSource/GoogleOpenSource.h>

#import "MobileVerificationViewController.h"

@interface SignInViewController () <GPPSignInDelegate>

@property (nonatomic, copy) void (^confirmActionBlock)(void);
@property (nonatomic, copy) void (^cancelActionBlock)(void);

@end

// Strings for Alert Views.
static NSString *const kSignOutAlertViewTitle = @"Warning";
static NSString *const kSignOutAlertViewMessage =
@"Modifying this element will sign you out of G+. Are you sure you wish to continue?";
static NSString *const kSignOutAlertCancelTitle = @"Cancel";
static NSString *const kSignOutAlertConfirmTitle = @"Continue";

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        
    // Make sure the GPPSignInButton class is linked in because references from
    // xib file doesn't count.
    [GPPSignInButton class];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = GOOGLE_PLUS_ID;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin, kGTLAuthScopePlusMe, kGTLAuthScopePlusUserinfoEmail, kGTLAuthScopePlusUserinfoProfile ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[GPPSignIn sharedInstance] trySilentAuthentication];
    [self reportAuthStatus];
    [self updateButtons];
    
    [super viewWillAppear:animated];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        
        NSLog(@"Received error %@ and auth object %@",error, auth);
        return;
    }
    
    [self reportAuthStatus];
    [self updateButtons];
}

- (void)didDisconnectWithError:(NSError *)error {
    
    if (error) {
        
        NSLog(@"Status: Failed to disconnect: %@", error);

    } else {
        
        NSLog(@"Status: Disconnected");
    }
    
    [self refreshUserInfo];
    [self updateButtons];
}

#pragma mark - Helper methods

// Temporarily force the sign in button to adopt its minimum allowed frame
// so that we can find out its minimum allowed width (used for setting the
// range of the width slider).
- (CGFloat)minimumButtonWidth {
    CGRect frame = self.gppSignInButton.frame;
    self.gppSignInButton.frame = CGRectZero;
    
    CGFloat minimumWidth = self.gppSignInButton.frame.size.width;
    self.gppSignInButton.frame = frame;
    
    return minimumWidth;
}

- (void)reportAuthStatus {
    
    if ([GPPSignIn sharedInstance].authentication) {
        NSLog(@"Status: Authenticated");
    
    } else {
        // To authenticate, use Google+ sign-in button.
        NSLog(@"Status: Not authenticated");
    }
    
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo {
    
    if ([GPPSignIn sharedInstance].authentication == nil) {
                
        return;
    }
    
    //self.userEmailAddress.text = [GPPSignIn sharedInstance].userEmail;
    
    // The googlePlusUser member will be populated only if the appropriate
    // scope is set when signing in.
    GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
    
    if (person == nil) {
        return;
    }
    
    /*NSLog(@"LastName : %@",person.name.familyName);
    NSLog(@"FirstName : %@",person.name.givenName);
    NSLog(@"authorizationTokenKey : %@",[GPPSignIn sharedInstance].authentication.accessToken);
    NSLog(@"Email : %@",[GPPSignIn sharedInstance].authentication.userEmail);*/

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[GPPSignIn sharedInstance].userEmail,@"email", @"google", @"source", person.name.givenName, @"first_name", person.name.familyName, @"last_name",  nil];

    //NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Test10@gmail.com",@"email", @"google", @"source", @"Test10", @"first_name", @"Test10", @"last_name",  nil];
    
    [self callMobileVerificationView:dict];
    
    // Load avatar image asynchronously, in background
    dispatch_queue_t backgroundQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        NSData *avatarData = nil;
        NSString *imageURLString = person.image.url;
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            avatarData = [NSData dataWithContentsOfURL:imageURL];
        }
        
        if (avatarData) {
            // Update UI from the main thread when available
            dispatch_async(dispatch_get_main_queue(), ^{
                //self.userAvatar.image = [UIImage imageWithData:avatarData];
            });
        }
    });
}

// Adjusts "Sign in", "Sign out", and "Disconnect" buttons to reflect
// the current sign-in state (ie, the "Sign in" button becomes disabled
// when a user is already signed in).
- (void)updateButtons {
    BOOL authenticated = ([GPPSignIn sharedInstance].authentication != nil);
    
    self.gppSignInButton.enabled = !authenticated;
    
    if (authenticated) {
        self.gppSignInButton.alpha = 0.5;
    } else {
        self.gppSignInButton.alpha = 1.0;
    }
}

// Creates and shows an UIAlertView asking the user to confirm their action as it will log them
// out of their current G+ session

- (void)showSignOutAlertViewWithConfirmationBlock:(void (^)(void))confirmationBlock
                                      cancelBlock:(void (^)(void))cancelBlock {
    if ([[GPPSignIn sharedInstance] authentication]) {
        self.confirmActionBlock = confirmationBlock;
        self.cancelActionBlock = cancelBlock;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kSignOutAlertViewTitle
                                                            message:kSignOutAlertViewMessage
                                                           delegate:self
                                                  cancelButtonTitle:kSignOutAlertCancelTitle
                                                  otherButtonTitles:kSignOutAlertConfirmTitle, nil];
        [alertView show];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (_cancelActionBlock) {
            _cancelActionBlock();
        }
    } else {
        if (_confirmActionBlock) {
            _confirmActionBlock();
            [self refreshUserInfo];
            [self updateButtons];
        }
    }
    
    _cancelActionBlock = nil;
    _confirmActionBlock = nil;
}

#pragma mark - Button Action Method

-(IBAction)googleBtnTapped:(id)sender {
    
}

-(IBAction)facebookBtnTapped:(id)sender {
   
    linkedInBtn.userInteractionEnabled = NO;
    self.gppSignInButton.userInteractionEnabled = NO;
    facebookBtn.userInteractionEnabled = NO;
 
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends", @"user_about_me", @"user_birthday", @"user_hometown", @"user_photos", @"user_location", @"user_education_history", @"user_work_history"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             //NSLog(@"token : %@",result.token);
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, picture, email"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      
                      if (!error) {
                          
                          /*NSLog(@"fetched user:%@", [FBSDKAccessToken currentAccessToken].tokenString);
                          NSLog(@"fetched user:%@", result);
                          NSLog(@"%@",result[@"email"]);*/
                          
                          NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:result[@"email"], @"email", @"facebook", @"source", result[@"first_name"], @"first_name", result[@"last_name"], @"last_name",  nil];
                          
                          [self callMobileVerificationView:dict];
                      }
                  }];
             }
        }
     }];
}

-(IBAction)linkedInBtnTapped:(id)sender {
    
    linkedInBtn.userInteractionEnabled = NO;
    self.gppSignInButton.userInteractionEnabled = NO;
    facebookBtn.userInteractionEnabled = NO;
    
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil] state:@"some state" showGoToAppStoreDialog:YES successBlock:^(NSString *returnState) {
        
        NSLog(@"%s","success called!");
        
        [self showLoaderWithTitle:@"Logging in..."];

        LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
        //NSLog(@"value=%@ isvalid=%@",[session value],[session isValid] ? @"YES" : @"NO");
        NSMutableString *text = [[NSMutableString alloc] initWithString:[session.accessToken description]];
        [text appendString:[NSString stringWithFormat:@",state=\"%@\"",returnState]];
        //NSLog(@"Response label text %@",text);
        
        NSString *url = @"https://api.linkedin.com/v1/people/~:(id,firstName,lastName,email-address)";
        
        if ([LISDKSessionManager hasValidSession]) {
            
            [[LISDKAPIHelper sharedInstance] getRequest:url success:^(LISDKAPIResponse *response) {
                // do something with response
                //NSLog(@"data : %@",response.data);
                
                NSData *data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[json objectForKey:@"emailAddress"], @"email", @"linkedin", @"source", [json objectForKey:@"firstName"], @"first_name", [json objectForKey:@"lastName"], @"last_name",  nil];
                
                [self callMobileVerificationView:dict];
            }
            error:^(LISDKAPIError *apiError) {
                // do something with error
                                                      
                    NSLog(@"%s %@","error called! ", [apiError description]);
                }

             ];
        }
    }
    errorBlock:^(NSError *error) {
            NSLog(@"%s %@","error called! ", [error description]);
        }
     ];
}

-(void)callMobileVerificationView:(NSMutableDictionary *)dict {
   
    userDict = [dict mutableCopy];
    
    [self performSegueWithIdentifier:@"MobileVerification" sender:self];
    
    [self removeLoader];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"MobileVerification"]) {
        MobileVerificationViewController *myVC = [segue destinationViewController];
        myVC.userDict = userDict; // set your properties here
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
