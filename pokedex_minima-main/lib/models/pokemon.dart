
class Pokemon {
  final int id;
  final String nombre;
  final String imagen;
  final List<String> tipos;
  final double altura;
  final double peso;
  final int experiencia;
  final List<String> habilidades;
  final Map<String, int> estadisticas;

  Pokemon({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.tipos,
    required this.altura,
    required this.peso,
    required this.experiencia,
    required this.habilidades,
    required this.estadisticas,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] ?? {};
    final other = sprites['other'] ?? {};
    final artwork = other['official-artwork'] ?? {};

    final stats = <String, int>{};
    for (final item in (json['stats'] as List? ?? [])) {
      stats[item['stat']['name']] = item['base_stat'];
    }

    return Pokemon(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? '',
      imagen: artwork['front_default'] ??
          sprites['front_default'] ??
          '',
      tipos: (json['types'] as List? ?? [])
          .map((tipo) => tipo['type']['name'].toString())
          .toList(),
      altura: (json['height'] ?? 0) / 10,
      peso: (json['weight'] ?? 0) / 10,
      experiencia: json['base_experience'] ?? 0,
      habilidades: (json['abilities'] as List? ?? [])
          .map((item) => item['ability']['name'].toString())
          .toList(),
      estadisticas: stats,
    );
  }
}
