//
//  HomeVC.m
//  TimeSheet
//
//  Created by kishore kumar nagalla on 03/05/16.
//  Copyright © 2016 kishore kumar nagalla. All rights reserved.
//

#import "HomeVC.h"
#import "DateTVC.h"
#import "TeamVC.h"
#import "AppDelegate.h"

#import "AFNetworking.h"

@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *dashBoardArray;
}


//
//8498072000

@end

@implementation HomeVC

- (void)viewDidLoad {
    self.title = @"TMS";
    self.navigationController.navigationBarHidden = NO;   

    dashBoardArray = [NSArray arrayWithObjects:@"TimeSheet Entry",@"Saved",@"Submitted",@"Rejected",@"Team", nil];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    imageView.image = [UIImage imageNamed:@"bgImage"];
    [self.view addSubview:imageView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 45, 10, 45);
    
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
    userName.text = [NSString stringWithFormat:@"   Username: %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    [self.view addSubview:userName];
    
    UILabel *userRole = [[UILabel alloc]initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, 30)];
    NSString* role = [[NSUserDefaults standardUserDefaults]valueForKey:@"ROLE"];
    userRole.text = [NSString stringWithFormat:@"   User Role: %@",role];

    
   
    [self.view addSubview:userRole];
    
    UICollectionView *collectionView =  [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.frame = CGRectMake(0, 124, self.view.frame.size.width, self.view.frame.size.height-124);
        collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerNib:[UINib nibWithNibName:@"HomeCCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    
    self.navigationItem.hidesBackButton = YES;
    
    
    UIBarButtonItem *logoutButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonAction)];
    
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    //AppDelegate *appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
}

-(void)logoutButtonAction{
    
    
    UIActivityIndicatorView *  activityindicator= [[UIActivityIndicatorView alloc]init];
    activityindicator.layer.cornerRadius =6;
    activityindicator.backgroundColor = [UIColor colorWithRed:229/255.0 green:47/255.0 blue:24/255.0 alpha:1];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityindicator.frame=CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-60)/2-64, 100, 60);
    [self.view addSubview:activityindicator];
    [activityindicator startAnimating];
    NSURLSessionConfiguration *configaration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configaration];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://173.15.43.75:418/tms/rest/logout?access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]];
    
 NSURLSessionDataTask *dataTask =   [manager dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
     
     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
     
        NSLog(@"%@",responseObject);
        if (httpResponse.statusCode == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"" message:@"Server not respond" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];

        }
     
     [activityindicator removeFromSuperview];
    }];
    
    [dataTask resume];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSString* role = [[NSUserDefaults standardUserDefaults]valueForKey:@"ROLE"];
    
    if ([role isEqualToString:@"ROLE_CONSULTANT"]) {
        
        return 4;
    }
    return 5;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *imageArray = [NSArray arrayWithObjects:@"round_add",@"round_save",@"round_submit",@"round_reject",@"team", nil];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    label.text = [dashBoardArray objectAtIndex:indexPath.row];
    
   
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:2];

    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    return cell;
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width/2 -60, self.view.frame.size.width/2 -60);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.isFromVC = FROM_NONE;

    if (indexPath.row == 0) {
        
        DateTVC *dataTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DATE_TVC"];
        
        dataTVC.dashItemType = FROM_TENTRY;

        [self.navigationController pushViewController:dataTVC animated:true];

        
       
     
    }else if (indexPath.row == 1) {
        DateTVC *dataTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DATE_TVC"];
        
        dataTVC.dashItemType = FROM_SAVED;
     
     
        [self.navigationController pushViewController:dataTVC animated:true];

    }else if (indexPath.row == 2) {
        DateTVC *dataTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DATE_TVC"];
        
        dataTVC.dashItemType = FROM_SUBMITTED;

     
        [self.navigationController pushViewController:dataTVC animated:true];
    }else if(indexPath.row == 3) {
        DateTVC *dataTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DATE_TVC"];
        
        dataTVC.dashItemType = FROM_REJECTED;

        
        [self.navigationController pushViewController:dataTVC animated:true];
    }else{
        TeamVC *teamVC = (TeamVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TeamVC"];
        appDelegate.isFromVC = FROM_TEAM;
        //   dateTVC.dateArray = selectedDates;
        [teamVC.tableView reloadData];
        [self.navigationController pushViewController:teamVC animated:YES];
        
    }
          
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
