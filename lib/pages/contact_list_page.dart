import 'dart:ui';

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/contacts/contacts_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/contacts/contacts_event.dart';

import 'package:flutter_clb_tinhban_ui_app/blocs/contacts/contacts_state.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/decorations.dart';

import 'package:flutter_clb_tinhban_ui_app/config/styles.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';

import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/conversation_page_slide.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/bottom_sheet_fixed.dart';

import 'package:flutter_clb_tinhban_ui_app/widgets/gradient_fab.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/gradient_snack_bar.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();

  const ContactListPage();
}

class _ContactListPageState extends State<ContactListPage>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  List<Contact> contacts;
  ContactsBloc contactsBloc;

  AnimationController animationController;
  Animation<double> animation;

  final TextEditingController usernameController = TextEditingController();
  List<String> strList = [];
  List<Widget> favouriteList = [];
  List<Widget> normalList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    contacts = List();
    contactsBloc = BlocProvider.of<ContactsBloc>(context);

    scrollController = ScrollController();
    scrollController.addListener(scrollListener);

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation =
        CurvedAnimation(curve: Curves.linear, parent: animationController);
    animationController.forward();

    contactsBloc.add(FetchContactsEvent());

    filterList();
    searchController.addListener(() {
      filterList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Contacts',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
        listener: (bc, state) {
          if (state is AddContactSuccessState) {
            Navigator.pop(context);
            GradientSnackBar.showMessage(
                context, "Contact Added Successfully!");
          } else if (state is ErrorState) {
            Navigator.pop(context);
            GradientSnackBar.showMessage(
                context, state.exception.errorMessage());
          }
        },
        child:
            BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
          if (state is FetchingContactsState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FetchedContactsState) {
            contacts = state.contacts;
            contacts.sort((a, b) =>
                a.username.toLowerCase().compareTo(b.username.toLowerCase()));

            filterList();
          }
          return AlphabetListScrollView(
            normalTextStyle: TextStyle(color: Colors.black, fontSize: 10),
            strList: strList,
            highlightTextStyle: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            showPreview: true,
            itemBuilder: (context, index) {
              return normalList[index];
            },
            indexedHeight: (i) {
              return 80;
            },
            keyboardUsage: true,
            headerWidgetList: <AlphabetScrollListHeader>[
              AlphabetScrollListHeader(widgetList: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffix: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      labelText: "Search",
                    ),
                  ),
                )
              ], icon: Icon(Icons.search), indexedHeaderHeight: (index) => 80),
              AlphabetScrollListHeader(
                  widgetList: favouriteList,
                  icon: Icon(Icons.star),
                  indexedHeaderHeight: (index) {
                    return 80;
                  }),
            ],
          );
        }),
      ),
      floatingActionButton: GradientFab(
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        animation: animation,
        vsync: this,
        onPressed: () => showAddContactsBottomSheet(context),
      ),
    ));
  }

  filterList() {
    favouriteList = [];
    normalList = [];
    strList = [];
    print('contac: $contacts');
    if (searchController.text.isNotEmpty) {
      contacts.retainWhere((contact) => contact.username
          .toLowerCase()
          .contains(searchController.text.toLowerCase()));
    }
    contacts.forEach((contact) {
      normalList.add(
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              iconWidget: Icon(Icons.star),
              onTap: () {},
            ),
            IconSlideAction(
              iconWidget: Icon(Icons.more_horiz),
              onTap: () {},
            ),
          ],
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                SlideLeftRout(
                    page: ConversationPageSlide(
                  startContact: contact,
                ))),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(contact.photoUrl),
              ),
              title: Text(contact.username),
              subtitle: Text(contact.name),
            ),
          ),
        ),
      );
      strList.add(contact.username);
    });
  }

  scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  void showAddContactsBottomSheet(parentContext) async {
    await showModalBottomSheetApp(
        context: context,
        builder: (BuildContext bc) {
          return BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) {
              return Card(
                color: Theme.of(context).backgroundColor,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Container(
                  decoration: BoxDecoration(
                      // color: Theme.of(context).backgroundColor,

                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0))),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                              constraints: BoxConstraints(minHeight: 100),
                              child: Image.asset(Assets.social)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Text(
                            'Add by Username',
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
                          child: TextField(
                            controller: usernameController,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subhead,
                            decoration: Decorations.getInputDecoration(
                                hint: '@username', context: parentContext),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: BlocBuilder<ContactsBloc, ContactsState>(
                                builder: (context, state) {
                                  return GradientFab(
                                    elevation: 0.0,
                                    child: _getButtonChild(state),
                                    onPressed: () {
                                      contactsBloc.add(AddContactEvent(
                                          usernameController.text));
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  _getButtonChild(ContactsState state) {
    if (state is AddContactSuccessState || state is ErrorState) {
      return Icon(
        Icons.check,
        color: Theme.of(context).primaryColor,
      );
    } else if (state is AddContactProgressState) {
      return SizedBox(
        height: 9,
        width: 9,
        child: CircularProgressIndicator(
          value: null,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      return Icon(
        Icons.done,
        color: Theme.of(context).primaryColor,
      );
    }
  }
}
