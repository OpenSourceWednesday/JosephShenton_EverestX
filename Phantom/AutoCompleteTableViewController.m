//
//  AutoCompleteTableViewController.m
//  PangeaIO
//
//  Created by Felon on 2/2/18.
//  Copyright © 2018 JJS Digital PTY LTD. All rights reserved.
//

#import "AutoCompleteTableViewController.h"

@interface AutoCompleteTableViewController ()

@end

@implementation AutoCompleteTableViewController

NSData *jsonData;
id jsonObject;

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *s = @"{\"temperature\": -260.65, \"humidity\": 54.05, \"time\": \"2016-03-14T09:46:48Z\", \"egg\": 1, \"id\": 6950, \"no2\": 0.0}";
    // comment above and uncomment below line, json s string for NSArray object
    // NSString *s = @"[{\"ID\":{\"Content\":268,\"type\":\"text\"},\"ContractTemplateID\":{\"Content\":65,\"type\":\"text\"}}]";
    self.navigationController.navigationItem.title = @"Auto Complete";
    NSString *s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"html" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    jsonData = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    //    Note that JSONObjectWithData will return either an NSDictionary or an NSArray, depending whether your JSON string represents an a dictionary or an array.
    jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
    }
    else
    {
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            NSLog(@"it is an array!");
            NSArray *jsonArray = (NSArray *)jsonObject;
            NSLog(@"jsonArray - %@",jsonArray);
        }
        else {
            NSLog(@"it is a dictionary");
            NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
            NSLog(@"jsonDictionary - %@",jsonDictionary);
        }
    }
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
    return [jsonObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"<%@></%@>", [jsonObject objectAtIndex:indexPath.row], [jsonObject objectAtIndex:indexPath.row]];
    
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

@end
