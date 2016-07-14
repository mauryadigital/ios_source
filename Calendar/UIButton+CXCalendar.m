//
//  UIButton+CXCalendar.m
//  Calendar
//
//  Created by Vladimir Grichina on 09.06.13.
//  Copyright (c) 2013 Componentix. All rights reserved.
//

#import "UIButton+CXCalendar.h"

@implementation UIButton (CXCalendar)

- (void)cx_setTitleTextAttributes:(NSDictionary *)attrs forState:(UIControlState)state
{
    if (attrs[NSFontAttributeName]) {
        self.titleLabel.font = attrs[NSFontAttributeName];
    }
    if (attrs[NSShadowAttributeName]) {
        self.titleLabel.shadowOffset = [attrs[NSShadowAttributeName] CGSizeValue];
    }
    if (attrs[NSForegroundColorAttributeName]) {
        [self setTitleColor:attrs[NSForegroundColorAttributeName] forState:state];
    }
    if (attrs[NSShadowAttributeName]) {
        [self setTitleShadowColor:attrs[NSShadowAttributeName] forState:state];
    }
}

@end
