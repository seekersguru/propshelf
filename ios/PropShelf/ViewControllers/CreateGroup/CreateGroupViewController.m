//
//  CreateGroupViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "CreateGroupViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface CreateGroupViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>

@property (nonatomic,strong) UIPickerView *providerPickerView;
@property (nonatomic,strong) NSMutableArray *cityArray;
@property (nonatomic,strong) NSMutableArray *locationArray;
@property (nonatomic,strong) NSString *selectedCity;

@end

@implementation CreateGroupViewController

@synthesize locationModelClass;
@synthesize createGroupModelClass;
@synthesize selectedCity;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"CREATE_GROUP_NAV_TITLE", nil);
    
    groupPicBtn.layer.cornerRadius = 30.0;
    groupPicBtn.layer.masksToBounds = YES;

    [[description layer] setBorderColor:[[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0] CGColor]];
    [[description layer] setBorderWidth:1.0];
    [[description layer] setCornerRadius:5.0];
    
    [[createGroupBtn layer] setCornerRadius:5.0];
    
    [self setToolbarItems];
    
    [self getAllCities];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
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
    
    txtGroupName.inputAccessoryView = Keyboardtoolbar;
    txtCity.inputAccessoryView = Keyboardtoolbar;
    txtLocation.inputAccessoryView = Keyboardtoolbar;
    description.inputAccessoryView = Keyboardtoolbar;
}

#pragma mark - KeyBoard Next, Previuos & Done Methods

-(void)PreviousField:(id)sender
{    
    if([txtGroupName isFirstResponder])
    {
        [description becomeFirstResponder];
    }
    else if([txtCity isFirstResponder])
    {
        [txtGroupName becomeFirstResponder];
    }
    else if([txtLocation isFirstResponder])
    {
        [txtCity becomeFirstResponder];
    }
    else if([description isFirstResponder])
    {
        [txtLocation becomeFirstResponder];
    }
}

-(void)NextField:(id)sender
{
    if([txtGroupName isFirstResponder])
    {
        [txtCity becomeFirstResponder];
    }
    else if([txtCity isFirstResponder])
    {
        [txtLocation becomeFirstResponder];
    }
    else if([txtLocation isFirstResponder])
    {
        [description becomeFirstResponder];
    }
    else if([description isFirstResponder])
    {
        [txtGroupName becomeFirstResponder];
    }
}

-(void)resignKeyKeyboard:(id)sender
{
    [self didEndAnimation];
    
    [txtGroupName resignFirstResponder];
    [txtCity resignFirstResponder];
    [txtLocation resignFirstResponder];
    [description resignFirstResponder];
    
    [self.view endEditing:YES];
}

#pragma mark - Get All Cities Methods

-(void)getAllCities {
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading Cities..."];
        
        if (self.locationModelClass == nil) {
            
            self.locationModelClass = [[LocationModelClass alloc] init];
            self.locationModelClass.delegate = self;
        }
        
        [self.locationModelClass getCitiesRequest];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

-(void)getAllLocations {
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading Locations..."];
        
        if (self.locationModelClass == nil) {
            
            self.locationModelClass = [[LocationModelClass alloc] init];
            self.locationModelClass.delegate = self;
        }
        
        [self.locationModelClass getLocationRequest:selectedCity];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

#pragma mark - Button Action Methods

-(IBAction)createGroupBtnTapped:(id)sender {
    
    [self didEndAnimation];

    if ([txtGroupName.text length] >= 3) {
        
        if ([description.text length] >= 10) {

            if ([txtCity.text length] > 0 && [txtLocation.text length] > 0) {
                
                if ([NetworkError checkNetwork]) {
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNewCreated"];
                    
                    [self showLoaderWithTitle:@"Creating Group..."];
                    
                    if (self.createGroupModelClass == nil) {
                        
                        self.createGroupModelClass = [[CreateGroupModelClass alloc] init];
                        self.createGroupModelClass.delegate = self;
                    }
                    
                    NSMutableDictionary *dict = nil;
                    
                    NSData* imageData = [Common resizeImageData:groupPicBtn.imageView.image];
                    NSString *streamBase64 = [ASIHTTPRequest base64forData:imageData];
                    
                    if ([description.text length] > 0) {
                        
                        if (streamBase64 == nil) {
                            
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:txtGroupName.text, @"name", txtCity.text, @"city", txtLocation.text, @"location", description.text, @"description", nil];
                        }
                        else {
                            
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:txtGroupName.text, @"name", txtCity.text, @"city", txtLocation.text, @"location", description.text, @"description", streamBase64, @"group_pic", nil];
                        }
                    }
                    else {
                        
                        if (streamBase64 == nil) {
                            
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:txtGroupName.text, @"name", txtCity.text, @"city", txtLocation.text, @"location", nil];
                        }
                        else {
                            
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:txtGroupName.text, @"name", txtCity.text, @"city", txtLocation.text, @"location", streamBase64, @"group_pic", nil];
                        }
                    }
                    
                    [self.createGroupModelClass createGroupRequest:dict];
                }
                else {
                    
                    [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
                    
                    return;
                }
            }
            else {
                
                [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"ENTER_MANDATORY_FIELDS", nil)];
            }
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"DESCRIPTION_VALIDATION_FIELDS", nil)];
        }
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"GROUP_NAME_VALIDATION_FIELDS", nil)];
        
        return;
    }
}

-(IBAction)groupPicBtnTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Exiting Photo", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}


