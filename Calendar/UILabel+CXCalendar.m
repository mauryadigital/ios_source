//
//  UILabel+CXCalendar.m
//  Calendar
//
//  Created by Vladimir Grichina on 09.06.13.
//  Copyright (c) 2013 Componentix. All rights reserved.
//

#import "UILabel+CXCalendar.h"

@implementation UILabel (CXCalendar)

- (void)cx_setTextAttributes:(NSDictionary *)attrs
{
    if (attrs[NSFontAttributeName]) {
        self.font = attrs[NSFontAttributeName];
    }
    if (attrs[NSForegroundColorAttributeName]) {
        self.textColor = attrs[NSForegroundColorAttributeName];
    }
//    if (attrs[NSShadowAttributeName]) {
//        self.shadowColor = attrs[NSShadowAttributeName];
//    }
//    if (attrs[NSShadowAttributeName]) {
//        self.shadowOffset = [attrs[NSShadowAttributeName] CGSizeValue];
//    }
}

@end
