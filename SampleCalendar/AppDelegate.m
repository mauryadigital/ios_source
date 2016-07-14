//
//  AppDelegate.m
//  SampleCalendar
//
//  Created by kishore kumar nagalla on 11/04/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window.backgroundColor = [UIColor whiteColor];
    _userTag = MANAGER_TAG;
    _selectedDates = [[NSMutableArray alloc]init];
    _mainDict = [[NSMutableDictionary alloc ]init];
    
    _submittedDict = [[NSMutableDictionary alloc]init];
    _savedDict = [[NSMutableDictionary alloc]init];
    _weeklyArray = [[NSMutableDictionary alloc]init];
    
    [self numberOfDaysForMonth];

    return YES;
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

-(NSInteger)numberOfDaysForMonth{
    
    NSDate *currentStartDate;
    NSDate *nextStartDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components= [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    [components setDay:1];
    currentStartDate = [calendar dateFromComponents:components];
    NSLog(@"currentStartDate: %@",currentStartDate);
    [components setMonth:components.month+1];

    nextStartDate = [calendar dateFromComponents:components];
    NSLog(@"nextStartDate: %@",nextStartDate);

    NSDateComponents *diffComponents = [calendar components:NSCalendarUnitDay fromDate:currentStartDate toDate:nextStartDate options:0];
    
    NSLog(@"diffComponents.day: %ld",(long)diffComponents.day);
    return diffComponents.day;
}


-(int)returnNumberHoursForDay:(NSString *)date {
    
    NSArray *array = [_mainDict valueForKey:date];
    NSArray *hours = [array valueForKey:@"hours"];
    
    return 10;
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
