//
//  ApplicationStatusViewController.m
//  LeaveManagement
//
//  Created by User on 5/17/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ApplicationStatusViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "ApprovedCellTableViewCell.h"
@interface ApplicationStatusViewController ()

@end

@implementation ApplicationStatusViewController
@synthesize applicationStatusTable,isManagerLogin;
- (void)viewDidLoad {
    [super viewDidLoad];
    dateAppliedArray=[[NSMutableArray alloc]init];
    noOfLeavesArray=[[NSMutableArray alloc]init];
    statusArray=[[NSMutableArray alloc]init];
    static NSString *simpleTableIdentifier = @"ApprovedCellTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"ApprovedCellTableViewCell" bundle:nil];
    [applicationStatusTable registerNib:nib forCellReuseIdentifier:simpleTableIdentifier];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    applicationStatusTable.frame=[UIScreen mainScreen].bounds;
    
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);

    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"APPDELEGATE ACCESS %@",appDelegate.accessTokenString);
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/history?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    
    [self.view addSubview:spinner];
    [spinner startAnimating];

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
    
    dateAppliedLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 5, applicationStatusTable.frame.size.width/3,30)];
    
    //iPhone 4
    noOfLeavesLabel=[[UILabel alloc]initWithFrame:CGRectMake(dateAppliedLabel.frame.size.width+dateAppliedLabel.frame.origin.x+20,0,applicationStatusTable.frame.size.width/4,45)];
    noOfLeavesLabel.lineBreakMode=NSLineBreakByWordWrapping;
    
    noOfLeavesLabel.numberOfLines=2;
    statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(noOfLeavesLabel.frame.size.width+noOfLeavesLabel.frame.origin.x+5,5,applicationStatusTable.frame.size.width/3,30)];
    
    dateAppliedLabel.textAlignment=NSTextAlignmentCenter;
    
     noOfLeavesLabel.textAlignment=NSTextAlignmentCenter;
   statusLabel.textAlignment=NSTextAlignmentCenter;
   
    [dateAppliedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [noOfLeavesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];

    
    
    CGRect headerFrame = CGRectMake(applicationStatusTable.frame.origin.x,0,applicationStatusTable.frame.size.width,40);
    
//    UILabel *labelView = [[UILabel alloc] initWithFrame:headerFrame];
//    labelView.textAlignment = NSTextAlignmentCenter;
//    labelView.text=@"Apply For Leave";
//    [labelView setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
//    
//    labelView.backgroundColor=[UIColor clearColor];
//    labelView.textColor=[UIColor colorWithRed:175.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    dateAppliedLabel.text=@"Date Applied";
    noOfLeavesLabel.text=@"No.of Leaves";
    statusLabel.text=@"Status";
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];

    headerView.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:6.0/255.0 blue:4.0/255.0 alpha:1.0];
                dateAppliedLabel.textColor=[UIColor blackColor];
                noOfLeavesLabel.textColor=[UIColor blackColor];
                statusLabel.textColor=[UIColor blackColor];
    [headerView addSubview:dateAppliedLabel];
    [headerView addSubview:noOfLeavesLabel];
    [headerView addSubview:statusLabel];
    [self.view addSubview:headerView];
   // applicationStatusTable.tableHeaderView = headerView;

   
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
    // [request responseString]; is how we capture textual output like HTML or JSON
    // [request responseData]; is how we capture binary output like images
    // Then to create an image from the response we might do something like
    // UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    NSString *theJSON = [request responseString];
    NSLog(@"THE JSON %@",theJSON);
    // Now we have successfully captured the JSON ouptut of our request
    //  [self.navigationController pushViewController:objHomeViewController animated:YES];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
   NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    // NSMutableDictionary *divisionDictionary = [jsonDictionary valueForKey:@""];
    NSLog(@"Application Status Dictionary %@",jsonDictionary);
    
    NSArray *results = [jsonDictionary valueForKey:@"leaveHistoryVOs"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dateAppliedArray=[[NSMutableArray alloc]init];
 
    for (int i=0; i<results.count; i++) {
        dict=[results objectAtIndex:i];
       
              NSString *leaveAppliedDateString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"leaveAppliedDate"]];
        
         NSArray* dateArray = [leaveAppliedDateString componentsSeparatedByString: @" "];
        
        
        
                [dateAppliedArray addObject:[dateArray objectAtIndex:0]];
        
                NSString *numberOfLeaveDaysString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"numberOfLeaveDays"]];
                [noOfLeavesArray addObject:numberOfLeaveDaysString];
                NSString *leaveStatusString=[NSString stringWithFormat:@"%@",[dict valueForKey:@"leaveStatus"]];
                [statusArray addObject:leaveStatusString];

    }

