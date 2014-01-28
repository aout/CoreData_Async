//
//  Book.m
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 28/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "Book.h"
#import "Page.h"


@implementation Book

@dynamic title;
@dynamic domain;
@dynamic pages;
@dynamic bookshelf;

- (void) configure
{
    sleep(1);
    int len = 40;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    [self setTitle:randomString];
}

@end
