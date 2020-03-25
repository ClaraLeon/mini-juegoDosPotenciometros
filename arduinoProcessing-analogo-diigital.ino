// CONEXION DE ARDUINO A PROCESSING - ENVIAR DATOS ANALOGOS (0- 1024) CON POTENCIOMETRO
// CONEXION DE ARDUINO A PROCESSING - ENVIAR DATOS DIGITALES CON PULSADOR

int inputPin = A0; // PUERTO ANALOGO 0 EN EL ARDUINO
int btn =  2; // PUERDO DIGITAL 2 EN EL ARDUINO

int sensorValue; // GUARDA LOS DATOS DIRECTAMENTE DEL POTENCIOMETRO
int potenciometroValor; // GUARDA Y ENVIA EL VALOR DEL POTENCIOMETRO /4
int btnValor = 0; //GUARDA Y ENVIA EL VALOR DEL PULSADOR

int estadoBtn = 0; // estado del btn 
boolean unaVez = false; // esto ayuda a controlar el valor, es decir que me muestre solo una vez el valor

void setup() {

  pinMode(btn, INPUT); // btn entrada

  // Los puertos analogos son de entrada por esta razon no se usa OUTPUT O INPUT
  Serial.begin(9600); //ENVIA LOS DATOS POR ESTE PUERTO
}

void loop() {
  estadoBtn = digitalRead(btn); // lee el estado del btn (actuador)
  
  /*if (estadoBtn == HIGH) // HIGH SE OPRIMIO
  {
    btnValor = 1; // dato que se enviara a processing
    
    Serial.println(btnValor);
  } else  {
    btnValor = 0; // dato que se enviara a processing;
    Serial.println(btnValor);
  } */

    if (estadoBtn == 1 && unaVez == false) {
     btnValor = 1;
     //Serial.println(btnValor);
     unaVez = true;
    }
    else if (estadoBtn == 0 && unaVez == true) {
     btnValor = 0;
     //Serial.println(btnValor);
     unaVez = false;
    }
    
  sensorValue = analogRead(inputPin); //Lee el valor del potencionetro


  //Esta linea no debe estar descomentada cuando se envia los datos a processing
  // DEC Es para que los datos sean númericos.
  // Se divide en 4 para que los valores vayan de 0 a 255 y de esta forma los colores en processing esten dentro de este valor.
  //Serial.println(sensorValue/4,DEC); // esto me permite leer los valores que estoy recibiendo por el monitor serie

  potenciometroValor = sensorValue / 4;
  //enviar = sensorValue; // de 0 a 1024
  //Serial.println(sensorValue,DEC);

   //envie por puerto serial la información del potenciometro y el pulsador
 Serial.print(potenciometroValor);
  Serial.print('T');
  Serial.print(btnValor);
  Serial.println();

  delay(100); //100 milisegundo para que processing reciba la info
}
