//
//  DataBaseCoordenada.m
//  TwitterSDK
//
//  Created by VINICIUS RESENDE FIALHO on 26/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import "DataBaseCoordenada.h"

@implementation DataBaseCoordenada


+(DataBaseCoordenada*)sharedManager{
    static DataBaseCoordenada *unicoDataCoord = nil;
    if(!unicoDataCoord){
        unicoDataCoord = [[super allocWithZone:nil]init];
    }
    return unicoDataCoord;
}

-(id)init{
    self = [super init];
    if(self){
        self.listaCoordenadasOcorrencia = [[NSMutableArray alloc]init];
        self.listaCoordenadasLentidao = [[NSMutableArray alloc] init];
        self.listaCoordenadasLatLong= [[NSMutableArray alloc]init];
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}


-(NSArray*)allItems{
    return [self listaCoordenadasOcorrencia];
}


-(void)criaCoordenadaSiteCETOcorrencia:(CoordenadaCetSite *)coordenada{
    [[[DataBaseCoordenada sharedManager] listaCoordenadasOcorrencia] addObject: coordenada];
}

-(MKPointAnnotation*)marcarPosicaoNoMapaDiretoSiteCetOcorrencia:(CoordenadaCetSite*)CoordCet{
    
    MKPointAnnotation *ponto = [[MKPointAnnotation alloc] init];
    CLGeocoder* geocoder = [[CLGeocoder alloc]init];
    NSString *ruaNumero = [NSString stringWithFormat:@"%@",[CoordCet local]];
    
    NSString *s = [NSString stringWithFormat:@"%@%@%@",ruaNumero,@" ",@"São Paulo"];
    
    [geocoder geocodeAddressString:s completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark  *aPlacemark in placemarks) {
            
            
            CLLocationCoordinate2D localizacao;
            ponto.title = @"Ocorrência";
            ponto.subtitle = [CoordCet titulo];
            
            //Guarda a latitude e longitude para marcação no mapa
            NSString *latitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.longitude];
            localizacao.latitude = [latitude doubleValue];
            localizacao.longitude = [longitude doubleValue];
            
            CoodenadaLatitudeLongitude *cordll = [[CoodenadaLatitudeLongitude alloc]init];
            cordll.latitude = [latitude doubleValue];
            cordll.longitude = [longitude doubleValue];
            [[[DataBaseCoordenada sharedManager] listaCoordenadasLatLong]addObject:cordll];
            
            ponto.coordinate = localizacao;
        }
    }];
    
    return ponto;

}

@end




