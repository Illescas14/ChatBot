import 'package:flutter/material.dart';

void main() {
  runApp(AppChatBot());
}

class AppChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot Médico Offline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: PantallaChatBot(),
    );
  }
}

class PantallaChatBot extends StatefulWidget {
  @override
  _PantallaChatBotEstado createState() => _PantallaChatBotEstado();
}

class _PantallaChatBotEstado extends State<PantallaChatBot> {
  final TextEditingController controladorMensaje = TextEditingController();
  final List<Map<String, dynamic>> mensajes = [];
  final ScrollController controladorScroll = ScrollController();

  void enviarMensaje() {
    String texto = controladorMensaje.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        mensajes.add({'emisor': 'usuario', 'mensaje': texto});
        controladorMensaje.clear();
      });
      generarRespuestaLocal(texto);
    }
  }

  void generarRespuestaLocal(String mensajeUsuario) {
    String respuesta;
    mensajeUsuario = mensajeUsuario.toLowerCase();
    if (mensajeUsuario.contains("hola")) {
      respuesta = "¡Hola! ¿En qué puedo ayudarte hoy con tus citas médicas?";
    } else if (mensajeUsuario.contains("cita")) {
      respuesta = "Para agendar una cita necesito tu nombre, fecha y hora preferida.";
    } else if (mensajeUsuario.contains("gracias")) {
      respuesta = "¡De nada! Estoy aquí para ayudarte.";
    } else {
      respuesta = "Lo siento, no entendí tu mensaje. ¿Podrías reformularlo?";
    }
    setState(() {
      mensajes.add({'emisor': 'bot', 'mensaje': respuesta});
    });
    Future.delayed(Duration(milliseconds: 100), () {
      controladorScroll.animateTo(
        controladorScroll.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget burbujaMensaje(String mensaje, bool esUsuario) {
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: esUsuario ? Colors.teal[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(mensaje),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistente Médico Offline'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: controladorScroll,
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                final mensaje = mensajes[index];
                return burbujaMensaje(
                  mensaje['mensaje'],
                  mensaje['emisor'] == 'usuario',
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controladorMensaje,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}