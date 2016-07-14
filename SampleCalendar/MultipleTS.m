

//
//  MultipleTS.m
//  SampleCalendar
//
//  Created by kishore kumar nagalla on 22/04/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "MultipleTS.h"

#import "AppDelegate.h"
#import "TimeSheetDetailVC.h"
#import "AFNetworking.h"
@interface MultipleTS ()<UITextViewDelegate>{
    NSArray *weekKeyArray;
}

@end

@implementation MultipleTS

- (void)viewDidLoad {
    [super viewDidLoad];
    weekKeyArray = [NSArray arrayWithObjects:@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun", nil];

      self.title = @"Hours Type";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"bgImage"];
    
    
    
    self.tableView.backgroundView = imageView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.backBarButtonItem.title=@" ";

    if (![[_timesheetVODict valueForKey:@"status"] isEqualToString:@"SUBMITTED"]) {
        UIBarButtonItem *save =[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonAction)];
        
        //self.navigationItem.rightBarButtonItem = save;
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton, save,nil];
    }
    
    
  
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    
  
}


-(NSMutableDictionary*)createNewEntryList{
    
    NSData *data = [self sendPostData:[_timesheetEntryVOList objectAtIndex:0]];

    NSDictionary *newDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *entryDict = [[NSMutableDictionary alloc]initWithDictionary:newDict];

    [entryDict setValue:@"Project" forKey:@"projectType"];
    [entryDict setValue:@"0:00" forKey:@"totalHours"];
    [entryDict setValue:@"0:00" forKey:@"projectTotalHoursForWeek"];
    [entryDict removeObjectForKey:@"timesheetEntryId"];
    [entryDict setValue:@"" forKey:@"timeOffHoursType"];

    for (NSString *day in weekKeyArray) {
        
        NSMutableDictionary *timeDict = [entryDict valueForKey:day];
        [timeDict setValue:@"0:00" forKey:@"hours"];
        [timeDict setValue:@"0" forKey:@"hrs"];
        [timeDict setValue:@"0" forKey:@"mins"];
        [timeDict removeObjectForKey:@"entryDetailsId"];

    }
    NSLog(@"%@",entryDict);

    return entryDict ;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self checkTotalHoursPerDay];
    [self setTotalHoursForWork];
    [self.tableView reloadData];
}

-(void)setTotalHoursForWork{
    
    
    
    NSLog(@"start");
    
    
        NSString *returnText=@"00.00";
        
        int totalHours=0;
        int totalMinutes=0;
        
        for(NSMutableDictionary *timesheetEntryVOListDict in [_timesheetVODict valueForKey:@"timesheetEntryVOList"]){
            if ([[timesheetEntryVOListDict valueForKey:@"projectType"]isEqualToString:@"Project"]) {
                
                for (NSString *day in weekKeyArray) {
                    
                    NSDictionary *timeDict = [timesheetEntryVOListDict valueForKey:day];
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
                            
                        }else if (tempArray.count==1) {
                            
                            int lhours = [[tempArray objectAtIndex:0]intValue];
                            NSLog(@"hours: %d",lhours);
                            
                            totalMinutes = totalMinutes + (lhours*60);
                            
                            NSLog(@"totalMinutes; %d",totalMinutes);
                            
                        }
                    }
                    
                }
                
            }
        }
        
        totalHours = totalMinutes/60;
        totalMinutes = totalMinutes%60;
        returnText = [NSString stringWithFormat:@"%.2d:%.2d",totalHours,totalMinutes];
        
        [_timesheetVODict setValue:returnText forKey:@"weekTotal"];
        
        NSLog(@"returnText: %@",returnText);
    
    
}

