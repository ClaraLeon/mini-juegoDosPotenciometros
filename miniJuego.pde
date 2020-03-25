//VARIABLES ---------------------------------------------------------------------------------------------------
import processing.serial.*;

//variables del arduino ---------------
Serial port;
String sensores;
int potenciometro;
int pulsador;

float mapeado;


//imagenes
PImage fondoIntro;
PImage fondoJuego;
PImage fonfoWin;
PImage cancha;
PImage balon;
PImage balon2;

int pantalla;
//movimiento de la cancha
int x = 5; 
int xMarcador = 85; 
int vel = 3;
int velBalon = 100;
int anchoCancha = 256;

int xBtn = 200; 
int yBtn= 70; 

int x2 = 5; 
int vel2 = 8;

int bal2X = 0;
float bal2Y = 450;
float vel3 = 6.9; 

//estado del juego
boolean estado= false;
int puntaje =0;
int sumatoria=0;
float distancia=0;

// PRUEBA DISPARO
//boolean presion = false; // condiciona el estado de la tecla(presionada o no presionada)
//boolean presionM = false; 



//SETUP ---------------------------------------------------------------------------------------------------
void setup() {
  size(800, 600);
  pantalla=1;

  fondoIntro = loadImage("fondoIntro.png");
  fondoJuego = loadImage("fondojuego.png");
  cancha = loadImage("cancha.png"); 
  balon = loadImage("balon.png");
  balon2 = loadImage("balon.png");
  fonfoWin = loadImage("fonfowin.png");

  
  //port = new Serial(this, Serial.list()[0], 9600);
  port = new Serial(this, "/dev/cu.usbmodem14201", 9600);
}

//DRAW ---------------------------------------------------------------------------------------------------
void draw() {
  if (pantalla == 1) {
    background(fondoIntro);
    fill(#ffffff);
    textSize(50);
    text(" ¡Jugar! ", 310, 320);

    if (mousePressed == true)
    {
      pantalla=2;
    }
  }

  if (pantalla == 2) {
    background(fondoJuego);
    //CANCHA
    //image(cancha,265,127);
    image(cancha, x, 127);
    noStroke();
    noFill();
    rect(xMarcador, 127, 100, 100);
    //ANIMACION CANCHA
    x= x + vel;
    xMarcador= xMarcador + vel;
    //CONDICIONAL PARA CREAR UN REBOTE CANCHA
    if (x+anchoCancha >= 800) {
      vel= vel * -1;
    } else if (x <= 0) {
      vel= vel * -1;
    }

    //ANIMACION BALON EN HORIZONTAL
    if (0 < port.available())
    {
      //Cuando se envian datos de dos cosas diferentes como un potenciometro y un pulsador
      // se utiliza port.readStringUntil('\n'); en vez de usar port.read(),
      sensores =  port.readStringUntil('\n');    

      if (sensores != null)// si sensores no es igual a null entonces haga lo siguiente
      {
        println(sensores); //imprima la información
        String[] datosSensor = split(sensores, 'T');

        if (datosSensor.length == 2)
        {
          println(datosSensor[0]);
          println(datosSensor[1]);
          potenciometro = int(trim(datosSensor[0]));      
          pulsador = int(trim(datosSensor[1]));
        }

        mapeado = map(potenciometro, 0, 255, 0, 710);
      }
      /*potenciometro= port.read();
       println(potenciometro);
       mapeado = map(potenciometro, 0, 255, 0, 710);*/
    }
    x2 = int(mapeado);
    //rect(x2, 450, 100, 100);

    image(balon, x2, 450);
    // x2= x2 + vel2;

    //CONDICIONAL PARA CREAR UN REBOTE BALON X
    if (x2+88 >= 800) {
      vel2= vel2 * -1;
    } else if (x2 <= 10) {
      vel2= vel2 * -1;
    }
    if (pulsador == 1 && bal2X == 0 )
    {
      bal2X = x2;
    } else if (pulsador == 0 && bal2X > 0) {
      bal2X = x2; 
      bal2Y = 450;
    }
    /*
    if (presion == true && bal2X == 0 ) { // si la tecla es igual a verdadero entonces haga lo siguiente
     bal2X = x2; // guarde la posición x del balon en movimiento
     } else if (presion == true && bal2X > 0) {
     bal2X = x2; 
     bal2Y = 450;
     }*/

    if (bal2X == 0) {
      // Si bal2X es igual 0 entonces no dibuje nada
    } else {// Si bal2X tiene un valor entonces
      //fill(155);
      //rect(bal2X, bal2Y, 80, 80);
      image(balon2, bal2X, bal2Y); // dibuje el balon con la ultima posición x
    }

    //ANIMACION BALON EN HORIZONTAL
    bal2Y= bal2Y - vel3;

    //CONDICIONAL PARA CREAR UN REBOTE BALON Y
    if (bal2Y <= 127) {
      vel3= vel3 * -1;
    } else if (bal2Y >= 450) {
      vel3= vel3 * -1;
    }
/*
    if (bal2Y >= 127 && bal2Y <= 227) {
      if (bal2X >= xMarcador && bal2X <= xMarcador+100 ) {
         puntaje = puntaje + 1;
      }
    }
*/

     distancia = dist(bal2X, bal2Y, xMarcador, 230);
     
     if (distancia <= 30)
     {
     estado= true;
     if (estado == true) {
     puntaje = puntaje + 1;
     noTint();
     }
     
     image(balon2, bal2X, bal2Y);
     }


    fill(#ffffff);
    textSize(20);
    text("PUNTAJE: " + puntaje, 30, 40);

    if (puntaje >= 50 ) {
      pantalla=3;
    }
  }

  if (pantalla == 3) {
    background(fonfoWin);
    fill(#ffffff);
    textSize(50);
    text(" ¡Haz Ganado! ", 100, 200);
    textSize(40);
    text(" puntaje máximo " + puntaje, 100, 250);
    textSize(30);
  }
}

/*-------------------- TECLA ESPACIO
 void keyPressed() { // cuando se oprime una tecla
 //println("" + keyCode); para averiguar el codigo de las teclas
 if (keyCode == 32) {
 presion=true;
 }
 }
 void keyReleased() {// cuando se suelta esa tecla
 if (keyCode == 32) {
 presion=false;
 }
 }*/
/*-------------------- MOUSE
 void mousePressed() {
 presionM=true;
 }
 
 void mouseReleased() {
 presionM=true;
 }-------------------- MOUSE*/
