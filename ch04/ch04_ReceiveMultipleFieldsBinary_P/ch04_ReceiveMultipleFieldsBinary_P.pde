// Processing Sketch
              
/*
 * ReceiveMultipleFieldsBinary_P
 *
 * portIndex must be set to the port connected to the Arduino
*/

import processing.serial.*;

Serial myPort;        // Create object from Serial class
short portIndex = 0;  // select the com port, 0 is the first port

char HEADER = 'H';

void setup()
{
  size(200, 200);
  // Open whatever serial port is connected to Arduino.
  String portName = Serial.list()[portIndex];
  println(Serial.list());
  println(" Connecting to -> " + portName);
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
int val;

  if ( myPort.available() >= 15)  // wait for the entire message to arrive
  {
    if( myPort.read() == HEADER) // is this the header
    {
      println("Message received:");
      // header found
      // get the integer containing the bit values
      val = readArduinoInt();
      // print the value of each bit
      for(int pin=2, bit=1; pin <= 13; pin++){
        print("digital pin " + pin + " = " );
        int isSet = (val & bit);
        if( isSet == 0) {
          println("0");
        }
        else{
          println("1");
        }
        bit = bit * 2; //shift the bit to the next higher binary place
      }
      println();
      // print the six analog values
      for(int i=0; i < 6; i ++){
        val = readArduinoInt();
        println("analog port " + i + "=" + val);
      }
      println("----");
    }
  }
}

// return integer value from bytes received from serial port (in low,high order)
int readArduinoInt()
{
  int val;      // Data received from the serial port

  val = myPort.read();              // read the least significant byte
  val = myPort.read() * 256 + val;  // add the most significant byte
  return val;
}
