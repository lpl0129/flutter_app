import 'package:flutter/material.dart';
import 'package:flutter_app/model/home_article_bean.dart';
import 'package:flutter_app/view/webview_page.dart';
import 'package:flutter_app/constant/textsize_const.dart';

/// 首页文章列表条目
class HomeArticleItem extends StatefulWidget {
  Article article;
  HomeArticleItem(this.article);

  @override
  State<StatefulWidget> createState() {
    return _HomeArticleState();
  }
}

class _HomeArticleState extends State<HomeArticleItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (ctx) => WebViewPage(
                    title: widget.article.title, url: widget.article.link)));
      },
      child: Card(
        color: Colors.white,
          margin: EdgeInsets.fromLTRB(5,5,5,0),
          child: Container(
            padding: EdgeInsets.fromLTRB(18,10,18,10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      color: Colors.black,
                      size: 18,
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.article.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black),
                          ),
                        ))
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      widget.article.title.replaceAll("&rdquo;", "").replaceAll("&ldquo;", ""),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: TextSizeConst.middleTextSize),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.black,
                      size: 15,
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            widget.article.niceDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black45),
                          ),
                        ))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
