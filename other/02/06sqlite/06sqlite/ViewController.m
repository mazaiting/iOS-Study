//
//  ViewController.m
//  06sqlite
//
//  Created by mazaiting on 18/1/25.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "ViewController.h"
#import "SqliteManager.h"

@interface ViewController ()
@property (nonatomic, strong) SqliteManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [SqliteManager new];
}
- (IBAction)createDb {
    [_manager createDb];
}
- (IBAction)createTable {
    [_manager createTable];
}
- (IBAction)insertData {
    [_manager insertData];
}
- (IBAction)queryData {
    [_manager queryData];
}
- (IBAction)updateData {
    [_manager updateData];
}
- (IBAction)deleteData {
    [_manager deleteData];
}
- (IBAction)closeDb {
    [_manager closeDb];
}

@end
