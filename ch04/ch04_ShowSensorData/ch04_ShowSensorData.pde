/*
 * ShowSensorData. 
 * 
 * Displays bar graph of CSV sensor data ranging from -127 to 127
 * expects format as: "Data,s1,s2,...s12\n" (any number of to 12 sensors is supported)
 * labels can be sent as follows: "Labels,label1, label2,...label12\n");
 */

import processing.serial.*;
import java.util.Set;

Serial myPort;  // Create object from Serial class
String message = null;
PFont fontA;    // font to display servo pin number 
int fontSize = 12;


int rectMargin = 40;
int windowWidth = 600;
int maxLabelCount = 12;
int windowHeight = rectMargin + (maxLabelCount + 1) * (fontSize *2);
int rectWidth = windowWidth - rectMargin*2;
int rectHeight = windowHeight - rectMargin;
int rectCenter = rectMargin + rectWidth / 2;

int origin = rectCenter;
int minValue = -5;
int maxValue = 5;

float scale = float(rectWidth) / (maxValue - minValue);

void settings() {
  //rectMargin = 0;
  size(windowWidth, windowHeight);
}

void setup() {
  short portIndex = 0;  // select the com port, 0 is the first port
  String portName = Serial.list()[portIndex];
  println( (Object[]) Serial.list());
  println(" Connecting to -> " + portName) ;
  myPort = new Serial(this, portName, 9600);
  fontA = createFont("Arial.normal", fontSize);  
  textFont(fontA);
}

void draw() {

  while (myPort.available () > 0) {
    message = myPort.readStringUntil(10); 
    if (message != null) {
      JSONObject json = new JSONObject();
      try {
        json = parseJSONObject(message);
      }
      catch(Exception e) {
        println("Could not parse [" + message + "]");
      }

      ArrayList<String> labels = new ArrayList<String>();
      ArrayList<Float> data = new ArrayList<Float>();
      for (String key : (Set<String>) json.keys()) {
        labels.add(key);
        data.add(json.getFloat(key));
      }

      background(255); 
      drawGrid(labels);   
      fill(204); 
      for (int i = 0; i < data.size(); i++) {
        drawBar(i, data.get(i));
      }
    }
  }
}

void drawBar(int yIndex, float value) { 
  rect(origin, yPos(yIndex)-fontSize, value * scale, fontSize);   //draw the value
}

void drawGrid(ArrayList<String> sensorLabels) {
  fill(0); 

  // Draw the minimum value
  text(minValue, xPos(minValue), rectMargin-fontSize);   
  line(xPos(minValue), rectMargin, xPos(minValue), rectHeight + fontSize); 
  // Draw the maximum value
  text((minValue+maxValue)/2, rectCenter, rectMargin-fontSize);   
  line(rectCenter, rectMargin, rectCenter, rectHeight + fontSize);
  text(maxValue, xPos(maxValue), rectMargin-fontSize);  
  line( xPos(maxValue), rectMargin, xPos(maxValue), rectHeight + fontSize);   

  for (int i=0; i < sensorLabels.size(); i++) {
    text(sensorLabels.get(i), fontSize, yPos(i));
    text(sensorLabels.get(i), xPos(maxValue) + fontSize, yPos(i));
  }
}

int yPos(int index) {
  return rectMargin + fontSize + (index * fontSize*2);
}

int xPos(int value) {
  return origin  + int(scale * value);
}
