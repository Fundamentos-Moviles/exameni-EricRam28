import 'dart:math';
import 'package:flutter/material.dart';

// Widget principal del juego Buscaminas
class Buscaminas extends StatefulWidget {
  const Buscaminas({super.key});

  @override
  State<Buscaminas> createState() => _BuscaminasState();
}

class _BuscaminasState extends State<Buscaminas> {
  // Tamaño del tablero (6x6)
  static const int gridsize = 6;
  // Número de bombas en el tablero
  static const int bombs =4;
  // Matriz que representa el tablero: 0 = vacío, 1 = bomba
  List<List<int>> board = List.generate(
      gridsize, (i) => List.generate(gridsize, (j) => 0, growable: false),
      growable: false);

  // Matriz que indica si una celda ha sido revelada
  List<List<bool>> revealed = List.generate(
      gridsize, (i) => List.generate(gridsize, (j) => false, growable: false),
      growable: false);

  // Indica si el juego ha terminado
  bool gameIni= false;
  // Indica si el jugador ha ganado
  bool winner= false;

  @override
  void initState(){
    super.initState();
    inGame();
  }

  // Método para inicializar o reiniciar el juego
  void inGame(){
    // Reinicia el tablero y las celdas reveladas
    for(int i=0; i<gridsize; i++){
      for(int j=0; j<gridsize; j++){
        board[i][j]=0;
        revealed[i][j]=false;
      }
    }
    gameIni=false;
    winner=false;

    // Coloca las bombas aleatoriamente en el tablero
    int bombasColocadas=0;
    Random rand = Random();
    while(bombasColocadas < bombs){
      int fila = rand.nextInt(gridsize);
      int columna = rand.nextInt(gridsize);
      if(board[fila][columna] == 0){
        board[fila][columna] = 1;//colocar bomba
        bombasColocadas++;
      }
      setState(() {});
    }
  }

  // Método para revelar una celda al hacer clic
  void revelarCelda(int fila, int columna){
    if(gameIni||revealed[fila][columna]){
      return;
    }
    setState(() {
      revealed[fila][columna]=true;

      if(board[fila][columna]==1){
        // Revelar todas las bombas cuando se presiona una
        for(int i=0; i<gridsize; i++){
          for(int j=0; j<gridsize; j++){
            if(board[i][j]==1){
              revealed[i][j]=true;
            }
          }
        }
        gameIni=true; // Si es bomba, termina el juego
      }else{
        if(checkWin()){
          winner=true;
          gameIni=true; // Si gana, termina el juego
        }
      }
    });
  }

  // Método para verificar si el jugador ha ganado
  bool checkWin(){
    for(int i=0; i<gridsize; i++){
      for(int j=0; j<gridsize; j++){
        if(board[i][j]==0 && !revealed[i][j]){
          return false; // Si hay una celda vacía no revelada, no ha ganado
        }
      }
    }
    return true; // Todas las celdas vacías reveladas
  }

  // Método para determinar el color de una celda
  Color obtenerColor(int fila, int columna){
    if(!revealed[fila][columna]) return Colors.grey; // No revelada
    if(board[fila][columna]==1) return Colors.red; // Bomba
    return Colors.green; // Vacía revelada
  }

  // Widget para crear un recuadro (celda) del tablero
  Widget crearRecuadro(int fila, int columna){
    return Expanded(
      child: InkWell(
        onTap: () => revelarCelda(fila, columna),
        child: Container(
          margin: const EdgeInsets.all(1),
          color: obtenerColor(fila, columna),
          child: Center(child: Container()),
        ),
      ),
    );
  }

  // Widget para crear una fila del tablero
  Widget crearFila(int fila){
    return Expanded(
      child: Row(
        children: [
          for(int j=0; j<gridsize; j++) crearRecuadro(fila, j)
        ],
      ),
    );
  }

  // Método para construir la interfaz de usuario del juego
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Buscaminas - \tEric Alejandro Ramírez Juarez 293974'),
        backgroundColor: Colors.white, 
      ),
      body: Column(
        children: [
          if (gameIni)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                winner ? '¡Ganaste!' : '¡Perdiste!',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          Expanded(child: Column(
            children: [
              for(int i=0; i<gridsize; i++) crearFila(i)
            ],
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: inGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Reiniciar Juego',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}