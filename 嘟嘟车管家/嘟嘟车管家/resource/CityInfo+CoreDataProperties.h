//
//  CityInfo+CoreDataProperties.h
//  嘟嘟车管家
//
//  Created by joinus on 15/11/18.
//  Copyright © 2015年 soulnear. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CityInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ename;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *listname;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
