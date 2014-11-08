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

//Mostra view com icones de sem conexão
-(void)semConexaoComInternet{
    self.iconeSemConexao.hidden = NO;
    self.labelSemConexao.hidden = NO;
}

//Solicita e guarda coordenada
-(void)pedeLocalizacaoUsuario{
    
 
}

-(void)chamaTabBarController{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    //Verifica se há conexão com a internet
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
