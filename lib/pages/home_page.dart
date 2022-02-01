import 'package:flutter/material.dart';
import 'package:heremego/models/post_model.dart';
import 'package:heremego/pages/detail_page.dart';
import 'package:heremego/sevices/auth_service.dart';
import 'package:heremego/sevices/prefs_service.dart';
import 'package:heremego/sevices/rtdb_sevice.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  _apiGetPosts() async {
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts) => {
          _resPosts(posts),
        });
  }

  _resPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  Future _openDetail() async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const DetailPage();
    }));
  if(results.isNotEmpty && results.containsKey("data")){
    print(results["data"]);
    _apiGetPosts();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("All Post"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => AuthService.signOutUser(context),
                icon: const Icon(Icons.exit_to_app_outlined))
          ],
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemList(post: items[index]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openDetail,
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ));
  }
}

class ItemList extends StatelessWidget {
  Post post;

  ItemList({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            post.content,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
