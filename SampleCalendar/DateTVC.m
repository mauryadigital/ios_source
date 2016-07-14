//
//  DateTVC.m
//  SampleCalendar
//
//  Created by kishore kumar nagalla on 22/04/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "DateTVC.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "MultipleTS.h"
#import "TimeSheetDetailVC.h"

@interface DateTVC (){
    NSMutableArray *timeSheetArray;
    NSMutableArray * headerArray;
    
    NSArray *weekKeyArray;
    NSArray *weekDispalyArray;
}

@end

@implementation DateTVC

- (void)viewDidLoad {
    
    weekDispalyArray = [NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];
    weekKeyArray = [NSArray arrayWithObjects:@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun", nil];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"bgImage"];

    self.tableView.backgroundView = imageView;
    
    
    UIActivityIndicatorView *activityindicator= [[UIActivityIndicatorView alloc]init];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityindicator.frame=CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-60)/2-64, 100, 60);
    activityindicator.layer.cornerRadius =6;
    activityindicator.backgroundColor = [UIColor colorWithRed:229/255.0 green:47/255.0 blue:24/255.0 alpha:1];
    [self.tableView addSubview:activityindicator];
    [activityindicator startAnimating];
    
    
    NSURLSessionConfiguration *configaraiton = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configaraiton];
    NSURL *url = nil;
    

    
    
    if (_dashItemType == FROM_TENTRY) {
        self.title = @"Weekly TS";

        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/rest/timesheet/listAll?page=0&consultantId=0&access_token=%@&date=",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]];
        
    }else if (_dashItemType == FROM_SAVED) {
        self.title = @"Saved TS";

        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/rest/timesheet/listAll?page=0&status=NOT_SUBMITTED&consultantId=0&access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]];
        
    }else if (_dashItemType == FROM_SUBMITTED) {
        self.title = @"Submitted TS";

        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/rest/timesheet/listAll?page=0&status=SUBMITTED&consultantId=0&access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]];
        
    }else if (_dashItemType == FROM_REJECTED) {
        self.title = @"Rejected TS";

        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/rest/timesheet/listAll?page=0&status=REJECTED&consultantId=0&access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]];
        
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        NSLog(@"%@",responseObject);
        if (httpResponse.statusCode == 200) {
            //1
            timeSheetArray = [[NSMutableArray alloc]initWithArray:[responseObject valueForKey:@"timesheetVOs"]];
            
            if (timeSheetArray==nil || timeSheetArray.count == 0) {
                [[[UIAlertView alloc] initWithTitle:@"No data available" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                
            [activityindicator removeFromSuperview];

                return;
            }
            //2
            
            
            for (int mvIndex =0 ; mvIndex<timeSheetArray.count; mvIndex++) {
                
                
                NSMutableDictionary *timesheetVODict = [[NSMutableDictionary alloc]initWithDictionary:[timeSheetArray objectAtIndex:mvIndex]];;
                
                
                NSMutableArray *timesheetEntryVOList = [[NSMutableArray alloc]initWithArray:[timesheetVODict valueForKey:@"timesheetEntryVOList"]];
                
                /*
                 
                 */
                for (int vIndex =0 ; vIndex<timesheetEntryVOList.count; vIndex++) {
                    
                    NSMutableDictionary *timesheetEntryVODict = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVOList objectAtIndex:vIndex]];
                    
                    
                    
                    NSMutableDictionary *client = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"client"]];
                    [timesheetEntryVODict setValue:client forKey:@"client"];
                    
                    NSMutableDictionary *monDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"mon"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateMon"]  forKey:@"date"];
                    [timesheetEntryVODict setValue:monDay forKey:@"mon"];
                    
                    NSMutableDictionary *tueDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"tue"]];
                    [tueDay setValue:[timesheetVODict valueForKey:@"dateTue"] forKey:@"date"];
                    [timesheetEntryVODict setValue:tueDay forKey:@"tue"];
                    
                    NSMutableDictionary *wedDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"wed"]];
                    [wedDay setValue:[timesheetVODict valueForKey:@"dateWed"] forKey:@"date"];

                    [timesheetEntryVODict setValue:wedDay forKey:@"wed"];
                    
                    NSMutableDictionary *thrDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"thu"]];
                    [thrDay setValue:[timesheetVODict valueForKey:@"dateThu"] forKey:@"date"];

                    [timesheetEntryVODict setValue:thrDay forKey:@"thu"];
                    
                    NSMutableDictionary *friDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"fri"]];
                    [friDay setValue:[timesheetVODict valueForKey:@"dateFri"] forKey:@"date"];

                    [timesheetEntryVODict setValue:friDay forKey:@"fri"];
                    
                    NSMutableDictionary *satDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"sat"]];
                    [satDay setValue:[timesheetVODict valueForKey:@"dateSat"] forKey:@"date"];

                    [timesheetEntryVODict setValue:satDay forKey:@"sat"];
                    
                    NSMutableDictionary *sunDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"sun"]];
                    [sunDay setValue:[timesheetVODict valueForKey:@"dateSun"] forKey:@"date"];

                    [timesheetEntryVODict setValue:sunDay forKey:@"sun"];
                    [timesheetEntryVOList replaceObjectAtIndex:vIndex withObject:timesheetEntryVODict];
                    

                    
                }
                [timesheetVODict setValue:timesheetEntryVOList forKey:@"timesheetEntryVOList"];

                [timeSheetArray replaceObjectAtIndex:mvIndex withObject:timesheetVODict];

                
                
            }
            
            NSLog(@"%@",timeSheetArray);
            [self.tableView reloadData];
            
        }else{
            
            [[[UIAlertView alloc] initWithTitle:@"Server not respond" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
        [activityindicator removeFromSuperview];
        
    }];
    
    [dataTask resume];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [super viewDidLoad];
    
    
    
    
    
}