//
//    for (int i=0; i<jsonDictionary.count; i++) {
//        NSString *leaveAppliedDateString=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"leaveAppliedDate"]];
//        [dateAppliedArray addObject:leaveAppliedDateString];
//        
//        NSString *numberOfLeaveDaysString=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"numberOfLeaveDays"]];
//        [noOfLeavesArray addObject:numberOfLeaveDaysString];
//        NSString *leaveStatusString=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"leaveStatus"]];
//        [statusArray addObject:leaveStatusString];
//    }
    
    NSLog(@"dateAppliedArray %@",dateAppliedArray);
    NSLog(@"noOfLeavesArray %@",noOfLeavesArray);

    NSLog(@"statusArray %@",statusArray);
    [applicationStatusTable reloadData];
    applicationStatusTable.delegate=self;
    applicationStatusTable.dataSource=self;
    }
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
[dateAppliedArray removeObjectAtIndex:indexPath.row];
    [noOfLeavesArray removeObjectAtIndex:indexPath.row];
[statusArray removeObjectAtIndex:indexPath.row];
    [applicationStatusTable reloadData];
}



-(void)viewDidAppear:(BOOL)animated{
    
    
    
    [super viewDidAppear:YES];
    
    
    
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Application Status"];
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
    
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
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
    return [dateAppliedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        for(UIView *eachView in [cell subviews])
//            [eachView removeFromSuperview];
//        
//        cell.frame=[UIScreen mainScreen].bounds;
//        
//        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(2, 5, cell.frame.size.width/3,30)];
//        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(l1.frame.size.width+l1.frame.origin.x+12,5,cell.frame.size.width/4,30)];
//        UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(l2.frame.size.width+l2.frame.origin.x+12,5,cell.frame.size.width/3,30)];
//        
//        l1.textAlignment=NSTextAlignmentCenter;
//        
//        l2.textAlignment=NSTextAlignmentCenter;
//        l3.textAlignment=NSTextAlignmentCenter;
//        
//        [l1 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
//        [l2 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
//        [l3 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
//        
//        
//        
//
//        
////        
////               if (indexPath.row==0) {
////            dateAppliedLabel.text=@"Date Applied";
////            noOfLeavesLabel.text=@"No.of Leave";
////            statusLabel.text=@"Status";
////            dateAppliedLabel.textColor=[UIColor whiteColor];
////            noOfLeavesLabel.textColor=[UIColor whiteColor];
////            statusLabel.textColor=[UIColor whiteColor];
////
////            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"smallButton.png"]];
////        }
//        
//        //else{
//            
//            
//            l1.text=[dateAppliedArray objectAtIndex:indexPath.row];
//            l2.text=[noOfLeavesArray objectAtIndex:indexPath.row];
//            l3.text=[statusArray objectAtIndex:indexPath.row];
//            cell.backgroundColor=[UIColor clearColor];
//        //Initialize Label
//      
//        //}
//        if ([l3.text isEqualToString:@"APPROVED"]) {
//            l3.textColor=[UIColor colorWithRed:99.0/255.0 green:186.0/255.0 blue:77.0/255.0 alpha:1.0];
//            
//        }
//     else   if ([l3.text isEqualToString:@"REJECTED"]) {
//            l3.textColor=[UIColor redColor];
//            
//            
//        }
//     else   if ([l3.text isEqualToString:@"PENDING"]) {
//            l3.textColor=[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
//            
//            
//        }
//     else   if ([l3.text isEqualToString:@"CANCELLED"]) {
//         l3.textColor=[UIColor blueColor];
//         
//         
//     }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        
//        [cell addSubview:l1];
//        [cell addSubview:l2];
//        [cell addSubview:l3];
//        
//    }
//        return cell;
    static NSString *simpleTableIdentifier = @"ApprovedCellTableViewCell";

    ApprovedCellTableViewCell *cell = (ApprovedCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApprovedCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
       //    UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(2, 5, cell.frame.size.width/3,30)];
        //   UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(l1.frame.size.width+l1.frame.origin.x+12,5,cell.frame.size.width/4,30)];
         //  UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(l2.frame.size.width+l2.frame.origin.x+12,5,cell.frame.size.width/3,30)];
    cell.nameLabel.text=[dateAppliedArray objectAtIndex:indexPath.row];
    cell.dmentLabel.text=[noOfLeavesArray objectAtIndex:indexPath.row];
    cell.statusLabel.text=[statusArray objectAtIndex:indexPath.row];
    
    
    cell.nameLabel.textAlignment=NSTextAlignmentCenter;
    
    cell.dmentLabel.textAlignment=NSTextAlignmentCenter;
    cell.statusLabel.textAlignment=NSTextAlignmentCenter;
    
    [ cell.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [cell.dmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [ cell.statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    cell.nameLabel.text=[dateAppliedArray objectAtIndex:indexPath.row];
    cell.dmentLabel.text=[noOfLeavesArray objectAtIndex:indexPath.row];
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
