
import 'package:eventell/shared/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleButtonCategory extends StatelessWidget {
  final name;
  final icon;
  const CircleButtonCategory({Key key, this.name, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizing.circleCategorySizePadd),
      child: Column(
        children: <Widget>[
          Container(
            width: Sizing.circleCategorySize,
            height: Sizing.circleCategorySize,
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: new Icon(
              this.icon,
              color: Colors.black,
            ),
          ),
          Text(this.name)
        ],
      ),
    );
  }
}