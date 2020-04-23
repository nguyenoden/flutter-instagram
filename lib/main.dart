import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/attachments/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_state.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/messages/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/share_stories/share_stories_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/simple_bloc_delegate.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/contacts/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/stories/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/user_stories/user_stories_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/themes.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/home_clb.dart';
import 'package:flutter_clb_tinhban_ui_app/login/register_page.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/user_data_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/authentication_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/chat_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/stories_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/user_data_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/comments/comments_bloc.dart';

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  //await FlutterDownloader.initialize();
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final UserDataProvider userDataProvider=UserDataProvider();
  final StorageRepository storageRepository = StorageRepository();
  final ChatRepository chatRepository = ChatRepository();
  final StoriesRepository storiesRepository = StoriesRepository();
  ShareObjects.prefs = await CachedSharedPreferences.getInstance();
  Constants.cacheDirPath = (await getTemporaryDirectory()).path;
  Constants.downloadsDirPath =
      (await DownloadsPathProvider.downloadsDirectory).path;
  // Khóa thiết bị không cho user thay đổi Orientation ( DeviceOrientation.portraitUp: luôn hiển thị màn hình đứng)
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      // Khai bao cac Bloc duoc su dung trong aap, neu khong se xuat hien loi
      MultiBlocProvider(
        providers: [

          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
                userDataRepository,userDataProvider,storageRepository
            ),
          ),
          BlocProvider<UserStoriesBloc>(
            create: (context) => UserStoriesBloc(
                storiesRepository,storageRepository
            ),
          ),
          BlocProvider<CommentsBloc>(
            create: (context) => CommentsBloc(
                storiesRepository,storageRepository
            ),
          ),
          BlocProvider<StoriesBloc>(
            create: (context) => StoriesBloc(
              storiesRepository,storageRepository
            ),
          ),
          BlocProvider<ShareStoriesBloc>(
            create: (context) => ShareStoriesBloc(
                storiesRepository,storageRepository
            ),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                authenticationRepository: authRepository,
                storageRepository: storageRepository,
                userDataRepository: userDataRepository)
              ..add(AppLaunched()),
          ),
          BlocProvider<ContactsBloc>(
            create: (context) => ContactsBloc(
                userDataRepository: userDataRepository,
                chatRepository: chatRepository),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              userDataRepository: userDataRepository,
              chatRepository: chatRepository,
              storageRepository: storageRepository,
            ),
          ),
          BlocProvider<AttachmentBloc>(
            create: (context) => AttachmentBloc(chatRepository),
          ),
          BlocProvider<MessagesBloc>(
            create: (context) => MessagesBloc(chatRepository),
          )
        ],
        child: CLB(),
      ),
    );
  });
}

class CLB extends StatelessWidget {
  Key key = UniqueKey();
  ThemeData themeData = Themes.light;

  Widget build(BuildContext context) {
    var uid = ShareObjects.prefs.getString(Constants.sessionUid);

    return MaterialApp(
        theme: themeData,
        key: key,
        title: ' CLB Tình Bạn',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is UnAuthenticated) {
              return RegisterPage();
            } else if (uid != null || state is ProfileUpdated) {
              return HomeCLB();
            } else {
              return RegisterPage();
            }
          },
        ));
  }
}
