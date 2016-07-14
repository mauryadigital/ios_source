//
//  ApplyViewController.m
//  LeaveManagement
//
//  Created by User on 5/16/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "ApplyViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
@interface ApplyViewController ()

@end

@implementation ApplyViewController
@synthesize applyLeaveTable,empDetailsArray,empInformationId,leavesDictionary;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [datePicker setDate:[NSDate date] animated:YES];
    
    dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    dateFormatter.dateStyle=NSDateFormatterMediumStyle;

    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //Here we can set the format which we need
    leavesDictionary=[[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    nIndex=0;
    nSectionIndex=0;
    //NSLog(@"%@",leavesDictionary);
     [applyLeaveTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
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
    applyLeaveTable.delegate=self;
    applyLeaveTable.dataSource=self;
    applyLeaveTableframe=CGRectMake(applyLeaveTable.frame.origin.x, applyLeaveTable.frame.origin.y, applyLeaveTable.frame.size.width, applyLeaveTable.frame.size.height);
    empDetailsArray=[[NSMutableArray alloc]initWithObjects:@"EID",@"Current Date",@"Type",@"From",@"To",@"No Of days",@"Reason",@"", nil];
    
    
    footerFrame = CGRectMake(0,0,applyLeaveTable.frame.size.width,40);
    UIView *footerView = [[UIView alloc] initWithFrame:footerFrame];
   // footerView.backgroundColor=[UIColor redColor];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitle:@"Apply" forState:UIControlStateNormal];
    [aButton setBackgroundColor:[UIColor colorWithRed:183.0/255.0 green:6.0/255.0 blue:4.0/255.0 alpha:1.0]];
    [aButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
  // [aButton setBackgroundImage:[UIImage imageNamed:@"smallButton.jpeg"] forState:UIControlStateNormal];
    footerView.userInteractionEnabled=YES;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 568)
        {
            aButton.frame = CGRectMake(footerView.frame.size.width/2-70, 0, 100, 40);
            
        }
        
        
        
        else if ([[UIScreen mainScreen] bounds].size.height >= 667)
        {
            aButton.frame = CGRectMake(footerView.frame.size.width/2-50, 0, 100, 40);

            
        }
    }
    
    else
    {
        //[ipad]
    }

    
    
    
    
    [aButton setUserInteractionEnabled:YES];
    [footerView setUserInteractionEnabled:YES];
    [footerView addSubview:aButton];
    
    applyLeaveTable.tableFooterView = footerView;
    [aButton becomeFirstResponder];
    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center =applyLeaveTable.center;
    
    
    [super viewWillAppear:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    
    
    
    [super viewDidAppear:YES];
    
    
    
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"Apply For Leave"];
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
    return [empDetailsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    for(UIView *eachView in [cell subviews])
        [eachView removeFromSuperview];
   
        CGRect smallFrame=CGRectMake(cell.frame.size.width/2-30, cell.frame.origin.y+10, cell.frame.size.width/2, cell.frame.size.height-20);
        CGRect bigFrame=CGRectMake(cell.frame.size.width/2, cell.frame.origin.y+10, cell.frame.size.width/2, cell.frame.size.height-20);
        
    //Initialize Label
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+25, cell.frame.origin.y, cell.frame.size.width/2, cell.frame.size.height)];
    [lbl1 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [lbl1 setTextColor:[UIColor blackColor]];
    lbl1.text = [empDetailsArray objectAtIndex:indexPath.row];
    [cell addSubview:lbl1];
        
        
        if (indexPath.row==0) {
            
            
               if ([[UIScreen mainScreen] bounds].size.height >= 667)
                {
                    
 EidTextbox= [[UITextField alloc]initWithFrame:CGRectMake(cell.frame.size.width/2, cell.frame.origin.y+10, 70, cell.frame.size.height-20)];
                
                }
            
            else if ([[UIScreen mainScreen] bounds].size.height <= 568)
            {
 EidTextbox= [[UITextField alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-30, cell.frame.origin.y+10, 70, cell.frame.size.height-20)];
            
            
            }
            
        
            
            EidTextbox.borderStyle=UITextBorderStyleRoundedRect;
            EidTextbox.backgroundColor=[UIColor lightGrayColor];
            EidTextbox.userInteractionEnabled=NO;
            NSLog(@"empInformationId %@",empInformationId);
            NSString *str=[NSString stringWithFormat:@"%@",empInformationId];
            EidTextbox.text=str;
            [cell addSubview:EidTextbox];
            EidTextbox.delegate=self;
            EidTextbox.tag=indexPath.row;
            EidTextbox.keyboardType = UIKeyboardTypeNumberPad;
                   }
      
       else if (indexPath.row==1) {
           
            NSDate *todayDate = [NSDate date]; // get today date
           dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
           dateFormatter.dateStyle=NSDateFormatterMediumStyle;
           
           [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
           
           if ([[UIScreen mainScreen] bounds].size.height >= 667)
           {
               
               appliedDateTextbox = [[UITextField alloc]initWithFrame:bigFrame];

               
           }
           
           else if ([[UIScreen mainScreen] bounds].size.height <= 568)
           {
               appliedDateTextbox = [[UITextField alloc]initWithFrame:smallFrame];

               
               
           }
           
            appliedDateTextbox.borderStyle=UITextBorderStyleRoundedRect;
            appliedDateTextbox.backgroundColor=[UIColor lightGrayColor];
            appliedDateTextbox.userInteractionEnabled=NO;
            appliedDateTextbox.text=convertedDateString;
           appliedDateTextbox.tag=indexPath.row;

            [cell addSubview:appliedDateTextbox];
            appliedDateTextbox.delegate=self;
        }
          else  if (indexPath.row==2) {
              pickerArray = [[NSMutableArray alloc]initWithObjects:@"CASUAL_LEAVE",
                             @"SICK_LEAVE",@"EARNED_LEAVE", nil];
              
              
              if ([[UIScreen mainScreen] bounds].size.height >= 667)
              {
                  
                  myTextField = [[UITextField alloc]initWithFrame:bigFrame];
                  
                  
              }
              
              else if ([[UIScreen mainScreen] bounds].size.height <= 568)
              {
                  myTextField = [[UITextField alloc]initWithFrame:smallFrame];
                  
                  
                  
              }
              
              myTextField.borderStyle=UITextBorderStyleRoundedRect;
              myTextField.backgroundColor=[UIColor lightGrayColor];
              myTextField.userInteractionEnabled=YES;
              myTextField.tag=indexPath.row;
             // myTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropdown.png"]];
              
              
              UIImageView *myImageview;
              
              if ([[UIScreen mainScreen] bounds].size.height >= 667)
              {
                  
                   myImageview=[[UIImageView alloc]initWithFrame:CGRectMake(myTextField.frame.origin.x-(myTextField.frame.size.width-130), 0, 24, 24)];
                  
              }
              
              else
              {
                  myImageview=[[UIImageView alloc]initWithFrame:CGRectMake(myTextField.frame.origin.x-(myTextField.frame.size.width-160), 0, 24, 24)];
                  
                  
              }

            
              myImageview.image=[UIImage imageNamed:@"dropdown.jpeg"];
              [myTextField addSubview:myImageview];
              [cell addSubview:myTextField];
              myTextField.delegate=self;
              myTextField.borderStyle = UITextBorderStyleRoundedRect;
              myTextField.textAlignment = NSTextAlignmentLeft;
              [cell addSubview:myTextField];

             // [self.view addSubview:myTextField];
              //[myTextField setPlaceholder:@"Pick a Sport"];
             
        }
        
        else if(indexPath.row==3)
        {
        
            if ([[UIScreen mainScreen] bounds].size.height >= 667)
            {
                
                dateTextField = [[UITextField alloc]initWithFrame:bigFrame];
                
                
            }
            
            else if ([[UIScreen mainScreen] bounds].size.height <= 568)
            {
                dateTextField = [[UITextField alloc]initWithFrame:smallFrame];
                
                
                
            }            dateTextField.borderStyle=UITextBorderStyleRoundedRect;
            dateTextField.backgroundColor=[UIColor lightGrayColor];
            dateTextField.userInteractionEnabled=YES;
            dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
            dateFormatter.dateStyle=NSDateFormatterMediumStyle;
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
         
            NSString *dateStr=[NSString stringWithFormat:@"%@",[dateFormatter  stringFromDate:[NSDate date]]];
           // dateTextField.tag=111;
            // myTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropdown.png"]];
            dateTextField.text=dateStr;
            dateTextField.tag=indexPath.row;
            [cell addSubview:dateTextField];
            dateTextField.delegate=self;
            dateTextField.borderStyle = UITextBorderStyleRoundedRect;
            dateTextField.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:dateTextField];
            
        
        
        
        }
        else if(indexPath.row==4)
        {
            
            if ([[UIScreen mainScreen] bounds].size.height >= 667)
            {
                
                toDateTextField = [[UITextField alloc]initWithFrame:bigFrame];
                
                
            }
            
            else if ([[UIScreen mainScreen] bounds].size.height <= 568)
            {
                toDateTextField = [[UITextField alloc]initWithFrame:smallFrame];
                
                
                
            }
            toDateTextField.borderStyle=UITextBorderStyleRoundedRect;
            toDateTextField.backgroundColor=[UIColor lightGrayColor];
            toDateTextField.userInteractionEnabled=YES;
            // dateTextField.tag=111;
            // myTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropdown.png"]];
            toDateTextField.tag=indexPath.row;
//            dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
//            dateFormatter.dateStyle=NSDateFormatterMediumStyle;
//            
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//             NSString *toDateStr=[NSString stringWithFormat:@"%@",[dateFormatter  stringFromDate:[NSDate date]]];
//            toDateTextField.text=toDateStr;
            [cell addSubview:toDateTextField];
            toDateTextField.delegate=self;
            toDateTextField.borderStyle = UITextBorderStyleRoundedRect;
            toDateTextField.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:toDateTextField];
            
            
            
            
        }
        
        else   if (indexPath.row==5) {
            if ([[UIScreen mainScreen] bounds].size.height >= 667)
            {
                
  numberOfDaysTextField = [[UITextField alloc]initWithFrame:CGRectMake(cell.frame.size.width/2, cell.frame.origin.y+10,70, cell.frame.size.height-20)];
                
            }
            
            else if ([[UIScreen mainScreen] bounds].size.height <= 568)
            {
  numberOfDaysTextField = [[UITextField alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-30, cell.frame.origin.y+10,70, cell.frame.size.height-20)];
                
                
            }
           
            
                numberOfDaysTextField.borderStyle=UITextBorderStyleRoundedRect;
                numberOfDaysTextField.backgroundColor=[UIColor lightGrayColor];
                numberOfDaysTextField.userInteractionEnabled=NO;
                [cell addSubview:numberOfDaysTextField];
                numberOfDaysTextField.delegate=self;
                numberOfDaysTextField.tag=indexPath.row;
           userMsg=[[UILabel alloc]initWithFrame:CGRectMake(numberOfDaysTextField.frame.size.width+numberOfDaysTextField.frame.origin.x+5, numberOfDaysTextField.frame.origin.y, 120,numberOfDaysTextField.frame.size.height)];
            numberOfDaysTextField.text=@"1";
            userMsg.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:9.0];
           // if (myTextField.text.length!=0) {
            
            userMsg.textAlignment=NSTextAlignmentLeft;
            userMsg.numberOfLines=2;
            //userMsg.backgroundColor=[UIColor redColor];
            userMsg.hidden=YES;
                [cell addSubview:userMsg];

           // }
            
          
          
            
            

        }
     else   if (indexPath.row==6) {
         reasonspickerArray = [[NSMutableArray alloc]initWithObjects:@"Suffering from Fever",
                        @"Suffering from Head ache",@"Suffering from Stomach ache",@"Going to home town",@"Other", nil];
         if ([[UIScreen mainScreen] bounds].size.height >= 667)
         {
             
             commonReasonTextField = [[UITextField alloc]initWithFrame:bigFrame];
             
             
         }
         
         else if ([[UIScreen mainScreen] bounds].size.height <= 568)
         {
             commonReasonTextField = [[UITextField alloc]initWithFrame:smallFrame];
             
             
             
         }
         commonReasonTextField.borderStyle=UITextBorderStyleRoundedRect;
         commonReasonTextField.backgroundColor=[UIColor lightGrayColor];
         commonReasonTextField.userInteractionEnabled=YES;
         commonReasonTextField.tag=indexPath.row;
         // myTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropdown.png"]];
         UIImageView *myImageview;
         
         if ([[UIScreen mainScreen] bounds].size.height >= 667)
         {
             
              myImageview=[[UIImageView alloc]initWithFrame:CGRectMake(commonReasonTextField.frame.origin.x-(commonReasonTextField.frame.size.width-130), 0, 24, 24)];
             
         }
         
         else if ([[UIScreen mainScreen] bounds].size.height <= 568)
         {
              myImageview=[[UIImageView alloc]initWithFrame:CGRectMake(commonReasonTextField.frame.origin.x-(commonReasonTextField.frame.size.width-160), 0, 24, 24)];
             
             
         }
        
         myImageview.image=[UIImage imageNamed:@"dropdown.jpeg"];
         [commonReasonTextField addSubview:myImageview];
         [cell addSubview:commonReasonTextField];
         commonReasonTextField.delegate=self;
         commonReasonTextField.borderStyle = UITextBorderStyleRoundedRect;
         commonReasonTextField.textAlignment = NSTextAlignmentLeft;
         [commonReasonTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];

         [cell addSubview:commonReasonTextField];
         
         // [self.view addSubview:myTextField];
         //[myTextField setPlaceholder:@"Pick a Sport"];


        }
     else   if (indexPath.row==7) {
         
         if ([[UIScreen mainScreen] bounds].size.height >= 667)
         {
             
Reasontextbox = [[UITextView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2, cell.frame.origin.y+10, cell.frame.size.width/2, cell.frame.size.height-5)];
             
         }
         
         else if ([[UIScreen mainScreen] bounds].size.height <= 568)
         {
Reasontextbox = [[UITextView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-30, cell.frame.origin.y+10, cell.frame.size.width/2, cell.frame.size.height-5)];
             
             
         }
         
        
         
         Reasontextbox.tag=indexPath.row;
         Reasontextbox.backgroundColor=[UIColor lightGrayColor];
         Reasontextbox.userInteractionEnabled=YES;
         Reasontextbox.tag=indexPath.row;
         if ([commonReasonTextField.text isEqualToString:@"Other"]) {
             Reasontextbox.hidden=NO;

         }
         else{
             Reasontextbox.hidden=YES;

         }
         [cell addSubview:Reasontextbox];


         Reasontextbox.delegate=self;
         
     }

   
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
      }
    return cell;
}

