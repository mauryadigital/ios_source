//
//  HolidaysViewController.h
//  LeaveManagement
//
//  Created by User on 5/18/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCalendarView.h"
@class YearHolidaysViewController;
@interface HolidaysViewController : UIViewController<CXCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *holidayListArray;
    NSMutableArray *holidayDatesArray;
    NSMutableArray *imagesArray;
    NSString *accessToken;
    NSMutableArray *monthNumberArray;
    NSMutableDictionary *jsonDictionary;
    NSMutableArray *datesListArray;
    UILabel *emptyLabel;
    UIActivityIndicatorView *spinner;
    

}
@property(nonatomic,strong) CXCalendarView *calendarView;
@property (strong, nonatomic)UITableView *holidayListTable;
@property (atomic)int monthNumber;
@property(nonatomic,strong) NSMutableArray *monthNumberArray;
@property(nonatomic,strong) NSMutableArray *holidayDatesArray;
@property(nonatomic,strong) NSMutableArray *holidayListArray;

@end
