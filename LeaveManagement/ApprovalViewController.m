//
//  ApprovalViewController.m
//  LeaveManagement
//
//  Created by User on 5/20/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ApprovalViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "ApprovedCellTableViewCell.h"
#import "ApprovalTableviewCell.h"
#import "ApprovedCellTableViewCell5.h"

@interface ApprovalViewController ()

@end

@implementation ApprovalViewController

//
//  ApplicationStatusViewController.m
//  LeaveManagement
//
//  Created by User on 5/17/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//


@synthesize approvalTable,leaveManagerTable,leaveManagerView,leaveManagerTitleLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
        {
            static NSString *simpleTableIdentifier5 = @"ApprovedCellTableViewCell5";
            UINib *nib = [UINib nibWithNibName:@"ApprovedCellTableViewCell5" bundle:nil];
            [approvalTable registerNib:nib forCellReuseIdentifier:simpleTableIdentifier5];
            
            
        }
        
        
        
        else if ([[UIScreen mainScreen] bounds].size.height >= 667)
        {
            static NSString *simpleTableIdentifier = @"ApprovedCellTableViewCell";
            UINib *nib = [UINib nibWithNibName:@"ApprovedCellTableViewCell" bundle:nil];
            [approvalTable registerNib:nib forCellReuseIdentifier:simpleTableIdentifier];
            
            
            
        }
    }
    
    else
    {
        //[ipad]
    }
    
    

    
    
    static NSString *managerCellIdentifier = @"ApprovalTableviewCell";
    
        UINib *nib1 = [UINib nibWithNibName:@"ApprovalTableviewCell" bundle:nil];
    [leaveManagerTable registerNib:nib1 forCellReuseIdentifier:managerCellIdentifier];
    

    
    empParamsArray=[[NSMutableArray alloc]initWithObjects:@"Name",@"Deportment",@"Type",@"No of Days",@"From",@"To",@"Reason", nil];
    historyEmpParamsArray=[[NSMutableArray alloc]initWithObjects:@"Type",@"No of Days",@"From",@"To",@"Reason", nil];
