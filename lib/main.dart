import 'package:flutter/material.dart';
import 'falastra_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Card Animation')),
        body: const Center(
          child: CardAnimationWidget(),
        ),
      ),
    );
  }
}

class CardAnimationWidget extends StatefulWidget {
  const CardAnimationWidget({super.key});

  @override
  _CardAnimationWidgetState createState() => _CardAnimationWidgetState();
}

class _CardAnimationWidgetState extends State<CardAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Animation<Offset>> _animations = [];
  List<bool> cardVisible = [true, true, true, true];
  int? droppedCardIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animations = List.generate(4, (index) {
      int group = index < 2 ? 1 : -1;
      double baseOffset = 100;
      double end = group * (baseOffset * (index % 2 + 0.5));
      return Tween<Offset>(
        begin: const Offset(0, 0),
        end: Offset(end, 0),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const cardWidth = 100.0;

    return GestureDetector(
      onTap: () {
        _controller.forward();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(4, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                // Animasyon başlamadan önce kartlar merkezde üst üste duracak
                double cardLeftPosition = screenWidth / 2 -
                    cardWidth / 2 +
                    _animations[index].value.dx;
                return Positioned(
                  left: cardLeftPosition,
                  top: MediaQuery.of(context).size.height / 2 -150,
                  child: cardVisible[index]
                      ? Draggable(
                          data: index,
                          feedback: const Material(
                            child: FalastraCard(),
                          ),
                          childWhenDragging: Container(),
                          child: const FalastraCard(),
                        )
                      : Container(),
                );
              },
            );
          }),

          Positioned(
            left: screenWidth / 2 - 50,
            top: MediaQuery.of(context).size.height / 2 + 50,
            child: DragTarget<int>(
              onWillAcceptWithDetails: (data) {
                return true;
              },
              onAcceptWithDetails: (details) {
                int data = details.data; // Fickleness veriyi burada alıyoruz.
                setState(() {
                  droppedCardIndex = data;
                  cardVisible[data] = false; // İlgili kartı görünmez yap
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kart $data bırakıldı')),
                );
              },

              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100,
                  height: 150,
                  color: Colors.blue.withOpacity(0.5),
                  child: Center(
                    child: droppedCardIndex != null
                        ? const FalastraCard()
                        : const Text(
                            'Buraya bırak',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
