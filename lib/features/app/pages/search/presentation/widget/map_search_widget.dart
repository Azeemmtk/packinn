import 'package:flutter/material.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';

class MapSearchWidget extends StatelessWidget {
  const MapSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height * 0.3,
          color: textFieldColor,
          child: Center(child: Text('Map')),
        ),
        height5,
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                'Find On Map',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
        height20,
      ],
    );
  }
}
