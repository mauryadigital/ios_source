//
//  HolidaysViewController.m
//  LeaveManagement
//
//  Created by User on 5/18/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "HolidaysViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "HolidayCustomCellTableViewCell.h"
#import "YearHolidaysViewController.h"
@interface HolidaysViewController ()

@end

@implementation HolidaysViewController
@synthesize calendarView;
@synthesize holidayListTable,monthNumber,monthNumberArray,holidayDatesArray,holidayListArray;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadView {
    [super loadView];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
        {
 holidayListTable=[[UITableView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/2-50, self.view.frame.size.width,self.view.frame.size.height/2)];
        }
        
        
        
        else if ([[UIScreen mainScreen] bounds].size.height >= 667)
        {
 holidayListTable=[[UITableView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/2, self.view.frame.size.width,self.view.frame.size.height/2)];
            
        }
    }
    
    else
    {
        //[ipad]
    }
    
    
   
    holidayListTable.backgroundColor=[UIColor clearColor];
    //holidayListTable.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [self.view addSubview:holidayListTable];
    
        NSLog(@"MONTHNUMBER Value %i",monthNumber);
}
-(void)viewWillAppear:(BOOL)animated{
    [datesListArray removeAllObjects];
    [holidayListArray removeAllObjects];
    
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
    
    monthNumberArray=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_data) name:@"reload_data" object:nil];
    

  //  holidayListArray=[[NSMutableArray alloc]initWithObjects:@"Ugadhi",@"Independebce Day",@"Gandhi Jayanthi",@"Republic Day",@"Children's Day",@"Telangana Formation Day",@"Ramzan",@"Christamas", nil];
  //  holidayDatesArray=[[NSMutableArray alloc]initWithObjects:@"08-April-2016",@"15-August-2016",@"02-October-2016",@"26-January-2016",@"14-November-2016",@"02-June-2016",@"08-July-2016",@"25-December-2016",@"08-April-2016",@"15-August-2016",@"02-October-2016",@"26-January-2016",@"14-November-2016",@"02-June-2016",@"08-July-2016", nil];
    imagesArray=[[NSMutableArray alloc]initWithObjects:@"newyear.jpg",@"mlk.jpg",@"valentines.jpeg",@"presidents_day.jpg",@"goodfriday.jpeg",@"eastersunday.jpeg",@"mothersday.jpg",@"memorialday.jpg",@"fathersday.jpg",@"independenceday.jpg",@"laborday.jpg",@"columbusday.jpg",@"thanksgiving.jpg",@"dayafter.jpg",@"christmas.jpg", nil];
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationItem.hidesBackButton=TRUE;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"arrow-left_red.png"];
    [btn setImage:btnImg forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn] ;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 100, 44)];

    
    UIButton *logutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg1 = [UIImage imageNamed:@"logout.jpeg"];
    [logutbtn setImage:btnImg1 forState:UIControlStateNormal];
    
    logutbtn.frame = CGRectMake(80, 5, btnImg1.size.width, btnImg1.size.height);
    [logutbtn addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:logutbtn];
    
    UIButton *yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
   // UIImage *btnImg1 = [UIImage imageNamed:@"logout.jpeg"];
   // [logutbtn setImage:btnImg1 forState:UIControlStateNormal];
    
    yearButton.frame = CGRectMake(20, 5, 50,30);
    yearButton.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:30.0/255.0 blue:40.0/255.0 alpha:1.0];
    [yearButton setTitle:@"Year" forState:UIControlStateNormal];
    [yearButton addTarget:self action:@selector(yearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:yearButton];
//    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)];
//    NSArray* buttons = [NSArray arrayWithObjects:btn,logutbtn,nil];
//    [toolbar setItems:buttons animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logutbtn] ;
    
    //[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:yearButton,logutbtn,nil]];

   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logutbtn] ;
  

   

    [super viewWillAppear:YES];


}

