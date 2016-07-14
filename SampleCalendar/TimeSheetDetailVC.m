
//
//  TimeSheetDetailVC.m
//  TimeSheet
//
//  Created by kishore kumar nagalla on 31/05/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "TimeSheetDetailVC.h"


@interface TimeSheetDetailVC ()<UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray *headerArray;
   
    
    NSMutableDictionary *totalLeaveHours;
    
    UITextField*  selectedTextFiled;

    NSIndexPath * selectedIndexPath;
    UIButton*  selectedButton;

    NSArray *hoursArray;
    NSArray *minutesArray;
    
    NSArray *leavePickerArray;
    NSArray *clientPickerArray;
    
    UIPickerView *pickerView;
    UIToolbar *toolBar ;
    
    NSString *hours;
    NSString *minutes;
    ;

    NSDictionary *newWorkDict;
    NSDictionary *newLeaveDict;
    
    NSString *workHours;
    NSString *leaveHours;
    
    
    NSArray * weekDispalyArray;
    NSArray * keyMonthDispalyArray;

    NSArray *weekKeyArray;
    
    BOOL isClientSelected;
    
   }

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation TimeSheetDetailVC

- (void)viewDidLoad {
    isClientSelected = true;
    
    self.title = @"Enter TS";
    if (!_isFromAdd) {
        
    }
    
  
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"bgImage"];
    self.tableView.backgroundView = imageView;
    
    
    workHours = @"00:00";
    leaveHours = @"00:00";

    newWorkDict = [NSDictionary dictionaryWithObjectsAndKeys:@"timesheetEntryId",@"",@"client",@"LLS",@"hours",@"",@"comments",@"", nil ];
    newLeaveDict = [NSDictionary dictionaryWithObjectsAndKeys:@"timesheetEntryId",@"",@"nonBillableHoursType",@"",@"hours",@"",@"comments",@"", nil ];
    
    leavePickerArray = [NSArray arrayWithObjects:@"Non_billable",@"Paid Vacation",@"Unpaid Vacation",@"Maternity",@"EDT", nil];
    clientPickerArray= [NSArray arrayWithObjects:@"LLS", nil];

    totalLeaveHours =[NSMutableDictionary new];

 //   workArray = [NSMutableArray new];
   // [workArray addObject:@"item"];
    
   // leaveArray = [NSMutableArray new];
   // [leaveArray addObject:@"item"];

    self.title = @"Enter Time Sheet for Week";
    
    weekDispalyArray = [NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];
    weekKeyArray = [NSArray arrayWithObjects:@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun", nil];
    
    hoursArray = [NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
    minutesArray = [NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    
    keyMonthDispalyArray = [NSArray arrayWithObjects:@"displayDateMon", @"displayDateTue",@"displayDateWed",@"displayDateThu",@"displayDateFri",@"displayDateSat",@"displayDateSun",nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    if (![self checkIsEditableView]) {
        
        UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonAction)];
        self.navigationItem.rightBarButtonItem = item;
        self.navigationItem.leftBarButtonItem = nil;

    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)closeButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 80;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =nil;
    
    
    NSString *cell1 = @"HeaderCell";
    NSString *cell2 = @"ClientCell";
    
    //totalHours

    if (indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cell1 forIndexPath:indexPath ];
        
        UIButton * client = (UIButton*)[cell.contentView viewWithTag:5];
        UIButton * project = (UIButton*)[cell.contentView viewWithTag:6];
        
        UIButton *clientButton =(UIButton*) [cell.contentView viewWithTag:1];
        UIButton *leaveButton =(UIButton*) [cell.contentView viewWithTag:2];

        
        UIButton *clientTypeButton =(UIButton*) [cell.contentView viewWithTag:5];
        UIButton *leaveTypeButton =(UIButton*) [cell.contentView viewWithTag:6];

        
        UIImage *selectedImage =[UIImage imageNamed:@"select"];
        UIImage *deSelectedImage =[UIImage imageNamed:@"unselect"];
        
        

        
        
        
        if ([[_timesheetEntryVOListDict valueForKey:@"projectType"]isEqualToString:@"Project"]) {
          
            [client setTitle:[NSString stringWithFormat:@"%@",[[_timesheetEntryVOListDict valueForKey:@"client"] valueForKey:@"clientName"]] forState:UIControlStateNormal];
            [project setTitle:[NSString stringWithFormat:@"%@",[_timesheetEntryVOListDict valueForKey:@"timeOffHoursType"]] forState:UIControlStateNormal];
            [clientButton setImage:selectedImage forState:UIControlStateNormal];
            [leaveButton setImage:deSelectedImage forState:UIControlStateNormal];
            
            
            if (!_isFromAdd) {
                leaveButton.enabled = NO;
                clientButton.enabled = NO;
                clientTypeButton.enabled = YES;
                leaveTypeButton.enabled = NO;
            }else{
                clientButton.enabled = YES;
                
                clientTypeButton.enabled = YES;
                leaveButton.enabled = YES;

                leaveTypeButton.enabled = NO;

            }
          

        }else{
            [project setTitle:[NSString stringWithFormat:@"%@",[_timesheetEntryVOListDict valueForKey:@"timeOffHoursType"]] forState:UIControlStateNormal];

            [client setTitle:[NSString stringWithFormat:@"%@",[[_timesheetEntryVOListDict valueForKey:@"client"] valueForKey:@"clientName"]] forState:UIControlStateNormal];
            [clientButton setImage:deSelectedImage forState:UIControlStateNormal];
            [leaveButton setImage:selectedImage forState:UIControlStateNormal];
            
            if (!_isFromAdd) {
                leaveButton.enabled = NO;
                clientButton.enabled = NO;
                clientTypeButton.enabled = NO;
                leaveTypeButton.enabled = YES;
            }else{
                clientButton.enabled = YES;
                clientTypeButton.enabled = NO;
                leaveTypeButton.enabled = YES;
                leaveButton.enabled = YES;
                
            }
        }
        if ([client.titleLabel.text isEqualToString:@""]) {
            [client setTitle:@"Not Available" forState:UIControlStateNormal];

        }
        if ([project.titleLabel.text isEqualToString:@""]) {
            [client setTitle:@"Not Available" forState:UIControlStateNormal];

        }
        
    } else{
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:cell2 forIndexPath:indexPath ];
        UITextField *dayTextField = (UITextField*)[cell.contentView viewWithTag:1];
        
        UITextField *hoursTextField = (UITextField*)[cell.contentView viewWithTag:2];
        
        UIButton *hoursButton =(UIButton*) [cell.contentView viewWithTag:4];
        
        
        if (indexPath.row == 8) {
            hoursButton.enabled = NO;
            hoursTextField.enabled = NO;
            dayTextField.text = @"Total Hours: ";
            hoursTextField.text = [NSString stringWithFormat:@"%@",[_timesheetEntryVOListDict valueForKey:@"totalHours"]];

            
        }else{
            dayTextField.text = [NSString stringWithFormat:@"%@, %@", [weekDispalyArray objectAtIndex:indexPath.row-1],[_timesheetVODict  valueForKey:[keyMonthDispalyArray objectAtIndex:indexPath.row-1]]];
            
            hoursButton.enabled = YES;
            hoursTextField.enabled = NO;

            
            NSDictionary *dayDict = [_timesheetEntryVOListDict valueForKey:[weekKeyArray objectAtIndex:indexPath.row-1]];
            hoursTextField.text = [NSString stringWithFormat:@"%@",[dayDict valueForKey:@"hours"]];
        }
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)editButtonAction:(id)sender {
    
    
    
}


