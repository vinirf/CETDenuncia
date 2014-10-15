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
    
    //Gesture para adicionar foto
    self.tapAddFoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tirarFoto)];
    
    self.tapAddFoto .numberOfTouchesRequired = 1;
    self.tapAddFoto .enabled = YES;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer: self.tapAddFoto];
    
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


///////////////////////////////////////////////////////////////////////////


- (void)locatilizaUsuario{
    
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
         
     }];
    
}


- (IBAction)buttonTwetar:(id)sender {
    
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
         //NSLog(@"placemark %@",placemark);
         //String to hold address
         //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         //NSLog(@"addressDictionary %@", placemark.addressDictionary);
         //         NSLog(@"Cidade %@",placemark.locality); // Extract the city name
         //         NSLog(@"Rua %@",placemark.name);
         //         NSLog(@"Bairro %@",placemark.subLocality);
         //NSLog(@"location %@",placemark.location);
         
         [Usuario sharedManager].localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",placemark.name];
         
         
         NSLog(@"Cidade do usuário %@", placemark.locality);
         if (![placemark.locality isEqualToString:@"São Paulo"]) {
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Local inválido"
                                       message:@"Você não pode enviar um tweet para a CETSP fora da cidade de São Paulo!"
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




-(void)tirarFoto{
    NSLog(@"Entrou pra tirar foto!");
    
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
    
    // UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


//-(void)pegarDadosTransitoCET{
//    
//    NSString* url = @"http://www.cetsp.com.br/";
//    NSURL* query = [NSURL URLWithString:url];
//    NSString* result = [NSString stringWithContentsOfURL:query encoding:NSUTF8StringEncoding error:nil];
//    
//    
//    NSString *string=result;
//    NSRange searchFromRange = [string rangeOfString:@"<body>"];
//    NSRange searchToRange = [string rangeOfString:@"</body>"];
//    NSString *substring = [string substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)];
//    
//    NSString *stringFinal = substring;
//    
//    NSRange continua =[stringFinal rangeOfString:@"<div class=\"boxZona"];
//    int i=0;
//    
//    while(continua.location != NSNotFound){
//        i +=1;
//        
//        stringFinal = [stringFinal substringFromIndex:continua.location];
//        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<h4>"].location+4];
//        NSString *vra = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</h4>"].location-2];
//        
//        switch (i) {
//            case 1:
//                self.label1.text = vra;
//                break;
//            case 2:
//                self.label2.text = vra;
//                break;
//            case 3:
//                self.label3.text = vra;
//                break;
//            case 4:
//                self.label4.text = vra;
//                break;
//            case 5:
//                self.label5.text = vra;
//                break;
//                
//            default:
//                break;
//        }
//        
//        continua = [stringFinal rangeOfString:@"<div class=\"boxZona"];
//        
//        
//        
//    }
//    
//    continua = [stringFinal rangeOfString:@"<div class=\"boxZona"];
//}



@end
