import 'package:shared_preferences/shared_preferences.dart';

class SessaoService {
  static const _usuarioIdKey = 'usuario_id';

  static Future<void> salvarUsuarioLogado(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_usuarioIdKey, id);
  }

  static Future<int?> obterUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_usuarioIdKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioIdKey);
  }
}
