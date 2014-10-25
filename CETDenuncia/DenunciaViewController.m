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
    
    //Arredonda bordas
    [[self.viewInformativo layer] setCornerRadius: 10];
    [[self.imgBackTirarFoto layer] setCornerRadius: 10];
    
    //Configura sombra e cor da view de rotas
    self.viewInformativo.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.viewInformativo.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.viewInformativo.layer.shadowRadius = 3.0f;
    self.viewInformativo.layer.shadowOpacity = 1.0f;
    
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
    
    [[Usuario sharedManager]setaPosicaoUsuario: self.locationManager.location.coordinate];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocationCoordinate2D coord = [[Usuario sharedManager]locUsuario];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude  longitude:coord.longitude] ;
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //Corta o número da rua
         NSArray *string = [placemark.name componentsSeparatedByString:@","];
         
         //Seta localizacao do Usuario (Cidade,Rua)
         [Usuario sharedManager].localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",string.firstObject];
         
         
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
             [tweetSheet setInitialText: endereco];
             
             NSLog(@"texto = %@",endereco);
             NSLog(@"usuario = %@",[Usuario sharedManager].localizacao);
             
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

///////////////////////////TIRA FOTO //////////////////////////////////


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


- (IBAction)btoInformativo:(id)sender {
    
    
    if (self.viewInformativo.hidden) {
        self.viewInformativo.hidden = NO;
        
        self.imageView.alpha = 0.3;
        self.imgBackground.alpha = 0.3;
        self.imgBackTirarFoto.alpha = 0.3;
        self.outBtoDenunciar.alpha = 0.3;
    }else{
        self.viewInformativo.hidden = YES;
        
        self.imageView.alpha = 1;
        self.imgBackground.alpha = 1;
        self.imgBackTirarFoto.alpha = 1;
        self.outBtoDenunciar.alpha = 1;
    }
    
}

@end
