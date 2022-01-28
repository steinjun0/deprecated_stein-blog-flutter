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
                  Expanded(
                    child: ListView.builder(
                      itemCount: postController.postList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 24, 16, 0),
                                child: Text(
                                  'Stein Blog',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(12, 4, 16, 0),
                                child: Text(
                                    'Programming, Music, Camera, and Life'),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                            ],
                          );
                        } else {
                          return InkWell(
                            onTap: () => {
                              Get.toNamed(
                                  '/post/${postController.posts[index - 1]['id']}')
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                  child: Container(
                                    constraints: BoxConstraints(minHeight: 50),
                                    child: postController.postList[index - 1],
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class PostController extends GetxController {
  List posts = [];
  List<Widget> postList = [];

  Widget getPostWidget(
      String category, String title, String subTitle, String date) {
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
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  subTitle,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              )
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
            children: [
              getPostWidget(
                  '[$categoriesText]',
                  posts[i]['title'],
                  posts[i]['sub_title'],
                  posts[i]['created_at'].substring(0, 10))
            ],
          )
        ],
      ));
    }
  }
}