-(void)done:(id)sender{

    NSLog(@"Done:%@",commonReasonTextField.text);
  //  NSString *str=[NSString stringWithFormat:@"%@",commonReasonTextField.text];
    toDateTextField.delegate=self;

    [myPickerView removeFromSuperview];
    [myTextField resignFirstResponder];
    [commonReasonTextField resignFirstResponder];
    [toolBar removeFromSuperview];
    
    [toDateTextField resignFirstResponder];
    
    [dateTextField resignFirstResponder];
    [datePicker removeFromSuperview];
    
    
    if (dateTextField.text && toDateTextField.text.length > 0)
    {
        
        
        fromDate=[dateFormatter dateFromString:dateTextField.text];
        NSDate *todate=[dateFormatter dateFromString:toDateTextField.text];
        
        
        if ([fromDate compare:todate]==NSOrderedDescending) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter the future date" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alertController dismissViewControllerAnimated:YES completion:^{
                   // toDateTextField.text=@"";
                   // numberOfDaysTextField.text=@"";
                    
                    
                }];
                
            });
            
            
        }
        
        else{
        
        [self numberOfDays];
        }
    }
    if (commonReasonTextField.text.length>0) {
        
    
    if([commonReasonTextField.text isEqualToString:@"Other"])
    {
       
        NSLog(@"OTHER Done %@",commonReasonTextField.text);

        Reasontextbox.hidden=NO;
        Reasontextbox.text=@"";
        [applyLeaveTable reloadData];
        [applyLeaveTable setDelegate:self];
        [applyLeaveTable setDataSource:self];
    
    }
    else{
        Reasontextbox.hidden=YES;

        [applyLeaveTable reloadData];
        [applyLeaveTable setDelegate:self];
        [applyLeaveTable setDataSource:self];
        
    
    }
    }
    


}