//    empDetailsArray=[[NSMutableArray alloc]initWithObjects:@"swathi",@"Technical",@"Staff",@"1",@"24-05-2016",@"25-05-2016",@"Stomach pain", nil];
    
   appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    index=0;
    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));

    
    tabFrame=[UIScreen mainScreen].bounds;
    
 self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    leaveManagerView=[[UIView alloc]initWithFrame:CGRectMake(20, 100, tabFrame.size.width-80, 400)];
    leaveManagerTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, tabFrame.size.width-40, tabFrame.size.height-70) style:UITableViewStylePlain];
    leaveManagerTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tabFrame.size.width-8, 30)];
    leaveManagerTitleLabel.backgroundColor=[UIColor colorWithRed:175.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    [leaveManagerTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];

    leaveManagerTitleLabel.text=@"Leave Manager";
    leaveManagerTitleLabel.textColor=[UIColor whiteColor];
    leaveManagerTitleLabel.textAlignment=NSTextAlignmentCenter;
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    //[closeButton setTitle:@"Close" forState:UIControlStateNormal];
    //[closeButton setBackgroundColor:[UIColor redColor]];
    [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame=CGRectMake(leaveManagerTitleLabel.frame.size.width-40,5, 24, 24);
    closeButton.userInteractionEnabled=YES;
    leaveManagerTitleLabel.userInteractionEnabled=YES;
    
    [leaveManagerView addSubview:leaveManagerTitleLabel];
    [leaveManagerView addSubview:leaveManagerTable];
    [self.view addSubview:leaveManagerView];
    [leaveManagerTitleLabel addSubview:closeButton];
    
    
    
    leaveManagerView.hidden=YES;
    leaveManagerTable.tag=222;
    approvalTable.tag=111;
 leaveManagerView.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationItem.hidesBackButton=TRUE;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"arrow-left_red.png"];
    [btn setImage:btnImg forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn] ;
    UIButton *logutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg1 = [UIImage imageNamed:@"logout.jpeg"];
    [logutbtn setImage:btnImg1 forState:UIControlStateNormal];
    
    logutbtn.frame = CGRectMake(0, 0, btnImg1.size.width, btnImg1.size.height);
    [logutbtn addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logutbtn] ;
    approvalTable.delegate=self;
    approvalTable.dataSource=self;
    
    
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 5, tabFrame.size.width/3,30)];
    if (appDelegate.isHistory) {
        departmentLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+20,0,approvalTable.frame.size.width/4,45)];
    }
    else{
    departmentLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+10,5,tabFrame.size.width/4+20,30)];
    }
    departmentLabel.lineBreakMode=NSLineBreakByWordWrapping;
    
    departmentLabel.numberOfLines=2;
 
    statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(departmentLabel.frame.size.width+departmentLabel.frame.origin.x-5,5,tabFrame.size.width/3,30)];
    
    nameLabel.textAlignment=NSTextAlignmentCenter;
    
    departmentLabel.textAlignment=NSTextAlignmentCenter;
    statusLabel.textAlignment=NSTextAlignmentCenter;
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [departmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    
    CGRect headerFrame = CGRectMake(approvalTable.frame.origin.x,0,approvalTable.frame.size.width,40);
    
    //    UILabel *labelView = [[UILabel alloc] initWithFrame:headerFrame];
    //    labelView.textAlignment = NSTextAlignmentCenter;
    //    labelView.text=@"Apply For Leave";
    //    [labelView setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    //
    //    labelView.backgroundColor=[UIColor clearColor];
    //    labelView.textColor=[UIColor colorWithRed:175.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    

    if (appDelegate.isHistory) {
        nameLabel.text=@"Date Applied";
        departmentLabel.text=@"No.of Leaves";
        statusLabel.text=@"Status";
       leaveManagerTitleLabel.text=@"Cancel Leave";
       
    }
    else{
       
        nameLabel.text=@"Name";
        departmentLabel.text=@"Department";
        statusLabel.text=@"Status";
        leaveManagerTitleLabel.text=@"Manager Approvals";

    
    }
    
        UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    
    headerView.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:6.0/255.0 blue:4.0/255.0 alpha:1.0];
    nameLabel.textColor=[UIColor blackColor];
    departmentLabel.textColor=[UIColor blackColor];
    statusLabel.textColor=[UIColor blackColor];
    [headerView addSubview:nameLabel];
    [headerView addSubview:departmentLabel];
    [headerView addSubview:statusLabel];
    [self.view addSubview:headerView];
  // approvalTable.tableHeaderView = headerView;
    
    //footer
    
    footerFrame = CGRectMake(leaveManagerTable.frame.origin.x,0,leaveManagerTable.frame.size.width,60);
    
    UIView *footerView = [[UIView alloc] initWithFrame:footerFrame];
    UIView *cancelFooterView = [[UIView alloc] initWithFrame:footerFrame];
