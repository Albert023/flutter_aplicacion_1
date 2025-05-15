class Gastos {
  final int? id;
  final String descripcion;
  final String categoria;
  final double monto;
  final String fecha;

  Gastos({
    this.id,
    required this.descripcion,
    required this.categoria,
    required this.monto,
    required this.fecha,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha,
    };
  }

  factory Gastos.fromMap(Map<String, dynamic> map) {
    return Gastos(
      id: map['id'],
      descripcion: map['descripcion'],
      categoria: map['categoria'],
      monto: map['monto'],
      fecha: map['fecha'],
    );
  }
}
