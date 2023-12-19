import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Qui sommes-nous",
          style: TextStyle(
              fontFamily: 'Michroma',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo baraka.PNG',
                width: 200, // Set your desired width
                height: 250, // Set your desired height
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 41),
              const Text(
                'On est ravi de vous présenter notre société de vente de produits agricoles. Nous sommes fiers de proposer une large gamme de produits de qualité supérieure pour les agriculteurs et les jardiniers. Nous croyons que l’agriculture durable est la clé d’un avenir prospère pour notre planète et notre communauté. C’est pourquoi nous nous engageons à fournir des produits respectueux de l’environnement qui aident les agriculteurs à maximiser leur rendement tout en préservant la terre pour les générations futures. Merci de faire confiance à notre société pour vos besoins en produits agricoles.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
