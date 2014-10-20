//
//  ViewController.m
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 19/09/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import "DenunciaViewController.h"

@interface DenunciaViewController ()
@end

@implementation DenunciaViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    //Conta CET
    self.nomeTwitter = @"@CETSP_";
    
    //Gesture para adicionar foto no tweet
    self.tapAddFoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tirarFoto)];
    self.tapAddFoto .numberOfTouchesRequired = 1;
    self.tapAddFoto .enabled = YES;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer: self.tapAddFoto];
    
    //Arredonda background da imagem da foto
    [[self.imgBackTirarFoto layer] setCornerRadius: 10];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
}



////////////////////////////////////////////////////////////////////////////////////// TWETAR //////////////////////////////////////////////////////////////////////////////////////


- (IBAction)buttonTwetar:(id)sender{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [[Usuario sharedManager]setaPosicaoUsuario:self.locationManager.location.coordinate];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocationCoordinate2D coord = [[Usuario sharedManager]locUsuario];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude  longitude:coord.longitude] ;
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//         NSLog(@"placemark %@", placemark);
//
//         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//         NSLog(@"addressDictionary %@", placemark.addressDictionary);
//         NSLog(@"Cidade %@",placemark.locality);
//         NSLog(@"Rua %@",placemark.name);
//         NSLog(@"Bairro %@",placemark.subLocality);
//         NSLog(@"location %@",placemark.location);
         
         [Usuario sharedManager].localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",placemark.name];
         
         
         //Só permite o tweet se o usuário estiver em SP
         if (![placemark.locality isEqualToString:@"São Paulo"]) {
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Local inválido"
                                       message:@"Você não pode enviar um tweet para a CETSP fora da cidade de São Paulo, ou não permitiu acesso a localização."
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
             return;
         }
         
         
         if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter]){
             
             SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
             [tweetSheet setInitialText:@"Tweeting from CETDenuncia"];
             [tweetSheet addImage:self.imageView.image];
             
             
             NSString *endereco = [NSString stringWithFormat:@"%@%@%@%@",self.nomeTwitter,@" ",[Usuario sharedManager].localizacao,@", "];
             [tweetSheet setInitialText:endereco];
             
             [self presentViewController: tweetSheet animated:YES completion:nil];
             
         }
         else{
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Desculpe"
                                       message:@"Você não pode enviar um tweet agora, verifique se seu dispositivo está conectado à internet e se você tem pelo menos uma conta do Twitter configurada."
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
         }

     }];
    
}



////////////////////////////////////////////////////////////////////////////////////// TIRAR FOTO //////////////////////////////////////////////////////////////////////////////////////


-(void)tirarFoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    [self presentViewController: imagePicker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageView setImage:self.imageView.image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
