//
//  CXCalendarCellView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarCellView.h"

@implementation CXCalendarCellView

- (void) setDay: (NSUInteger) day {
    if (_day != day) {
        _day = day;
        [self setTitle: [NSString stringWithFormat: @"%lu", (unsigned long)_day] forState: UIControlStateNormal];
        //NSLog(@"MY DAY %lu",(unsigned long)_day);
    }
}

- (NSDate *) dateWithBaseDate: (NSDate *) baseDate withCalendar: (NSCalendar *)calendar {
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                               fromDate:baseDate];
    components.day = self.day;
    NSLog(@"Component day %ld",(long)components.day);
    return [calendar dateFromComponents:components];
    
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if (selected) {
        self.backgroundColor = self.selectedBackgroundColor;
        
    } else {
        self.backgroundColor = self.normalBackgroundColor;
    }
}

@end
