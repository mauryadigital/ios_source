//
//  DashboardViewController.m
//  LeaveManagement
//
//  Created by User on 5/27/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "DashboardViewController.h"
#import "ApplyViewController.h"
#import "ApplicationStatusViewController.h"
#import "HolidaysViewController.h"
#import "ApprovalViewController.h"
#import "EmpDetailsViewController.h"
#import "AvailableLeavesViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "HRPoliciesViewController.h"
@interface DashboardViewController ()

@end

@implementation DashboardViewController
@synthesize popupOkButton,popupViewPickerTextField,popupViewPickerValue,jsonDictionary,casualLeavesLabel,sickLeavesLabel,totalLeavesLabel,remainingLeavesLabel;
@synthesize isManagerLogin,approveLeavesButton,popup;
@synthesize empIdLabel,empNameLabel,empDesignationLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
       labelsArray=[[NSMutableArray alloc]initWithObjects:@"Apply For Leave",@"Holidays",@"Available Leaves",@"Leaves History",@"View Request Received",@"Emp Details",@"HRPolicies", nil];
    imagesArray=[[NSMutableArray alloc]initWithObjects:@"empApply.png",@"empholiday.png",@"empAvailable.png",@"Lhistory.png",@"managerview.png",@"empDetails.png",@"empDetails.png", nil];
    labelsArray1=[[NSMutableArray alloc]initWithObjects:@"Apply For Leave",@"Holidays",@"Available Leaves",@"Leaves History",@"HRPolicies", nil];
    imagesArray1=[[NSMutableArray alloc]initWithObjects:@"empApply.png",@"empholiday.png",@"empAvailable.png",@"Lhistory.png",@"empDetails.png", nil];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
      self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+100, self.view.frame.size.width-20, self.view.frame.size.height-180) collectionViewLayout:layout];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_collectionView];

    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
 
    
    if (appDelegate.isManagerLogin)
        approveLeavesButton.hidden=NO;
    else
        approveLeavesButton.hidden=YES;
    
    
    
    empDesignationLabel.text=@"";
    
    empNameLabel.text=@"";
    empIdLabel.text=@"";
    
  
    
    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);

    
    NSLog(appDelegate.isManagerLogin ? @"YES" : @"NO");
    empNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y-90, _collectionView.frame.size.width, 21)];
    [empNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
    empNameLabel.textColor=[UIColor blackColor];
    [self.view addSubview:empNameLabel];
    
    empDesignationLabel=[[UILabel alloc]initWithFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y-65, _collectionView.frame.size.width, 21)];
    [empDesignationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
    empDesignationLabel.textColor=[UIColor blackColor];
    [self.view addSubview:empDesignationLabel];
    
    
    empIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y-40, _collectionView.frame.size.width, 21)];
    [empIdLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
    empIdLabel.textColor=[UIColor blackColor];
    [self.view addSubview:empIdLabel];
   
    
  //  AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"APPDELEGATE ACCESS %@",appDelegate.accessTokenString);
    [super viewWillAppear:YES];
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/list?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
        // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    

    UIGestureRecognizer *tapper;
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(popupOkButtonAction:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=TRUE;
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *btnImg = [UIImage imageNamed:@"arrow-left_red.png"];
//    [btn setImage:btnImg forState:UIControlStateNormal];
//    
//    btn.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
//    [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn] ;
    
    
   settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg1 = [UIImage imageNamed:@"setting.png"];
    [settingsBtn setImage:btnImg1 forState:UIControlStateNormal];
    
    settingsBtn.frame = CGRectMake(0, 0, btnImg1.size.width, btnImg1.size.height);
    [settingsBtn addTarget:self action:@selector(settingsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn] ;
    settingsBtn.selected=YES;
    popup.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
    [_collectionView addSubview:popup];

    popup.hidden=YES;
    popupViewPickerValue.textAlignment=NSTextAlignmentCenter;
    popupViewPickerTextField.delegate=self;
    popupViewPickerValue.delegate=self;
    popupPickerArray = [[NSMutableArray alloc]initWithObjects:@"Paid Leaves",@"Earned Leaves", nil];
    popupViewPickerTextField.delegate=self;
    [_collectionView reloadData];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];

    
}
-(void) requestFinished: (ASIHTTPRequest *) request {
    if(request.tag==111){
        
        NSString *theJSON = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@"Dictionary %@",jsonDictionary);
        NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
        NSLog(@"str %@",str);
        AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;

        if([str isEqualToString:@"SUCCESS"]){
            appDelegate.accessTokenString=@"";
            if (appDelegate.isManagerLogin)
                appDelegate.isManagerLogin=NO;
          
            else
                appDelegate.isManagerLogin=YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
    }
    
    
    else{
    // [request responseString]; is how we capture textual output like HTML or JSON
    // [request responseData]; is how we capture binary output like images
    // Then to create an image from the response we might do something like
    // UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    NSString *theJSON = [request responseString];
    NSLog(@"THE JSON %@",theJSON);
    // Now we have successfully captured the JSON ouptut of our request
    //  [self.navigationController pushViewController:objHomeViewController animated:YES];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
   jsonDictionary = [parser objectWithString:theJSON error:nil];
    // NSMutableDictionary *divisionDictionary = [jsonDictionary valueForKey:@""];
    NSLog(@"Available Leaves dictionary %@",jsonDictionary);
    NSString *casualString=[jsonDictionary valueForKey:@"casualLeave"];
      NSString *sickLeaveString=[jsonDictionary valueForKey:@"sickLeave"];
    paidLeavesString=[[NSString alloc]init];
AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        appDelegate.leavesDictionary=[jsonDictionary mutableCopy];
  // paidLeavesString=[jsonDictionary valueForKey:@"paidLeave"];
    NSString *totalLeavesString=[jsonDictionary valueForKey:@"totalLeaves"];
    NSString *remainingLeavesString=[jsonDictionary valueForKey:@"remainingLeaves"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict objectForKey:[jsonDictionary valueForKey:@"employeeInformationVO"]];
   dict=[jsonDictionary valueForKey:@"employeeInformationVO"];
   NSLog(@"EMP ARRAY %@",[dict valueForKey:@"designation"]);
  
        empDesignationLabel.text=@"";
        empNameLabel.text=@"";
        empIdLabel.text=@"";
        
        empId=[dict valueForKey:@"employeeInformationID"] ;
        NSLog(@"empID %@",empId);

    
    if (dict.count!=0) {
        empDesignationLabel.text=[NSString stringWithFormat:@"Designation : %@",[[dict valueForKey:@"designation"] lowercaseString]];
       
        empNameLabel.text=[NSString stringWithFormat:@"Name : %@",[dict valueForKey:@"employeeName"]];
        empIdLabel.text=[NSString stringWithFormat:@"EmailID : %@",[[dict valueForKey:@"email"] lowercaseString]];

    
    
    
    }
    NSLog(@"sickLeave %@",sickLeaveString);
    casualLeavesLabel.text=casualString;
    sickLeavesLabel.text=sickLeaveString;
    totalLeavesLabel.text=totalLeavesString;
    remainingLeavesLabel.text=remainingLeavesString;
    }
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}
- (IBAction)popupOkButtonAction:(id)sender {
    
    popup.hidden=YES;
    _collectionView.alpha=1.0;
    popupViewPickerTextField.text=@"";
    popupViewPickerValue.text=@"";
    popupPicker.hidden=YES;
    toolBar.hidden=YES;
    [popupPicker removeFromSuperview];
    [toolBar removeFromSuperview];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [popupPicker selectRow:0 inComponent:0 animated:YES];
    // The delegate method isn't called if the row is selected programmatically
    [self pickerView:popupPicker didSelectRow:0 inComponent:0];

    [self addPickerView];
    [popupPicker removeFromSuperview];
    
    [toolBar removeFromSuperview];
    [popupViewPickerTextField becomeFirstResponder];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)addPickerView{
    
    popupPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, popup.frame.size.height+popup.frame.origin.y, self.view.frame.size.width, 100)];
    popupPicker.dataSource = self;
    popupPicker.delegate = self;
    popupPicker.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          popupPicker.frame.size.height-50, self.view.frame.size.width, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    popupViewPickerTextField.inputView = popupPicker;
    popupViewPickerTextField.inputAccessoryView = toolBar;
    [self.view addSubview:popupPicker];
    [self.view addSubview:toolBar];
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [popupViewPickerTextField setText:[popupPickerArray objectAtIndex:row]];
    
    if (row==0) {
        NSString *str=[jsonDictionary valueForKey:@"Paid Leaves"];
        if (str.length==0) {
            popupViewPickerValue.text=@"no";
        }
        else{
        popupViewPickerValue.text=str;
        }
    }
    else
    {
        
        popupViewPickerValue.text=[jsonDictionary valueForKey:@"earnedLeave"];
        
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [popupPickerArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    return [popupPickerArray objectAtIndex:row];
}
-(void)done:(id)sender{
    
    NSLog(@"Done");
   [popupPicker selectRow:0 inComponent:0 animated:YES];

    [popupPicker removeFromSuperview];
    
    [popupViewPickerTextField resignFirstResponder];
    
    [toolBar removeFromSuperview];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    
    [super viewDidAppear:YES];
    
    
    
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Leave Management System"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)settingsButtonAction:(id)sender{
   
    
    if ([settingsBtn isSelected]) {

    CGRect tabFrame=[UIScreen mainScreen].bounds;
    
    
    settingsView=[[UIView alloc]initWithFrame:CGRectMake(tabFrame.size.width-140,0,140, 80)];
    settingsView.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];

    UIButton *changePwdButton=[UIButton buttonWithType:UIButtonTypeCustom];
   //[changePwdButton setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    [changePwdButton setTitle:@"ChangePassword" forState:UIControlStateNormal];
        changePwdButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
        changePwdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        changePwdButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        [changePwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [changePwdButton setBackgroundColor:[UIColor redColor]];
    [changePwdButton addTarget:self action:@selector(changePasswordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    changePwdButton.frame=CGRectMake(5,10,120,30);
    [changePwdButton setUserInteractionEnabled:YES];
    UIButton *logoutButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
   //[logoutButton setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        logoutButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
        logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        logoutButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    //[logoutButton setBackgroundColor:[UIColor redColor]];
    [logoutButton addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.frame=CGRectMake(5,40,120,30);
    [logoutButton setUserInteractionEnabled:YES];
    [settingsView addSubview:changePwdButton];
    [settingsView addSubview:logoutButton];
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionTransitionFlipFromTop
                         animations:^{
                             [self.view addSubview:settingsView];
                             
                         }
                         completion:^(BOOL finished){
                         }];
        

        [settingsBtn setSelected: NO];

    }
    else{
       
        [self closeSettings];

        
        

    }
}
-(void)closeSettings{

    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         settingsView.frame=CGRectMake(0, 0, 0, 0);
                         settingsView.hidden=YES;

                     }
                     completion:^(BOOL finished){
                     }];
    

    [settingsBtn setSelected: YES];



}
- (void)changePasswordButtonAction:(id)sender {
    
    changePwd=[[ChangePasswordsViewController alloc]initWithNibName:@"ChangePasswordsViewController" bundle:nil];
    
    [self.navigationController pushViewController:changePwd animated:YES];
}

-(void)logoutButtonAction:(id)sender
{
    
    
    
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/logout?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=111;
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    appDelegate.accessTokenString=@"";


    [self.view addSubview:spinner];
    [spinner startAnimating];
    
 
    
}
//Collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger count;
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
 
    if (appDelegate.isManagerLogin) {
   count=[labelsArray count];
    }
    else{
    
        count=[labelsArray1 count];
    }
    return count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
 cell.backgroundColor=[UIColor clearColor];
    
    UIButton *cellButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    cellButton.frame=CGRectMake(0,0, 100, 100);
    //[cellButton setBackgroundImage:[UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    cellButton.tag=indexPath.row;
    [cellButton addTarget:self action:@selector(gridButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:cellButton];
    cellButton.alpha=1.0;
    UIButton *imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    imageButton.frame=CGRectMake(cell.frame.size.width/2-30,10, 64, 64);
    imageButton.tag=indexPath.row;
    [imageButton addTarget:self action:@selector(gridButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
      [cell addSubview:imageButton];
    imageButton.alpha=1.0;
    UILabel *descLbl;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
        {
          descLbl=[[UILabel alloc]initWithFrame:CGRectMake(imageButton.frame.origin.x-40, imageButton.frame.origin.y+imageButton.frame.size.height-10, cell.frame.size.width,50)];
            [descLbl setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
            
        }
        
        
        
        else if ([[UIScreen mainScreen] bounds].size.height >= 667)
        {
           descLbl=[[UILabel alloc]initWithFrame:CGRectMake(imageButton.frame.origin.x-50, imageButton.frame.origin.y+imageButton.frame.size.height-10, cell.frame.size.width,50)];
            
            [descLbl setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
            
        }
    }
    
    else
    {
        //[ipad]
    }

    
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;

    if (appDelegate.isManagerLogin) {
       descLbl.text=@"";
        descLbl.text=[labelsArray objectAtIndex:indexPath.row];
        [imageButton setBackgroundImage:[UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];

    }
    else{
        descLbl.text=@"";

        descLbl.text=[labelsArray1 objectAtIndex:indexPath.row];
        [imageButton setBackgroundImage:[UIImage imageNamed:[imagesArray1 objectAtIndex:indexPath.row]] forState:UIControlStateNormal];

    
    }
    
    descLbl.textColor=[UIColor blackColor];
    descLbl.textAlignment=NSTextAlignmentCenter;
    

    [cell addSubview:descLbl];
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{






}

-(void)gridButtonCliked:(UIButton*)sender{
    
   

    if (sender.tag==2)
    {
        AvailableLeavesViewController *objAvailableLeavesViewController=[[AvailableLeavesViewController alloc]initWithNibName:@"AvailableLeavesViewController" bundle:nil];
        [self.navigationController pushViewController:objAvailableLeavesViewController animated:YES];
        
    }
    else if (sender.tag==1){
    
        HolidaysViewController *objHolidaysViewController=[[HolidaysViewController alloc]initWithNibName:@"HolidaysViewController" bundle:nil];
        [self.navigationController pushViewController:objHolidaysViewController animated:YES];
    
    
    
    }

    else if (sender.tag==0){
        
        ApplyViewController *apply=[[ApplyViewController alloc]initWithNibName:@"ApplyViewController" bundle:nil];
        NSLog(@"empID Value %@",empId);
        apply.empInformationId=empId;
        apply.leavesDictionary=[jsonDictionary mutableCopy];
        [self.navigationController pushViewController:apply animated:YES];
        
        
        
    }
    else if (sender.tag==3){
        AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        appDelegate.isHistory=TRUE;
        ApprovalViewController *objApprovalViewController=[[ApprovalViewController alloc]initWithNibName:@"ApprovalViewController" bundle:nil];
        [self.navigationController pushViewController:objApprovalViewController animated:YES];

        
        
        
    }
    else if (sender.tag==4){
        
        AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        appDelegate.isHistory=FALSE;

        if (appDelegate.isManagerLogin) {
        ApprovalViewController *objApprovalViewController=[[ApprovalViewController alloc]initWithNibName:@"ApprovalViewController" bundle:nil];
        [self.navigationController pushViewController:objApprovalViewController animated:YES];

        }
        else{
        
            HRPoliciesViewController *objHRPoliciesViewController=[[HRPoliciesViewController alloc]initWithNibName:@"HRPoliciesViewController" bundle:nil];
            [self.navigationController pushViewController:objHRPoliciesViewController animated:YES];
            
        
        }
        
        
    }

    else if (sender.tag==5){
        
        EmpDetailsViewController *objEmpDetailsViewController=[[EmpDetailsViewController alloc]initWithNibName:@"EmpDetailsViewController" bundle:nil];
        [self.navigationController pushViewController:objEmpDetailsViewController animated:YES];
        
        
        
        
    }
    else if (sender.tag==6){
        
        HRPoliciesViewController *objHRPoliciesViewController=[[HRPoliciesViewController alloc]initWithNibName:@"HRPoliciesViewController" bundle:nil];
        [self.navigationController pushViewController:objHRPoliciesViewController animated:YES];
        
        
        
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize collectionCells;
    
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
        {
            collectionCells=CGSizeMake(145, 100);
           
        }
        
        
        
        else if ([[UIScreen mainScreen] bounds].size.height >= 667)
        {
            collectionCells=CGSizeMake(170, 110);
  
           
        }
    }
    
    else
    {
        //[ipad]
    }
    

    
    
    
    
    return collectionCells;
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