-(BOOL)checkIsEditableView{
    if ([[_timesheetVODict valueForKey:@"status"] isEqualToString:@"SUBMITTED"]) {
        return NO;
    }
    return YES;

}


-(void)pickerDoneButtonAction{
    self.tableView.contentInset = UIEdgeInsetsMake( 64,0, 0, 0);
    
    pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    toolBar.frame= CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 30);
}

#pragma mark - BUTTON ACTIONS

- (IBAction)radioButtonActionForType:(id)sender {
    if (![self checkIsEditableView]) {
        return;
    }
    UIButton *currentButton = (UIButton*)sender;
    
    UITableViewCell *cell = (UITableViewCell*) currentButton.superview.superview;
    
    UIButton *secondButton =(UIButton*) [cell.contentView viewWithTag:currentButton.tag==1?2:1];
    
    
    
    
    UIImage *selectedImage =[UIImage imageNamed:@"select"];
    UIImage *deSelectedImage =[UIImage imageNamed:@"unselect"];
    
    [currentButton setImage:selectedImage forState:UIControlStateNormal];
    [secondButton setImage:deSelectedImage forState:UIControlStateNormal];
    
    
    /*Project
     TimeOff
     projectType*/
    
    UIButton *clientButton =(UIButton*) [cell.contentView viewWithTag:5];
    UIButton *leaveButton =(UIButton*) [cell.contentView viewWithTag:6];

    if (currentButton.tag == 1) {
        [_timesheetEntryVOListDict setValue:@"Project" forKey:@"projectType"];
        [_timesheetEntryVOListDict setValue:@"" forKey:@"timeOffHoursType"];
        clientButton.enabled = YES;
        leaveButton.enabled = NO;

    }else{
        [_timesheetEntryVOListDict setValue:@"TimeOff" forKey:@"projectType"];
        [_timesheetEntryVOListDict setValue:@"" forKey:@"timeOffHoursType"];

       // [_timesheetEntryVOListDict setValue:@"" forKey:[[_timesheetEntryVOListDict valueForKey:@"client"] valueForKey:@"clientName"] ];
        clientButton.enabled = NO;
        leaveButton.enabled = YES;
    }
    
    for (NSString *day in weekKeyArray) {
        NSDictionary *dayDict = [_timesheetEntryVOListDict valueForKey:day];
        [dayDict setValue:@"0.00" forKey:@"hours"];

    }
   
    [_timesheetEntryVOListDict setValue:@"00:00" forKey:@"totalHours"];

    [_timesheetEntryVOListDict setValue:@"00:00" forKey:@"projectTotalHoursForWeek"];

    
    [self.tableView reloadData];
}