//approveButton
    
    UIButton *approveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [approveButton setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    [approveButton setTitle:@"Approve" forState:UIControlStateNormal];
    [approveButton setBackgroundColor:[UIColor redColor]];
    [approveButton addTarget:self action:@selector(approveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    approveButton.frame=CGRectMake((leaveManagerTable.frame.size.width/2-70)/2, 0,80,30);
    [approveButton setUserInteractionEnabled:YES];
    
//rejectButton
    
    UIButton *rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rejectButton setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    [rejectButton setTitle:@"Reject" forState:UIControlStateNormal];
    [rejectButton setBackgroundColor:[UIColor redColor]];
    [rejectButton addTarget:self action:@selector(rejectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    rejectButton.frame=CGRectMake(leaveManagerTable.frame.size.width/2+approveButton.frame.origin.x, 0, 80,30);
    [rejectButton setUserInteractionEnabled:YES];
    
    //cancel button
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor redColor]];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame=CGRectMake(footerView.frame.size.width/2-30, 0,80,30);
    [cancelButton setUserInteractionEnabled:YES];

    
    [footerView setUserInteractionEnabled:YES];
    [footerView addSubview:rejectButton];
    [footerView addSubview:approveButton];
    [cancelFooterView addSubview:cancelButton];
    
    //buttons adding to footer
    if (appDelegate.isHistory) {
        leaveManagerTable.tableFooterView = cancelFooterView;
    }
    else{
    leaveManagerTable.tableFooterView = footerView;
    }
    [rejectButton becomeFirstResponder];
    [self getData];
    // webservices for status tables
       [super viewWillAppear:YES];
    
}
//ServiceCall
-(void)getData{


    NSString *urlString;
    
    if (appDelegate.isHistory) {
        urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/history?access_token=%@",appDelegate.accessTokenString];
    }
    
    else{
        
        urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/approvalList?access_token=%@",appDelegate.accessTokenString];
        
    }
    
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=666;
    [request startAsynchronous];
    
    //spinner
    
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    

}

//Getting response
-(void) requestFinished: (ASIHTTPRequest *) request {
    
    //status table data
    if(request.tag==111){
        NSString *theJSON = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@"Dictionary %@",jsonDictionary);
        NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
        NSLog(@"str %@",str);
        if([str isEqualToString:@"SUCCESS"]){
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
    }
    
    //Approval service response
    else if(request.tag==555){
    
        NSString *theJSON = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@" Approve Dictionary %@",jsonDictionary);
        
        NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
        NSLog(@"str %@",str);
        if([str isEqualToString:@"SUCCESS"]){
            
            // Begin update
            
            // Perform update
            [nameArray removeObjectAtIndex:index.row];
            [departmentArray removeObjectAtIndex:index.row];
            [statusArray removeObjectAtIndex:index.row];
            [approvalTable reloadData];
            approvalTable.delegate=self;
            approvalTable.dataSource=self;
            // End update
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Status updated successfully" preferredStyle:UIAlertControllerStyleAlert];
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alertController dismissViewControllerAnimated:YES completion:^{
                                     // set afterDelay as per your requirement.

                    //[self.navigationController popViewControllerAnimated:YES];
//                    [statusArray removeAllObjects];
//                    [self getData];
//                    [approvalTable reloadData];
//                    [approvalTable setDelegate:self];
//                    [approvalTable setDataSource:self];
                }];
                
            });
            
        }
        
        
        
    }
    else if(request.tag==666)
    {
        nameArray=[[NSMutableArray alloc]init];
        departmentArray=[[NSMutableArray alloc]init];
        statusArray=[[NSMutableArray alloc]init];
    NSString *theJSON = [request responseString];
    NSLog(@"THE JSON %@",theJSON);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
   approvalJsonDictionary = [parser objectWithString:theJSON error:nil];
    NSLog(@"Approval Dictionary %@",approvalJsonDictionary);
        if (appDelegate.isHistory) {
           
            results=nil;
            results=[[NSArray alloc]init];
            NSLog(@"Application Status Dictionary %@",approvalJsonDictionary);
            
            
            results = [approvalJsonDictionary valueForKey:@"leaveHistoryVOs"];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            for (int i=0; i<results.count; i++) {
                dict=[results objectAtIndex:i];
                
                NSString *leaveAppliedDateString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"leaveAppliedDate"]];
                
                NSArray* dateArray = [leaveAppliedDateString componentsSeparatedByString: @" "];
                
                
                
                [nameArray addObject:[dateArray objectAtIndex:0]];
                
                NSString *numberOfLeaveDaysString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"numberOfLeaveDays"]];
                [departmentArray addObject:numberOfLeaveDaysString];
                NSString *leaveStatusString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"leaveStatus"]];
                [statusArray addObject:leaveStatusString];
                
                
                
            }

        
    }
        else{
            results = [approvalJsonDictionary valueForKey:@"approvalVOs"];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            for (int i=0; i<results.count; i++) {
                dict=[results objectAtIndex:i];
                
                NSString *leaveAppliedDateString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"employeeName"]];
                [nameArray addObject:leaveAppliedDateString];
                
                
                NSString *numberOfLeaveDaysString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"department"]];
                [departmentArray addObject:numberOfLeaveDaysString];
                NSString *leaveStatusString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"leaveStatus"]];
                [statusArray addObject:leaveStatusString];
                
                
            }
            
            
                   }
    
    NSLog(@"dateAppliedArray %lu",(unsigned long)nameArray.count);
    NSLog(@"noOfLeavesArray %@",departmentArray);
    
    NSLog(@"statusArray %@",statusArray);
    [approvalTable reloadData];
    approvalTable.delegate=self;
    approvalTable.dataSource=self;
    }
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}
-(void)handle_data
{
    [approvalTable reloadData];
    approvalTable.delegate=self;
    approvalTable.dataSource=self;
}
-(void)approveButtonAction{
    
    [self postValues];
    [self removemanagerView];

}
- (void)closeButtonAction:(id)sender{
    
    
    [self removemanagerView];


}
-(void)removemanagerView{

    approvalTable.alpha=1.0;
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         approvalTable.userInteractionEnabled=YES;
                         leaveManagerView.frame = CGRectMake(0, 490, 375, 300);
                         
                         leaveManagerView.hidden=YES;
                         
                     }
                     completion:^(BOOL finished){
                     }];


}
-(void)rejectButtonAction{
    [self postValues1];

    [self removemanagerView];
    


}
-(void)cancelButtonAction{
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/update"];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    request.tag=555;
    
    
    
    [request setRequestMethod:@"POST"];
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", appDelegate.accessTokenString];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    //[request setPostValue:@"access_token" forKey:appDelegate.accessTokenString];
    [request addRequestHeader:@"Authorization" value:authValue];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    [dict setValue:[approvalDictArray objectAtIndex:0] forKey:@"employeeLeaveGrantedID"];
    
    [dict setValue:@"CANCELLED" forKey:@"leaveStatus"];
    
    [request appendPostData:[[SBJsonWriter new] dataWithObject:dict]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [self removemanagerView];


}
-(void)postValues{



   // AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/update"];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    request.tag=555;
    
    
    
    [request setRequestMethod:@"POST"];
     NSString *authValue = [NSString stringWithFormat:@"Bearer %@", appDelegate.accessTokenString];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    //[request setPostValue:@"access_token" forKey:appDelegate.accessTokenString];
    [request addRequestHeader:@"Authorization" value:authValue];
    [request addRequestHeader:@"Accept" value:@"application/json"];
   
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];


    
    
    [dict setValue:[approvalDictArray objectAtIndex:0] forKey:@"employeeLeaveGrantedID"];
    
    
        [dict setValue:@"APPROVED" forKey:@"leaveStatus"];

   
    [request appendPostData:[[SBJsonWriter new] dataWithObject:dict]];


       [request setDelegate:self];
    [request startAsynchronous];
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    


}

