import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/model/data.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/profile/profile_friend.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/avatar_circle_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static final List<User> name = <User>[
    BarackObama,
    DonaldTrump,
    AbrahamLincoln,
    GeorgeWBush,
    GeorgeWashington,
    BarackObama,
  ];

  _MySearchDelegate _delegate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _delegate = _MySearchDelegate(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: InkWell(
            splashColor: Colors.grey,
              onTap: ()async {
              await showSearch(context: context, delegate:_delegate);
              },
              child: Icon(
                Icons.search,
                size: 30,
                color: Colors.black87,
              )),
          title: GestureDetector(
            onTap: ()async {
              await showSearch(context: context, delegate:_delegate);
            },

            child: Text(
              'Search...',
              style: TextStyle(color: Colors.grey, fontSize: 20,fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
      body: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: search.length,
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 2 : 1),
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          itemBuilder: (BuildContext context, int index) => Container(
                color: Colors.white,
                  child: Image.asset(

                    search[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
    );
  }

}

class _MySearchDelegate extends SearchDelegate<List<User>> {
  final List<User> _name;
  final List<User> _historySearch;
  User _selected;

  _MySearchDelegate(List<User> word)
      : this._name = word,
        _historySearch = <User>[BarackObama, AbrahamLincoln];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                this.query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }

// Build leading search Bar
  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.arrow_menu,
        progress: transitionAnimation,
      ),
      onPressed: () {
        this.close(context, null);
      },
    );
  }

// widget of result pager
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  this.close(context, _name);
                },
                child: ListTile(
                    leading: Container(
                      child: CircleAvatar(
                        radius: 60,
                       // backgroundImage: file!=null?FileImage(file):null,
                        child:  Center(
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
                    title: Text(
                      _selected.name,
                      style: TextStyle(color: Colors.black),
                    ))),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final Iterable<User> suggestions = this.query.isEmpty
        ? _historySearch
        : _name.where((word) => word.name.startsWith(query));

    return _SuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (User suggestion) {
        this._selected = suggestion;
        this.query = suggestion.name;
        this._historySearch.insert(0, suggestion);
        showResults(context);
      },
    );
  }
}

// Suggestions list widget displayed in the search page.
class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    this.suggestions,
    this.query,
    this.onSelected,
  });

  final List<User> suggestions;
  final String query;
  final ValueChanged<User> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final List<User> suggestion = suggestions;
        return ListTile(
            leading:Container(
              child: CircleAvatar(
                radius: 60,
                //backgroundImage: file!=null?FileImage(file):null,
                child:  Center(
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
            title: Text(suggestion[i].name),
            onTap: () {
              // onSelected(suggestion[i]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileFriend(
                            user: suggestion[i],
                            post: posts[0],
                          )));
            });
      },
    );
  }
}
