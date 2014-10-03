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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 3.0;
    [self.view.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    [self pedeLocalizacaoUsuario];
    

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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
    }
    
}

-(void)pedeLocalizacaoUsuario{
    //Localização
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [[Usuario sharedManager]setaPosicaoUsuario:self.locationManager.location.coordinate];
    
    
    

}

-(void)chamaTabBarController{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        [self chamaAlertView];
        
    } else {
                CLGeocoder *ceo = [[CLGeocoder alloc]init];
                CLLocationCoordinate2D coord = [[Usuario sharedManager]locUsuario];
                CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude  longitude:coord.longitude] ;
                
                [ceo reverseGeocodeLocation: loc completionHandler:
                 ^(NSArray *placemarks, NSError *error) {
                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                     //NSLog(@"placemark %@",placemark);
                     //String to hold address
                     //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                     //NSLog(@"addressDictionary %@", placemark.addressDictionary);
                     //         NSLog(@"Cidade %@",placemark.locality); // Extract the city name
                     //         NSLog(@"Rua %@",placemark.name);
                     //         NSLog(@"Bairro %@",placemark.subLocality);
                     //NSLog(@"location %@",placemark.location);
                     
                     [Usuario sharedManager].localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",placemark.name];
                     
                     NSLog(@"f88orm = %@",[Usuario sharedManager].localizacao);
                     
                     [self performSegueWithIdentifier:@"chamaApp" sender: self];
                 }];
                NSLog(@"f88orm = %@",[Usuario sharedManager].localizacao);

        
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
