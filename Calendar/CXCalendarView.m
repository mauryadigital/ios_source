//
//  CXCalendarView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarView.h"

#import <QuartzCore/QuartzCore.h>

#import "CXCalendarCellView.h"
#import "UIColor+CXCalendar.h"
#import "UILabel+CXCalendar.h"
#import "UIButton+CXCalendar.h"

#import "HolidaysViewController.h"


#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"



static const CGFloat kGridMargin = 1;
static const CGFloat kDefaultMonthBarButtonWidth = 10;

@implementation CXCalendarView

@synthesize delegate,monthNumber,holidayListArray,monthNumberArray,holidayDatesArray;

- (id) initWithFrame: (CGRect) frame {
    if ((self = [super initWithFrame: frame])) {
        
        
    
        
        
        
        
        [self setDefaults];
    }

    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setDefaults];
}

- (void) setDefaults {
    self.backgroundColor = [UIColor clearColor];

//   CGGradientRef gradient = CGGradientCreateWithColors(NULL,
//        (CFArrayRef)@[
//                      (id)[UIColor lightGrayColor].CGColor,
//                      (id)[UIColor lightGrayColor].CGColor], NULL);

    self.monthBarBackgroundColor = [UIColor colorWithRed:183.0/255.0 green:6.0/255.0 blue:4.0/255.0 alpha:1.0];

    // TODO: Merge default text attributes when given custom ones!
    self.monthLabelTextAttributes = @{
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                      NSFontAttributeName : [UIFont systemFontOfSize:[UIFont buttonFontSize]],
                                      };    self.weekdayLabelTextAttributes = @{
         NSForegroundColorAttributeName: [UIColor blackColor],
        NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]],
        NSShadowAttributeName : [NSValue valueWithCGSize:CGSizeMake(0, 1)]
        };
    self.cellLabelNormalTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor blackColor]
    };
    self.cellLabelSelectedTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor colorWithRed:183.0/255.0 green:6.0/255.0 blue:4.0/255.0 alpha:1.0]
    };
    self.cellSelectedBackgroundColor = [UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
    self.cellNormalBackgroundColor = [UIColor clearColor];

    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    _calendar = [[NSCalendar currentCalendar] retain];

    _monthBarHeight = 48;
    _weekBarHeight = 32;

    self.selectedDate = nil;
    self.displayedDate = [NSDate date];
}

- (void) dealloc {
    [_calendar release];
    [_selectedDate release];
    [_displayedDate release];
    [_dateFormatter release];

    [super dealloc];
}

- (NSCalendar *) calendar {
    return _calendar;
}

- (void) setCalendar: (NSCalendar *) calendar {
    if (_calendar != calendar) {
        [_calendar release];
        _calendar = [calendar retain];
        _dateFormatter.calendar = _calendar;

        [self setNeedsLayout];
    }
}

- (NSDate *) selectedDate {
    return _selectedDate;
}

- (void) updateSelectedDate {
    for (CXCalendarCellView *cellView in self.dayCells) {
        cellView.selected = NO;
    }
 [self cellForDate: self.selectedDate].selected = YES;
}

- (void) setSelectedDate: (NSDate *) selectedDate {
    if (![selectedDate isEqual: _selectedDate]) {
        [_selectedDate release];
        _selectedDate = [selectedDate retain];

        [self updateSelectedDate];

        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView: self didSelectDate: _selectedDate];
        }
    }
}

- (NSDate *) displayedDate {
    return _displayedDate;
}

- (void) setDisplayedDate: (NSDate *) displayedDate {
    if (_displayedDate != displayedDate) {
        [_displayedDate release];
        _displayedDate = [displayedDate retain];

        NSString *monthName = [[_dateFormatter standaloneMonthSymbols] objectAtIndex: self.displayedMonth - 1];
        
        NSLog(@"Month NAme %@",monthName);
        self.monthLabel.text = [NSString stringWithFormat: @"%@", monthName];

        [self updateSelectedDate];

        [self setNeedsLayout];
    }
}

- (NSUInteger) displayedYear {
    NSDateComponents *components = [self.calendar components: NSCalendarUnitYear
                                                    fromDate: self.displayedDate];
    return components.year;
}

