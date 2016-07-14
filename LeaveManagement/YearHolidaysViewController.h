//
//  YearHolidaysViewController.h
//  LeaveManagement
//
//  Created by User on 6/20/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HolidaysViewController;
@interface YearHolidaysViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    UIActivityIndicatorView *spinner;

}
@property (strong, nonatomic) IBOutlet UITableView *yearTable;
@property (strong,nonatomic)NSMutableArray *holidayDatesArray;
@property (strong,nonatomic)NSMutableArray *holidayNamesArray;

@end
