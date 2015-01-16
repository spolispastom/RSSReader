//
//  RSSListTableViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "RSSListTableViewController.h"

@interface RSSListTableViewController ()

@end

@implementation RSSListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.NewsItems = [self dowlandRSSDataFromURL: @"http://news.yandex.ru/hardware.rss"];
    
    if (!self.NewsItems)
        self.NewsItems = [[ NSMutableArray alloc ] init ];
    
     defaultDateFormatter = [[NSDateFormatter alloc] init];
    [defaultDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [ self loadInitialData ];
    
}

NSDateFormatter * defaultDateFormatter;

-(NSMutableArray *) dowlandRSSDataFromURL: (NSString *) url{
  
    NSMutableArray * dataNewsItems = [[ NSMutableArray alloc ] init ];
    
    NSData * rssData = [self getDataFromURL: url];
    
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData: rssData ];
        
        
    return dataNewsItems;
}

- (NSData *) getDataFromURL:(NSString *) url {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError * error = [[NSError alloc] init];
    NSHTTPURLResponse * responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        return nil;
    }
    
    return oResponseData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.NewsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [ tableView dequeueReusableCellWithIdentifier: @"ListPrototypeCell" forIndexPath: indexPath ];
    
    NewsItem * newsItem = [ self.NewsItems objectAtIndex: indexPath.row ];
    cell.textLabel.text = newsItem.Title;
    cell.detailTextLabel.text = [defaultDateFormatter stringFromDate: newsItem.CreationDate];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- ( IBAction ) unwindToList: ( UIStoryboardSegue * ) segue {
    //AddToDoItemViewController * sourse = [segue sourceViewController];
    
}


- ( void ) loadInitialData {
    
    NewsItem * item1 = [[ NewsItem alloc ] initFromTitle: @"Китайский производитель смартфонов «вдохновился» моделями Apple и Samsung"
                                         andCreationDate: [NSDate date]
                                              andContent: @"Xiaomi, третий в мире производитель смартфонов, анонсировал модели Mi Note и Mi Note Pro, по дизайну похожие на iPhone 6 Plus. Об этом сообщается в официальном аккаунте компании в Facebook." ];
    
    NewsItem * item2 = [[ NewsItem alloc ] initFromTitle: @"Российские ракетные двигатели разрешили продать в США"
                                         andCreationDate: [NSDate date]
                                              andContent: @"Правительство России выдало разрешение НПО «Энергомаш» и Объединенной ракетно-космической корпорации (ОРКК) на поставку ракетных двигателей РД-181 для ракет-носителей Antares американской корпорации Orbital Sciences. Об этом пишут в пятницу, 16 января, «Известия» со ссылкой на президента ракетно-космической корпорации «Энергия» Владимира Солнцева." ];
    NewsItem * item3 = [[ NewsItem alloc ] initFromTitle: @"Google приостановит производство своих очков"
                                         andCreationDate: [NSDate date]
                                              andContent: @"Компания Google объявила об остановке производства текущей версии Google Glass — очков с прозрачным дисплеем и камерой. Об этом сообщил в четверг, 15 января, телеканал CNBC." ];
                        
    [ self.NewsItems addObject: item1 ];
    [ self.NewsItems addObject: item2 ];
    [ self.NewsItems addObject: item3 ];
}

#pragma mark - Table view delegate

- ( void ) tableView: ( UITableView * ) tableView didSelectRowAtIndexPath: ( NSIndexPath * ) indexPath {
    [ tableView deselectRowAtIndexPath: indexPath animated: NO ];
    
    _currentNewsItem = [ self.NewsItems objectAtIndex: indexPath . row ];
    
    [ tableView reloadRowsAtIndexPaths: @[ indexPath ] withRowAnimation: UITableViewRowAnimationNone ];
}

@end
