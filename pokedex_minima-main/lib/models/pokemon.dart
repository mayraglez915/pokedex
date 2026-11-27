
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
  final List<String> movimientos;

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
    required this.movimientos,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      nombre: json['name'],
      imagen: json['sprites']['other']['official-artwork']
              ['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      tipos: (json['types'] as List)
          .map((tipo) => tipo['type']['name'].toString())
          .toList(),
      altura: (json['height'] as num).toDouble() / 10,
      peso: (json['weight'] as num).toDouble() / 10,
      experiencia: json['base_experience'] ?? 0,
      habilidades: (json['abilities'] as List)
          .map((habilidad) =>
              habilidad['ability']['name'].toString())
          .toList(),
      estadisticas: {
        for (var stat in json['stats'])
          stat['stat']['name'].toString():
              stat['base_stat'] as int,
      },
      movimientos: (json['moves'] as List)
          .take(10)
          .map((movimiento) =>
              movimiento['move']['name'].toString())
          .toList(),
    );
  }
}
