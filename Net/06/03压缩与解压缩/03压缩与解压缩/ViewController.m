//
//  ViewController.m
//  03压缩与解压缩
//
//  Created by mazaiting on 18/1/9.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "SSZipArchive/SSZipArchive.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SSZipArchive createZipFileAtPath:@"/Users/mazaiting/Desktop/tomcat1.zip" withContentsOfDirectory:@"/Users/mazaiting/Desktop/tomcat"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *str = @"/Users/mazaiting/Desktop/tomcat.zip";
    
    [SSZipArchive unzipFileAtPath:str toDestination:@"/Users/mazaiting/Desktop/tomcat"];
}

@end
