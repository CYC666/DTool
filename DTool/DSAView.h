//
//  DSAView.h
//  DToolDemo
//
//  Created by CYC on 2020/12/9.
//

// 选择中国省市区

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^DSAViewBlock)(NSArray *list);

@interface DSAView : UIView

@property (copy, nonatomic) DSAViewBlock sureBlock;

@end

@interface DSAViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;

@end

NS_ASSUME_NONNULL_END
