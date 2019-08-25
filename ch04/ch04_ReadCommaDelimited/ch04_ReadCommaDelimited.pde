// Processing Sketch to read comma delimited serial              
// expects format: H,1,2,3

import processing.serial.*;

Serial myPort;        // Create object from Serial class
char HEADER = 'H';    // character to identify the start of a message
short LF = 10;        // ASCII linefeed

// WARNING!
// If necessary change the definition below to the correct port
short portIndex = 0;  // select the com port, 0 is the first port

void setup() {
  size(200, 200);
  println( (Object[]) Serial.list());
  println(" Connecting to -> " + Serial.list()[portIndex]);
  myPort = new Serial(this, Serial.list()[portIndex], 9600);
}

void draw() {
  if (myPort.available() > 0) {

    String message = myPort.readStringUntil(LF); // read serial data
    if (message != null)
    {
      message = message.trim(); // Remove whitespace from start/end of string
      println(message);
      String [] data = message.split(","); // Split the comma-separated message
      if (data[0].charAt(0) == HEADER && data.length == 4) // check validity
      {
        for (int i = 1; i < data.length; i++) // skip header (start at 1, not 0)                       
        {
          println("Value " +  i + " = " + data[i]);  // Print the field values
        }
        println();
      }
    }
  }
}
