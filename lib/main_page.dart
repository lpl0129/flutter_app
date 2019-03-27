import 'package:flutter/material.dart';
import 'package:flutter_app/home_page.dart';
import 'package:flutter_app/view/project_practice_page.dart';
import 'package:flutter_app/view/wechat_article_page.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> with TickerProviderStateMixin {
  var _pageCtr;
  int _tabIndex = 0;

  @override
  void initState() {
    _pageCtr = PageController(initialPage: 0, keepPage: true);
  }

  @override
  void dispose() {
    _pageCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: _pageCtr,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            ProjectPracticePage(),
            WechatArticlePage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.deepPurpleAccent,
          onTap: (index) => _tap(index),
          items: [
            BottomNavigationBarItem(title: Text("推荐"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(title: Text("项目"), icon: Icon(Icons.map)),
            BottomNavigationBarItem(
                title: Text("公众号"), icon: Icon(Icons.contact_mail))
          ],
        ),
      ),
    );
  }

  _tap(int index) {
    setState(() {
      _tabIndex = index;
      _pageCtr.jumpToPage(index);
    });
  }
}