- (NSUInteger) displayedMonth {
    NSDateComponents *components = [self.calendar components: NSCalendarUnitMonth
                                                    fromDate: self.displayedDate];
    NSLog(@"DISPLAY MONTH %ld",(long)components.month);
    monthNumber=(int)components.month;
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    appDelegate.monthNumber=monthNumber;
    holidayDatesArray=[[NSMutableArray alloc]init];
    //AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"APPDELEGATE ACCESS %@",appDelegate.accessTokenString);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/holidays/?access_token=%@",appDelegate.accessTokenString]];
    // NSString *url=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/holidays/?access_token=%@",appDelegate.accessTokenString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        
        NSLog(@"responseString : %@",responseString);
        //NSData *responseData = [request responseData];
        //NSLog(@"responseData : %@",responseData);
        NSString *theJSON = [request responseString];
        NSLog(@"THE JSON %@",theJSON);
        // Now we have successfully captured the JSON ouptut of our request
        //  [self.navigationController pushViewController:objHomeViewController animated:YES];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        // NSMutableDictionary *divisionDictionary = [jsonDictionary valueForKey:@""];
        NSLog(@"calender dictionary %@",jsonDictionary);
        //  NSMutableArray *groups = [[NSMutableArray alloc] init];
        
        NSArray *results = [jsonDictionary valueForKey:@"holidayCalendar"];
        //NSLog(@"Count %@", results);
        // NSDictionary* loan = [results objectAtIndex:0];
        //NSLog(@"loan : %@",loan);
        
        //    for (NSDictionary *groupDic in results) {
        //
        //    }
        
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        holidayListArray=[[NSMutableArray alloc]init];
        holidayDatesArray=[[NSMutableArray alloc]init];
        
        for (int i=0; i<results.count; i++) {
            dict=[results objectAtIndex:i];
            NSString *str=[NSString stringWithFormat:@"%@",[dict valueForKey:@"holidayName"]];
            NSLog(@"STR : %@",str);
            [holidayListArray addObject:str];
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
        
        
        
        
        
        
        NSLog(@"holidayDatesArray VALUE %@",holidayDatesArray);
        NSLog(@"holidayListArray VALUE %@",holidayListArray);
        
      

        
        if (holidayDatesArray.count!=0) {
            
        
        monthNumberArray=[[NSMutableArray alloc]init];
        for (int i=0; i<holidayDatesArray.count; i++) {
            NSString *dateStr =[holidayDatesArray objectAtIndex:i];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate* myDate = [dateFormatter dateFromString:dateStr];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:myDate];
            NSInteger month = [components month];
            NSInteger year = [components year];
          //  NSNumber *val1 = [NSNumber numberWithInteger:year];

            NSNumber *val = [NSNumber numberWithInteger:month];
            
            [monthNumberArray addObject:val];
            
            
        }
        NSLog(@"MonthNumberArray %@",monthNumberArray);
            
            for (int i=0; i<monthNumberArray.count; i++) {
                NSArray* dateArray = [[holidayDatesArray objectAtIndex:i] componentsSeparatedByString: @"-"];
                NSString* monthString = [dateArray objectAtIndex: 1];
                NSString* dayString = [dateArray objectAtIndex: 2];
                NSLog(@"MY MONTH STRING %@",monthString);
                NSLog(@"MY DAY STRING %@",dayString);
                
              
               
                if (monthNumber==[monthString intValue]) {
                    CXCalendarCellView *cellView = [self.dayCells objectAtIndex:[dayString intValue]-1];
                    cellView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:30.0/255.0 blue:40.0/255.0 alpha:1.0];
                    
                }

            }
            
            
        
       /*
        if (monthNumberArray.count!=0) {
            NSLog(@"monthNO::%@",[monthNumberArray objectAtIndex:3]);
            
        }
        
        if (monthNumber==7) {
            CXCalendarCellView *cellView = [self.dayCells objectAtIndex:7];
            cellView.backgroundColor=[UIColor greenColor];
            
        }
        else if (monthNumber==6) {
            CXCalendarCellView *cellView = [self.dayCells objectAtIndex:1];
            cellView.backgroundColor=[UIColor greenColor];
            
        }
        else if (monthNumber==8) {
            CXCalendarCellView *cellView = [self.dayCells objectAtIndex:14];
            cellView.backgroundColor=[UIColor greenColor];
            
        }
        else if (monthNumber==9) {
            CXCalendarCellView *cellView = [self.dayCells objectAtIndex:4];
            cellView.backgroundColor=[UIColor greenColor];
            
        }
        else if (monthNumber==10) {
            CXCalendarCellView *cellView = [self.dayCells objectAtIndex:2];
            cellView.backgroundColor=[UIColor greenColor];
            CXCalendarCellView *cellView1 = [self.dayCells objectAtIndex:10];
            cellView1.backgroundColor=[UIColor greenColor];
            CXCalendarCellView *cellView2 = [self.dayCells objectAtIndex:29];
            cellView2.backgroundColor=[UIColor greenColor];
            
        }
        
        else if (monthNumber==12) {
            CXCalendarCellView *cellView = [self.dayCells objectAtIndex:24];
            cellView.backgroundColor=[UIColor greenColor];
            
        }
        */
 
        }
        
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error : %@",error);
        
        
    }];
    [request startAsynchronous];
    
    [self addSubview:spinner];
    [spinner startAnimating];
    

    return components.month;
}

