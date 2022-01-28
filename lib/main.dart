import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stein_blog/post/index.dart';

import 'API.dart' as API;

void main() => runApp(
      GetMaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        )),
        getPages: [
          GetPage(
            name: '/',
            page: () => Home(),
          ),
          GetPage(
            name: '/post/:param',
            page: () => PostDetail(),
          ),
        ],
      ),
    );

class Home extends StatelessWidget {
  final postController = Get.put(PostController());

  Home({Key? key}) : super(key: key) {
    postController.getPosts();
  }

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          title: Text("stein blog"),
        ),
        body: GetBuilder<PostController>(
          builder: (context) {
            return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stein Blog',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: postController.postList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => {
                              Get.toNamed(
                                  '/post/${postController.posts[index]['id']}')
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                constraints: BoxConstraints(minHeight: 50),
                                child: postController.postList[index],
                              ),
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
  List posts = [];
  List<Widget> postList = [];

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
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String cleanTitleString(title) {
    return title.replaceAll('\\', ' ');
  }

  void getPosts() async {
    posts = await API.getPostList();
    // posts = Map<String, List>.from(await API.getPostList());
    update();
    postList = [];
    String categoriesText = '';
    for (var i = 0; i < posts.length; i++) {
      categoriesText = '';
      posts[i]['categories'].forEach((category) {
        categoriesText += '${category['name']}, ';
      });
      categoriesText = categoriesText.substring(0, categoriesText.length - 2);
      posts[i]['title'] = cleanTitleString(posts[i]['title']);
      postList.add(Column(
        children: [
          Row(
            children: [getPostWidget('[$categoriesText]', posts[i]['title'])],
          )
        ],
      ));
    }
  }
}
