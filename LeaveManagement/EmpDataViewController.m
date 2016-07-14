//
//  EmpDataViewController.m
//  LeaveManagement
//
//  Created by User on 6/21/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "EmpDataViewController.h"
#import "AppDelegate.h"
#import "ApprovalTableviewCell.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
@interface EmpDataViewController ()

@end

@implementation EmpDataViewController
@synthesize empDataDictionary,nameLabel,designationLabel,emailLabel,departmentLabel,leavesTable;
- (void)viewDidLoad {
    [super viewDidLoad];
   // empDataArray=[[NSMutableDictionary alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
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
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
      // AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    _employeeImageView.image=[UIImage imageNamed:@"pic.jpg"];
    
    NSString *casualLeaves=[empDataDictionary valueForKey:@"casualLeave"];
    NSString *earnedLeave=[empDataDictionary valueForKey:@"earnedLeave"];
   // NSString *paidLeave=[empDataDictionary valueForKey:@"paidLeave"];
    NSString *remainingLeaves=[empDataDictionary valueForKey:@"remainingLeaves"];
    NSString *sickLeave=[empDataDictionary valueForKey:@"sickLeave"];
    NSString *totalLeaves=[empDataDictionary valueForKey:@"totalLeaves"];

    NSLog(@"casualLeaves %@",casualLeaves);
    
    leavesArray=[[NSMutableArray alloc]initWithObjects:totalLeaves,remainingLeaves,casualLeaves,sickLeave,earnedLeave,nil];
    leaveTypeArray=[[NSMutableArray alloc]initWithObjects:@"Total Leaves",@"Remaining Leaves",@"Casual Leaves",@"Sick Leaves",@"Earned Leaves",nil];
  
    NSMutableDictionary* dict=[empDataDictionary valueForKey:@"employeeInformationVO"];
    
    
    NSLog(@"EMPDICT %@",dict);
    
    
    
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
        {
            [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
            
            [departmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
            [emailLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
            [designationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:9.0]];
            
            designationLabel.numberOfLines=0;
            
            designationLabel.lineBreakMode=NSLineBreakByWordWrapping;
            
            emailLabel.numberOfLines=0;
            
            emailLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        }
        
        
        
        else if ([[UIScreen mainScreen] bounds].size.height >= 667)
        {
            
            
        }
    }
    
    else
    {
        //[ipad]
    }

    


    nameLabel.text=[dict valueForKey:@"employeeName"];
designationLabel.text=[dict valueForKey:@"designation"];
    departmentLabel.text=[dict valueForKey:@"department"];
    emailLabel.text=[dict valueForKey:@"email"];

    [leavesTable reloadData];
    leavesTable.delegate=self;
    leavesTable.dataSource=self;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Employee Data"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)goBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) requestFinished: (ASIHTTPRequest *) request {
    
        NSString *theJSON = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@"Dictionary %@",jsonDictionary);
        NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
        NSLog(@"str %@",str);
        if([str isEqualToString:@"SUCCESS"])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
       
    }
}

-(void)logoutButtonAction:(id)sender{
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/logout?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=111;
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [leavesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ApprovalTableviewCell";
    
    ApprovalTableviewCell *cell = (ApprovalTableviewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApprovalTableviewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.leaveTypeLabel.text=[leaveTypeArray objectAtIndex:indexPath.row];
    cell.noOfLeavesLabel.text=[leavesArray objectAtIndex:indexPath.row];
    
    return cell;
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
