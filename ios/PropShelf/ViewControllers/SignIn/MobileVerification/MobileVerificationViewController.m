//
//  MobileVerificationViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 11/3/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "MobileVerificationViewController.h"

@interface MobileVerificationViewController ()

@end

@implementation MobileVerificationViewController

@synthesize loginModelClass;

@synthesize userDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sendOTPBtn.layer.cornerRadius = 4.0;
    sendOTPBtn.layer.masksToBounds = YES;
    
    verfiyBtn.layer.cornerRadius = 4.0;
    verfiyBtn.layer.masksToBounds = YES;
    
    [self setToolbarItems];
}

#pragma mark - setToolbarItems Methods

-(void)setToolbarItems {
    
    UIToolbar *Keyboardtoolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,44)];
    
    Keyboardtoolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(PreviousField:)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(NextField:)];
    
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyKeyboard:)];
    
    [Keyboardtoolbar setItems:[[NSArray alloc]initWithObjects:previousButton,nextButton,extraSpace,doneButton,nil]];
    
    txtCountryCode.inputAccessoryView = Keyboardtoolbar;
    txtMobileNumber.inputAccessoryView = Keyboardtoolbar;
    txtOTP.inputAccessoryView = Keyboardtoolbar;
}

#pragma mark - KeyBoard Next, Previuos & Done Methods

-(void)PreviousField:(id)sender
{
    [self didEndAnimation];
    
    if([txtCountryCode isFirstResponder])
    {
        [self didStartAnimation:150];
        
        [txtOTP becomeFirstResponder];
    }
    else if([txtMobileNumber isFirstResponder])
    {
        [self didStartAnimation:100];
        
        [txtCountryCode becomeFirstResponder];
    }
    else if([txtOTP isFirstResponder])
    {
        [self didStartAnimation:100];
        
        [txtMobileNumber becomeFirstResponder];
    }
}

-(void)NextField:(id)sender
{
    [self didEndAnimation];
    
    if([txtCountryCode isFirstResponder])
    {
        [self didStartAnimation:100];
        
        [txtMobileNumber becomeFirstResponder];
    }
    else if([txtMobileNumber isFirstResponder])
    {
        [self didStartAnimation:150];
        
        [txtOTP becomeFirstResponder];
    }
    else if([txtOTP isFirstResponder])
    {
        [self didStartAnimation:100];
        
        [txtCountryCode becomeFirstResponder];
    }
}

-(void)resignKeyKeyboard:(id)sender
{
    [self didEndAnimation];
    
    [txtOTP resignFirstResponder];
    [txtMobileNumber resignFirstResponder];
    [txtCountryCode resignFirstResponder];
    
    [self.view endEditing:YES];
}

#pragma mark - Button Action Methods

-(IBAction)sendBtnTapped:(id)sender {
    
    if ([txtMobileNumber.text length] > 0) {
        
        if ([txtMobileNumber.text length] == 10) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDict objectForKey:@"email"], @"email", txtMobileNumber.text, @"mobile", [userDict objectForKey:@"source"], @"source", [userDict objectForKey:@"first_name"], @"first_name", [userDict objectForKey:@"last_name"], @"last_name",  nil];
            
            [self callLoginWebService:dict];
        }
        else {
         
            [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"PHONE_NUMBER", nil)];
            
            return;
        }
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"DATA_IS_MANDATORY", nil)];
        
        return;
    }
}

-(IBAction)verifyBtnTapped:(id)sender {
    
    if ([txtOTP.text length] > 0) {
        
        [self resignKeyKeyboard:nil];
        
        if ([NetworkError checkNetwork]) {
            
            [self showLoaderWithTitle:@"Logging in..."];
            
            if (self.loginModelClass == nil) {
                
                self.loginModelClass = [[LoginModelClass alloc] init];
                self.loginModelClass.delegate = self;
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDict objectForKey:@"email"],@"userName", txtOTP.text, @"otp", nil];
            
            [self.loginModelClass verifyOTPRequest:dict];
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"DATA_IS_MANDATORY", nil)];
        
        return;
    }
}

-(IBAction)resendBtnTapped:(id)sender {
    
    if ([txtMobileNumber.text length] > 0) {
        
        [self resignKeyKeyboard:nil];
        
        if ([NetworkError checkNetwork]) {
            
            [self showLoaderWithTitle:@"Sending OTP..."];
            
            if (self.loginModelClass == nil) {
                
                self.loginModelClass = [[LoginModelClass alloc] init];
                self.loginModelClass.delegate = self;
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:txtMobileNumber.text,@"userName", nil];
            
            [self.loginModelClass resendOTPRequest:dict];
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"MOBILE_DETAILS_MANDATORY", nil)];
        
        return;
    }
}

