//
//  HRPoliciesViewController.m
//  LeaveManagement
//
//  Created by User on 6/22/16.
//  Copyright © 2016 Pyramid. All rights reserved.
//

#import "HRPoliciesViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"
@interface HRPoliciesViewController ()

@end

@implementation HRPoliciesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"policies" ofType:@"pdf"];
//    NSURL *targetURL = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
//webView.scalesPageToFit=YES;
//    [webView loadRequest:request];
//    
//    [self.view addSubview:webView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    imageView.image=[UIImage imageNamed:@"HRPlc.png"];
    [self.view addSubview:imageView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationItem.hidesBackButton=TRUE;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"arrow-left_red.png"];
    [btn setImage:btnImg forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn] ;
    UIButton *logutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg1 = [UIImage imageNamed:@"logout.jpeg"];
    [logutbtn setImage:btnImg1 forState:UIControlStateNormal];
    
    logutbtn.frame = CGRectMake(0, 0, btnImg1.size.width, btnImg1.size.height);
    [logutbtn addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logutbtn] ;
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    [super viewWillAppear:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //set bar color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:203.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];
    //set title and title color
    [self.navigationItem setTitle:@"HR Leave Policies"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)goBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) requestFinished: (ASIHTTPRequest *) request {
    
    
    NSString *theJSON = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary* jsonDictionary = [parser objectWithString:theJSON error:nil];
    NSLog(@"Dictionary %@",jsonDictionary);
    NSString *str=[NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"response"]];
    NSLog(@"str %@",str);
    if([str isEqualToString:@"SUCCESS"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
}

-(void)logoutButtonAction:(id)sender{
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://173.15.43.75:418/lms/rest/logout?access_token=%@",appDelegate.accessTokenString];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.tag=111;
    
    
    // [request setPostValue:userNameField.text forKey:@"your_key"];
    
    [request startAsynchronous];
    
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
