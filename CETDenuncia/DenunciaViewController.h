//
//  ViewController.h
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 19/09/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Usuario.h"

@interface DenunciaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>


@property NSString *nomeTwitter;
@property  NSString *imageString;
@property  NSString *localizacao;
@property MKMapView *mapa;
@property CLLocationManager *locationManager;


@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *outBtoDenunciar;
@property (weak, nonatomic) IBOutlet UIButton *outBtoImagem;


@end
