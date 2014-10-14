//
//  TutorialViewController.m
//  Corneta SP
//
//  Created by EMERSON DE SOUZA BARROS on 14/10/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()
@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Títulos e imagens
    self.pageTitles = @[@"Fotografe e denuncie uma irregularidade diretamente para a CET no Twitter.", @"Acompanhe em tempo real o Twitter da CET.", @"Com esse mapa, fique ligado nas ocorrências próximas à você."];
    self.pageImages = @[@"Tela-Denuncia.png", @"Tela-OlhoVivo.png", @"Tela-Localizaçao.png"];
    
    //Cria o ViewController associado ao story board
    self.tutorialViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"PageViewController"];
    self.tutorialViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex: 0];
    NSArray *viewControllers = @[startingViewController];
    [self.tutorialViewController setViewControllers:viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //Diminui o tamanho do Tutorial viewcontroller
    self.tutorialViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController: self.tutorialViewController];
    [self.view addSubview: self.tutorialViewController.view];
    [self.tutorialViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    if ([_tutorialViewController.viewControllers.lastObject isEqual: pageContentViewController]) {
        self.botaoComecar.hidden = NO;
    }else{
        self.botaoComecar.hidden = YES;
    }
    
    
    
    
    
    return pageContentViewController;
}






#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex: index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex: index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}


@end
