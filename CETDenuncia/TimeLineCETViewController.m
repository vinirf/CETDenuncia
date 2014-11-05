//
//  TimeLineCETViewController.m
//  CETDenuncia
//
//  Created by VINICIUS RESENDE FIALHO on 19/09/14.
//  Copyright (c) 2014 Vinicius Resende | Emerson Barros. All rights reserved.
//

#import "TimeLineCETViewController.h"

@interface TimeLineCETViewController()
@end

@implementation TimeLineCETViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    //Delegate da Web view
    self.TimeLineCETWebView.delegate = self;
    
    self.pararRepeticaoProtocolo = YES;
    [self carregaComponentesIniciaisTwiter];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//Sobrepõe a barra de status
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)carregaComponentesIniciaisTwiter{
    
    //Carrega o conteúdo do html no webview
    NSString *embedHTML = @"<html><head></head><body><a class=\"twitter-timeline\" href=\"https://twitter.com/CETSP_\" data-widget-id=\"519942987082502144\">Tweets de @CETSP_</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script></body></html>";
    
    //Delegate
    [self.TimeLineCETWebView loadHTMLString: embedHTML baseURL: nil];
    [self.TimeLineCETWebView setDataDetectorTypes: UIDataDetectorTypeNone];
}


//BLOCK DE LINKS EXTERNOS
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(self.pararRepeticaoProtocolo){
        self.pararRepeticaoProtocolo = NO;
        self.viewCarregamento.hidden = NO;
        [self.iconeCarregamento startAnimating];
    }
    
    return !(navigationType == UIWebViewNavigationTypeLinkClicked);
}

-(void)desapareceTelaCarregamento{
    self.viewCarregamento.hidden = YES;
    [self.iconeCarregamento stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.pararRepeticaoProtocolo = YES;
    [self performSelector:@selector(desapareceTelaCarregamento) withObject:NULL afterDelay:4.0];
}

//Recarrega a timeline da CET
- (IBAction)btnVoltarPerfil:(id)sender {
    self.pararRepeticaoProtocolo = YES;
    [self carregaComponentesIniciaisTwiter];
}

@end
