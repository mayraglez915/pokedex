
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

  Pokemon? pokemon;
  bool cargando = false;
  String error = '';

  Future<void> buscarPokemon() async {
    final nombre = _controlador.text.trim().toLowerCase();

    if (nombre.isEmpty) {
      setState(() {
        error = 'Escribe el nombre o número de un Pokémon';
        pokemon = null;
      });
      return;
    }

    setState(() {
      cargando = true;
      error = '';
      pokemon = null;
    });

    try {
      final resultado = await _servicio.obtenerPokemon(nombre);

      if (!mounted) return;

      setState(() {
        pokemon = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        pokemon = null;
        cargando = false;
        error = 'No se encontró el Pokémon. Intenta nuevamente.';
      });
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFDC3545),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.catching_pokemon,
                size: 75,
                color: Color(0xFFDC3545),
              ),

              const SizedBox(height: 10),

              const Text(
                '¡Encuentra tu Pokémon!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Busca por nombre o número de Pokédex',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: _controlador,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => buscarPokemon(),
                decoration: InputDecoration(
                  hintText: 'Ejemplo: pikachu o 25',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: cargando ? null : buscarPokemon,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    'Buscar Pokémon',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC3545),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (cargando)
                const Column(
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFFDC3545),
                    ),
                    SizedBox(height: 12),
                    Text('Buscando Pokémon...'),
                  ],
                ),

              if (error.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              if (pokemon != null)
                tarjetaPokemon(pokemon!),
            ],
          ),
        ),
      ),
    );
  }

  Widget tarjetaPokemon(Pokemon p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '#${p.id.toString().padLeft(3, '0')}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          if (p.imagen.isNotEmpty)
            Image.network(
              p.imagen,
              height: 190,
              width: 190,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                );
              },
            ),

          const SizedBox(height: 10),

          Text(
            p.nombre.toUpperCase(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: p.tipos.map((tipo) {
              return Chip(
                label: Text(
                  tipo.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFFDC3545),
              );
            }).toList(),
          ),

          const Divider(height: 30),

          filaDato('Altura', '${p.altura} m'),
          filaDato('Peso', '${p.peso} kg'),
          filaDato('Experiencia base', '${p.experiencia}'),

          const Divider(height: 30),

          seccionTitulo('Habilidades'),
          Wrap(
            spacing: 6,
            children: p.habilidades.map((habilidad) {
              return Chip(label: Text(habilidad));
            }).toList(),
          ),

          const Divider(height: 30),

          seccionTitulo('Estadísticas'),

          ...p.estadisticas.entries.map((stat) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stat.key.replaceAll('-', ' ').toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${stat.value}'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: (stat.value / 255).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: const Color(0xFFDC3545),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 30),

          seccionTitulo('Movimientos'),

          Wrap(
            spacing: 6,
            children: p.movimientos.map((movimiento) {
              return Chip(
                label: Text(movimiento.replaceAll('-', ' ')),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget filaDato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(valor),
        ],
      ),
    );
  }

  Widget seccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