//Datepicker
-(void)datePickerBtnAction
{
    
    NSLog(@"NINDEX:%li",(long)nIndex);

    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(applyLeaveTable.frame.origin.x, applyLeaveTable.frame.size.height-100, applyLeaveTable.frame.size.width, 100)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.hidden=NO;
    datePicker.date=[NSDate date];
    
    [self.view addSubview:datePicker];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          myPickerView.frame.size.height-50, applyLeaveTable.frame.size.width, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    NSLog(@"NINDEX:%li",(long)nIndex);
    if(nIndex==3){
        
    dateTextField.inputView = datePicker;
    dateTextField.inputAccessoryView = toolBar;
        [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    }
    else{
        toDateTextField.inputView = datePicker;
        toDateTextField.inputAccessoryView = toolBar;
        [datePicker addTarget:self action:@selector(LabelTitle1:) forControlEvents:UIControlEventValueChanged];
    }
    [self.view addSubview:datePicker];
    [self.view addSubview:toolBar];

}

-(void)LabelTitle:(id)sender
{
    
    NSLog(@"datePicker.date %@",datePicker.date);
    dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    dateFormatter.dateStyle=NSDateFormatterMediumStyle;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

       NSString *str=[NSString stringWithFormat:@"%@",[dateFormatter  stringFromDate:datePicker.date]];
    //assign text to label
    dateTextField.text=str;
    
    
}
-(void)LabelTitle1:(id)sender
{
    dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    dateFormatter.dateStyle=NSDateFormatterMediumStyle;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *str=[NSString stringWithFormat:@"%@",[dateFormatter  stringFromDate:datePicker.date]];
    //assign text to label
    toDateTextField.text=str;
    
}
-(void)numberOfDays{


    NSString *start = dateTextField.text;
    NSString *end = toDateTextField.text;
    dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    dateFormatter.dateStyle=NSDateFormatterMediumStyle;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    
    numberOfDaysTextField.text=[NSString  stringWithFormat:@"%ld",[components day]+1];
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"leavesDictionary %@",appDelegate.leavesDictionary);
    
    if (myTextField.text.length!=0) {
        NSString *casualLeaves=[appDelegate.leavesDictionary valueForKey:@"casualLeave"];
        NSString *earnedLeave=[appDelegate.leavesDictionary valueForKey:@"earnedLeave"];
        //NSString *paidLeave=[appDelegate.leavesDictionary valueForKey:@"paidLeave"];
        NSString *sickLeave=[appDelegate.leavesDictionary valueForKey:@"sickLeave"];
        NSMutableArray *arrays=[[NSMutableArray alloc]initWithObjects:casualLeaves,sickLeave,earnedLeave, nil];
        NSString *selectedLeaveType;
        NSLog(@"%@",arrays);
        /* user friendly msg for Remaining leaves*/
        for (int i=0; i<arrays.count; i++) {
            
            if ([myTextField.text isEqualToString:[pickerArray objectAtIndex:i]]) {
                selectedLeaveType=[NSString stringWithFormat:@"%@",[arrays objectAtIndex:i]];
            }
        }
        
        
        
       
        NSString *message=[NSString stringWithFormat:@" Remaining %@S :%@",myTextField.text,selectedLeaveType];
        userMsg.text=message;
        userMsg.hidden=NO;
        NSString *alertMsg=[NSString stringWithFormat:@"You have only %@ %@S",selectedLeaveType,myTextField.text];
        int val1=[numberOfDaysTextField.text intValue];
        int val2=[selectedLeaveType intValue];
        if (val1 > val2) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alertController dismissViewControllerAnimated:YES completion:^{
                   // toDateTextField.text=@"";
                   // numberOfDaysTextField.text=@"";
                }];
                
            });

        }
        else{
        
        }
        
        
    }

}
-(void)save:(id)sender
{
    self.navigationItem.rightBarButtonItem=nil;
    [datePicker removeFromSuperview];
}

