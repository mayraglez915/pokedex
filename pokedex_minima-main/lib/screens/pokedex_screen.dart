
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

  void _limpiar() {
    setState(() {
      _controlador.clear();
      _futuroPokemon = null;
    });
  }

  Color _colorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'fire': return Colors.deepOrange;
      case 'water': return Colors.blue;
      case 'grass': return Colors.green;
      case 'electric': return Colors.amber;
      case 'psychic': return Colors.purple;
      case 'ice': return Colors.cyan;
      case 'fighting': return Colors.brown;
      case 'poison': return Colors.deepPurple;
      case 'ground': return Colors.orange;
      case 'rock': return Colors.blueGrey;
      case 'fairy': return Colors.pink;
      case 'flying': return Colors.indigo;
      case 'bug': return Colors.lightGreen;
      case 'ghost': return Colors.deepPurpleAccent;
      case 'dragon': return Colors.teal;
      case 'dark': return Colors.black87;
      case 'steel': return Colors.grey;
      default: return Colors.green;
    }
  }

  Widget _dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(titulo,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Flexible(
            child: Text(valor,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _seccion(String titulo, List<Widget> elementos) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ...elementos,
        ],
      ),
    );
  }

  Widget _tarjetaPokemon(Pokemon p) {
    final color = p.tipos.isNotEmpty
        ? _colorTipo(p.tipos.first)
        : Colors.green;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text('#${p.id.toString().padLeft(3, '0')}',
                style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            if (p.imagen.isNotEmpty)
              Image.network(
                p.imagen,
                height: 190,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.catching_pokemon, size: 120),
              ),
            Text(
              p.nombre.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: p.tipos.map((tipo) {
                return Chip(
                  label: Text(tipo.toUpperCase()),
                  backgroundColor: _colorTipo(tipo).withOpacity(0.25),
                );
              }).toList(),
            ),
            _seccion('Información general', [
              _dato('Altura', '${p.altura} m'),
              _dato('Peso', '${p.peso} kg'),
              _dato('Experiencia', '${p.experiencia} puntos'),
              _dato('Habilidades', p.habilidades.join(', ')),
            ]),
            _seccion('Estadísticas', [
              _dato('Vida', '${p.estadisticas['hp'] ?? 0}'),
              _dato('Ataque', '${p.estadisticas['attack'] ?? 0}'),
              _dato('Defensa', '${p.estadisticas['defense'] ?? 0}'),
              _dato('Velocidad', '${p.estadisticas['speed'] ?? 0}'),
              _dato('Ataque especial',
                  '${p.estadisticas['special-attack'] ?? 0}'),
              _dato('Defensa especial',
                  '${p.estadisticas['special-defense'] ?? 0}'),
            ]),
            _seccion('Movimientos', [
              ...p.movimientos.map((m) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.flash_on),
                    title: Text(m),
                  )),
            ]),
          ],
        ),
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
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text('Mi Pokédex'),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controlador,
              decoration: InputDecoration(
                labelText: 'Escribe el nombre del Pokémon',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onSubmitted: (_) => _buscar(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _buscar,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: _limpiar,
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _futuroPokemon == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.catching_pokemon,
                              size: 90, color: Colors.red),
                          SizedBox(height: 10),
                          Text('Busca tu Pokémon favorito'),
                        ],
                      ),
                    )
                  : FutureBuilder<Pokemon>(
                      future: _futuroPokemon,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                              child: Text(
                                  'No se encontró el Pokémon. Intenta nuevamente.'));
                        }

                        return _tarjetaPokemon(snapshot.data!);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
