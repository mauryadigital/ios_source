//
//  ApprovalViewController.h
//  LeaveManagement
//
//  Created by User on 5/20/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ApprovedCellTableViewCell.h"
@class AppDelegate;
@interface ApprovalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{

    NSMutableArray *nameArray;
    NSMutableArray *myArray;
    NSMutableArray *departmentArray;
    NSMutableArray *statusArray;
    
    UILabel *nameLabel;
    UILabel *departmentLabel;
    UILabel *statusLabel;
    
    CGRect footerFrame;
    NSIndexPath *index;

//Manager
    
    NSMutableArray *empParamsArray;
    NSMutableArray *empDetailsArray;
    NSMutableArray *historyEmpParamsArray;
    NSMutableArray *historyEmpDetailsArray;
    
    NSArray *results;
    UIActivityIndicatorView *spinner;
    NSMutableDictionary *approvalJsonDictionary;
    NSMutableArray *approvalDictArray;
    NSString * update;
    AppDelegate *appDelegate;
    CGRect tabFrame;
    UIButton *closeButton;
}

@property (strong, nonatomic)  UIView *leaveManagerView;

@property (strong, nonatomic)  UITableView *leaveManagerTable;

@property (strong, nonatomic)  UILabel *leaveManagerTitleLabel;

@property (strong, nonatomic) IBOutlet UITableView *approvalTable;
- (IBAction)closeButtonAction:(id)sender;

@end
