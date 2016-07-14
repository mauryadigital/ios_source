//
//  AppDelegate.m
//  LeaveManagement
//
//  Created by User on 5/12/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize objNavigationController;
@synthesize objViewController;
@synthesize accessTokenString;
@synthesize monthNumber;
@synthesize isManagerLogin;
@synthesize isHistory;
@synthesize leavesDictionary;

//  @synthesize holidayDatesArray;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
//    UIImageView *imgview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
//    imgview.frame=self.window.frame;
//    [self.window setBackgroundColor:[UIColor colorWithPatternImage:imgview.image]];
    NSLog(@"System Version is %@",[[UIDevice currentDevice] systemVersion]);
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            
            objViewController=[[ViewController alloc]initWithNibName:@"ViewController_4s" bundle:nil];
        }
        
        
       else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            
            objViewController=[[ViewController alloc]initWithNibName:@"ViewController_5s" bundle:nil];
        }
        else if ([[UIScreen mainScreen] bounds].size.height >= 667)
        {
            
            objViewController=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
        }
    }
    
    else
    {
        //[ipad]
    }
    
   
    
    
    
    
    
    
    
    
    objNavigationController=[[UINavigationController alloc]initWithRootViewController:objViewController];
    //set bar color
    [objNavigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [objNavigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [objNavigationController.navigationItem setTitle:@"Leave Management System"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"Helvetica Neue" size:20], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    accessTokenString=[[NSString alloc]init];

    
    
    
    //set back button arrow color
    [objNavigationController.navigationBar setTintColor:[UIColor whiteColor]];
       self.window.rootViewController=objNavigationController;
    [self.window makeKeyAndVisible];
    return YES;    return YES;
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