#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet.tag == 0) {
        
        switch (buttonIndex) {
            case 0://Camera Take Photo or Video
                
                if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront|UIImagePickerControllerCameraDeviceRear]){
                    
                    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
                    imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    //For Video --> //ipc.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString *) kUTTypeImage, nil];
                    imgPickerController.allowsEditing = NO;
                    imgPickerController.showsCameraControls = YES;
                    imgPickerController.delegate = self;
                    
                    [self presentViewController:imgPickerController animated:YES completion:nil];
                }
                else{
                    
                    [Common showAlertWithTitle:NSLocalizedString(@"ERROR_ALERT_TITLE", nil) andMessage:NSLocalizedString(@"CAMERA_UNAVAILABLE", nil)];
                }
                
                break;
            case 1: {
                
                if ([UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeSavedPhotosAlbum])
                {
                    UIImagePickerController *imagePicker =
                    [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType =
                    UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                              (NSString *) kUTTypeImage,
                                              nil];
                    imagePicker.allowsEditing = NO;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
            }
                break;
            default:
                
                break;
        }
    }
    else {
        
    }
}

#pragma mark -
#pragma mark UIImagePicker Methods

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    picker = nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        [groupPicBtn setImage:[Common resizeImage:image] forState:UIControlStateNormal];
        
        //NSData* imageData = [Common resizeImageData:image];
        //NSString *streamBase64 = [ASIHTTPRequest base64forData:imageData];
        
        image = nil;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
        
    mediaType = nil;
}

#pragma mark - Create Group Model Class Delegate

-(void)didCreateGroupSuccessfully:(NSString *)message {
    
    if ([message isEqualToString:@"Group with same name already exists"]) {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:message];
        
        return;
    }
    
    [self removeLoader];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didCreateGroupFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didGetGroupUserSuccessfully:(NSMutableArray *)userArray {

    [self removeLoader];
}

-(void)didGetGroupUserFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark - Location Model Class Delegate

-(void)didGetCitiesSuccessfully:(NSMutableArray *)citiesArray {
    
    self.cityArray = [citiesArray mutableCopy];
    
    [self removeLoader];
}

-(void)didGetCitiesFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didGetLocationsSuccessfullyDict:(NSMutableDictionary *)locationsDict {
    
    [self removeLoader];
}

-(void)didGetLocationsSuccessfullyArray:(NSMutableArray *)locationsArray {
    
    self.locationArray = [locationsArray mutableCopy];
    
    [self removeLoader];
    
    [self showPickerView];
}

-(void)didGetLocationsFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark - Show Picker View

-(void)showPickerView {
    
    if (self.providerPickerView != nil) {
        self.providerPickerView = nil;
        self.providerPickerView.delegate = nil;
        self.providerPickerView.dataSource = nil;
    }
    
    // Add the picker
    self.providerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 200, 0, 0)];
    self.providerPickerView.delegate = self;
    self.providerPickerView.dataSource = self;
    self.providerPickerView.showsSelectionIndicator = YES;
    [self.providerPickerView selectRow:0 inComponent:0 animated:NO];
    self.providerPickerView.backgroundColor = [UIColor whiteColor];
    
    if (isCity == YES) {
        
        txtCity.inputView = self.providerPickerView;
    }
    else if (isLocation == YES) {
        
        txtLocation.inputView = self.providerPickerView;
    }
}

- (void)dismissActionSheet:(id)sender {
    
    [txtLocation resignFirstResponder];
    [txtCity resignFirstResponder];
}

#pragma mark - UIPickerView Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isCity == YES) {
        
        txtCity.text = [self.cityArray objectAtIndex:row];
        
        selectedCity = [self.cityArray objectAtIndex:row];
    }
    else if (isLocation == YES) {
        
        txtLocation.text = [self.locationArray objectAtIndex:row];
    }
    
    //NSLog(@"Selected :- %@",selectedCat);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    int value = 0;
    
    if (isCity == YES) {
        
        value = self.cityArray.count;
    }
    else if (isLocation == YES) {
        
        value = self.locationArray.count;
    }
    
    return value;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    
    if (isCity == YES) {
        
        title = [self.cityArray objectAtIndex:row];
    }
    else if (isLocation == YES) {
        
        title = [self.locationArray objectAtIndex:row];
    }
    
    return title;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didEndAnimation];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self didEndAnimation];

    if(textField.tag == 1)
    {

    }
    else if(textField.tag == 2)
    {
        isCity = YES;
        isLocation = NO;

        [self showPickerView];
    }
    else if(textField.tag == 3)
    {
        isCity = NO;
        isLocation = YES;
        
        if ([txtCity.text length] > 0 && self.locationArray.count == 0) {
            
            [self getAllLocations];
        }
        else if ([txtLocation.text length] == 0){
            
            [self showAlertViewWithTitle:NSLocalizedString(@"APP_POPUP_TITLE", nil) message:NSLocalizedString(@"SELECT_CITY", nil)];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    /*if (textField == txtCity || textField == txtLocation) {
        
        return NO;
    }*/
    
    return YES;
}

#pragma mark - UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [self didEndAnimation];

    if(textView.tag == 4)
    {
        [self didStartAnimation:70];
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.tag == 4) {
        
        if (description.text.length > 0) {
            descriptionPlaceHolder.hidden = YES;
        }
        else {
            descriptionPlaceHolder.hidden = NO;
        }
    }
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
