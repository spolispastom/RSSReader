//
//  RSSDownloader.m
//  RSSReader
//
//  Created by Михаил Куренков on 19.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "RSSParser.h"

@implementation RSSParser

NSDateFormatter * rssDateFormatter;
NSXMLParser * parser;

NSString * currentPropertyName;
NSMutableString * currentValue;

NSString * title;
NSDate * creationDate ;
NSString * content;
NSString * linkString;

BOOL isParseItem = NO;

NSMutableArray * newsList;

- (BOOL) parse
{
    rssDateFormatter = [[NSDateFormatter alloc] init];
    [rssDateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss Z:"];
    
    if (_data && _delegate)
    {
        parser = [[NSXMLParser alloc] initWithData: _data];
        [parser setDelegate: self];
        [parser setShouldResolveExternalEntities:YES];
    
        return [parser parse];
    }
    else return NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName  isEqual: @"channel"])
    {
        newsList = [[NSMutableArray alloc] init];
    }
    else if ([elementName  isEqual: @"item"])
    {
        title = @"";
        content = @"";
        currentPropertyName = @"";
        currentValue = [[NSMutableString alloc] init];
        
        title = nil;
        creationDate = nil;
        content = nil;
        linkString = nil;
        
        isParseItem = YES;
    }
    else currentPropertyName = elementName;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(currentValue)
    {
        if ([currentPropertyName  isEqual: currentPropertyName] && [currentPropertyName length] > 1 && [string length] > 0)
        {
            if (currentValue.length > 0)
                [currentValue appendString: string];
            else
            {
                [currentValue appendString: string];
                while (currentValue.length > 0 &&
                       ([currentValue characterAtIndex:0] == '\n' ||
                        [currentValue characterAtIndex:0] == '\t' ||
                        [currentValue characterAtIndex:0] == ' '))
                {
                    [currentValue deleteCharactersInRange: NSMakeRange(0, 1)];
                }
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName  isEqual: @"channel"])
    {
        [_delegate setNewsArray: newsList];
    }
    else if ([elementName  isEqual: @"item"])
    {
        [newsList addObject:[[NewsItem alloc] initWithTitle: title
                                            andCreationDate: creationDate
                                                 andContent: content
                                                    andLink: linkString]];
        isParseItem = NO;
    }
    else if (isParseItem)
    {
        if ([currentPropertyName  isEqual: @"title"])
        {
            title = [currentValue copy];
            [currentValue deleteCharactersInRange: NSMakeRange(0, currentValue.length)];
        }
        else if ([currentPropertyName  isEqual: @"description"])
        {
            content = [currentValue copy];
            [currentValue deleteCharactersInRange: NSMakeRange(0, currentValue.length)];
        }
        else if ([currentPropertyName  isEqual: @"pubDate"])
        {
            creationDate = [rssDateFormatter dateFromString: currentValue];
            [currentValue deleteCharactersInRange: NSMakeRange(0, currentValue.length)];
        }
        else if ([currentPropertyName  isEqual: @"link"])
        {
            linkString =[currentValue copy];
            [currentValue deleteCharactersInRange: NSMakeRange(0, currentValue.length)];
        }
    }
}
@end
