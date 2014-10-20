//
//  AppDelegate.m
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 19/09/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //Cor da Tabbar
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    //Cores da view de tutorial
    [UIPageControl appearance].pageIndicatorTintColor = [UIColor lightGrayColor];
    [UIPageControl appearance].currentPageIndicatorTintColor = [UIColor blackColor];
    [UIPageControl appearance].backgroundColor = [UIColor whiteColor];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
}

- (void)applicationWillTerminate:(UIApplication *)application{
}

@end
