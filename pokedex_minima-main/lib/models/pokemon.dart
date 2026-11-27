class Pokemon {
  final int id;
  final String nombre;
  final String imagen;
  final List<String> tipos;
  final double altura;
  final double peso;
  final int experienciaBase;
  final List<String> habilidades;
  final int vida;

  Pokemon({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.tipos,
    required this.altura,
    required this.peso,
    required this.experienciaBase,
    required this.habilidades,
    required this.vida,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final estadisticas = json['stats'] as List;

    return Pokemon(
      id: json['id'],
      nombre: json['name'],
      imagen: json['sprites']['other']
              ['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ?? '',
      tipos: (json['types'] as List)
          .map((tipo) => tipo['type']['name'] as String)
          .toList(),
      altura: (json['height'] as num).toDouble() / 10,
      peso: (json['weight'] as num).toDouble() / 10,
      experienciaBase: json['base_experience'] ?? 0,
      habilidades: (json['abilities'] as List)
          .map((habilidad) =>
              habilidad['ability']['name'] as String)
          .toList(),
      vida: estadisticas.firstWhere(
        (stat) => stat['stat']['name'] == 'hp',
      )['base_stat'] as int,
    );
  }
}