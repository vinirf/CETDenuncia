//
//  DataBaseCoordenada.h
//  TwitterSDK
//
//  Created by VINICIUS RESENDE FIALHO on 26/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordenadaCetSite.h"
#import "CoordenadaCetSiteLentidao.h"
#import "CoodenadaLatitudeLongitude.h"
#import <MapKit/MapKit.h>

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface DataBaseCoordenada : NSObject

@property NSMutableArray *listaCoordenadasOcorrencia;
@property NSMutableArray *listaCoordenadasLentidao;

@property NSMutableArray *listaCoordenadasLatLong;

+(DataBaseCoordenada*)sharedManager;

//X,Y,TYPE,SPEED,DirType,Direction
-(NSMutableArray*)allItems;


//Ocorrencia e Lentidao
-(void)criaCoordenadaSiteCETOcorrencia:(CoordenadaCetSite *)coord;
-(MKPointAnnotation*)marcarPosicaoNoMapaDiretoSiteCetOcorrencia:(CoordenadaCetSite*)CoordCet;

-(void)criaCoordenadaSiteCETLentidao:(CoordenadaCetSiteLentidao *)coord;
-(MKPointAnnotation*)marcarPosicaoNoMapaDiretoSiteCetLentidao:(CoordenadaCetSiteLentidao*)CoordCet;
    
@end
