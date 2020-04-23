import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/like.dart';
import 'package:flutter_clb_tinhban_ui_app/model/post.dart';
import 'package:flutter_clb_tinhban_ui_app/model/story.dart';
import 'package:flutter_clb_tinhban_ui_app/model/sub_comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';

const placeholderStories = <Story>[];
const Nguyen =
    User(name: 'NguyenFlutter', photoUrl: 'assets/images/nguyen.jpg');
const BarackObama = User(
    name: 'Barack Obama',
    photoUrl: 'assets/images/BarackObama.jpg',
    stories: placeholderStories);
const DonaldTrump = User(
    name: 'Donald Trump',
    photoUrl: 'assets/images/DonaldTrump.jpg',
    stories: placeholderStories);
const AbrahamLincoln = User(
    name: 'Abraham Lincoln',
    photoUrl: 'assets/images/AbrahamLincoln.jpg',
    stories: placeholderStories);
const GeorgeWBush = User(
    name: 'George WBush',
    photoUrl: 'assets/images/GeorgeWBush.jpg',
    stories: placeholderStories);
const GeorgeWashington = User(
    name: 'George Washington',
    photoUrl: 'assets/images/GeorgeWashington.jpg',
    stories: placeholderStories);
const currentUser = Nguyen;
final search = [
  'assets/images/post1.jpg',
  'assets/images/post2.jpg',
  'assets/images/post3.jpg',
  'assets/images/post4.jpg',
  'assets/images/post5.jpg',
  'assets/images/post6.jpg',
  'assets/images/post7.jpg',
  'assets/images/post8.jpg',
  'assets/images/post9.jpg',
  'assets/images/post10.jpg',
  'assets/images/post11.jpg',
  'assets/images/post12.jpg',
];

final posts = <Post>[
  Post(
    user: Nguyen,
    imgUrls: [
      'assets/images/post1.jpg',
      'assets/images/post2.jpg',
      'assets/images/post3.jpg',
      'assets/images/post4.jpg',
      'assets/images/post5.jpg',
      'assets/images/post6.jpg',
      'assets/images/post7.jpg',
      'assets/images/post8.jpg',
      'assets/images/post9.jpg',
      'assets/images/post10.jpg',
      'assets/images/post11.jpg',
      'assets/images/post12.jpg',
    ],
    likes: [

    ],
    comments: [

    ],
    description:
        'Cánh đồng hoa tulip Hà Lan Hà Lan luôn được mệnh danh là quê hương của loài hoa kiêu sa tuyệt đẹp - tulip. Nơi đây có những cánh đồng hoa tulip ngập tràn màu sắc, trải dài bất tận tạo nên những bức tranh muôn màu sắc, đẹp ngoài sức tưởng tượng của con người.',
    timePost: DateTime(2019, 5, 23, 12, 35, 0),
  ),
  Post(
    user: AbrahamLincoln,
    imgUrls: [
      'assets/images/post4.jpg',
      'assets/images/post5.jpg',
      'assets/images/post6.jpg',
    ],
    likes: [

    ],
    comments: [

    ],
    description:
        'Những cánh đồng hoa tulip nở rộ, đủ màu sắc và chạy dài tới tận chân trời là cảnh đẹp khiến bất cứ ai nhìn thấy cũng phải trầm trồ ngất ngây. Mùa hoa tulip bắt đầu từ cuối tháng 3 tới khoảng đầu tháng 8. Vào thời điểm này, những bông hoa với đủ màu sắc tím, hồng, đỏ, vàng... đua nhau nở, giống như những suối hoa rực rỡ muôn màu.  ',
    timePost: DateTime(2019, 5, 23, 12, 35, 0),
  ),
  Post(
    user: BarackObama,
    imgUrls: [
      'assets/images/post7.jpg',
      'assets/images/post8.jpg',
      'assets/images/post9.jpg'
    ],
    likes: [],
    comments: [],
    description:
        'Những cánh đồng hoa tulip nở rộ, đủ màu sắc và chạy dài tới tận chân trời là cảnh đẹp khiến bất cứ ai nhìn thấy cũng phải trầm trồ ngất ngây. Mùa hoa tulip bắt đầu từ cuối tháng 3 tới khoảng đầu tháng 8. Vào thời điểm này, những bông hoa với đủ màu sắc tím, hồng, đỏ, vàng... đua nhau nở, giống như những suối hoa rực rỡ muôn màu.',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: GeorgeWBush,
    imgUrls: ['assets/images/post10.jpg'],
    likes: [],
    comments: [],
    description: 'Những cánh đồng hoa tulip nở rộ.',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: currentUser,
    imgUrls: [Assets.image_1, Assets.image_2],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: currentUser,
    imgUrls: [Assets.image_3, Assets.image_4, Assets.image_5],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: GeorgeWashington,
    imgUrls: [Assets.image_6, Assets.image_7, Assets.image_8, Assets.image_9],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: GeorgeWashington,
    imgUrls: [
      Assets.image_10,
      Assets.image_11,
      Assets.image_12,
      Assets.image_13,
      Assets.image_14
    ],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: currentUser,
    imgUrls: [Assets.image_15],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: AbrahamLincoln,
    imgUrls: [Assets.image_16],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: GeorgeWBush,
    imgUrls: [Assets.image_17],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: DonaldTrump,
    imgUrls: [Assets.image_17, Assets.image_18, Assets.image_19],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: Nguyen,
    imgUrls: [Assets.image_20, Assets.image_21],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: DonaldTrump,
    imgUrls: [
      Assets.image_23,
      Assets.image_24,
      Assets.image_25,
      Assets.image_26
    ],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: GeorgeWBush,
    imgUrls: [
      Assets.image_27,
      Assets.image_28,
      Assets.image_29,
      Assets.image_30
    ],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: GeorgeWBush,
    imgUrls: [Assets.image_31, Assets.image_32, Assets.image_33],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: BarackObama,
    imgUrls: [
      Assets.image_34,
      Assets.image_35,
      Assets.image_36,
      Assets.image_37,
    ],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: currentUser,
    imgUrls: [Assets.image_1],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
  Post(
    user: AbrahamLincoln,
    imgUrls: [Assets.image_10],
    likes: [],
    comments: [],
    description: 'Năm của những điều tốt đẹp',
    timePost: DateTime(2019, 5, 2, 0, 0, 0),
  ),
];
