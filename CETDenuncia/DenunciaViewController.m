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
    
    //Localização
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //Arredonda botões
    [[self.outBtoDenunciar layer] setCornerRadius: 5];
    [[self.outBtoImagem layer] setCornerRadius: 5];

    //[Usuario sharedManager].locUsuario = self.locationManager.location.coordinate;
    
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self pegarLocalizacaoDoUsuario];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

///////////////////////////////////////////////////////////////////////////


- (void)pegarLocalizacaoDoUsuario{
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocationCoordinate2D coord = [[Usuario sharedManager]locUsuario];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude  longitude:coord.longitude] ;
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         self.localizacao = [NSString stringWithFormat:@"%@%@%@",placemark.subLocality,@", ",placemark.name];
     }];
    
}


- (IBAction)buttonTwetar:(id)sender {
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Tweeting from CETDenuncia"];
        [tweetSheet addImage:self.imageView.image];
        
        NSString *endereco = [NSString stringWithFormat:@"%@%@%@%@",self.nomeTwitter,@" ",self.localizacao,@", "];
        [tweetSheet setInitialText:endereco];

        [self presentViewController: tweetSheet animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Descuple"
                                  message:@"Você não pode enviar um tweet agora, verifique se seu dispositivo está conectado à internet e se você tem pelo menos uma conta do Twitter configurada."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}



- (IBAction)takePhoto:(UIButton *)sender {
    
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
