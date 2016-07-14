//
//  AppDelegate.h
//  SampleCalendar
//
//  Created by kishore kumar nagalla on 11/04/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import <UIKit/UIKit.h>


#define FROM_TEAM 5
#define FROM_NONE -1


#define MANAGER_TAG 100
#define CONSULTANT_TAG 101


#define FROM_TENTRY 20
#define FROM_SAVED 21
#define FROM_SUBMITTED 22
#define FROM_REJECTED 23
#define FROM_TEAM_M 24
#define FROM_NONE -1


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *selectedDates;

@property(nonatomic)NSMutableDictionary *mainDict;
@property(nonatomic)NSMutableDictionary *submittedDict;
@property(nonatomic)NSMutableDictionary *savedDict;
@property(nonatomic)NSMutableDictionary *weeklyArray;

@property(nonatomic)NSString *selectedWeekText;
@property(nonatomic,assign)int isFromVC;
@property(nonatomic,assign)int userTag;

-(int)returnNumberHoursForDay:(NSString *)date;



@end

