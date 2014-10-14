//
//  ViewInicialViewController.m
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 03/10/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import "ViewInicialViewController.h"

@interface ViewInicialViewController ()
@end

@implementation ViewInicialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Animação de entrada com o logo do app
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 3.0;
    [self.view.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    //Puxa localização do usuário
    [self pedeLocalizacaoUsuario];
    
    //
    [self performSelector:@selector(chamaTabBarController) withObject:NULL afterDelay:3.0];
    
    
}

-(void)chamaAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CET"
                                                    message:@"O Aplicativo não pode ser iniciado sem internet!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)pedeLocalizacaoUsuario{
    
    //Localização
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [[Usuario sharedManager]setaPosicaoUsuario: self.locationManager.location.coordinate];
}

-(void)chamaTabBarController{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    //Verificca se há conexão com a internet
    if (networkStatus == NotReachable) {
        [self chamaAlertView];
        
    }else{
        
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocationCoordinate2D coord = [[Usuario sharedManager]locUsuario];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude  longitude:coord.longitude] ;
                
        [ceo reverseGeocodeLocation: loc completionHandler:
            ^(NSArray *placemarks, NSError *error) {
                     
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            [Usuario sharedManager].localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",placemark.name];
                     
            NSLog(@"f88orm = %@",[Usuario sharedManager].localizacao);
                
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialVisto"] == NO) {
                [self tutorialVisualizado];
                [self performSegueWithIdentifier:@"entraNoTutorial" sender: self];

            }else{
                [self performSegueWithIdentifier:@"entraNoApp" sender: self];
            }

        }];
        
        NSLog(@"f88orm = %@",[Usuario sharedManager].localizacao);
    }
    

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)tutorialVisualizado{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialVisto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
