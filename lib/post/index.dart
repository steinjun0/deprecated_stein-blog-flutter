import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:stein_blog/API.dart' as API;

class PostDetail extends StatelessWidget {
  final postDetailController = Get.put(PostDetailController());

  PostDetail({Key? key}) : super(key: key) {
    postDetailController.getPostDetail();
  }

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          title: Text("stein blog"),
        ),
        body: GetBuilder<PostDetailController>(builder: (context) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      '${postDetailController.isLoading() ? 'loading' : postDetailController.postDetail['title']}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Text('${postDetailController.postDetail}'),
                    Html(
                      data: postDetailController.isLoading()
                          ? 'loading...'
                          : postDetailController.postDetail['html'],
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      );
}

class PostDetailController extends GetxController {
  var postDetail;

  bool isLoading() => postDetail == null;

  String cleanTitleString(title) {
    return title.replaceAll('\\', ' ');
  }

  void getPostDetail() async {
    postDetail = await API.getPostDetail(Get.parameters['param']);
    postDetail['title'] = cleanTitleString(postDetail['title']);
    update();
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
