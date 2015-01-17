//
//  SelectionContext.m
//  RSSReader
//
//  Created by Михаил Куренков on 17.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "SelectionContext.h"

@implementation SelectionContext

static SelectionContext * context = nil;

+ (SelectionContext *) Instance{
    
    if (!context)
    {
        context = [[super allocWithZone:NULL] init];
    }
    
    return context;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self Instance];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

@end
