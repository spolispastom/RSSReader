//
//  RSSDownloader.m
//  RSSReader
//
//  Created by Михаил Куренков on 19.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "RSSParser.h"

@interface RSSParser()

@property (nonatomic) NSDateFormatter * rssDateFormatter;
@property (nonatomic) NSXMLParser * parser;

@property (nonatomic) NSString * currentPropertyName;
@property (nonatomic) NSMutableString * currentValue;

@property (nonatomic) NSString * title;
@property (nonatomic) NSDate * creationDate ;
@property (nonatomic) NSString * content;
@property (nonatomic) NSString * linkString;

@property (nonatomic) NSMutableArray * newsList;

@property (nonatomic) BOOL isParseItem;

@end

@implementation RSSParser

@synthesize data;
@synthesize delegate;



- (RSSParser *) initWithData: (NSData *) newsData
{
    self = [super init];
    data = newsData;
    return self;
}

- (BOOL) parse
{
    _rssDateFormatter = [[NSDateFormatter alloc] init];
    [_rssDateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss Z:"];
    
    if (data && delegate)
    {
        _parser = [[NSXMLParser alloc] initWithData: data];
        [_parser setDelegate: self];
        [_parser setShouldResolveExternalEntities:YES];
        
        return [_parser parse];
    }
    else return NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName  isEqual: @"channel"])
    {
        _newsList = [[NSMutableArray alloc] init];
        _isParseItem = NO;
    }
    else if ([elementName  isEqual: @"item"])
    {
        _title = @"";
        _content = @"";
        _currentPropertyName = @"";
        _currentValue = [[NSMutableString alloc] init];
        
        _title = nil;
        _creationDate = nil;
        _content = nil;
        _linkString = nil;
        
        _isParseItem = YES;
    }
    else _currentPropertyName = elementName;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(_currentValue)
    {
        if ([_currentPropertyName length] > 1 && [string length] > 0)
        {
            if (_currentValue.length > 0)
                [_currentValue appendString: string];
            else
            {
                [_currentValue appendString: string];
                while (_currentValue.length > 0 &&
                       ([_currentValue characterAtIndex:0] == '\n' ||
                        [_currentValue characterAtIndex:0] == '\t' ||
                        [_currentValue characterAtIndex:0] == ' '))
                {
                    [_currentValue deleteCharactersInRange: NSMakeRange(0, 1)];
                }
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName  isEqual: @"channel"])
    {
        [delegate newsParser: self didParseNews: _newsList];
    }
    else if ([elementName  isEqual: @"item"])
    {
        [_newsList addObject:[[NewsItem alloc] initWithTitle: _title
                                            andCreationDate: _creationDate
                                                 andContent: _content
                                                    andLink: _linkString]];
        _isParseItem = NO;
    }
    else if (_isParseItem)
    {
        if ([_currentPropertyName  isEqual: @"title"])
        {
            _title = [_currentValue copy];
            [_currentValue deleteCharactersInRange: NSMakeRange(0, _currentValue.length)];
        }
        else if ([_currentPropertyName  isEqual: @"description"])
        {
            _content = [_currentValue copy];
            [_currentValue deleteCharactersInRange: NSMakeRange(0, _currentValue.length)];
        }
        else if ([_currentPropertyName  isEqual: @"pubDate"])
        {
            _creationDate = [_rssDateFormatter dateFromString: _currentValue];
            [_currentValue deleteCharactersInRange: NSMakeRange(0, _currentValue.length)];
        }
        else if ([_currentPropertyName  isEqual: @"link"])
        {
            _linkString =[_currentValue copy];
            [_currentValue deleteCharactersInRange: NSMakeRange(0, _currentValue.length)];
        }
    }
}
@end
