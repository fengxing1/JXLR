//
//  TableViewCellAnnouncement.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/3/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "TableViewCellAnnouncement.h"

@implementation TableViewCellAnnouncement

-(instancetype)TableViewCellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"TableViewCellAnnouncement";
    TableViewCellAnnouncement *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[TableViewCellAnnouncement alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [self initView];
    }
    return cell;
}

-(void)initView{
    
}
@end