#pragma mark - Text field delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    toolBar.hidden=YES;
    NSDate *todayDate = [NSDate date]; // get today date
    if (textField==EidTextbox) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                       target:self action:@selector(keypadDone:)];
        toolBar = [[UIToolbar alloc]initWithFrame:
                   CGRectMake(0, self.view.frame.size.height-265, self.view.frame.size.width, 50)];
        [toolBar setBarStyle:UIBarStyleBlackOpaque];
        NSArray *toolbarItems = [NSArray arrayWithObjects:
                                 doneButton, nil];
        [toolBar setItems:toolbarItems];
        [self.view addSubview:toolBar];
        

    }
    
      else  if (textField.tag==2) {
          [self addPickerView:textField];
            [myPickerView selectRow:0 inComponent:0 animated:YES];
            // The delegate method isn't called if the row is selected programmatically
            [self pickerView:myPickerView didSelectRow:0 inComponent:0];
            [myPickerView removeFromSuperview];
            [toolBar removeFromSuperview];
            [myTextField becomeFirstResponder];
        }
        else if (textField.tag==3 ){
            nIndex=textField.tag;
            dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
            dateFormatter.dateStyle=NSDateFormatterMediumStyle;
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];

           dateTextField.text = [dateFormatter stringFromDate:todayDate];
            [self datePickerBtnAction];
            [datePicker removeFromSuperview];
            [toolBar removeFromSuperview];
            [dateTextField becomeFirstResponder];
        }
        
        else if (textField.tag==4 ){
            nIndex=textField.tag;
            dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
            dateFormatter.dateStyle=NSDateFormatterMediumStyle;
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];

            toDateTextField.text = [dateFormatter stringFromDate:todayDate];

            [self datePickerBtnAction];
            [datePicker removeFromSuperview];
            [toolBar removeFromSuperview];
            [toDateTextField becomeFirstResponder];
        }
        else  if (textField.tag==6) {
            [self addPickerView:textField];
            [myPickerView selectRow:0 inComponent:0 animated:YES];
            // The delegate method isn't called if the row is selected programmatically
            [self pickerView:myPickerView didSelectRow:0 inComponent:0];
            [myPickerView removeFromSuperview];
            [toolBar removeFromSuperview];
            [commonReasonTextField becomeFirstResponder];
        }
        else  if (textField.tag==7) {
           
        }

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if (textField==toDateTextField) {
        
    }

}
-(void)keypadDone:(UITextField *)sender{

    [EidTextbox resignFirstResponder];
    toolBar.hidden=YES;

}
//Picker
-(void)addPickerView:(UITextField *)textField{
    
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(applyLeaveTable.frame.origin.x, applyLeaveTable.frame.size.height-100, applyLeaveTable.frame.size.width, 100)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     myPickerView.frame.size.height-50, applyLeaveTable.frame.size.width, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    if (textField.tag==2) {
        myPickerView.tag=textField.tag;
        myTextField.inputView = myPickerView;
        myTextField.inputAccessoryView = toolBar;

    }
    else if(textField.tag==6){
        myPickerView.tag=textField.tag;

        commonReasonTextField.inputView = myPickerView;
        commonReasonTextField.inputAccessoryView = toolBar;
    
    }
    
    [self.view addSubview:myPickerView];
    [self.view addSubview:toolBar];
   

}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    NSInteger count;
    if (pickerView.tag==2) {
        count=[pickerArray count];
    }
    else  if (pickerView.tag==6){
        count=[reasonspickerArray count];
    }
    return count;
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (myPickerView.tag==2) {
        [myTextField setText:[pickerArray objectAtIndex:row]];

    }
  else  if (myPickerView.tag==6) {
      
      
        [commonReasonTextField setText:[reasonspickerArray objectAtIndex:row]];
     [Reasontextbox setText:[reasonspickerArray objectAtIndex:row]];
        
    }

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    NSString *titleString;
    if (myPickerView.tag==2) {
        titleString=[pickerArray objectAtIndex:row];
        
    }
    else  if (myPickerView.tag==6) {
        titleString=[reasonspickerArray objectAtIndex:row];
        
    }

    
    
    return titleString;
}
-(void)applyButtonAction:(id)sender{
    NSLog(@"Your button tapped");
    applyLeaveTable.frame=applyLeaveTableframe;
    [applyLeaveTable reloadData];
    applyLeaveTable.delegate=self;
    applyLeaveTable.dataSource=self;
    
    
    //Service
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"APPDELEGATE ACCESS %@",appDelegate.accessTokenString);
    
    
   // NSString *urlString1=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/apply?access_token=%@&employeeInformationID=%@&leaveType=%@&leaveAppliedDate=%@&leaveFromDate=%@&leaveToDate=%@&comments=%@",appDelegate.accessTokenString,EidTextbox.text,myTextField.text,appliedDateTextbox.text,dateTextField.text,toDateTextField.text,Reasontextbox.text];
