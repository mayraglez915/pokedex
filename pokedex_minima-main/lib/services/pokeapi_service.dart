
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  Future<Pokemon> obtenerPokemon(String nombre) async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${nombre.toLowerCase()}',
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      return Pokemon.fromJson(datos);
    } else if (respuesta.statusCode == 404) {
      throw Exception('Pokémon no encontrado');
    } else {
      throw Exception('Error al consultar la API');
    }
  }
}
