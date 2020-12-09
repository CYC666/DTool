//
//  DSAView.m
//  DToolDemo
//
//  Created by CYC on 2020/12/9.
//

#import "DSAView.h"

@interface DSAView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *button1;    // 返回
@property (strong, nonatomic) UIView *view1;        // 承载
@property (strong, nonatomic) UIView *view2;        // 承载按钮
@property (strong, nonatomic) UIView *view3;        // 浮块
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;    // 表视图数据
@property (strong, nonatomic) NSMutableArray *selectArray;  // 选中的地址




@end

@implementation DSAView



#pragma mark ========================================生命周期========================================
+ (instancetype)new {
    
    DSAView *view = [[DSAView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view creatUIAction];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}


#pragma mark - 创建UI
- (void)creatUIAction {
    
    
    
    // 返回按钮
    _button1 = [[UIButton alloc] initWithFrame:self.bounds];
    _button1.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _button1.alpha = 0;
    [_button1 addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button1];
    
    CGFloat height = 0.0;
    
    // 主视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    _view1 = view;
    
    height = 600;
    _view1.frame = CGRectMake(0, self.frame.size.height - height + [UIScreen mainScreen].bounds.size.height, self.frame.size.width, height);
    
    // 圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"请选择";
        label.userInteractionEnabled = NO;
        [view addSubview:label];
    }
    
    {
        UIView *viewA = [[UIView alloc] initWithFrame:CGRectMake(15, 50, view.frame.size.width - 15*2, 30)];
        [view addSubview:viewA];
        _view2 = viewA;
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, viewA.frame.size.height - 0.5, viewA.frame.size.width, 0.5)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [viewA addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, viewA.frame.size.height - 2, 80, 2)];
        line2.backgroundColor = [UIColor colorWithRed:28/255.0 green:225/255.0 blue:231/255.0 alpha:1];
        line2.layer.cornerRadius = 1;
        [viewA addSubview:line2];
        _view3 = line2;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, viewA.frame.size.height)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"选择城市" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
        [viewA addSubview:button];
    }
    
    {
        // 表视图
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 50+30, view.frame.size.width - 15*2, view.frame.size.height - 50 - 30)
                                                      style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 40;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[DSAViewCell class] forCellReuseIdentifier:@"DSAViewCell"];
        [view addSubview:_tableView];
    }
    

    
    // 出现
    [UIView animateWithDuration:.25 animations:^{
        _button1.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 animations:^{
            _view1.transform = CGAffineTransformMakeTranslation(0, -[UIScreen mainScreen].bounds.size.height);
        }];
    }];
    
    
    [self loadDataAction];
    
}


#pragma mark - 刷新UI
- (void)updateUIAction {
    
    for (UIView *view in _view2.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    double x = 0.0;
    double w = 0.0;
    if (_selectArray.count == 0) {
        
        
        NSString *text = @"选择城市";
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, _view2.frame.size.height)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
        [_view2 addSubview:button];
        x += button.frame.origin.x;
        w = size.width;
        
    } else {
        
        for (NSDictionary *model in _selectArray) {
            
            NSString *text = [NSString stringWithFormat:@"%@", model[@"name"]];
            CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x + w + 10, 0, size.width, _view2.frame.size.height)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:text forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
            [_view2 addSubview:button];
            x = button.frame.origin.x;
            w = size.width;
        }
    }
    
    [UIView animateWithDuration:.25 animations:^{
        _view3.frame = CGRectMake(x, _view2.frame.size.height - 2, w, 2);
    }];
    
    [_tableView reloadData];
    
}



#pragma mark ========================================动作响应=============================================

#pragma mark - 退出
- (void)backAction {
    
    // 消失
    [UIView animateWithDuration:.25 animations:^{
        _view1.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 animations:^{
            _button1.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
    
}

#pragma mark - 选择城市
- (void)button1Action:(UIButton *)button {
    
    if (_selectArray.count != 0) {
        [_selectArray removeLastObject];
        [self loadDataAction];
    }
    
}

#pragma mark ========================================网络请求=============================================

#pragma mark - 加载数据
- (void)loadDataAction {
    
    
    
    
    
    if (_selectArray.count == 0) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error = nil;
        NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        _dataArray = items.mutableCopy;
    } else {
        
        NSDictionary *model = _selectArray.lastObject;
        NSArray *list = model[@"city"];
        if (list.count == 0) {
            
            // 没有下一级
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                _sureBlock(_selectArray);
                [self backAction];
            });
        } else {
            
            _dataArray = list.mutableCopy;
        }
    }
    
    [self updateUIAction];
}

#pragma mark ========================================代理方法=============================================

#pragma mark - 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
//    return 20;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSAViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DSAViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < _dataArray.count) {
        NSDictionary *model = _dataArray[indexPath.row];
        
        cell.label.text = [NSString stringWithFormat:@"%@", model[@"name"]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _dataArray.count) {
        NSDictionary *model = _dataArray[indexPath.row];
        
        if (_selectArray.count == 0) {
            
            _selectArray = [NSMutableArray array];
        }
        [_selectArray addObject:model];
        [self loadDataAction];
    }
}



@end




@implementation DSAViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self creatUIAction];
        
    }
    return self;
    
}

#pragma mark - 创建UI
- (void)creatUIAction {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 15*2, 40)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    self.label = label;
    
    UIView *line= [[UIView alloc] initWithFrame:CGRectMake(0, label.frame.size.height - 0.5, label.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
}


@end
