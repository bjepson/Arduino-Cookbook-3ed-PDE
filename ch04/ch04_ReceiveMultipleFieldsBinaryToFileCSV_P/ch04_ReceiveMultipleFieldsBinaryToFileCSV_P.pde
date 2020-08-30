/*
 * ReceiveMultipleFieldsBinaryToFileCSV_P
 *
 * portIndex must be set to the port connected to the Arduino
 * based on ReceiveMultipleFieldsBinary, this version saves data to CSV
 * Press any key to stop logging and save file
 */

import processing.serial.*;
import java.util.*;
import java.text.*;

DateFormat fnameFormat = new SimpleDateFormat("yyMMdd_HHmm");
DateFormat  timeFormat = new SimpleDateFormat("hh:mm:ss");

String fileName;
Table table;

Serial myPort;        // Create object from Serial class
short portIndex = 0;  // select the com port, 0 is the first port
char HEADER = 'H';

void setup()
{
  size(200, 200);
  
  // Open whatever serial port is connected to Arduino.
  String portName = Serial.list()[portIndex];
  println((Object[]) Serial.list());
  println(" Connecting to -> " + portName);
  myPort = new Serial(this, portName, 9600);

  Date now = new Date();
  fileName = fnameFormat.format(now);

  // Create the table and add all the columns
  table = new Table();
  table.addColumn("Time");
  for (int pin=2; pin <= 13; pin++) {
    table.addColumn("D" + str(pin));
  }
  for (int i=0; i < 6; i ++) {
    table.addColumn("A" + str(i));
  }
}

void draw()
{

  if ( myPort.available() >= 15)  // wait for the entire message to arrive
  {
    if ( myPort.read() == HEADER) // is this the header
    {
      
      String timeString = timeFormat.format(new Date());

      TableRow newRow = table.addRow();
      newRow.setString("Time", timeString);
      
      // get the integer containing the bit values
      int val = readArduinoInt();

      // print the value of each bit
      for (int pin=2, bit=1; pin <= 13; pin++) {
        int isSet = (val & bit);
        if (isSet == 0) {
          newRow.setInt("D" + str(pin), 0);
        } else {
          newRow.setInt("D" + str(pin), 1);
        }
        bit = bit * 2; // shift the bit
      }

      // print the six analog values
      for (int i=0; i < 6; i ++) {
        val = readArduinoInt();
        newRow.setInt("A" + str(i), val);
      }
    }
  }
}

void keyPressed() {
  saveTable(table, fileName + ".csv");
  exit(); // Stops the program
}

// return the integer value from bytes received on the serial port
// (in low,high order)
int readArduinoInt()
{
  int val;      // Data received from the serial port

  val = myPort.read();             // read the least significant byte
  val = myPort.read() * 256 + val; // add the most significant byte
  return val;
}
