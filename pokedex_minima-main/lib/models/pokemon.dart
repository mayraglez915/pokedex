
class Pokemon {
  final int id;
  final String nombre;
  final String imagen;
  final List<String> tipos;
  final double altura;
  final double peso;

  Pokemon({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.tipos,
    required this.altura,
    required this.peso,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      nombre: json['name'],
      imagen: json['sprites']['other']
          ['official-artwork']['front_default'],
      tipos: (json['types'] as List)
          .map((tipo) => tipo['type']['name'] as String)
          .toList(),

      // Conversiones de unidades
      altura: json['height'] / 10,
      peso: json['weight'] / 10,
    );
  }
}
