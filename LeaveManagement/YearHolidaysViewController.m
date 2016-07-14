//
//  YearHolidaysViewController.m
//  LeaveManagement
//
//  Created by User on 6/20/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "YearHolidaysViewController.h"
#import "HolidayCustomCellTableViewCell.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "HolidaysViewController.h"
@interface YearHolidaysViewController ()

@end

@implementation YearHolidaysViewController
@synthesize yearTable,holidayDatesArray,holidayNamesArray;
- (void)viewDidLoad {
    [super viewDidLoad];
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

    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    holidayDatesArray=[[NSMutableArray alloc]init];
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/holidays/?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];

    [self.view addSubview:spinner];
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
    NSLog(@"holiday List Dictionary %@",jsonDictionary);
    
    NSArray *results = [jsonDictionary valueForKey:@"holidayCalendar"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    holidayNamesArray=[[NSMutableArray alloc]init];
    holidayDatesArray=[[NSMutableArray alloc]init];
    for (int i=0; i<results.count; i++) {
        dict=[results objectAtIndex:i];
        NSString *str=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayName"]];
        NSLog(@"STR : %@",str);
        
        NSString *datestring=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayDate"]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        //Create the date assuming the given string is in GMT
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDate *date = [df dateFromString:datestring];
        
        //Create a date string in the local timezone
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        NSString *localDateString = [df stringFromDate:date];
        NSLog(@"date = %@", localDateString);
           [holidayDatesArray addObject:localDateString];
        [holidayNamesArray addObject:str];
    }
    
    NSLog(@"HolidayNAME %@",holidayDatesArray);
    
    NSLog(@"HOLIDAYYYYY %@",holidayNamesArray);
    [yearTable reloadData];
    yearTable.delegate=self;
    yearTable.dataSource=self;
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    }

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Year Holidays List"];
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
    
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [holidayNamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"HolidayCustomCellTableViewCell";
    
    HolidayCustomCellTableViewCell *cell = (HolidayCustomCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HolidayCustomCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
 
        cell.holidayNameLbl.text=[holidayNamesArray objectAtIndex:indexPath.row];
    cell.holidayDateLbl.text=[holidayDatesArray objectAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
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
