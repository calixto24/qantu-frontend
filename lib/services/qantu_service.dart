/// Contrato del servicio que responde las preguntas de los niños.
/// Hoy se usa MockQantuService (respuestas de prueba).
/// Cuando el backend este listo, se crea ApiQantuService que implemente
/// esta misma clase y se cambia en un solo lugar, sin tocar las pantallas.
abstract class QantuService {
  Future<String> responder(String pregunta);
}

/// Version simulada: espera un par de segundos y devuelve un texto fijo.
class MockQantuService implements QantuService {
  @override
  Future<String> responder(String pregunta) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'El gran imperio inca se llamaba Tawantinsuyo porque estaba '
        'formado por 4 grandes regiones (suyos) unidas desde el ombligo '
        'sagrado del Cusco.';
  }
}