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

@interface ViewController ()

//
@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SubLoadInitialize new];
    [SubLoadInitialize2 new];    
}


@end