-(void)postValues1{
    
    
    //AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/update"];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    request.tag=555;
    
    
    
    [request setRequestMethod:@"POST"];
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", appDelegate.accessTokenString];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    //[request setPostValue:@"access_token" forKey:appDelegate.accessTokenString];
    [request addRequestHeader:@"Authorization" value:authValue];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    [dict setValue:[approvalDictArray objectAtIndex:0] forKey:@"employeeLeaveGrantedID"];
    
    [dict setValue:@"REJECTED" forKey:@"leaveStatus"];
    
    [request appendPostData:[[SBJsonWriter new] dataWithObject:dict]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    [self.view addSubview:spinner];
    [spinner startAnimating];


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
-(void)viewDidAppear:(BOOL)animated{
 
    [super viewDidAppear:YES];
    
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    
    if (appDelegate.isHistory) {
        [self.navigationItem setTitle:@"Application Status"];

    }
    else{
    
    [self.navigationItem setTitle:@"View Request Received"];
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)logoutButtonAction:(id)sender{
    
    //AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/logout?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=111;
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
 
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count;
    if (tableView.tag==111) {
        count=[nameArray count];
    }
    else{
       
        count=[empDetailsArray count];
      
    
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ApprovedCellTableViewCell";
    static NSString *simpleTableIdentifier5 = @"ApprovedCellTableViewCell5";

    static NSString *managerCellIdentifier = @"ApprovalTableviewCell";
    
    
    switch (tableView.tag) {
        case 111:
        {
           
            if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
                {
                    ApprovedCellTableViewCell5 *cell = (ApprovedCellTableViewCell5 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier5];
                    if (cell == nil)
                    {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApprovedCellTableViewCell5" owner:self options:nil];
                        cell = [nib objectAtIndex:0];
                    }
                    
                    cell.nameLabel.text=[nameArray objectAtIndex:indexPath.row];
                    cell.dmentLabel.text=[departmentArray objectAtIndex:indexPath.row];
                    cell.statusLabel.text=[statusArray objectAtIndex:indexPath.row];
                    
                    
                    cell.nameLabel.textAlignment=NSTextAlignmentCenter;
                    
                    cell.dmentLabel.textAlignment=NSTextAlignmentCenter;
                    cell.statusLabel.textAlignment=NSTextAlignmentCenter;
                    
                    [ cell.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    [cell.dmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    [ cell.statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    NSLog(@"NAME ARRAY COUNT :%@",nameArray);
                    cell.nameLabel.text=[nameArray objectAtIndex:indexPath.row];
                    cell.dmentLabel.text=[departmentArray objectAtIndex:indexPath.row];
                    cell.statusLabel.text=[statusArray objectAtIndex:indexPath.row];
                    cell.backgroundColor=[UIColor clearColor];
                    //Initialize Label
                    
                    //}
                    if ([ cell.statusLabel.text isEqualToString:@"APPROVED"]) {
                        cell.statusLabel.textColor=[UIColor colorWithRed:99.0/255.0 green:186.0/255.0 blue:77.0/255.0 alpha:1.0];
                        
                    }
                    else   if ([ cell.statusLabel.text isEqualToString:@"REJECTED"]) {
                        cell.statusLabel.textColor=[UIColor redColor];
                        
                        
                    }
                    else   if ([ cell.statusLabel.text isEqualToString:@"PENDING"]) {
                        cell.statusLabel.textColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
                        
                        
                    }
                    else   if ([cell.statusLabel.text isEqualToString:@"CANCELLED"]) {
                        cell.statusLabel.textColor=[UIColor blueColor];
                        
                        
                    }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                    
                }
                
                
                
                else if ([[UIScreen mainScreen] bounds].size.height >= 667)
                {
                    ApprovedCellTableViewCell *cell = (ApprovedCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                    if (cell == nil)
                    {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApprovedCellTableViewCell" owner:self options:nil];
                        cell = [nib objectAtIndex:0];
                    }
                    
                    cell.nameLabel.text=[nameArray objectAtIndex:indexPath.row];
                    cell.dmentLabel.text=[departmentArray objectAtIndex:indexPath.row];
                    cell.statusLabel.text=[statusArray objectAtIndex:indexPath.row];
                    
                    
                    cell.nameLabel.textAlignment=NSTextAlignmentCenter;
                    
                    cell.dmentLabel.textAlignment=NSTextAlignmentCenter;
                    cell.statusLabel.textAlignment=NSTextAlignmentCenter;
                    
                    [ cell.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    [cell.dmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    [ cell.statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    NSLog(@"NAME ARRAY COUNT :%@",nameArray);
                    cell.nameLabel.text=[nameArray objectAtIndex:indexPath.row];
                    cell.dmentLabel.text=[departmentArray objectAtIndex:indexPath.row];
                    cell.statusLabel.text=[statusArray objectAtIndex:indexPath.row];
                    cell.backgroundColor=[UIColor clearColor];
                    //Initialize Label
                    
                    //}
                    if ([ cell.statusLabel.text isEqualToString:@"APPROVED"]) {
                        cell.statusLabel.textColor=[UIColor colorWithRed:99.0/255.0 green:186.0/255.0 blue:77.0/255.0 alpha:1.0];
                        
                    }
                    else   if ([ cell.statusLabel.text isEqualToString:@"REJECTED"]) {
                        cell.statusLabel.textColor=[UIColor redColor];
                        
                        
                    }
                    else   if ([ cell.statusLabel.text isEqualToString:@"PENDING"]) {
                        cell.statusLabel.textColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
                        
                        
                    }
                    else   if ([cell.statusLabel.text isEqualToString:@"CANCELLED"]) {
                        cell.statusLabel.textColor=[UIColor blueColor];
                        
                        
                    }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                    
                    
                }
            }
            
            else
            {
                //[ipad]
            }
            

            
            
            
                    }
            break;
            
             case 222:
        {
     
            
            
            ApprovalTableviewCell *cell = (ApprovalTableviewCell *)[tableView dequeueReusableCellWithIdentifier:managerCellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApprovalTableviewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
            }
            cell.frame=CGRectMake(0, 0, tabFrame.size.width-20, 44);
            
            if (appDelegate.isHistory) {
                cell.leaveTypeLabel.text=[historyEmpParamsArray objectAtIndex:indexPath.row];

            }
            else{
                cell.leaveTypeLabel.text=[empParamsArray objectAtIndex:indexPath.row];

            }
            cell.noOfLeavesLabel.text=[empDetailsArray objectAtIndex:indexPath.row];
            if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
                {
                    cell.noOfLeavesLabel.textAlignment=NSTextAlignmentLeft;
                    
                }
            }
            //cell.leaveTypeLabel.textAlignment=NSTextAlignmentLeft;
            //cell.noOfLeavesLabel.textAlignment=NSTextAlignmentLeft;

                [cell.leaveTypeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
                [cell.leaveTypeLabel setTextColor:[UIColor blackColor]];
            
                [cell.noOfLeavesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
                [cell.noOfLeavesLabel setTextColor:[UIColor blackColor]];
            
            
            
            
//                UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width/2, cell.frame.origin.y, 5, cell.frame.size.height)];
//                [lbl3 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
//                [lbl3 setTextColor:[UIColor blackColor]];
//                lbl3.text = @":";
//                NSLog(@"empDetailsArray : %@",empDetailsArray);
//                [cell addSubview:lbl3];
            
                [cell setBackgroundColor:[UIColor clearColor]];
                
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }
            
            
        default:
            break;
    }
    
    return 0;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    index=indexPath;
    
    
    if(tableView.tag==111){
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    dictionary=[results objectAtIndex:indexPath.row];
    NSLog(@"%@",dictionary);
        NSString *employeeLeaveGrantedID;
        NSString *leaveStatus;
        if (appDelegate.isHistory) {
           
            NSString *typeString=[dictionary valueForKey:@"leaveType"];
            NSString *noofDaysString=[dictionary valueForKey:@"numberOfLeaveDays"];
            NSString *fromString=[dictionary valueForKey:@"leaveFromDate"];
            NSString *toString=[dictionary valueForKey:@"leaveToDate"];
            employeeLeaveGrantedID=[dictionary valueForKey:@"employeeLeaveGranted"];
            leaveStatus=[dictionary valueForKey:@"leaveStatus"];
            NSString *resonString=[dictionary valueForKey:@"comments"];

            
            
            empDetailsArray=[[NSMutableArray alloc]initWithObjects:typeString,noofDaysString,fromString,toString,resonString, nil];
            
  

        }
        else{
            NSString *nameString=[dictionary valueForKey:@"employeeName"];
            NSString *departmentString=[dictionary valueForKey:@"department"];
            NSString *typeString=[dictionary valueForKey:@"leaveType"];
            NSString *noofDaysString=[dictionary valueForKey:@"numberOfDays"];
            NSString *fromString=[dictionary valueForKey:@"leaveFromDate"];
            NSString *toString=[dictionary valueForKey:@"leaveToDate"];
            NSString *resonString=[dictionary valueForKey:@"reason"];
            employeeLeaveGrantedID=[dictionary valueForKey:@"employeeLeaveGrantedID"];
            leaveStatus=[dictionary valueForKey:@"leaveStatus"];
            NSLog(@"resonString : %@",resonString);
            empDetailsArray=[[NSMutableArray alloc]initWithObjects:nameString,departmentString,typeString,noofDaysString,fromString,toString,resonString, nil];
        
            
        }
    approvalDictArray=[[NSMutableArray alloc]initWithObjects:employeeLeaveGrantedID,leaveStatus, nil];
    NSLog(@"EMP DETAILS %@",empDetailsArray);
    
    if ([leaveStatus isEqualToString:@"REJECTED"]) {
        
    }
    
    else{
        
       leaveManagerView.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
            {
    leaveManagerView.frame = CGRectMake(4, 490, tabFrame.size.width-8, empDetailsArray.count*60);
            }
            else if ([[UIScreen mainScreen] bounds].size.height >= 667)
            {
                leaveManagerView.frame = CGRectMake(20, 490, 335, empDetailsArray.count*60);
                
            }
              closeButton.frame=CGRectMake(leaveManagerView.frame.size.width-40,5, 24, 24);
            
            }
    approvalTable.alpha=0.5;
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         approvalTable.userInteractionEnabled=NO;
                         
                         if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                         {
                             if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
                             {
                                 leaveManagerView.frame = CGRectMake(4, 80, tabFrame.size.width-8, empDetailsArray.count*60);
                                 leaveManagerTitleLabel.frame=CGRectMake(0, 0, tabFrame.size.width-8, 30);
                                 leaveManagerTable.frame=CGRectMake(4, 30,tabFrame.size.width-8, tabFrame.size.height-50);
                            closeButton.frame=CGRectMake(leaveManagerTable.frame.size.width-40,5, 24, 24);
                             }
                             
                             else if ([[UIScreen mainScreen] bounds].size.height >= 667)
                             {
                                 leaveManagerView.frame = CGRectMake(20, 80, 335, empDetailsArray.count*60);
                                
                                    leaveManagerTitleLabel.frame=CGRectMake(0, 0, leaveManagerView.frame.size.width, 30);
                                 closeButton.frame=CGRectMake(leaveManagerTable.frame.size.width-40,5, 24, 24);

                                 leaveManagerTable.frame=CGRectMake(0, 30,330, 400);
                                 
                                 
                             }
                             
                             
                          

                         }
                         
                         
                        
                         leaveManagerView.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
                         leaveManagerTable.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
                         leaveManagerView.hidden=NO;
//leaveManagerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
                      leaveManagerTable.backgroundColor=[UIColor clearColor];}
                     completion:^(BOOL finished){
                     }];
    }
    }
    [leaveManagerTable reloadData];
    leaveManagerTable.delegate=self;
    leaveManagerTable.dataSource=self;
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
