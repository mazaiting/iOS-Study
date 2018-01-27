//
//  Client+CoreDataProperties.h
//  Mac服务器
//
//  Created by mazaiting on 18/1/27.
//  Copyright © 2018年 mazaiting. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Client.h"

NS_ASSUME_NONNULL_BEGIN

@interface Client (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *portNumber;
@property (nullable, nonatomic, retain) NSString *ipAddress;
@property (nullable, nonatomic, retain) NSDate *connectTime;

@end

NS_ASSUME_NONNULL_END
