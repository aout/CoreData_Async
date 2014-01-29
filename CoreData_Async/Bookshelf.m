//
//  Bookshelf.m
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 28/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "Bookshelf.h"
#import "Book.h"


@implementation Bookshelf

@dynamic domain;
@dynamic books;

- (void) configure
{
    int len = 3;
    NSString *letters = @"ab";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    [self setDomain:randomString];
}

@end
