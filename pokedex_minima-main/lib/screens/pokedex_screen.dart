
import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokeapi_service.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final TextEditingController _controlador = TextEditingController();
  final PokeApiService _servicio = PokeApiService();
  Future<Pokemon>? _futuroPokemon;

  void _buscar() {
    final nombre = _controlador.text.trim();
    if (nombre.isEmpty) return;
    setState(() => _futuroPokemon = _servicio.obtenerPokemon(nombre));
  }

  Widget _dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$titulo: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex mínima')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controlador,
              decoration: const InputDecoration(
                labelText: 'Nombre del Pokémon',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _buscar(),
            ),
            const SizedBox(height: 10),
            FilledButton(
                onPressed: _buscar,
                child: const Text('Buscar Pokémon')),
            const SizedBox(height: 16),
            Expanded(
              child: _futuroPokemon == null
                  ? const Center(child: Text('Busca un Pokémon'))
                  : FutureBuilder<Pokemon>(
                      future: _futuroPokemon,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('No se encontró el Pokémon'));
                        }

                        final p = snapshot.data!;
                        return SingleChildScrollView(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  if (p.imagen.isNotEmpty)
                                    Image.network(p.imagen, height: 150),
                                  Text(p.nombre.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  _dato('Tipos', p.tipos.join(', ')),
                                  _dato('Altura', '${p.altura} m'),
                                  _dato('Peso', '${p.peso} kg'),
                                  _dato('Experiencia',
                                      '${p.experiencia} puntos'),
                                  _dato('Habilidades',
                                      p.habilidades.join(', ')),
                                  _dato('Ataque',
                                      '${p.estadisticas['attack'] ?? 0}'),
                                  _dato('Defensa',
                                      '${p.estadisticas['defense'] ?? 0}'),
                                  _dato('Velocidad',
                                      '${p.estadisticas['speed'] ?? 0}'),
                                  _dato('Ataque especial',
                                      '${p.estadisticas['special-attack'] ?? 0}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
