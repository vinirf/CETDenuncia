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

@property UIPageViewController *tutorialViewController;
@property NSArray *pageTitles;
@property NSArray *pageImages;

@property (weak, nonatomic) IBOutlet UIButton *botaoComecar;

//PAGES
-(PageContentViewController *)viewControllerAtIndex:(NSUInteger)index;
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController;
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController;

@end