-(void)callLoginWebService:(NSMutableDictionary *)dict {
    
    [self resignKeyKeyboard:nil];
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Logging in..."];
        
        if (self.loginModelClass == nil) {
            
            self.loginModelClass = [[LoginModelClass alloc] init];
            self.loginModelClass.delegate = self;
        }
        
        [self.loginModelClass loginRequest:dict];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

#pragma mark - Login Model Class Delegate Method

-(void)didOTPVerifiedSuccessfully {
    
    [[NSUserDefaults standardUserDefaults] setObject:txtMobileNumber.text forKey:@"mobileNumber"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"+91" forKey:@"CountryCode"];

    //[[NSUserDefaults standardUserDefaults] setObject:txtCountryCode.text forKey:@"CountryCode"];

    [APP_DELEGATE addWallView];
    
    [self removeLoader];
}

-(void)didOTPVerifiedFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didLoginSuccessfully:(NSMutableDictionary *)responseDict {

    if ([[responseDict objectForKey:@"message"] isEqualToString:@"Otp sent please verifiy"] && [[responseDict objectForKey:@"CAN_RESEND_OTP"] intValue] == 1) {
        
        [self removeLoader];
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"OTP_ALREADY_SENT", nil)];
        
        return;
    }
    else if ([[responseDict objectForKey:@"success"] isEqualToString:@"User created, mobile otp required"]) {
        
        [[NSUserDefaults standardUserDefaults] setValue:[responseDict objectForKey:@"otp_testing_ask_to_delete_ecurity_issue"] forKey:@"Test_OTP"];
                
        if (self.loginModelClass == nil) {
            
            self.loginModelClass = [[LoginModelClass alloc] init];
            self.loginModelClass.delegate = self;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDict objectForKey:@"email"], @"userName", [[NSUserDefaults standardUserDefaults] objectForKey:@"Test_OTP"], @"otp", nil];
        
        [self.loginModelClass verifyOTPRequest:dict];

        /*[self removeLoader];

        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"VERIFY_OTP", nil)];
        
        return;*/
    }
    else if ([[responseDict objectForKey:@"success"] isEqualToString:@"User logged in successfuly"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:txtMobileNumber.text forKey:@"mobileNumber"];

        [[NSUserDefaults standardUserDefaults] setObject:@"+91" forKey:@"CountryCode"];
        
        //[[NSUserDefaults standardUserDefaults] setObject:txtCountryCode.text forKey:@"CountryCode"];

        [Common saveLoggedInUserInfoFromDictionary:responseDict];

        [APP_DELEGATE addWallView];
        
        [self removeLoader];
    }
    else if ([[responseDict objectForKey:@"message"] isEqualToString:@"Source should be one of linkedin, facebook or google or mobile"]) {
        
        [self removeLoader];
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString([responseDict objectForKey:@"message"], nil)];
        
        return;
    }
    else if ([[responseDict objectForKey:@"message"] isEqualToString:@"Enter 10 digit mobile number"]) {
        
        [self removeLoader];
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"OTP_ALREADY_SENT", nil)];
        
        return;
    }
    else if (([[responseDict objectForKey:@"message"] isEqualToString:@"Can not login"])) {
        
        [self removeLoader];
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString([responseDict objectForKey:@"message"], nil)];
        
        return;
    }
    else {
        
        [Common saveLoggedInUserInfoFromDictionary:responseDict];
    }
    
    [self removeLoader];
}

-(void)didLoginFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didResendOTPSuccessfully:(NSString *)message {
    
    //[self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"OTP_RESEND", nil)];
    
    [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:[NSString stringWithFormat:@"Please enter OTP %@", message]];
    
    [self removeLoader];
    
    return;
    
}

-(void)didResendOTPFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark - Animation Methods

-(void)didStartAnimation:(int)withValue {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    rect.origin.y = rect.origin.y - withValue;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)didEndAnimation {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didEndAnimation];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self didEndAnimation];
    
    if (textField.tag == 0) {
        
        [self didStartAnimation:100];
    }
    else {
        
        [self didStartAnimation:150];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];

    if (textField == txtMobileNumber) {
        
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
        }
        return false;
    }
    
    return YES;
}

-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    return simpleNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