-(BOOL)checkTotalHoursPerDay{
    
    
    
    
        NSString *errorText = @"";
        
        for (NSString *day in weekKeyArray) {
           // int totalHours=0;
            int totalMinutes=0;
            NSArray *dayArray = [[_timesheetEntryVOList valueForKey:day] valueForKey:@"hours"];
            NSLog(@"%@",dayArray);
            
            for (NSString *time in dayArray) {
                
                NSArray *tempArray = [time componentsSeparatedByString:@":"];
                
                if (tempArray.count==2) {
                    
                    int lhours = [[tempArray objectAtIndex:0]intValue];
                    int lminutes = [[tempArray objectAtIndex:1]intValue];
                    
                    NSLog(@"hours: %d minutes:%d",lhours,lminutes);
                    
                    totalMinutes = totalMinutes + (lhours*60)+lminutes;
                    
                }else if (tempArray.count==1) {
                    
                    int lhours = [[tempArray objectAtIndex:0]intValue];
                    NSLog(@"hours: %d",lhours);
                    
                    totalMinutes = totalMinutes + (lhours*60);
                    
                    NSLog(@"totalMinutes; %d",totalMinutes);
                    
                }
                
            }
            
            if (totalMinutes>=1440) {
                NSLog(@"total minutes ;' %d",totalMinutes);
                errorText = [errorText stringByAppendingString:[NSString stringWithFormat:@"%@, ",day]];
            }
           
            NSLog(@"errorText %@",errorText);
        }
    
    if (errorText.length>0) {
        errorText = [errorText substringToIndex:errorText.length-2];
        
        [[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Total Hours per day cannot exceed 23:59 for week days : %@",errorText] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        return YES;
    }
    
    return NO;
}

-(void)addButtonAction{
    
    [_timesheetEntryVOList addObject:[self createNewEntryList]];
    
    UINavigationController *nvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TimeSheetDetailNVC"];
    
    TimeSheetDetailVC *timeSheetDetailVC = [nvc.viewControllers objectAtIndex:0];
    timeSheetDetailVC.isFromAdd = YES;
    timeSheetDetailVC.timesheetVODict = _timesheetVODict;
    timeSheetDetailVC.timesheetEntryVOListDict = [_timesheetEntryVOList lastObject];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[_timesheetVODict valueForKey:@"status"] isEqualToString:@"REJECTED"]){
        
        return _timesheetEntryVOList.count+3;
    }
    
    return _timesheetEntryVOList.count+2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[_timesheetVODict valueForKey:@"status"] isEqualToString:@"REJECTED"]){
        if (indexPath.row == _timesheetEntryVOList.count || indexPath.row == _timesheetEntryVOList.count+1) {
            return 122;
        }
    }else {
        if (indexPath.row == _timesheetEntryVOList.count ) {
            return 122;
        }
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if([[_timesheetVODict valueForKey:@"status"] isEqualToString:@"REJECTED"]){
        if (indexPath.row == _timesheetEntryVOList.count+2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SSUBMIT" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        if (indexPath.row == _timesheetEntryVOList.count+1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SSUBMIT" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
    if(indexPath.row >=0 && indexPath.row <_timesheetEntryVOList.count){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        NSDictionary *dict = [_timesheetEntryVOList objectAtIndex:indexPath.row] ;
        
        NSString *projectType = [dict valueForKey:@"projectType"];
        
        UILabel *textLabel = (UILabel*)[cell.contentView viewWithTag:1];
        
        if ([projectType isEqualToString:@"Project"]) {
            textLabel.text = [NSString stringWithFormat:@"%@: %@ - %@ hr",projectType,[[dict valueForKey:@"client"] valueForKey:@"clientName"],[dict valueForKey:@"totalHours"]];
            
        }else{
            textLabel.text = [NSString stringWithFormat:@"%@: %@ - %@ hr",projectType,[dict valueForKey:@"timeOffHoursType"],[dict valueForKey:@"totalHours"]];
        }
    }else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        //  dict
        
        UILabel *commentTitle =(UILabel*) [cell.contentView viewWithTag:1];
        

        
        UITextView *commentTextView =(UITextView*) [cell.contentView viewWithTag:2];
        commentTextView.layer.borderWidth = 0.4;
        commentTextView.layer.borderColor = [UIColor blackColor].CGColor;
        commentTextView.layer.cornerRadius = 5;
        commentTextView.delegate = self;
        commentTextView.backgroundColor = [UIColor clearColor];
        commentTextView.editable = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if([[_timesheetVODict valueForKey:@"status"] isEqualToString:@"REJECTED"]){
            
            if(indexPath.row == _timesheetEntryVOList.count ){
                
                commentTitle.text = @"Manager Comments:";
                commentTextView.text = [NSString stringWithFormat:@"%@",[_timesheetVODict valueForKey:@"mngComments"]];

            }else if(indexPath.row == _timesheetEntryVOList.count+1 ){
                commentTitle.text = @"Consultant Comments:";
                commentTextView.editable = YES;

                commentTextView.text = [NSString stringWithFormat:@"%@",[_timesheetVODict valueForKey:@"comments"]];

            }
            return cell;
        }else{
            
            if(indexPath.row == _timesheetEntryVOList.count ){
                
                commentTitle.text = @"Consultant Comments:";
                commentTextView.editable = YES;
                commentTextView.text = [NSString stringWithFormat:@"%@",[_timesheetVODict valueForKey:@"comments"]];
                
            }
            return cell;
        }
    }
    
   

    if(indexPath.row %2 == 0){
        cell.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    }else{
        cell.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    }
    
   // cell.textLabel.text = [dict valueForKey:@"project"];
    return cell;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    UITableViewCell *cell = (UITableViewCell*)textView.superview.superview;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 230, 0);

    [self.tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}
-(void)textViewDidChange:(UITextView *)textView{
    
    UITableViewCell *cell = (UITableViewCell*)textView.superview.superview;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
    
    if([[_timesheetVODict valueForKey:@"status"] isEqualToString:@"REJECTED"]){
        
        if(selectedIndexPath.row == _timesheetEntryVOList.count ){
            
           // commentTitle.text = @"Manager Comments:";
          //  commentTextView.text = [NSString stringWithFormat:@"%@",[_timesheetVODict valueForKey:@"comments"]];
            
        }else if(selectedIndexPath.row == _timesheetEntryVOList.count+1 ){
           // commentTitle.text = @"Employee Comments:";
            
            [_timesheetVODict setValue:textView.text forKey:@"comments"];
            
        }
    }else{
        
        if(selectedIndexPath.row == _timesheetEntryVOList.count ){
            //commentTitle.text = @"Employee Comments:";
            [_timesheetVODict setValue:textView.text forKey:@"comments"];
            
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [self.tableView reloadData];

        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(NSString *)returnString:(NSDate*)date{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"hh:mm a"];
    return [ dateformatter stringFromDate:date];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >=0 && indexPath.row <_timesheetEntryVOList.count){
        
        UINavigationController *nvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TimeSheetDetailNVC"];
        
        TimeSheetDetailVC *timeSheetDetailVC = [nvc.viewControllers objectAtIndex:0];
        timeSheetDetailVC.timesheetVODict = _timesheetVODict;
        timeSheetDetailVC.timesheetEntryVOListDict = [_timesheetEntryVOList objectAtIndex:indexPath.row];
        [self presentViewController:nvc animated:YES completion:nil];
    }
}


- (void)editButtonAction:(id)sender {
    self.tableView.editing = !self.tableView.isEditing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
        if(indexPath.row >= _timesheetEntryVOList.count ){
            
            [[[UIAlertView alloc]initWithTitle:@"" message:@"You can'nt delete this row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            self.tableView.editing = !self.tableView.isEditing;
            return;

            
        }

    
    
  
    
    if (_timesheetEntryVOList.count == 2) {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"You can'nt delete first two items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        self.tableView.editing = !self.tableView.isEditing;
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row>1) {
            [_timesheetEntryVOList removeObjectAtIndex:indexPath.row];

        }else{
            [[[UIAlertView alloc]initWithTitle:@"" message:@"You can'nt delete it" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            self.tableView.editing = !self.tableView.isEditing;
        }
        
        [self.tableView reloadData];
        
    }
}



- (IBAction)saveButtonAction:(id)sender {
    [self submitDataToServer:NO];
}

- (IBAction)submitButtonAction:(id)sender {
    [self submitDataToServer:TRUE];

}

-(void)submitDataToServer:(BOOL)isSubmitted{

    if ([self checkTotalHoursPerDay]) {
        return;
    }
    UIActivityIndicatorView *  activityindicator= [[UIActivityIndicatorView alloc]init];
    activityindicator.layer.cornerRadius =6;
    activityindicator.backgroundColor = [UIColor colorWithRed:229/255.0 green:47/255.0 blue:24/255.0 alpha:1];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityindicator.frame=CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-60)/2-64, 100, 60);
    [self.view addSubview:activityindicator];
    [activityindicator startAnimating];
    
    NSURLSessionConfiguration *dataConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:dataConfig];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]);
    
    [_timesheetVODict setValue:!isSubmitted?@"SAVE":@"SUBMIT" forKey:@"weekStatus"];
    
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://173.15.43.75:418/tms/rest/timesheet/update"]];
    [request setHTTPMethod:@"POST"];
    NSString *token = [NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [ request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPBody:[self sendPostData:_timesheetVODict]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask= [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [activityindicator removeFromSuperview];

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode == 200) {
            
            if (isSubmitted) {
                [_timesheetVODict setValue:@"SUBMITTED" forKey:@"status"];
            }else{
                [_timesheetVODict setValue:@"NOT_SUBMITTED" forKey:@"status"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
             [[[UIAlertView alloc] initWithTitle:@"Server not respond" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
            
        
        NSLog(@"error: %@",error);
        
        NSLog(@"responseObject: %@",responseObject);
        
    }];
    [dataTask resume];
    
}

-(NSData *)sendPostData:(NSMutableDictionary*)dict{
    
    NSData *data  = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    // NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    // NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    
    
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *outString = [text stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    data = [ outString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return data;
}






/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
