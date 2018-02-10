//
//  ViewController.m
//  DemoFlowCI
//
//  Created by wealon on 2017/3/21.
//  Copyright © 2017年 MDJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *sounds;
@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tasks = [NSMutableArray array];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSInteger count = 1;
    for (NSString *soundURL in [self musicURLList])
    {
        NSURL *url = [NSURL URLWithString:soundURL];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                          {
                                              NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                                                stringByAppendingPathComponent:response.suggestedFilename];
                                              NSLog(@"=========   %zd   ==============",count);
                                              NSLog(@"source Path = %@",location);
                                              NSLog(@"dest Path = %@",path);
                                              if (location != nil)
                                              {
                                                  // 剪切文件
                                                  [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
                                              }
                                          }];
        
        [task resume];
        count ++;
        [self.tasks addObject:task];
    }
    
    
}

- (void)resourceAbout
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, screenSize.width, screenSize.height - 20)
                                                          style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"allsounds" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", [data allKeys]);//直接打印数据。
    NSLog(@"%@", [data allValues]);//直接打印数据。
    
    
    NSArray *sounds = [data allValues];
    
    sounds = [sounds sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        
        NSString *id1 = obj1[@"id"];
        NSString *id2 = obj2[@"id"];
        return [id1 integerValue] > [id2 integerValue];
    }];
    
    NSArray *urlList = [self musicURLList];
    NSMutableArray *tmpArrList = [NSMutableArray array];
    NSInteger i = 0;
    for (NSDictionary *soundDic in sounds)
    {
        NSString *titleID = soundDic[@"id"];
        if ([titleID integerValue] < 100)
        {
            continue;
        }
        NSString *url = [urlList objectAtIndex:i];
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:soundDic];
        [tmpDic setObject:url forKey:@"downUrl"];
        [tmpArrList addObject:tmpDic];
        i++;
        
    }
    
    self.sounds = tmpArrList;
    [self writePlist];
    [self musicURLList];
}

- (void)writePlist
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"white.plist"];   //获取路径
    NSLog(@"fileName = %@",filename);
    [self.sounds writeToFile:filename atomically:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 199 - 15 = 184
    NSInteger count = [self.sounds count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sound"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sound"];
    }
    
    NSDictionary *soundDic = [self.sounds objectAtIndex:indexPath.row];
    NSString *title = soundDic[@"title"];
    NSString *titleID = soundDic[@"id"];
    NSString *sound = soundDic[@"sound"];
    NSString *url = soundDic[@"downUrl"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",titleID,title];
    cell.detailTextLabel.text = url;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)musicURLList
{
    NSArray *tmpArr = @[
                        @"http://dts.doutushe.com/whitenoise3d/1000423714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1001413714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1002383714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1003423714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1004383714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1005383714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1006403714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1007403714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1008413714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1009403714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1010383714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1011403714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1012403714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1013120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1014423714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1015120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1016120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1017120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1018120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1019120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1020120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1021120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1022120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1023120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1024413714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1025403714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1026120614030908.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1027403714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1028423714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1029423714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1030423714151115.caf",
                        @"http://dts.doutushe.com/whitenoise3d/1031120614098037.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1033382716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1034382716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1035383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1036012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1037012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1038503615097027.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1039452716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1040452716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1041333815097027.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1042382716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1043363714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1044452716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1045012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1046012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1047012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1048012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1049382716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1050382716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1051462716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1052382716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1053392716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1054413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1055392716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1057383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1058403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1059403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1060413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1061393714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1062403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1063012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1064392716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1065452716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1066383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1067012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1068392716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1069392716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1070120614098037.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1071003715097027.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1072012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1073392716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1074413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1075110415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1076413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1077402716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1078402716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1079402716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1080012316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1081413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1082462716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1083462716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1084142115118227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1085452716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1086413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1087462716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1088022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1089402716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1090402716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1091382716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1092022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1093022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1094402716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1095022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1096120614098037.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1097423714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1098472716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1099402716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1100472716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1101462716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1102412716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1103413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1104412716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1105403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1106412716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1107022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1108403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1109022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1110022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1111413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1112383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1113412716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1115412716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1116383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1117413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1118022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1119412716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1120373714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1121422716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1122383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1123022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1124403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1125383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1126022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1127422716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1128422716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1129022316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1130142115118227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1131423714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1132032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1134452716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1135383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1137413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1138032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1139383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1140032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1141403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1142393714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1143403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1144110415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1145120415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1146120415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1147110415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1148110415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1149120415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1150110415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1151432716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1152383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1153120614098037.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1154423714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1155403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1156032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1157032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1158032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1159032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1160452716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1161403714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1162110415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1163032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1164432716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1166462716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1167442716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1168442716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1169373714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1170032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1171383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1172383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1173442716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1175383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1176442716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1177413714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1178032316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1179042316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1180423714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1181373714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1182383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1183042316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1185120415084177.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1186383714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1188042316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1189373714115157.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1190442716036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1191042316036227.mp3",
                        @"http://dts.doutushe.com/whitenoise3d/1192042316036227.mp3"
                        
                        ];
    
    // 184
    NSInteger count = [tmpArr count];
    NSLog(@"count = %zd",count);
    return tmpArr;
}


@end
