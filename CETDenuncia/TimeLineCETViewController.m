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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.TimeLineCETWebView.delegate = self;
    
    //load html content into webview
    NSString *embedHTML = @"<html><head></head><body><a class=\"twitter-timeline\" href=\"https://twitter.com/CETSP_\" data-widget-id=\"514860431031017472\">Tweets de @CETSP_</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script></body></html>";
    
    [self.TimeLineCETWebView loadHTMLString:embedHTML baseURL:nil];
    [self.TimeLineCETWebView setDataDetectorTypes:UIDataDetectorTypeNone];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

/* Metodo do delegate UIWebView
   Bloqueia o acesso para links externos*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return !(navigationType == UIWebViewNavigationTypeLinkClicked);
}

@end
