//
//  TeamVC.m
//  TimeSheet
//
//  Created by kishore kumar nagalla on 17/05/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "TeamVC.h"
#import "DateTVC.h"
#import "TeamVC.h"
#import "PreviewVC.h"
#import "AFNetworking.h"
@interface TeamVC (){
    
    NSMutableArray *approvalArray;
}

@end

@implementation TeamVC

- (void)viewDidLoad {
    
    
    
    UIActivityIndicatorView *activityindicator= [[UIActivityIndicatorView alloc]init];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityindicator.frame=CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-60)/2-64, 100, 60);
    activityindicator.layer.cornerRadius =6;
    activityindicator.backgroundColor = [UIColor colorWithRed:229/255.0 green:47/255.0 blue:24/255.0 alpha:1];
    [self.tableView addSubview:activityindicator];
    [activityindicator startAnimating];
    
    
    NSURLSessionConfiguration *configaraiton = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configaraiton];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/rest/timesheet/approvals?page=0&consultantId=0&access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode == 200) {
            //1
            approvalArray = [[NSMutableArray alloc]initWithArray:[responseObject valueForKey:@"timesheetVOs"]];
            //2
            
                if (approvalArray==nil || approvalArray.count == 0) {
                    [[[UIAlertView alloc] initWithTitle:@"No data available" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    
                    [activityindicator removeFromSuperview];
                    
                    return;
                }
            
            for (int mvIndex =0 ; mvIndex<approvalArray.count; mvIndex++) {
                
                
                NSMutableDictionary *timesheetVODict = [[NSMutableDictionary alloc]initWithDictionary:[approvalArray objectAtIndex:mvIndex]];;
                [approvalArray replaceObjectAtIndex:mvIndex withObject:timesheetVODict];
                
                
                NSMutableArray *timesheetEntryVOList = [[NSMutableArray alloc]initWithArray:[timesheetVODict valueForKey:@"timesheetEntryVOList"]];
                
                [timesheetVODict setValue:timesheetEntryVOList forKey:@"timesheetEntryVOList"];
                /*
                 
                 */
                for (int vIndex =0 ; vIndex<timesheetEntryVOList.count; vIndex++) {
                    
                    NSMutableDictionary *timesheetEntryVODict = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVOList objectAtIndex:vIndex]];
                    [timesheetEntryVOList replaceObjectAtIndex:vIndex withObject:timesheetEntryVODict];
                    
                    NSMutableDictionary *monDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"mon"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateMon"]  forKey:@"date"];
                    [timesheetEntryVODict setValue:monDay forKey:@"mon"];
                    
                    NSMutableDictionary *tueDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"tue"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateTue"] forKey:@"date"];
                    [timesheetEntryVODict setValue:tueDay forKey:@"tue"];
                    
                    NSMutableDictionary *wedDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"wed"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateWed"] forKey:@"date"];
                    
                    [timesheetEntryVODict setValue:wedDay forKey:@"wed"];
                    
                    NSMutableDictionary *thrDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"thu"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateThu"] forKey:@"date"];
                    
                    [timesheetEntryVODict setValue:thrDay forKey:@"thu"];
                    
                    NSMutableDictionary *friDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"fri"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateFri"] forKey:@"date"];
                    
                    [timesheetEntryVODict setValue:friDay forKey:@"fri"];
                    
                    NSMutableDictionary *satDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"sat"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateSat"] forKey:@"date"];
                    
                    [timesheetEntryVODict setValue:satDay forKey:@"sat"];
                    
                    NSMutableDictionary *sunDay = [[NSMutableDictionary alloc]initWithDictionary:[timesheetEntryVODict valueForKey:@"sun"]];
                    [monDay setValue:[timesheetVODict valueForKey:@"dateSun"] forKey:@"date"];
                    
                    [timesheetEntryVODict setValue:sunDay forKey:@"sun"];
                    
                    
                }
                
                
                
                
            }
            
            
            [self.tableView reloadData];
            
        }else{
            
            [[[UIAlertView alloc] initWithTitle:@"Server not respond" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
        [activityindicator removeFromSuperview];
        
    }];
    
    [dataTask resume];
    
    
    
//    self.title = @"Tap to confirm actions";
    self.title = @"Approval TS";

    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"bgImage"];
    
    self.tableView.backgroundView = imageView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}
-(void)viewWillAppear:(BOOL)animated{
    
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
    return approvalArray.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *textLable= [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 44)];
    textLable.textAlignment = NSTextAlignmentCenter;
    if (section ==0) {
        textLable.backgroundColor = [UIColor blueColor];
        textLable.text =@"  Pending";
    }else if(section ==1){
        textLable.backgroundColor = [UIColor greenColor];
        textLable.text =@"  Approved";

    }else{
    textLable.backgroundColor = [UIColor redColor];
    textLable.text =@"  Rejected";
    }
    textLable.textColor = [UIColor whiteColor];
    textLable.font = [UIFont boldSystemFontOfSize:16];
    return textLable;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    
    
    NSDictionary *weekDict = [approvalArray objectAtIndex:indexPath.row];
    
    // weekStartDate : "06/06/2016"
    //weekEndDate : "06/12/2016"
    
    
    UILabel *weekLabel = (UILabel*)[self.view viewWithTag:1];
    
   // weekLabel.text = [NSString stringWithFormat:@"    %@ - %@     - %@",[weekDict valueForKey:@"weekStartDate"],[weekDict valueForKey:@"weekEndDate"],[weekDict valueForKey:@"status"]];
    weekLabel.text = [NSString stringWithFormat:@" %@ - %@ ",[weekDict valueForKey:@"weekStartDate"],[weekDict valueForKey:@"weekEndDate"]];

    UILabel *empLabel = (UILabel*)[self.view viewWithTag:2];
    empLabel.text = [NSString stringWithFormat:@"Employee: %@",[weekDict valueForKey:@"consultantName"]];
    
    UILabel *houaLabel = (UILabel*)[self.view viewWithTag:3];
    houaLabel.text = [NSString stringWithFormat:@"%@",[weekDict valueForKey:@"weekTotal"]];

    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.section ==0) {
         
     }else if (indexPath.section ==1) {
         
     }else{
         
     }
    
     PreviewVC *previewVC = (PreviewVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PreviewVC"];
    
    previewVC.approvalArray = approvalArray;
    previewVC.approvalDict =[ approvalArray objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:previewVC animated:YES];

    /*
    DateTVC *dateTVC = (DateTVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"DATE_TVC"];
   // dateTVC.title = [weeksArray objectAtIndex:indexPath.row];
    dateTVC.title = @"";

    dateTVC.selectedDate = [NSDate date];
    
    [dateTVC.tableView reloadData];
    [self.navigationController pushViewController:dateTVC animated:YES];
*/
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