- (CGFloat) monthBarHeight {
    return _monthBarHeight;
}

- (void) setMonthBarHeight: (CGFloat) monthBarHeight {
    if (_monthBarHeight != monthBarHeight) {
        _monthBarHeight = monthBarHeight;
        [self setNeedsLayout];
    }
}

- (CGFloat) weekBarHeight {
    return _weekBarHeight;
}

- (void) setWeekBarHeight: (CGFloat) weekBarHeight {
    if (_weekBarHeight != weekBarHeight) {
        _weekBarHeight = weekBarHeight;
        [self setNeedsLayout];
    }
}

- (void) touchedCellView: (CXCalendarCellView *) cellView {
    
    NSLog(@"self.displayedDate %@",self.displayedDate);
    self.selectedDate = [cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar];
   // self.selectedDate = [cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar];
    
}

- (void) monthForward {
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger year = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    
    NSLog(@"YEAR %li",(long)year);
    
    
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = 1;
    
    
    
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
    
    
    
    
    NSLog(@"MONTHBACK :%i",monthNumber);
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;

    appDelegate.monthNumber=monthNumber;
    monthNumberArray=[[NSMutableArray alloc]init];
    
   // [self displayedMonth];
 
  [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];

   
}



- (void) monthBack
{
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = -1;
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
   
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    appDelegate.monthNumber=monthNumber;
    monthNumberArray=[[NSMutableArray alloc]init];
    
    //[self displayedMonth];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
}

- (void) reset {
    self.selectedDate = nil;
}

- (NSDate *) displayedMonthStartDate {
    NSDateComponents *components = [self.calendar components: NSCalendarUnitMonth|NSCalendarUnitYear
                                                    fromDate: self.displayedDate];
    components.day = 1;
    return [self.calendar dateFromComponents: components];
}

- (CXCalendarCellView *) cellForDate: (NSDate *) date {
    if (!date) {
        return nil;
    }

    NSDateComponents *components = [self.calendar components: NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                                        fromDate: date];
    if (components.month == self.displayedMonth &&
            components.year == self.displayedYear &&
            [self.dayCells count] >= components.day) {

        return [self.dayCells objectAtIndex: components.day - 1];
    }
    return nil;
}

- (void) applyStyles {
    _monthBar.backgroundColor = self.monthBarBackgroundColor;
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
}

- (void) layoutSubviews {
    [super layoutSubviews];

    [self applyStyles];

    CGFloat top = 0;

    if (self.monthBarHeight) {
        self.monthBar.frame = CGRectMake(0, top+5, self.bounds.size.width, self.monthBarHeight+5);
        self.monthLabel.frame = CGRectMake(0, top-5, self.bounds.size.width, self.monthBar.bounds.size.height);
        self.monthForwardButton.frame = CGRectMake(self.monthBar.bounds.size.width - kDefaultMonthBarButtonWidth-10, top-5,
                                                   kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        self.monthBackButton.frame = CGRectMake(10, top-5, kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        top = self.monthBar.frame.origin.y + self.monthBar.frame.size.height;
    } else {
        self.monthBar.frame = CGRectZero;
    }

    if (self.weekBarHeight) {
        self.weekdayBar.frame = CGRectMake(0, top-10, self.bounds.size.width, self.weekBarHeight);
        CGRect contentRect = CGRectInset(self.weekdayBar.bounds, kGridMargin, 0);
        for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
            UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
            label.frame = CGRectMake((contentRect.size.width / 7) * (i % 7), 0,
                                     contentRect.size.width / 7, contentRect.size.height);
        }
        top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
    } else {
        self.weekdayBar.frame = CGRectZero;
    }

    // Calculate shift
    NSDateComponents *components = [self.calendar components: NSCalendarUnitWeekday
                                                    fromDate: [self displayedMonthStartDate]];
    NSInteger shift = components.weekday - self.calendar.firstWeekday;
    if (shift < 0) {
        shift = 7 + shift;
    }

    // Calculate range
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth
                                       forDate:self.displayedDate];

    self.gridView.frame = CGRectMake(kGridMargin, top,
                                     self.bounds.size.width - kGridMargin * 2,
                                     self.bounds.size.height - top);
    CGFloat cellHeight = self.gridView.bounds.size.height / 6.0;
    CGFloat cellWidth = (self.bounds.size.width - kGridMargin * 2) / 7.0;
    for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
        CXCalendarCellView *cellView = [self.dayCells objectAtIndex:i];
        cellView.frame = CGRectMake(cellWidth * ((shift + i) % 7), cellHeight * ((shift + i) / 7),
                                    cellWidth, cellHeight);
        cellView.hidden = i >= range.length;
    }
}

