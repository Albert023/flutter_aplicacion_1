import 'package:flutter/material.dart';
import 'package:flutter_aplicacion_1/layouts/formulario.dart';
import '../models/gastos.dart';
import '../services/gastos_services.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key}); //Esto se va a borrar

  State<Inicio> createState() => InicioState();
}

class InicioState extends State<Inicio> {
  final GastosServices gastosServices = GastosServices();

  Future<List<Gastos>> cargarGastos() async {
    return await gastosServices.getGastos();
  }

  void eliminarGastos(int id) async {
    final confirmar = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Eliminar gasto?"),
            content: Text("Estas seguro que quieres eliminar este gasto"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Eliminar"),
              ),
            ],
          ),
    );

    if (confirmar == true) {
      await gastosServices.eliminarGastos(id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gastos")),

      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.95,

          heightFactor: 0.90,

          child: FutureBuilder<List<Gastos>>(
            future: cargarGastos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.isEmpty)
                return Center(child: Text("No hay gastos registrados"));

              final gastos = snapshot.data!;
              final total = gastos.fold(0.0, (sum, e) => sum + e.monto);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    //Lista donde se ven todos los gastos
                    child: ListView.builder(
                      itemCount: gastos.length,
                      itemBuilder: (context, index) {
                        final e = gastos[index];
                        return Card(
                          child: ListTile(
                            title: Text("${e.descripcion}   \$${e.monto}"),
                            subtitle: Text('${e.categoria} - ${e.fecha}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,

                              //Botones en la pagina principal
                              children: [
                                //Boton para Editar Un gasto
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                Formulario_gastos(gasto: e),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),

                                //Boton para eliminar gastos
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => eliminarGastos(e.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),

      //Boton para agregar un nuevo gasto
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Formulario_gastos()),
          ).then((_) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
