//
//  MyTabBarViewController.m
//  LoLApp
//
//  Created by LT on 2015-08-29.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "NormalViewController.h"
#import "RankedViewController.h"


@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setBarTintColor:[UIColor colorWithRed:42.0/255.0 green:103.0/255.0 blue:100.0/255.0 alpha:1]];
    [self.tabBar setBarStyle:UIBarStyleBlack];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    
    self.playerID = [self.playerInfo objectForKey:@"id"];
    
    NormalViewController *nVc = [self.viewControllers objectAtIndex:0];
    RankedViewController *rVc = [self.viewControllers objectAtIndex:1];
    
    nVc.playerID = self.playerID;
    rVc.playerId = self.playerID;
    
    nVc.playerInfo = self.playerInfo;
    rVc.playerInfo = self.playerInfo;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//    
//}


@end
