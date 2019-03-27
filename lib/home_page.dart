import 'package:flutter/material.dart';
import 'package:flutter_app/home_banner.dart';
import 'package:flutter_app/model/home_article_bean.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app/manager/api_manager.dart';
import 'package:flutter_app/constant/textsize_const.dart';
import 'package:flutter_app/widget/item_home_article.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<HomeBanner> banners = List();
  List<Article> articles = List();

  // banner 控制器
  SwiperController _bannerController = SwiperController();
  ScrollController _scrollController = ScrollController();

  //  请求首页文章页码
  int curPage = 0;

  @override
  void initState() {
    super.initState();
    getBanner();
    getList(false);
    _bannerController.autoplay = true;
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScroll == pixels) {
        curPage++;
        getList(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget listView = ListView.builder(
      itemBuilder: (context, index) {
        return index == 0
            ? createBannerItem()
            : HomeArticleItem(articles[index - 1]);
      },
      itemCount: articles.length - 1,
      controller: _scrollController,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("推荐文章"),
        backgroundColor: Color.fromARGB(255, 199, 136, 213),
        centerTitle: true,
      ),
      body: RefreshIndicator(child: listView, onRefresh: _pullToRefresh),
    );
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    await getList(false);
    return null;
  }

  /// 创建banner条目
  Widget createBannerItem() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: banners.length != 0
          ? Swiper(
              autoplayDelay: 3500,
              controller: _bannerController,
              itemWidth: MediaQuery.of(context).size.width,
              itemHeight: 180,
              pagination: pagination(),
              itemBuilder: (BuildContext context, int index) {
                return new Image.network(
                  banners[index].imagePath,
                  fit: BoxFit.fill,
                );
              },
              itemCount: banners.length,
              viewportFraction: 0.8,
              scale: 0.9,
            )
          : SizedBox(
              width: 0,
              height: 0,
            ),
    );
  }

  SwiperPagination pagination() => SwiperPagination(
      margin: EdgeInsets.all(0.0),
      builder: SwiperCustomPagination(
          builder: (BuildContext context, SwiperPluginConfig config) {
        return Container(
          color: Colors.black45,
          height: 40,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            children: <Widget>[
              Text(
                "${banners[config.activeIndex].title}",
                style: TextStyle(
                    fontSize: TextSizeConst.smallTextSize, color: Colors.white),
              ),
              Expanded(
                flex: 1,
                child: new Align(
                  alignment: Alignment.centerRight,
                  child: new DotSwiperPaginationBuilder(
                          color: Colors.white70,
                          activeColor: Colors.green,
                          size: 6.0,
                          activeSize: 6.0)
                      .build(context, config),
                ),
              )
            ],
          ),
        );
      }));

  void getBanner() async {
    Response response = await ApiManager().getHomeBanner();
    var homeBannerBean = HomeBannerBean.fromJson(response.data);
    setState(() {
      banners.clear();
      banners.addAll(homeBannerBean.data);
    });
  }

  /// 获取首页推荐文章数据
  Future<Null> getList(bool loadMore) async {
    Response response = await ApiManager().getHomeArticle(curPage);
    var homeArticleBean = HomeArticleBean.fromJson(response.data);
    setState(() {
      if (loadMore) {
        articles.addAll(homeArticleBean.data.datas);
      } else {
        articles.clear();
        articles.addAll(homeArticleBean.data.datas);
      }
    });
  }
}
