//
//  TutorialViewController.h
//  Corneta SP
//
//  Created by EMERSON DE SOUZA BARROS on 14/10/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface TutorialViewController : UIViewController <UIPageViewControllerDataSource>

@property UIPageViewController *pageViewController;
@property NSArray *pageTitles;
@property NSArray *pageImages;

@end
