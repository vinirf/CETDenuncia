//
//  ViewInicialViewController.m
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 03/10/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import "ViewInicialViewController.h"

#define IS_IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewInicialViewController ()
@end

@implementation ViewInicialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Animação de entrada com o logo do app
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 2.0;
    [self.view.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    //Solicita e guarda coordenadas do usuário
    [self pedeLocalizacaoUsuario];
    
    //Guarda o local (rua, cidade .. etc) e chama o tutorial ou tela de denuncia
    [self performSelector:@selector(chamaTabBarController) withObject:NULL afterDelay:0.0];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//Mostra view com icones de sem conexão
-(void)semConexaoComInternet{
    self.iconeSemConexao.hidden = NO;
    self.labelSemConexao.hidden = NO;
}

//Solicita e guarda coordenada
-(void)pedeLocalizacaoUsuario{
    
    //Localização
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    //Se for uma versão igual o maior do iOS8 requer autorização especial
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [[Usuario sharedManager]setaPosicaoUsuario: self.locationManager.location.coordinate];
}

-(void)chamaTabBarController{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    //Verificca se há conexão com a internet
    if (networkStatus == NotReachable) {
        [self semConexaoComInternet];
    
    }else{
        
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocationCoordinate2D coord = [[Usuario sharedManager]locUsuario];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude  longitude:coord.longitude] ;
                
        [ceo reverseGeocodeLocation: loc completionHandler:
            ^(NSArray *placemarks, NSError *error) {
                     
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            [Usuario sharedManager].localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",placemark.name];
                     
            NSLog(@"view inicial = %@",[Usuario sharedManager].localizacao);
            
                
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialVisto"] == NO) {
                [self tutorialVisualizado];
                [self performSegueWithIdentifier:@"entraNoTutorial" sender: self];

            }else{
                [self performSegueWithIdentifier:@"entraNoApp" sender: self];
            }

        }];
        
    }

}

//Salva que o tutorial já foi vizualizado
-(void)tutorialVisualizado{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialVisto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
