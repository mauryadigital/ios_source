//
//  AvailableLeavesViewController.m
//  LeaveManagement
//
//  Created by User on 7/4/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "AvailableLeavesViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "ApprovalTableviewCell.h"
@interface AvailableLeavesViewController ()

@end

@implementation AvailableLeavesViewController
@synthesize availableLeavesTable,leaveGuideTextView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame=[UIScreen mainScreen].bounds;
}
-(void)viewWillAppear:(BOOL)animated{
CGRect tabFrame=[UIScreen mainScreen].bounds;
    availableLeavesTable.frame=CGRectMake(tabFrame.origin.x, tabFrame.origin.y,tabFrame.size.width, 210);
    availableLeavesTable.backgroundColor=[UIColor clearColor];
    availableLeavesTable.contentInset = UIEdgeInsetsMake(-5, 0, -5, 0);

    [self.view addSubview:availableLeavesTable];

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
   // UIView *views=[[UIView alloc]initWithFrame:CGRectMake(availableLeavesTable.frame.origin.x, 50, availableLeavesTable.frame.size.width, 50)];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(availableLeavesTable.frame.origin.x,availableLeavesTable.frame.size.height, availableLeavesTable.frame.size.width, 30)];
    [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];

    lbl.text=@"Leave Guidlines";
    lbl.textColor=[UIColor whiteColor];
    lbl.textAlignment=NSTextAlignmentCenter;
   // [views addSubview:lbl];
    [self.view addSubview:lbl];
    lbl.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:6.0/255.0 blue:4.0/255.0 alpha:1.0];
    
    
    NSLog(@"self.view.frame : %@",NSStringFromCGRect(self.view.frame));
    NSLog(@"availableLeavesTable :%@",NSStringFromCGRect(availableLeavesTable.frame));
    NSLog(@"lbl :%@",NSStringFromCGRect(lbl.frame));

    
    
    UITextView *myTextView=[[UITextView alloc]init];
    myTextView.frame=CGRectMake(availableLeavesTable.frame.origin.x,availableLeavesTable.frame.size.height+30,self.view.frame.size.width,tabFrame.size.height-(lbl.frame.size.height+lbl.frame.origin.y)-70);
    
    [myTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
    
    myTextView.text=@"• For counting number of days during leave only working days will be considered.\n\n• Holidays, weekends in between will not be counted as part of leave.\n\n• Leave taken in excess of eligibility will be treated as Leave on Loss of Pay.\n\n• Leave taken in excess of eligibility will be treated as Leave on Loss of Pay.\n\n• Casual Leave cannot be availed for more than 3 days at a stretch on any one occasion\n\n• Holidays and weekly-off days occurring during the period of the Sick Leave will not be counted as part of the leave.\n\n• Earned Leave cannot be combined with Casual Leave. In case of emergency\n\n• Earned Leave can be combined with Sick Leave, if the Sick Leave to an employee’s credit is insufficient to cover the period of illness.";
    myTextView.editable=NO;
    myTextView.textColor=[UIColor blackColor];
    myTextView.textAlignment=NSTextAlignmentLeft;
    // [views addSubview:lbl];
    [self.view addSubview:myTextView];
    myTextView.backgroundColor=[UIColor clearColor];

    
    
    
    
    
    

    //availableLeavesTable.tableFooterView = views;

    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(availableLeavesTable.frame.size.width / 2.0, availableLeavesTable.frame.size.height / 2.0);
    leavesArray=[[NSMutableArray alloc]init];
    leaveTypeArray=[[NSMutableArray alloc]initWithObjects:@"Casual Leaves",@"Sick Leaves",@"Earned Leaves",@"Total Leaves",@"Remaining Leaves",nil];
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/list?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    


}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Available Leaves"];
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
    [availableLeavesTable addSubview:spinner];
    [spinner startAnimating];
    
    
    
}
-(void) requestFinished: (ASIHTTPRequest *) request {
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
    
    else{
        NSString *theJSON = [request responseString];
        NSLog(@"THE JSON %@",theJSON);
                SBJsonParser *parser = [[SBJsonParser alloc] init];
       NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
        NSLog(@"Available Leaves dictionary %@",jsonDictionary);
        NSString *casualString=[jsonDictionary valueForKey:@"casualLeave"];
        NSString *sickLeaveString=[jsonDictionary valueForKey:@"sickLeave"];
        NSString *earnedLeaveString=[jsonDictionary valueForKey:@"earnedLeave"];
        
        AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        appDelegate.leavesDictionary=[jsonDictionary mutableCopy];
       // NSString *paidLeavesString=[jsonDictionary valueForKey:@"paidLeave"];
        NSString *totalLeavesString=[jsonDictionary valueForKey:@"totalLeaves"];
        NSString *remainingLeavesString=[jsonDictionary valueForKey:@"remainingLeaves"];
        leavesArray=[[NSMutableArray alloc]initWithObjects:casualString,sickLeaveString,earnedLeaveString,totalLeavesString,remainingLeavesString, nil];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict objectForKey:[jsonDictionary valueForKey:@"employeeInformationVO"]];
        dict=[jsonDictionary valueForKey:@"employeeInformationVO"];
        NSLog(@"EMP ARRAY %@",[dict valueForKey:@"designation"]);
          availableLeavesTable.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, leavesArray.count*44);
        //leaveGuideTextView.frame=CGRectMake(self.view.frame.origin.x,availableLeavesTable.frame.origin.y+availableLeavesTable.frame.size.height, availableLeavesTable.frame.size.width, self.view.frame.size.height-availableLeavesTable.frame.size.height);
        [availableLeavesTable reloadData];
        availableLeavesTable.delegate=self;
        availableLeavesTable.dataSource=self;
        
    }
    NSLog(@"LEAVES ARRAY %@",leavesArray);
    [spinner stopAnimating];
    [spinner removeFromSuperview];
        
   
}
//Tableview delegate and datasource methods

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
