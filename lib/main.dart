import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddScreen(),
    );
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;

  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: Stack(
      children: [
        Container(
            alignment: Alignment.bottomCenter,
            height: size.height - 300,
            color: Colors.red,
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: OpenTopPainter(isOpen),
                    child: Container(
                      height: 65,
                      width: double.infinity,

                      // child: Icon(Icons.add),
                    ),
                  ),
                  Positioned(
                      right: size.width * 0.4,
                      left: size.width * 0.4,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                          if (isOpen) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: EdgeInsets.only(bottom: isOpen ? 0 : 4),
                          decoration: BoxDecoration(
                              boxShadow: isOpen
                                  ? []
                                  : [
                                      const BoxShadow(
                                          spreadRadius: 1,
                                          offset: Offset(0, 5),
                                          blurRadius: 10,
                                          blurStyle: BlurStyle.normal,
                                          color: Color.fromARGB(255, 92, 0, 31))
                                    ],
                              color: Colors.pink,
                              borderRadius: isOpen
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))
                                  : BorderRadius.circular(15)),
                          height:
                              isOpen ? size.height * 0.078 : size.height * 0.07,
                          width: 40,
                          child: Center(
                            child: AnimatedIcon(
                                icon: AnimatedIcons.event_add,
                                size: 40,
                                progress: animationController),
                          ),
                        ),
                      )),
                ],
              ),
            )),
        AnimatedPositioned(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          bottom: 60,
          height: animationController.value * 150,
          right: MediaQuery.sizeOf(context).width * 0.45 -
              MediaQuery.sizeOf(context).width *
                  0.25 *
                  animationController.value,
          left:
              size.width * 0.45 - size.width * 0.25 * animationController.value,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.pink, borderRadius: BorderRadius.circular(15)),
            child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0),
                  end: const Offset(0, 1),
                ).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Curves.fastOutSlowIn,
                )),
                child: Text(
                  "TEXT",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 25 * animationController.value),
                )),
          ),
        ),
      ],
    ));
  }
}

/*Stack(
        children: [
          Center(
            child: Cube(
              onObjectCreated: (object) {
                object.mesh;
              },
              onSceneCreated: (Scene scene) {
                scene.camera.zoom = 10;
                scene.world.add(Object(
                    fileName: 'assets/c.obj',
                    lighting: true,
                    scene: Scene(
                      onUpdate: () {},
                    )));
              },
            ),
          ),
          Positioned(
              child:*/

class OpenTopPainter extends CustomPainter {
  final bool isOpen;

  OpenTopPainter(this.isOpen);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 5)
      ..lineTo(size.width * 0.35, 5)
      ..quadraticBezierTo(
        size.width * 0.4,
        5,
        size.width * 0.40,
        20,
      )
      ..arcToPoint(Offset(size.width * 0.6, 20),
          clockwise: false, radius: const Radius.circular(01))
      ..quadraticBezierTo(
        size.width * 0.6,
        5,
        size.width * 0.65,
        5,
      )
      ..lineTo(size.width, 5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close;

    final path2 = Path()
      ..moveTo(0, 5)
      ..lineTo(size.width * 0.35, 5)
      ..lineTo(size.width, 5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close;
    final paint = Paint()..color = Colors.white;
    canvas.drawShadow(isOpen ? path : path2, Colors.white, 5, true);
    canvas.drawPath(isOpen ? path : path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
