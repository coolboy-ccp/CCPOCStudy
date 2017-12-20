//
//  ViewController.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/11/17.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "ViewController.h"
#import "SubLoadInitialize.h"
#import "SubLoadInitialize2.h"
#import "CopyStrong.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SubLoadInitialize new];
    [SubLoadInitialize2 new];
    CopyStrong *cs = [CopyStrong new];
   // abort();
    [cs testCopyStrong];
    
}


@end
