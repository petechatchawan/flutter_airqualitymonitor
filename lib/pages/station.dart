import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Station extends StatefulWidget {
  const Station({
    super.key,
    required this.id,
    required this.name,
    required this.lastdate,
    required this.lasttime,
  });
  final String id;
  final String name;
  final String lastdate;
  final String lasttime;
  @override
  State<Station> createState() => _StationState();
}

class _StationState extends State<Station> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Stack();
  }
}