/*
 
 for(NSMutableDictionary *timesheetEntryVOListDict in [dict valueForKey:@"timesheetEntryVOList"]){
 
 
 NSDictionary *timeDict = [timesheetEntryVOListDict valueForKey:day];
 NSString *tempText = [NSString stringWithFormat:@"%@",[timeDict valueForKey:@"hours"]];
 if (tempText==nil||[tempText isEqualToString:@"<null>"]) {
 
 }else{
 //
 }
 
 
 }
 }
 */


-(void)setTotalHoursForWork{
    
    
    
    NSLog(@"start");
    
   
    for(NSDictionary *dict in timeSheetArray){
         NSString *returnText=@"00.00";

        int totalHours=0;
        int totalMinutes=0;
        
        for(NSMutableDictionary *timesheetEntryVOListDict in [dict valueForKey:@"timesheetEntryVOList"]){
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
        
        [dict setValue:returnText forKey:@"weekTotal"];
        
        NSLog(@"returnText: %@",returnText);
    }
    
    
}



-(void)viewWillAppear:(BOOL)animated{
//    [self checkTotalHoursPerDay];
    [self setTotalHoursForWork];
    [self.tableView reloadData];
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
           return timeSheetArray.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekCell" forIndexPath:indexPath];
    
    
    NSDictionary *dict = [timeSheetArray objectAtIndex:indexPath.row];
    
    
    UILabel *weekLabel = (UILabel *)[cell.contentView viewWithTag:2];
    weekLabel.text = [NSString stringWithFormat:@"%@ - %@", [dict valueForKey:@"weekStartDate"], [dict valueForKey:@"weekEndDate"]];

    
    UILabel *statusLabel = (UILabel *)[cell.contentView viewWithTag:3];
    statusLabel.layer.cornerRadius =5;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    NSString *status = [NSString stringWithFormat:@"%@ ",[dict valueForKey:@"status"]];
    statusLabel.text = status;
    
   if ([status isEqualToString:@"NOT_STARTED "]) {
       statusLabel.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:108.0/255.0 blue:159.0/255.0 alpha:1];
   }else if ([status isEqualToString:@"NOT_SUBMITTED "]) {
       statusLabel.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:148.0/255.0 blue:6.0/255.0 alpha:1];

    }else if ([status isEqualToString:@"SUBMITTED "]) {
        statusLabel.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.5];

    }else if ([status isEqualToString:@"REJECTED "]) {
        statusLabel.backgroundColor = [UIColor colorWithRed:185.0/255.0 green:74.0/255.0 blue:72.0/255.0 alpha:1];

    }else if ([status isEqualToString:@"APPROVED "]) {
        statusLabel.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:136.0/255.0 blue:71.0/255.0 alpha:1];

    }
    
    UILabel *hoursLabel = (UILabel *)[cell.contentView viewWithTag:5];
    hoursLabel.text = [NSString stringWithFormat:@"  %@ hrs",[dict valueForKey:@"weekTotal"]];

    
    UIButton *editButton = (UIButton*)[cell.contentView viewWithTag:4];
    
    if ([[dict valueForKey:@"status"] isEqualToString:@"SUBMITTED"] || [[dict valueForKey:@"status"] isEqualToString:@"APPROVED"]) {
        editButton.hidden = YES;
    }else{
        editButton.hidden = NO;

    }
    if(indexPath.row %2 == 0){
        cell.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    }else{
        cell.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    }
    
   
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [timeSheetArray objectAtIndex:indexPath.row];
    if ([[dict valueForKey:@"status"] isEqualToString:@"APPROVED"] || [[dict valueForKey:@"status"] isEqualToString:@"SUBMITTED"]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    MultipleTS *multipleTS = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MultipleTS"];
    multipleTS.timesheetEntryVOList = [[timeSheetArray objectAtIndex:indexPath.row] valueForKey:@"timesheetEntryVOList"];
    multipleTS.timesheetVODict = [timeSheetArray objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:multipleTS animated:YES];
    
    return;

}

- (IBAction)editButtonAction:(id)sender {
    
    
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
