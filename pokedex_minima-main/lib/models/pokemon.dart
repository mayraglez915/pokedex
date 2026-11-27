class Pokemon {
  final int id;
  final String nombre;
  final String imagen;
  final List<String> tipos;
  final double altura;
  final double peso;
  final int experienciaBase;

  Pokemon({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.tipos,
    required this.altura,
    required this.peso,
    required this.experienciaBase,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
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
    );
  }
}
