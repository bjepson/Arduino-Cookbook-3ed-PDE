/*
 * ReceiveBinaryData_P
 *
 * portIndex must be set to the port connected to the Arduino
 */
import processing.serial.*;

Serial myPort;        // Create object from Serial class

// WARNING!
// If necessary change the definition below to the correct port
short portIndex = 0;  // select the com port, 0 is the first port

char HEADER = 'H';
int value1, value2;         // Data received from the serial port

void setup()
{
  size(600, 600);
  // Open whatever serial port is connected to Arduino.
  String portName = Serial.list()[portIndex];
  println((Object[]) Serial.list());
  println(" Connecting to -> " + portName);
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  // read the header and two binary *(16 bit) integers:
  if ( myPort.available() >= 5)  // If at least 5 bytes are available,
  {
    if( myPort.read() == HEADER) // is this the header
    {
      value1 = myPort.read();                 // read the least significant byte
      value1 =  myPort.read() * 256 + value1; // add the most significant byte

      value2 = myPort.read();                 // read the least significant byte
      value2 =  myPort.read() * 256 + value2; // add the most significant byte

      println("Message received: " + value1 + "," + value2);
    }
  }
  background(255);             // Set background to white
  fill(0);                     // set fill to black

  // draw rectangle with coordinates based on the integers received from Arduino
  rect(0, 0, value1,value2);
}
