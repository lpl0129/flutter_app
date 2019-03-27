import 'package:flutter/material.dart';
import 'package:flutter_app/manager/api_manager.dart';
import 'package:flutter_app/model/project_list_bean.dart';
import 'package:flutter_app/widget/item_project.dart';

/// 项目列表页
class ProjectListPage extends StatefulWidget {
  int cid = 0;

  ProjectListPage({@required this.cid});

  @override
  State<StatefulWidget> createState() {
    return _ProjectListState();
  }
}

class _ProjectListState extends State<ProjectListPage> with AutomaticKeepAliveClientMixin {

  int index = 1;
  List<Project> projects = List();


  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (BuildContext context, int position){
        return ProjectItem(projects[position]);
      },
    );
  }

  /// 获取项目列表
  void getList() async {
    await ApiManager().getProjectList(widget.cid, index)
        .then((response){
          if(response != null){
            var projectListBean = ProjectListBean.fromJson(response.data);
            setState(() {
              projects.addAll(projectListBean.data.datas);
            });
          }
    });
  }


  @override
  bool get wantKeepAlive => true;

}
