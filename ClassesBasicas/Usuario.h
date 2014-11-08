//
//  Usuario.h
//  TwitterSDK
//
//  Created by VINICIUS RESENDE FIALHO on 26/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Usuario : NSObject <CLLocationManagerDelegate>

@property CLLocationCoordinate2D locUsuario;
@property NSString *nome;
@property NSString *localizacao;

+(Usuario*)sharedManager;
-(void)setaPosicaoUsuario:(CLLocationCoordinate2D)posUsuario;

@property CLLocationManager *locationManager;
-(void)atualizaLocalizacao;


@end