//     NSLog(@"URL STRING %@",urlString1);
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/apply"];
   NSURL *url = [NSURL URLWithString:urlString];
//
   
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", appDelegate.accessTokenString];
   


   // NSString* reqString = [NSString stringWithString:[reqDict JSONRepresentation]];
    
    //Request
   // NSData* requestData = [NSData dataWithBytes:[reqString UTF8String] length:[reqString length]];

    [request setRequestMethod:@"POST"];
//    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjects:[NSArray arrayWithObject:@"application/x-www-form-urlencoded"] forKeys:[NSArray arrayWithObject:@"Content-Type"]];
//    [request setRequestHeaders:dict];
   [request addRequestHeader:@"Accept" value:@"application/json"];
   // [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]]];
    NSLog(@"%@",EidTextbox.text);
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    //[request setPostValue:@"access_token" forKey:appDelegate.accessTokenString];
    [request addRequestHeader:@"Authorization" value:authValue];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:EidTextbox.text forKey:@"employeeInformationID"];
    [dict setValue:myTextField.text forKey:@"leaveType"];
    [dict setValue:appliedDateTextbox.text forKey:@"leaveAppliedDate"];
    [dict setValue:dateTextField.text forKey:@"leaveFromDate"];
    [dict setValue:toDateTextField.text forKey:@"leaveToDate"];
    [dict setValue:Reasontextbox.text forKey:@"comments"];
    [dict setValue:numberOfDaysTextField.text forKey:@"numberOfLeaveDays"];
    [request appendPostData:[[SBJsonWriter new] dataWithObject:dict]];
    [request setDelegate:self];
    [request startAsynchronous];
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
}
- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error]   localizedDescription]);
    
}
/*
-(void)startRequest:(NSString*)methodName andParams:(NSArray*)parameters withID:(NSString*)identificator
{
    
    NSMutableDictionary* reqDict = [NSMutableDictionary dictionary];
    [reqDict setObject:methodName forKey:@"method"];
    [reqDict setObject:parameters forKey:@"params"];
    [reqDict setObject:identificator forKey:@"id"];
    
    //RPC JSON
    NSString* reqString = [NSString stringWithString:[reqDict JSONRepresentation]];
    
    //Request
    NSData* requestData = [NSData dataWithBytes:[reqString UTF8String] length:[reqString length]];
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
 
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/leave/apply?access_token=%@",appDelegate.accessTokenString];
    NSURL *url = [NSURL URLWithString:urlString];
    
  ASIFormDataRequest *asiRequest=[ASIFormDataRequest requestWithURL:url];
    
    [asiRequest addRequestHeader:@"Accept" value:@"application/json"];
    [asiRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]]];
    [asiRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    [asiRequest appendPostData:requestData];
    [asiRequest setDelegate:self];
    
    [asiRequest startAsynchronous];
    
}
 */

