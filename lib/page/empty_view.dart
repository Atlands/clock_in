import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.date_range_outlined,
              size: 150,
              color: Colors.grey.withOpacity(0.5),
            ),
            Text('没有记录',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey.withOpacity(0.5),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 100)
          ],
        ));
  }
}