- (UIView *) monthBar {
    if (!_monthBar) {
        _monthBar = [[[UIView alloc] init] autorelease];
        _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: _monthBar];
    }
    return _monthBar;
}

- (UILabel *) monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[[UILabel alloc] init] autorelease];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _monthLabel.backgroundColor = [UIColor clearColor];
        [self.monthBar addSubview: _monthLabel];
    }
    return _monthLabel;
}

- (UIButton *) monthBackButton {
    if (!_monthBackButton) {
        _monthBackButton = [[[UIButton alloc] init] autorelease];
        [_monthBackButton setTitle: @"<" forState:UIControlStateNormal];
        [_monthBackButton addTarget: self
                             action: @selector(monthBack)
                   forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthBackButton];
    }
    return _monthBackButton;
}

- (UIButton *) monthForwardButton {
    if (!_monthForwardButton) {
        _monthForwardButton = [[[UIButton alloc] init] autorelease];
        [_monthForwardButton setTitle: @">" forState:UIControlStateNormal];
        [_monthForwardButton addTarget: self
                                action: @selector(monthForward)
                      forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthForwardButton];
    }
    return _monthForwardButton;
}

- (UIView *) weekdayBar {
    if (!_weekdayBar) {
        _weekdayBar = [[[UIView alloc] init] autorelease];
        _weekdayBar.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0];
    }
    return _weekdayBar;
}

- (NSArray *) weekdayNameLabels {
    if (!_weekdayNameLabels) {
        NSMutableArray *labels = [NSMutableArray array];
        self.calendar.firstWeekday=2;
        for (NSUInteger i = self.calendar.firstWeekday; i < self.calendar.firstWeekday + 7; ++i) {
            NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);
            UILabel *label = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
            label.tag = i;
            [label cx_setTextAttributes:self.weekdayLabelTextAttributes];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [[_dateFormatter shortWeekdaySymbols] objectAtIndex: index];

            [labels addObject:label];
            [_weekdayBar addSubview: label];
        }

        [self addSubview:_weekdayBar];
        _weekdayNameLabels = [[NSArray alloc] initWithArray:labels];
    }
    return _weekdayNameLabels;
}

- (UIView *) gridView {
    if (!_gridView) {
        _gridView = [[[UIView alloc] init] autorelease];
        _gridView.backgroundColor = [UIColor clearColor];
        _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: _gridView];
    }
    return _gridView;
}

- (NSArray *) dayCells {
    if (!_dayCells) {
        NSMutableArray *cells = [NSMutableArray array];
        
         for (NSUInteger i = 1; i <= 31; ++i) {
            CXCalendarCellView *cell = [[CXCalendarCellView new] autorelease];
            cell.tag = i;
            cell.day = i;
           
                      [cell addTarget: self
                     action: @selector(touchedCellView:)
           forControlEvents: UIControlEventTouchUpInside];
           
             
                    cell.normalBackgroundColor = self.cellNormalBackgroundColor;
                    cell.selectedBackgroundColor = self.cellSelectedBackgroundColor;
             

            
            
    
          
//            cell.normalBackgroundColor = self.cellNormalBackgroundColor;
//            cell.selectedBackgroundColor = self.cellSelectedBackgroundColor;
           
            [cell cx_setTitleTextAttributes:self.cellLabelNormalTextAttributes forState:UIControlStateNormal];
            [cell cx_setTitleTextAttributes:self.cellLabelSelectedTextAttributes forState:UIControlStateSelected];

            [cells addObject:cell];
            [self.gridView addSubview: cell];
        }
        _dayCells = [[NSArray alloc] initWithArray:cells];
        
    }
    
    
    
    
    
    
    return _dayCells;
}

@end