//Sending Mail
-(void)sendEmail{

    // Email Subject
    NSString *emailTitle = @"LMS";
    // Email Content
    NSString *messageBody = @"Leave Application sent!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"swathi.bhairi@pyramidinc.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}






- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"Response %@",  [request responseString]);
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
    
        if(myTextField.text.length==0||dateTextField.text.length==0||appliedDateTextbox.text.length==0||toDateTextField.text.length==0||commonReasonTextField.text.length==0){
    
    
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please fill all the fields" preferredStyle:UIAlertControllerStyleAlert];
    
           [self presentViewController:alertController animated:YES completion:nil];
    
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
             [alertController dismissViewControllerAnimated:YES completion:^{
             //[self.navigationController popViewControllerAnimated:YES];
             }];
    
             });
    
    
    
        }
        else{
            
            NSString *theJSON = [request responseString];
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
            NSLog(@"Dictionary %@",jsonDictionary);
            NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
            NSLog(@"str %@",str);
            if([str isEqualToString:@"SUCCESS"]){

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Leave applied successfully" preferredStyle:UIAlertControllerStyleAlert];
    
        [self presentViewController:alertController animated:YES completion:nil];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            [alertController dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        });
        
        }
            else{
            
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alertController dismissViewControllerAnimated:YES completion:^{
                       // [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                });

            
            
            }
        }
    }
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
}
- (void)requestFailed:(ASIHTTPRequest *)response
{
    NSError *error = [response error];
    NSLog(@"%ld", (long)[error code]);
    if([error code] !=4)
    {
        NSString *errorMessage = [error localizedDescription];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"LMS" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alertController dismissViewControllerAnimated:YES completion:^{
                //[self.navigationController popViewControllerAnimated:YES];
            }];
            
        });
    }
 
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    
    if (textView.tag==7) {
        applyLeaveTable.frame= CGRectMake( applyLeaveTable.frame.origin.x,  applyLeaveTable.frame.origin.y-textView.tag*20,  applyLeaveTable.frame.size.width,  applyLeaveTable.frame.size.height);
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textView.tag inSection:nSectionIndex];
        [ applyLeaveTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
    
//   applyLeaveTable.frame= CGRectMake( applyLeaveTable.frame.origin.x,  applyLeaveTable.frame.origin.y-nIndex*11,  applyLeaveTable.frame.size.width,  applyLeaveTable.frame.size.height);
//  NSIndexPath *indexPath =[NSIndexPath indexPathForRow:nIndex inSection:nSectionIndex];
//   [ applyLeaveTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) String
{
    if ([String isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        applyLeaveTable.frame=applyLeaveTableframe;
        [applyLeaveTable reloadData];
        applyLeaveTable.delegate=self;
        applyLeaveTable.dataSource=self;

        
        return NO;
    }
    
    return YES;
}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//
//    applyLeaveTable.frame= CGRectMake( applyLeaveTable.frame.origin.x,  applyLeaveTable.frame.origin.y-nIndex*15,  applyLeaveTable.frame.size.width,  applyLeaveTable.frame.size.height);
//    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:nIndex inSection:nSectionIndex];
//    [ applyLeaveTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    return YES;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    applyLeaveTable.frame=applyLeaveTableframe;
    [applyLeaveTable reloadData];
    applyLeaveTable.delegate=self;
    applyLeaveTable.dataSource=self;
    return YES;
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
