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
  late List<Animation<Offset>> _animations;
  List<bool> cardVisible = List.generate(10, (_) => true);  // 10 kart için görünürlük listesi
  List<int?> droppedCardIndices = List.generate(3, (_) => null); // Her DragTarget için ayrı indeks
  int dropCount = 0; // Bırakılan kart sayısını takip eder

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 10 kart için animasyonlar oluşturuluyor
    _animations = List.generate(10, (index) {
      int group = index < 5 ? 1 : -1; // İlk 5 kart sağa, diğer 5 kart sola kayacak
      double baseOffset = 100; // Offset'i biraz küçülttüm
      double end = group * (baseOffset * (index % 5 + 0.5));
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
      child: SingleChildScrollView( // Yatay kaydırma sağlamak için
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: screenWidth + 800, // Kartlar için ekstra genişlik
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Kartların gösterimi için animasyonlar
              ...List.generate(10, (index) {
                return AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    double cardLeftPosition = screenWidth / 2 -
                        cardWidth / 2 +
                        _animations[index].value.dx;
                    return Positioned(
                      left: cardLeftPosition + index, // Kartlar arasında mesafe koymak için
                      top: MediaQuery.of(context).size.height / 2 - 100,
                      child: cardVisible[index] && dropCount < 3 // 3 kart bırakıldıktan sonra bırakmayı engelle
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

              // İlk DragTarget
              Positioned(
                left: screenWidth / 2 - 200,
                top: MediaQuery.of(context).size.height / 2 -300,
                child: DragTarget<int>(
                  onWillAcceptWithDetails: (data) {
                    return dropCount < 3; // 3 kart bırakıldıktan sonra kabul etme
                  },
                  onAcceptWithDetails: (details) {
                    int data = details.data; // Bırakılan kartın indeksini alıyoruz
                    setState(() {
                      droppedCardIndices[0] = data;
                      cardVisible[data] = false; // İlgili kartı görünmez yap
                      dropCount++; // Bırakılan kart sayısını artır
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
                        child: droppedCardIndices[0] != null
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

              // İkinci DragTarget
              Positioned(
                left: screenWidth / 2 - 50,
                top: MediaQuery.of(context).size.height / 2 -300,
                child: DragTarget<int>(
                  onWillAcceptWithDetails: (data) {
                    return dropCount < 3; // 3 kart bırakıldıktan sonra kabul etme
                  },
                  onAcceptWithDetails: (details) {
                    int data = details.data; // Bırakılan kartın indeksini alıyoruz
                    setState(() {
                      droppedCardIndices[1] = data;
                      cardVisible[data] = false; // İlgili kartı görünmez yap
                      dropCount++; // Bırakılan kart sayısını artır
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
                        child: droppedCardIndices[1] != null
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

              // Üçüncü DragTarget
              Positioned(
                left: screenWidth / 2 + 100,
                top: MediaQuery.of(context).size.height / 2 -300,
                child: DragTarget<int>(
                  onWillAcceptWithDetails: (data) {
                    return dropCount < 3; // 3 kart bırakıldıktan sonra kabul etme
                  },
                  onAcceptWithDetails: (details) {
                    int data = details.data; // Bırakılan kartın indeksini alıyoruz
                    setState(() {
                      droppedCardIndices[2] = data;
                      cardVisible[data] = false; // İlgili kartı görünmez yap
                      dropCount++; // Bırakılan kart sayısını artır
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
                        child: droppedCardIndices[2] != null
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

        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
