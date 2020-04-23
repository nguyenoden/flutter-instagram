import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class EditProfile extends StatefulWidget {
  final User user;

  const EditProfile({Key key, this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(user);
}

class _EditProfileState extends State<EditProfile> {
  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var phoneController = TextEditingController();
  var sexController = TextEditingController();
  var dateOfBirthController = TextEditingController();
  var ageController = TextEditingController();
  var introductoryController = TextEditingController();
  var locationController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode sexFocusNode = FocusNode();
  FocusNode dateOfBirthFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
  FocusNode introductoryFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  File fileImageProfile;
  final format = DateFormat("yyyy-MM-dd");

  // ignore: close_sinks
  ProfileBloc profileBloc;
  final User user;

  _EditProfileState(this.user);

  @override
  void initState() {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    nameController.text = user.name ?? "";
    usernameController.text = user.username ?? "";
    phoneController.text = user.phoneNumber.toString() ?? "";
    sexController.text = user.sex ?? "";
    dateOfBirthController.text = user.dateOfBirth ?? "";
    ageController.text = user.age.toString() ?? "";
    introductoryController.text = user.introductory.toString() ?? "";
    locationController.text = user.location.toString()?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Chỉnh sửa trang cá nhân',
            style: Theme.of(context).textTheme.title,
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => {
              Navigator.pop(context),
              profileBloc.add(FetchProfileUserEvent(user.documentId))
            },
            child: Icon(
              Icons.close,
              size: 24,
              color: Palette.colorBlack,
            ),
          ),
          elevation: 1.0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  profileBloc.add(UpdateProfileUserEvent(
                      nameController.text,
                      usernameController.text,
                      int.parse(ageController.text),
                      fileImageProfile,
                      int.parse(phoneController.text),
                      sexController.text,
                      dateOfBirthController.text,
                      user.photoUrl,
                      introductoryController.text,
                      locationController.text));
                },
                icon: Icon(
                  Icons.check,
                  size: 24,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        listener: (context, state) {
          if (state is FinishProgressState) {
            Future.delayed(Duration(milliseconds: 300), () {
              //profileBloc.add(InitialProfileEvent());
            });
          }
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () => _showDialogImageOption(context),
                                  child: Container(
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: fileImageProfile != null
                                          ? FileImage(fileImageProfile)
                                          : user.photoUrl != null
                                              ? CachedNetworkImageProvider(
                                                  user.photoUrl)
                                              :  AssetImage(Assets.placeholder),
                                      child: Center(
                                        child: Icon(
                                          Icons.camera,
                                          color: Theme.of(context).accentColor,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    width: 90.0,
                                    height: 90.0,
                                    padding: EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: nameController,
                          focusNode: nameFocusNode,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, nameFocusNode, usernameFocusNode);
                          },
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person_outline,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintText: 'Name',
                            labelText: 'Name',
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                          ),
                        ),
                        TextFormField(
                          focusNode: usernameFocusNode,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, usernameFocusNode, phoneFocusNode);
                          },
                          controller: usernameController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person_outline,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintText: 'Username',
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                            labelText: 'Username',
                          ),
                        ),
                        TextFormField(
                          focusNode: phoneFocusNode,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, phoneFocusNode, ageFocusNode);
                          },
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.phone,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                            hintText: 'Phone Number',
                            labelText: 'Phone Number',
                          ),
                        ),
                        TextFormField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          focusNode: ageFocusNode,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, ageFocusNode, sexFocusNode);
                          },
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.perm_identity,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                            hintText: 'Age',
                            labelText: 'Age',
                          ),
                        ),
                        TextFormField(
                          controller: sexController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          focusNode: sexFocusNode,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, sexFocusNode, dateOfBirthFocusNode);
                          },
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person_outline,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                            hintText: 'Sex',
                            labelText: 'Sex',
                          ),
                        ),
                        TextFormField(
                          controller: introductoryController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          focusNode: introductoryFocusNode,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, introductoryFocusNode,
                                locationFocusNode);
                          },
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.today,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                            hintText: 'Introductory',
                            labelText: 'Introductory',
                          ),
                        ),
                        TextFormField(
                          controller: locationController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          focusNode: locationFocusNode,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, locationFocusNode,
                                dateOfBirthFocusNode);
                          },
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.location_on,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                            hintText: 'Location',
                            labelText: 'Location',
                          ),
                        ),
                        DateTimeField(
                          focusNode: dateOfBirthFocusNode,
                          controller: dateOfBirthController,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.date_range,
                              size: 24,
                              color: Theme.of(context).accentColor,
                            ),
                            hintStyle: Theme.of(context).textTheme.caption,
                            labelStyle: Theme.of(context).textTheme.body1,
                            hintText: 'Date of birth',
                            labelText: 'Date of birth',
                          ),
                          format: format,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1980),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2030));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              bloc: profileBloc,
              builder: (context, state) {
                if (state is InProgressState) {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).accentColor),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Update profile user...',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ));
                }
                if (state is FinishProgressState) {
                  return Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Theme.of(context).accentColor,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Icons.check,
                            size: 40,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  _showDialogImageOption(BuildContext context) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Choose source',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            children: <Widget>[
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      File fileImage = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 300,
                          maxHeight: 300);
                      setState(() {
                        fileImageProfile = fileImage;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.photo_library,
                          color: Theme.of(context).accentColor,
                          size: 24,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Image gallery',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            )),
                      ],
                    )),
              ),
              SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                    File fileImage = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 1920,
                        maxHeight: 1028,
                        imageQuality: 100);
                    setState(() {
                      fileImageProfile = fileImage;
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).accentColor,
                        size: 24,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Camera ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          )),
                    ],
                  )),
            ],
          );
        });
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocusNode,
      FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }
}
