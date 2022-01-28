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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                    child: Column(
                      children: [
                        Text(
                          '${postDetailController.isLoading() ? 'loading' : postDetailController.postDetail['title']}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                '${postDetailController.isLoading() ? 'loading' : postDetailController.postDetail['sub_title']}',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${postDetailController.isLoading() ? 'loading' : postDetailController.getCleanDateString(postDetailController.postDetail['created_at'])}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      children: [
                        // Text('${postDetailController.postDetail}'),
                        Html(
                          data: postDetailController.isLoading()
                              ? 'loading...'
                              : postDetailController.postDetail['html'],
                          style: {
                            "pre": Style(
                              padding: EdgeInsets.fromLTRB(12, 16, 12, 0),
                              backgroundColor: Colors.grey[300],
                              lineHeight: LineHeight.number(1.5),
                            ),
                            "blockquote": Style(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              backgroundColor: Colors.grey[300],
                              fontStyle: FontStyle.italic,
                            ),
                          },
                        ),
                      ],
                    ),
                  )
                ],
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

  String getCleanDateString(date) {
    return date.substring(0, 10) + ' ' + date.substring(11, 19);
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
