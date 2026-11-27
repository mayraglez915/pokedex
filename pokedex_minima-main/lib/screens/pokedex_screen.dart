import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokeapi_service.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final _controlador = TextEditingController();
  Future<Pokemon>? _futuroPokemon;

  void _buscar() {
    final texto = _controlador.text.trim();

    if (texto.isEmpty) return;

    setState(() {
      _futuroPokemon = obtenerPokemon(texto);
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex mínima'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controlador,
              decoration: const InputDecoration(
                labelText: 'Nombre o número del Pokémon',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
            ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: _buscar,
              child: const Text('Buscar'),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: _futuroPokemon == null
                  ? const Center(
                      child: Text(
                        'Escribe un nombre y presiona Buscar',
                      ),
                    )
                  : FutureBuilder<Pokemon>(
                      future: _futuroPokemon,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          final pokemon = snapshot.data!;

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  pokemon.imagen,
                                  height: 180,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 100,
                                    );
                                  },
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  '#${pokemon.id} - ${pokemon.nombre}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: pokemon.tipos.map((tipo) {
                                    return Chip(
                                      label: Text(tipo),
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  'Altura: ${pokemon.altura.toStringAsFixed(1)} m',
                                  style: const TextStyle(fontSize: 18),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Peso: ${pokemon.peso.toStringAsFixed(1)} kg',
                                  style: const TextStyle(fontSize: 18),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Experiencia base: ${pokemon.experienciaBase} XP',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}