- (IBAction)clientORLeaveTypePickerAction:(id)sender {
    
    if (![self checkIsEditableView]) {
        return;
    }
    
    UIButton *button = (UIButton*)sender;
    selectedButton= button;
    UITableViewCell *cell = (UITableViewCell*)button.superview.superview;
    
    
    selectedTextFiled = (UITextField *) [cell.contentView viewWithTag:2];
    selectedIndexPath = [self.tableView indexPathForCell:cell];
    
    
    if (pickerView==nil) {
        pickerView = [[UIPickerView alloc]init];
        pickerView.delegate= self;
        pickerView.dataSource =self;
        pickerView.backgroundColor = [UIColor whiteColor];
        
        pickerView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
        [self.view addSubview:pickerView];
        
        toolBar = [[UIToolbar alloc]init];
        [self.view addSubview:toolBar];
        
        toolBar.frame= CGRectMake(0, self.view.frame.size.height-240, self.view.frame.size.width, 40);
        toolBar.barTintColor = [UIColor blackColor];
        toolBar.tintColor = [UIColor whiteColor];
        UIBarButtonItem*  flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneButtonAction)];
        toolBar.items = [NSArray arrayWithObjects:flex,done, nil ];
    }
    
   
    [pickerView reloadAllComponents];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 230, 0);
    
    pickerView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
    toolBar.frame= CGRectMake(0, self.view.frame.size.height-240, self.view.frame.size.width, 40);
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    NSLog(@"working hours");
}







- (IBAction)hoursButtonAction:(id)sender {
    if (![self checkIsEditableView]) {
        return;
    }
    UIButton *button = (UIButton*)sender;
    selectedButton= button;
    UITableViewCell *cell = (UITableViewCell*)button.superview.superview;
    
    
    selectedTextFiled = (UITextField *) [cell.contentView viewWithTag:2];
    selectedIndexPath = [self.tableView indexPathForCell:cell];
    
    
    
    if (pickerView==nil) {
        pickerView = [[UIPickerView alloc]init];
        pickerView.delegate= self;
        pickerView.dataSource =self;
        pickerView.backgroundColor = [UIColor whiteColor];
        
        pickerView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
        [self.view addSubview:pickerView];
        
        toolBar = [[UIToolbar alloc]init];
        [self.view addSubview:toolBar];
        
        toolBar.frame= CGRectMake(0, self.view.frame.size.height-240, self.view.frame.size.width, 40);
        toolBar.barTintColor = [UIColor blackColor];
        toolBar.tintColor = [UIColor whiteColor];
        UIBarButtonItem*  flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneButtonAction)];
        toolBar.items = [NSArray arrayWithObjects:flex,done, nil ];
    }
    [pickerView reloadAllComponents];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 230, 0);
    
    pickerView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
    toolBar.frame= CGRectMake(0, self.view.frame.size.height-240, self.view.frame.size.width, 40);
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    NSLog(@"working hours");
}



