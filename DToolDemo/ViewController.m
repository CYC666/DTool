//
//  ViewController.m
//  DToolDemo
//
//  Created by CYC on 2020/12/8.
//

#import "ViewController.h"
#import "DSAView.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 300, 80)];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    
}

#pragma mark - 选择地区
- (void)button1Action:(UIButton *)button {
    

    
    DSAView *tipView = [DSAView new];
    __weak typeof(self) weakSelf = self;
    tipView.sureBlock = ^(NSArray * _Nonnull list) {
        
        if (list.count > 0) {
    
            NSString *text = @"";
            for (NSDictionary *model in list) {
            
                if (text.length == 0) {
                    
                    text = [NSString stringWithFormat:@"%@", model[@"name"]];
                } else {
                    text = [NSString stringWithFormat:@"%@|%@", text, model[@"name"]];
                }
            }
            
            [weakSelf.button setTitle:text forState:UIControlStateNormal];
        }
        
    };
    
}


@end
