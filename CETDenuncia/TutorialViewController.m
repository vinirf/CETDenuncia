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

-(void)localizar{
    
    //Localização
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //Se for uma versão igual o maior do iOS8 requer autorização especial
    //    if(IS_IOS8_OR_LATER) {
    //       [self.locationManager requestAlwaysAuthorization];
    //    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [[Usuario sharedManager]setaPosicaoUsuario: self.locationManager.location.coordinate];
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocationCoordinate2D coord = [[Usuario sharedManager]locUsuario];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude  longitude:coord.longitude] ;
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         [Usuario sharedManager].localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",placemark.name];
         
         NSLog(@"view tuto = %@",[Usuario sharedManager].localizacao);

         
     }];

    
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    //Arredonda background da imagem da foto
    [[self.botaoComecar layer] setCornerRadius: 10];
    
    //Títulos e imagens
    self.pageTitles = @[@"Fotografe e denuncie uma irregularidade diretamente para a CET no Twitter.", @"No tweet sua localização é incorporada automaticamente, e você pode enviar uma imagem da ocorrência.", @"Acompanhe em tempo real o Twitter da CET.", @"Com o mapa, fique ligado nas ocorrências próximas à você."];
    self.pageImages = @[@"Tela-Denuncia.png", @"Tela-Tweetando.png", @"Tela-OlhoVivo.png", @"Tela-Localizacao.png"];
    
    //Cria o ViewController associado ao story board
    self.tutorialViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"PageViewController"];
    self.tutorialViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex: 0];
    NSArray *viewControllers = @[startingViewController];
    [self.tutorialViewController setViewControllers:viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //Diminui o tamanho do Tutorial viewcontroller
    self.tutorialViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    
    [self addChildViewController: self.tutorialViewController];
    [self.view addSubview: self.tutorialViewController.view];
    [self.tutorialViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(PageContentViewController *)viewControllerAtIndex:(NSUInteger)index{
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    

    return pageContentViewController;
}



#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    if(index == 3)
        self.botaoComecar.hidden = NO;
    else
        self.botaoComecar.hidden = YES;

    
    return [self viewControllerAtIndex: index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    
    //Quando estiver na 3a página mostra o botão
    if(index == 3){
        [self localizar];
        self.botaoComecar.hidden = NO;
    }else{
        self.botaoComecar.hidden = YES;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex: index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.pageTitles count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}


@end
