//
//  CustomCell.h
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/3/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewForImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *headline;

@end
