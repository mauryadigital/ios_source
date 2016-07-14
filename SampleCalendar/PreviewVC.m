//
//  PreviewVC.m
//  TimeSheet
//
//  Created by kishore kumar nagalla on 18/05/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "PreviewVC.h"
#import "TimeSheetDetailVC.h"
#import "AFNetworking.h"

@interface PreviewVC ()<UITextViewDelegate>{
    
    NSArray *dayArray;
    NSArray * weekKeyArray;
    BOOL isFromPresentVC;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PreviewVC

- (void)viewDidLoad {
    weekKeyArray = [NSArray arrayWithObjects:@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun", nil];
    self.title = @"Preview & Approve";
    
    dayArray = [NSArray arrayWithObjects:@"2015-05-17",@"2015-05-18",@"2015-05-19",@"2015-05-20",@"2015-05-21",@"2015-05-22",@"2015-05-23", nil];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"bgImage"];
    [self.view addSubview: imageView];

    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (isFromPresentVC) {
        isFromPresentVC = NO;
        CGRect rect = self.tableView.frame;
        rect.origin.y=0;
        self.tableView.frame = rect;

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==0) {
        return 1;
    }
    
    

    NSArray *timesheetEntryVOList= [_approvalDict valueForKey:@"timesheetEntryVOList"];


    return timesheetEntryVOList.count+2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==1) {
        NSArray *timesheetEntryVOList= [_approvalDict valueForKey:@"timesheetEntryVOList"];
        NSLog(@"%ld",(long)timesheetEntryVOList.count);

        if(indexPath.row >= timesheetEntryVOList.count){
            return 120;
        }
    
    }
    return indexPath.section == 0?60:44;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return section == 0?0:30;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = nil;

    if (indexPath.section ==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
      //  dict
        UILabel *name =(UILabel*) [cell.contentView viewWithTag:2];
        UILabel *week =(UILabel* )[cell.contentView viewWithTag:3];
        UILabel *hours =(UILabel*)[cell.contentView viewWithTag:4];
        
        name.text = [_approvalDict valueForKey:@"consultantName"];
        week.text = [NSString stringWithFormat:@"%@ - %@",[_approvalDict valueForKey:@"weekStartDate"],[_approvalDict valueForKey:@"weekEndDate"]];

        hours.text = [NSString stringWithFormat:@"%@",[_approvalDict valueForKey:@"weekTotal"]];
       
        cell.contentView.backgroundColor = [UIColor clearColor];

        return cell;
    }else {
        
        NSArray *timesheetEntryVOList= [_approvalDict valueForKey:@"timesheetEntryVOList"];
        NSLog(@"%ld",(long)timesheetEntryVOList.count);
  
        if(indexPath.row >= timesheetEntryVOList.count){
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
            //  dict
            UITextView *commentTextView =(UITextView*) [cell.contentView viewWithTag:2];
            commentTextView.layer.borderWidth = 0.6;
            commentTextView.layer.borderColor = [UIColor blackColor].CGColor;
            commentTextView.layer.cornerRadius = 5;
            commentTextView.delegate = self;
            commentTextView.backgroundColor = [UIColor clearColor];
            commentTextView.editable = NO;
            UILabel *commentTitle =(UILabel*) [cell.contentView viewWithTag:1];

            if(indexPath.row == timesheetEntryVOList.count){
                commentTitle.text = @"Consultant Comments:";
                commentTextView.text = [NSString stringWithFormat:@"%@",[_approvalDict valueForKey:@"comments"]];

            }else{
                commentTitle.text = @"Manager Comments:";
                commentTextView.text = [NSString stringWithFormat:@"%@",[_approvalDict valueForKey:@"mngComments"]];
                commentTextView.editable = YES;

            }
            return cell;
        }
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NSDictionary *dict = [timesheetEntryVOList objectAtIndex:indexPath.row];
        NSString *projectType = [dict valueForKey:@"projectType"];
        
        UILabel *textLabel = (UILabel*)[cell.contentView viewWithTag:1];
        
        if ([projectType isEqualToString:@"Project"]) {
            textLabel.text = [NSString stringWithFormat:@"%@: %@ - %@ hr",projectType,[[dict valueForKey:@"client"] valueForKey:@"clientName"],[dict valueForKey:@"totalHours"]];
            
        }else{
            textLabel.text = [NSString stringWithFormat:@"%@: %@ - %@ hr",projectType,[dict valueForKey:@"timeOffHoursType"],[dict valueForKey:@"totalHours"]];
        }
        
        
        if(indexPath.row %2 == 0){
            cell.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        }else{
            cell.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
        }
        
    }
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isFromPresentVC = YES;
    UINavigationController *nvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TimeSheetDetailNVC"];
    
