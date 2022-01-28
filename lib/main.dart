import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'API.dart' as API;

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  final postController = Get.put(PostController());
  var count = 0.obs;

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          title: Text("counter"),
        ),
        body: GetBuilder<PostController>(
          builder: (context) {
            return Center(
              child: Column(children: [
                ElevatedButton(
                    onPressed: postController.getMainPagePosts,
                    child: const Text('get Main List')),
                Expanded(
                  child: ListView.separated(
                    itemCount: postController.postsTextList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: postController.postsTextList[index],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ]),
            );
          },
        ),
      );
}

class PostController extends GetxController {
  Map<String, List> posts = {'programming': [], 'camera': [], 'music': []};
  List<Widget> postsTextList = [];

  Widget getPostWidget(String category, String title) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void getMainPagePosts() async {
    posts = Map<String, List>.from(await API.getMainPageList());
    update();
    postsTextList = [];
    for (var i = 0; i < posts['programming']!.length; i++) {
      postsTextList.add(Column(
        children: [
          Row(
            children: [
              getPostWidget('programming', posts['programming']![i]['title'])
            ],
          )
        ],
      ));
    }
  }

  ListView getMainPagePostsListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 18),
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text(
                    'programming',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    'test',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
