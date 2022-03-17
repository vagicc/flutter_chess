import 'dart:ui';

import 'package:flutter/material.dart';
import '../common/color_consts.dart';
import '../main.dart';
import 'battle_page.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameStyle = const TextStyle(
      fontSize: 64,
      color: Colors.black,
    );

    final menuItemStyle = TextStyle(
      fontSize: 28,
      color: ColorConsts.Primary,
    );

    //主页
    final menuItems = Center(
      child: Column(
        children: <Widget>[
          const Expanded(child: SizedBox(), flex: 4),
          Text(
            "中国象棋=",
            style: nameStyle,
            textAlign: TextAlign.center,
          ),
          const Expanded(child: SizedBox()),
          TextButton(
            child: Text(
              "单机对战",
              style: menuItemStyle,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const BattlePage();
                }),
              );
            },
          ),
          const Expanded(child: SizedBox()),
          TextButton(
            child: Text(
              "挑战云主机",
              style: menuItemStyle,
            ),
            onPressed: () {},
          ),
          const Expanded(child: SizedBox()),
          TextButton(
            child: Text("排行榜", style: menuItemStyle),
            onPressed: () {},
          ),
          const Expanded(child: SizedBox(), flex: 3),
          Text("將師象棋，益智好玩",
              style: TextStyle(color: Colors.black54, fontSize: 16)),
          const Expanded(child: SizedBox()),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: ColorConsts.LightBackground,
      body: Stack(
        children: <Widget>[
          menuItems,
          //设置按钮
          Positioned(
            child: IconButton(
              icon: const Icon(Icons.settings, color: ColorConsts.Primary),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
