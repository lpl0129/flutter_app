import 'package:flutter/material.dart';
import 'package:flutter_app/model/project_classify_bean.dart';
import 'package:flutter_app/widget/async_snapshot_widget.dart';
import 'package:flutter_app/view/project_list_page.dart';
import 'package:flutter_app/manager/api_manager.dart';
import 'package:dio/dio.dart';

class ProjectPracticePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProjectPracticeState();
}

class _ProjectPracticeState extends State<ProjectPracticePage>
    with SingleTickerProviderStateMixin {
  TabController _tabCtrl;
  var _tabsName = List<String>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: _buildFuture, future: getProjectClassify());
  }

  Widget _buildFuture(
      BuildContext context, AsyncSnapshot<List<ProjectClassify>> snapshot) {
    return AsyncSnapshotWidget(
      snapshot: snapshot,
      successWidget: (snapshot) {
        if (snapshot.data != null) {
          _parseWeChatCounts(snapshot.data);
          if (_tabCtrl == null) {
            _tabCtrl = TabController(
                length: snapshot.data.length, vsync: this, initialIndex: 0);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("项目"),
              backgroundColor: Colors.greenAccent,
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                TabBar(
                  indicatorColor: Colors.greenAccent,
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.black45,
                  controller: _tabCtrl,
                  isScrollable: true,
                  tabs: _createTabs(),
                ),
                Expanded(
                    flex: 1,
                    child: TabBarView(
                        controller: _tabCtrl,
                        children: _createPages(snapshot.data)))
              ],
            ),
          );
        }
      },
    );
  }

  /// 网络请求，获取项目分类
  Future<List<ProjectClassify>> getProjectClassify() async {
    try {
      Response response;
      response = await ApiManager().getProjectClassify();
      return ProjectClassifyBean.fromJson(response.data).data;
    } catch (e) {
      return null;
    }
  }

  /// 生成顶部tab
  List<Widget> _createTabs() {
    List<Widget> widgets = List();
    for (String item in _tabsName) {
      var tab = Tab(
        text: item,
      );
      widgets.add(tab);
    }
    return widgets;
  }

  /// 创建项目列表页
  List<Widget> _createPages(List<ProjectClassify> projectClassify) {
    List<Widget> widgets = List();
    for (ProjectClassify project in projectClassify) {
      var page = ProjectListPage(cid: project.id);
      widgets.add(page);
    }
    return widgets;
  }

  /// 解析项目列表
  void _parseWeChatCounts(List<ProjectClassify> projectClassify) {
    _tabsName.clear();
    for (ProjectClassify project in projectClassify) {
      _tabsName.add(project.name);
    }
  }
}
