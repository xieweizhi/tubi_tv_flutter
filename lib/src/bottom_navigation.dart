import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onSelectedTab;

  BottomNavigation({Key key, @required this.currentTab, this.onSelectedTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: Color(0xff26262d)),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [_makeItem(0), _makeItem(1), _makeItem(2)],
            onTap: (index) => onSelectedTab(index)));
  }

  BottomNavigationBarItem _makeItem(int index) {
    const images = [
      "assets/icons/home_normal.png",
      "assets/icons/browse_normal.png",
      "assets/icons/search_normal.png"
    ];
    const selectedImages = [
      "assets/icons/home_selected.png",
      "assets/icons/browse_selected.png",
      "assets/icons/search_selected.png"
    ];
    const titles = ["Home", "Browse", "Search"];
    var image = (index == currentTab ? selectedImages : images)[index];

    var selected = index == currentTab;
    var textColor = selected ? Color(0xffee5c32) : Colors.white;

    return BottomNavigationBarItem(
        icon: Container(
            child: Image.asset(image, color: selected ? textColor : null),
            width: 26,
            height: 26),
        title: Text(
          titles[index],
          style: TextStyle(color: textColor, fontSize: 12),
        ));
  }
}