    TimeSheetDetailVC *timeSheetDetailVC = [nvc.viewControllers objectAtIndex:0];
    timeSheetDetailVC.timesheetVODict = _approvalDict;
    NSArray *timesheetEntryVOList= [_approvalDict valueForKey:@"timesheetEntryVOList"];

    timeSheetDetailVC.timesheetEntryVOListDict = [timesheetEntryVOList objectAtIndex:indexPath.row];
    [self presentViewController:nvc animated:YES completion:nil];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    UITableViewCell *cell = (UITableViewCell*)textView.superview.superview;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 230, 0);
    
    [self.tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    UITableViewCell *cell = (UITableViewCell*)textView.superview.superview;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
    NSArray *timesheetEntryVOList= [_approvalDict valueForKey:@"timesheetEntryVOList"];

    if(selectedIndexPath.row == timesheetEntryVOList.count){
      //  [_approvalDict setValue:textView.text forKey:@"comments"];
        
    }else{
        [_approvalDict setValue:textView.text forKey:@"mngComments"];
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView reloadData];
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//  
//    if (section ==0) {
//        
//        return nil;
//    }
//    
//    UIView *bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    bgView.backgroundColor= [UIColor whiteColor];
//    UILabel *textLable= [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.view.frame.size.width+20, 30)];
//    
//    if (section !=0) {
//        textLable.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:0.3];
//        textLable.text = dayArray[section-1];
//    }
//    textLable.font = [UIFont boldSystemFontOfSize:16];
//    [bgView addSubview:textLable];
//
//    return bgView;
//    
//}

- (IBAction)rejectButtonAction:(id)sender {
    
    NSString *comments = [_approvalDict valueForKey:@"mngComments"];
    
    if (comments!=nil && comments.length >0) {
        
        
    }else{
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter valid comments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        return;
    }
    
    
    [self actionOnTimeSheet:NO];
}
- (IBAction)approveButtonAction:(id)sender {
    [self actionOnTimeSheet:YES];
}

-(void)actionOnTimeSheet:(BOOL)isApprove{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    UIActivityIndicatorView *activityindicator= [[UIActivityIndicatorView alloc]init];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityindicator.frame=CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-60)/2-64, 100, 60);
    activityindicator.layer.cornerRadius =6;
    activityindicator.backgroundColor = [UIColor colorWithRed:229/255.0 green:47/255.0 blue:24/255.0 alpha:1];
    [self.tableView addSubview:activityindicator];
    [activityindicator startAnimating];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    NSURL *url = [NSURL URLWithString:@"http://173.15.43.75:418/tms/rest/timesheet/statusUpdate"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [_approvalDict setValue:isApprove?@"APPROVED":@"REJECTED" forKey:@"status"];

    [request setHTTPBody:[self sendPostData:_approvalDict]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSString *token = [NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"access_token"]];
    [request setValue:token forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode == 200) {
            //1
            
            [_approvalArray removeAllObjects];
            [_approvalArray addObjectsFromArray:[responseObject valueForKey:@"timesheetVOs"]];
            //2
            
            
            for (int mvIndex =0 ; mvIndex<_approvalArray.count; mvIndex++) {
                
                
                NSMutableDictionary *timesheetVODict = [[NSMutableDictionary alloc]initWithDictionary:[_approvalArray objectAtIndex:mvIndex]];;
                [_approvalArray replaceObjectAtIndex:mvIndex withObject:timesheetVODict];
                
                
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
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
             [[[UIAlertView alloc] initWithTitle:@"Server not respond" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
        [activityindicator removeFromSuperview];
        
    }];
    [task resume];
    
    
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