- (void)addButtonAction:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    
    
    if (button.tag == 1) {
        
     //   [workArray addObject:newWorkDict];
        
      //  [workArray addObject:@"item"];
     //   NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
      //  [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];


    }else{
       // [leaveArray addObject:newWorkDict];

       // [leaveArray addObject:@"item"];
       // NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
        //[self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView reloadData];
    
}
#pragma mark - picker delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (selectedButton.tag != 4) {
        return 1;
    }
    return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    


    if (component==0) {
        
        if(selectedButton.tag == 4){
            return hoursArray.count;

        }else{
            return selectedButton.tag == 5 ? clientPickerArray.count : leavePickerArray.count;
 
        }
        
    }else if (component==1) {
        
        return 1;
    }else if (component==2) {
        
        return minutesArray.count;
    }else if (component==3) {
        
        return 1;
    }
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(selectedButton.tag == 4){
        
        if (component==0) {
            if(selectedButton.tag ==3){
                return selectedIndexPath.section == 0 ? clientPickerArray[row] : leavePickerArray[row];
            }
            
            return [hoursArray objectAtIndex:row];
        }else if (component==1) {
            
            return @"hh";
        }else if (component==2) {
            
            return [minutesArray objectAtIndex:row];
        }else  {
            
            return @"mm";
        }
        return [minutesArray objectAtIndex:row];
    }else{
        if(selectedButton.tag == 5){
            
            return [clientPickerArray objectAtIndex:row];
            
        }else{
            return [leavePickerArray objectAtIndex:row];

        }
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (selectedIndexPath.row >0 && selectedIndexPath.row<9) {
        
        if (component == 0) {
            hours = [hoursArray objectAtIndex:row];
        }else  if (component == 2) {
            minutes = [minutesArray objectAtIndex:row];
        }

        NSString *hoursSpend =  [  NSString stringWithFormat:@"%.2ld:%.2ld",(long)[hours?hours:@"0" integerValue],(long)[minutes?minutes:@"00" integerValue]];

        NSDictionary *dayDict = [_timesheetEntryVOListDict valueForKey:[weekKeyArray objectAtIndex:selectedIndexPath.row-1]];
        
        if (selectedButton.tag == 3) {
            
        }else{ // tag =4
            
            [dayDict setValue:hoursSpend forKey:@"hours"];
            
            selectedTextFiled.text = hoursSpend;
            
            
        }
        
        
        [_timesheetEntryVOListDict setValue:[self totalHoursForWork] forKey:@"totalHours"];
        [_timesheetEntryVOListDict setValue:[self totalHoursForWork] forKey:@"projectTotalHoursForWeek"];

        
        [self.tableView reloadData];

        return;

        
    }else{
        /*
         Project
         TimeOff
         projectType
         timeOffHoursType
         client
         */
        
        if(selectedButton.tag == 5){

            [selectedButton setTitle:[clientPickerArray objectAtIndex:row] forState:UIControlStateNormal];
            [[_timesheetEntryVOListDict valueForKey:@"client"] setValue:[clientPickerArray objectAtIndex:row] forKey:@"clientName"];
            [[_timesheetEntryVOListDict valueForKey:@"client"] setValue:@"1" forKey:@"clientId"];

            //[_timesheetEntryVOListDict ]
            
        }else{
            [selectedButton setTitle:[leavePickerArray objectAtIndex:row] forState:UIControlStateNormal];
            [_timesheetEntryVOListDict setValue:[leavePickerArray objectAtIndex:row] forKey:@"timeOffHoursType"];
        }
        
    }

    
    
    
  
    
    
    [self.tableView reloadData];
}


-(NSString*)totalHoursForWork{
    
    
   /*
    NSString *type = [dict valueForKey:@"projectType"];
    if ([type isEqualToString:@"Project"] ) {
    [workArray addObject:type];
    }else{
    [leaveArray addObject:type];
    }
    */
    NSLog(@"start");
    NSString *returnText=@"00:00";
    
    int totalHours=0;
    int totalMinutes=0;
    
    
    
    
        for (NSString *day in weekKeyArray) {
            
            NSDictionary *timeDict = [_timesheetEntryVOListDict valueForKey:day];
            NSString *tempText = [NSString stringWithFormat:@"%@",[timeDict valueForKey:@"hours"]];
            if (tempText==nil||[tempText isEqualToString:@"<null>"]) {
                
            }else{
                NSArray *tempArray = [tempText componentsSeparatedByString:@":"];

                if (tempArray.count==2) {
                    
                    int lhours = [[tempArray objectAtIndex:0]intValue];
                    int lminutes = [[tempArray objectAtIndex:1]intValue];
                    
                    NSLog(@"hours: %d minutes:%d",lhours,lminutes);
                    
                    totalMinutes = totalMinutes + (lhours*60)+lminutes;
                    
                    NSLog(@"total minutes ;' %d",totalMinutes);
                    NSLog(@"totalMinutes; %d",totalMinutes);
                    
                }
            }
            
        }
    
    
    totalHours = totalMinutes/60;
    totalMinutes = totalMinutes%60;
    returnText = [NSString stringWithFormat:@"%.2d:%.2d",totalHours,totalMinutes];
    NSLog(@"returnText: %@",returnText);
    NSLog(@"end");
    return returnText;
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
