import 'package:app/ui/page/about_page.dart';
import 'package:app/util/event_bus.dart';
import 'package:app/util/layout_util.dart';
import 'package:app/util/log_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/material.dart';

import 'course_page.dart';
import 'learn_page.dart';
import 'mine_page.dart';

/**
 *  TAB 选课  课程  我的 tab的几种处理方式 https://www.jianshu.com/p/3bf61b805d11
 *  返回拦截 多次点击后再退出
 * */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  static int lastExitTime = 0;

  int _currentIndex = 0;
  List<Widget> pages = [CoursePage(),LearnPage(),MinePage()];

  Future<bool> _onBackPressed(context) async {
    int nowExitTime = DateTime.now().millisecondsSinceEpoch;
    if (nowExitTime - lastExitTime > 2000) {
      lastExitTime = nowExitTime;
      ToastUtil.show('再按一次退出程序');
      return await Future.value(false);
    }
    return await Future.value(true);
  }


  @override
  void initState() {
    super.initState();
    this.onListener();
  }

  void onListener(){
    eventBus.on("gotoHome",(res){
      Log.i("goto");
      if(mounted){
        setState(() {
          _currentIndex = 0;
        });
      }
    });
  }

  void onTabTapped(){

  }

  BottomNavigationBarItem barItem(String title,Image selectIcon,Image defIcon,int index){
    return  BottomNavigationBarItem(
        title: new Text(title,style: TextStyle(color: _currentIndex == index ? Colors.orangeAccent : Colors.grey)), icon: Container(child: _currentIndex == index ? selectIcon : defIcon,width: LayoutUtil.auto(52),));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return _onBackPressed(context);
      },
      child:Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            barItem("选课",Image.asset("./assets/image/icons-tab-01a.png",),Image.asset("./assets/image/icons-tab-01b.png"),0),
            barItem("课堂",Image.asset("./assets/image/icons-tab-02a.png"),Image.asset("./assets/image/icons-tab-02b.png"),1),
            barItem("我的",Image.asset("./assets/image/icons-tab-03a.png"),Image.asset("./assets/image/icons-tab-03b.png"),2)
          ],
        ),
      )
    );
  }
}
