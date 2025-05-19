// ignore_for_file: camel_case_types, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_aplicacion_1/models/gastos.dart';
import 'package:flutter_aplicacion_1/services/gastos_services.dart';

class Formulario_gastos extends StatefulWidget {
  const Formulario_gastos({super.key, this.gasto});
  final Gastos? gasto;
  @override
  State<Formulario_gastos> createState() => Formulario_gastosState();
}

class Formulario_gastosState extends State<Formulario_gastos> {
  final formKey = GlobalKey<FormState>(); // clave para validar el formulario

  String descripcion = "";
  String categoria = "";
  double monto = 0;
  String fecha = "";

  //campos necesesarios para el campo de la fecha con el calendario
  TextEditingController fechaController = TextEditingController();
  DateTime? fechaSeleccionada;

  @override
  //Metodo para inicializar los valores cuando es para modificar un gasto
  void initState() {
    super.initState();
    {
      if (widget.gasto != null) {
        descripcion = widget.gasto!.descripcion;
        categoria = widget.gasto!.categoria;
        monto = widget.gasto!.monto;
        fecha = widget.gasto!.fecha;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gastos")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              //Campo del formulario para ingresar la Descripcion
              TextFormField(
                initialValue:
                    descripcion, //Inicializacion de la descripcion, si existen
                decoration: InputDecoration(labelText: "Descripcion"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Ingresa una Descripcion"
                            : null,
                onSaved: (value) => descripcion = value!,
              ),

              //Campo del formulario para ingresar la categoria
              TextFormField(
                initialValue:
                    categoria, //Inicializacion de la categoria, si existe
                decoration: InputDecoration(labelText: "Categoria"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Ingresa una categoria"
                            : null,
                onSaved: (value) => categoria = value!,
              ),

              //Campo del formulario para ingresar el monto
              TextFormField(
                initialValue:
                    monto != 0
                        ? monto.toString()
                        : "", //Inicializacion del monto, si existe y es diferente de 0
                decoration: InputDecoration(labelText: "Monto"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Ingresa un monto";
                  if (double.tryParse(value) == null) return "Monto invalido";
                  if (double.parse(value) < 0.0) {
                    return "Ingres un monto mayor que 0.0";
                  }
                },
                onSaved: (value) => monto = double.parse(value!),
              ),

              TextFormField(
                controller: fechaController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Fecha",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  ); //Esto es para no abrir el teclado

                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      fechaSeleccionada = picked;
                      fechaController.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    });
                  }
                },
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Seleccione una fecha"
                            : null,
                onSaved: (value) => fecha = value!,
              ),

              SizedBox(height: 16),

              //Boton para guardar un nuevo gasto o modificar uno que ya existe
              ElevatedButton(
                child: Text("Guardar"),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final gasto = Gastos(
                      id: widget.gasto?.id, //null si es nuevo
                      descripcion: descripcion,
                      categoria: categoria,
                      monto: monto,
                      fecha: fecha,
                    );

                    final servicio = GastosServices();
                    if (gasto.id == null) {
                      await GastosServices().insertGasto(
                        gasto,
                      ); //Si es un nuevo gasto
                    } else {
                      await servicio.actualizarGastos(
                        gasto,
                      ); //Para editar un gasto que ya exista
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
