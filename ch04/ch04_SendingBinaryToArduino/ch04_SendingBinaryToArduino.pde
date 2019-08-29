// Processing Sketch
              
/* SendingBinaryToArduino
 * Language: Processing
 */
import processing.serial.*;

Serial myPort;  // Create object from Serial class
public static final char HEADER    = 'H';
public static final char MOUSE_TAG = 'M';

void setup()
{
  size(512, 512);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw(){
}

void serialEvent(Serial p) {
  // handle incoming serial data
  String inString = myPort.readStringUntil('\n');
  if(inString != null) {     
    print( inString );   // print text string from Arduino
  }
}

void mousePressed() {
  sendMessage(MOUSE_TAG, mouseX, mouseY);
}

void sendMessage(char tag, int x, int y){
  // send the given index and value to the serial port
  myPort.write(HEADER);
  myPort.write(tag);
  myPort.write((char)(x / 256)); // msb
  myPort.write(x & 0xff);  //lsb
  myPort.write((char)(y / 256)); // msb
  myPort.write(y & 0xff);  //lsb
}