-(void) requestFinished: (ASIHTTPRequest *) request {
    
    
    if(request.tag==111){
    
        NSString *theJSON = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        jsonDictionary = [parser objectWithString:theJSON error:nil];
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
  jsonDictionary = [parser objectWithString:theJSON error:nil];
    NSLog(@"holiday List Dictionary %@",jsonDictionary);
    
    NSArray *results = [jsonDictionary valueForKey:@"holidayCalendar"];
  
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    holidayListArray=[[NSMutableArray alloc]init];
    holidayDatesArray=[[NSMutableArray alloc]init];
    datesListArray=[[NSMutableArray alloc]init];
    for (int i=0; i<results.count; i++) {
        dict=[results objectAtIndex:i];
        NSString *str=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayName"]];
        NSLog(@"STR : %@",str);
        
        NSString *datestring=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayDate"]];
        
        
        ////////
        
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        //Create the date assuming the given string is in GMT
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDate *date = [df dateFromString:datestring];
        
        //Create a date string in the local timezone
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        NSString *localDateString = [df stringFromDate:date];
        NSLog(@"date = %@", localDateString);
        
        // My local timezone is: Europe/London (GMT+01:00) offset 3600 (Daylight)
        // prints out: date = 08/12/2013 22:01
        
        
        
        
        
        [holidayDatesArray addObject:localDateString];
    }
    
    NSLog(@"HolidayNAME %@",holidayDatesArray);
    
    NSLog(@"HOLIDAYYYYY %@",holidayListArray);
    
    //getting month number
    for (int i=0; i<holidayDatesArray.count; i++)
    {
        NSString *dateStr =[holidayDatesArray objectAtIndex:i];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* myDate = [dateFormatter dateFromString:dateStr];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:myDate];
        NSInteger month = [components month];
        NSNumber *val = [NSNumber numberWithInteger:month];

        [monthNumberArray addObject:val];
    

    }
    NSLog(@"MonthNumberArray %@",monthNumberArray);
    
    
    if(holidayDatesArray.count!=0)
    
    
    {
        if (!self.calendarView) {
            self.calendarView = [[CXCalendarView alloc] initWithFrame: CGRectMake(0, -5, self.view.frame.size.width, self.view.frame.size.height/2+30)] ;
            [self.view addSubview: self.calendarView];
            // self.calendarView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
            self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            self.calendarView.backgroundColor=[UIColor clearColor];
            self.calendarView.selectedDate = [NSDate date];
            
            self.calendarView.delegate = self;
        }
    
       
       // holidayListTable.backgroundColor=[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
        //empty label
        emptyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,holidayListTable.frame.size.height/2, self.view.frame.size.width,30)];
        emptyLabel.backgroundColor=[UIColor clearColor];
        emptyLabel.hidden=YES;
        emptyLabel.text=@"There are no holidays in this month";
        [holidayListTable addSubview:emptyLabel];
  
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(self.calendarView.frame.origin.x, self.calendarView.frame.origin.y+self.calendarView.frame.size.height, holidayListTable.frame.size.width, 5)];
        headerView.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:6.0/255.0 blue:4.0/255.0 alpha:1.0];
        //UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, 30)];
        
        //labelView.backgroundColor=[UIColor redColor];
        [self.view addSubview:headerView];
        // holidayListTable.tableHeaderView = headerView;
        
        
       AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        NSLog(@"appDelegate.monthNumber:  %i",appDelegate.monthNumber);
        
        for (int i=0; i<holidayDatesArray.count; i++) {
            NSArray* dateArray = [[holidayDatesArray objectAtIndex:i] componentsSeparatedByString: @"-"];
            NSString* monthString = [dateArray objectAtIndex: 1];
            NSString* dayString = [dateArray objectAtIndex: 2];
            NSLog(@"MY MONTH STRING %@",monthString);
            NSLog(@"MY DAY STRING %@",dayString);
            
            
            
            

            
                    if ([monthString intValue]==appDelegate.monthNumber)
                    
                    {
                        dict=[results objectAtIndex:i];
                        NSLog(@"DICTIONARY %@",dict);
                        NSString *str=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayName"]];
                        
                        [holidayListArray addObject:str];
                          NSString *datestring=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayDate"]];
                        
                        
                        [datesListArray addObject:datestring];
                        
                        
                        
                    }
            
        }
        NSLog(@"HOLYYYYYYYY : %@",holidayListArray);
        [holidayListTable reloadData];
      
        holidayListTable.delegate=self;
        holidayListTable.dataSource=self;

    
    }
    }
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error %@", [request error]);
    if ([request error]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Leave Management System" message:@"fail" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                                                        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }
}
-(void)handle_data
{
    NSArray *results = [jsonDictionary valueForKey:@"holidayCalendar"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    holidayListArray=nil;
    datesListArray=nil;
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"appDelegate.monthNumber:  %i",appDelegate.monthNumber);
    holidayListArray=[[NSMutableArray alloc]init];
    datesListArray=[[NSMutableArray alloc]init];

    for (int i=0; i<holidayDatesArray.count; i++) {
        NSArray* dateArray = [[holidayDatesArray objectAtIndex:i] componentsSeparatedByString: @"-"];
        NSString* monthString = [dateArray objectAtIndex: 1];
      //  NSString* dayString = [dateArray objectAtIndex: 2];
        if ([monthString intValue]==appDelegate.monthNumber) {
            dict=[results objectAtIndex:i];
            NSLog(@"DICTIONARY %@",dict);
            NSString *str=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayName"]];
            [holidayListArray addObject:str];
            //dates
            NSString *datestring=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayDate"]];
            [datesListArray addObject:datestring];
        }
    }
    
    [holidayListTable reloadData];
    [holidayListTable setDelegate:self];
    [holidayListTable setDataSource:self];
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [holidayListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"HolidayCustomCellTableViewCell";
    HolidayCustomCellTableViewCell *cell = (HolidayCustomCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HolidayCustomCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
   
    //cell.holidayImage.image=[UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]];
   // AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    if (holidayListArray.count==0)
    {
        emptyLabel.hidden=NO;
        //[cell addSubview:emptyLabel];
        
    }
    else{

    cell.holidayNameLbl.text=[holidayListArray objectAtIndex:indexPath.row];
    cell.holidayDateLbl.text=[datesListArray objectAtIndex:indexPath.row];
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:YES];
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Holidays List"];
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
-(void)yearButtonAction:(id)sender
{
    YearHolidaysViewController *yearHolidaysViewControllerObj=[[YearHolidaysViewController alloc]initWithNibName:@"YearHolidaysViewController" bundle:nil];
    [self.navigationController pushViewController:yearHolidaysViewControllerObj animated:NO];

}
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
    return YES;
}

#pragma mark CXCalendarViewDelegate

- (void) calendarView: (CXCalendarView *) calendarView
        didSelectDate: (NSDate *) date {
    
   
    /*TTAlert([NSString stringWithFormat: @"Selected date: %@", date]);*/
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
