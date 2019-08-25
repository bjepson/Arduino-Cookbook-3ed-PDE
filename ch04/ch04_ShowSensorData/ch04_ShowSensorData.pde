/*
 * ShowSensorData. 
 * 
 * Displays bar graph of JSON sensor data ranging from -127 to 127
 * expects format as: "{'label1': value, 'label2': value,}\n" 
 * for example:
 * {'x': 1.0, 'y': -1.0, 'z': 2.1,}
 */

import processing.serial.*;
import java.util.Set;

Serial myPort;  // Create object from Serial class
PFont fontA;    // font to display text 
int fontSize = 12;
short LF = 10;        // ASCII linefeed

int rectMargin  = 40;
int windowWidth = 600;
int maxLabelCount = 12; // Increase this if you need to support more labels
int windowHeight  = rectMargin + (maxLabelCount + 1) * (fontSize *2);
int rectWidth  = windowWidth - rectMargin*2;
int rectHeight = windowHeight - rectMargin;
int rectCenter = rectMargin + rectWidth / 2;

int origin = rectCenter;
int minValue = -5;
int maxValue = 5;

float scale = float(rectWidth) / (maxValue - minValue);

// WARNING!
// If necessary change the definition below to the correct port
short portIndex = 0;  // select the com port, 0 is the first port

void settings() {
  size(windowWidth, windowHeight);
}

void setup() {
  println( (Object[]) Serial.list());
  println(" Connecting to -> " + Serial.list()[portIndex]);
  myPort = new Serial(this, Serial.list()[portIndex], 9600);
  fontA = createFont("Arial.normal", fontSize);  
  textFont(fontA);
}

void draw() {

  if (myPort.available () > 0) {
    String message = myPort.readStringUntil(LF); 
    if (message != null) {
      
      // Load the JSON data from the message
      JSONObject json = new JSONObject();
      try {
        json = parseJSONObject(message);
      }
      catch(Exception e) {
        println("Could not parse [" + message + "]");
      }

      // Copy the JSON labels and values into separate arrays.
      ArrayList<String> labels = new ArrayList<String>();
      ArrayList<Float> values = new ArrayList<Float>();
      for (String key : (Set<String>) json.keys()) {
        labels.add(key);
        values.add(json.getFloat(key));
      }

      // Draw the grid and chart the values
      background(255); 
      drawGrid(labels);   
      fill(204); 
      for (int i = 0; i < values.size(); i++) {
        drawBar(i, values.get(i));
      }
    }
  }
}

// Draw a bar to represent the current sensor reading
void drawBar(int yIndex, float value) { 
  rect(origin, yPos(yIndex)-fontSize, value * scale, fontSize);
}

void drawGrid(ArrayList<String> sensorLabels) {
  fill(0); 

  // Draw the minimum value label and a line for it
  text(minValue, xPos(minValue), rectMargin-fontSize);   
  line(xPos(minValue), rectMargin, xPos(minValue), rectHeight + fontSize); 
  
  // Draw the center value label and a line for it
  text((minValue+maxValue)/2, rectCenter, rectMargin-fontSize);   
  line(rectCenter, rectMargin, rectCenter, rectHeight + fontSize);
  
  // Draw the maximum value label and a line for it
  text(maxValue, xPos(maxValue), rectMargin-fontSize);  
  line(
  xPos(maxValue), rectMargin, xPos(maxValue), rectHeight + fontSize);   

  // Print each sensor label
  for (int i=0; i < sensorLabels.size(); i++) {
    text(sensorLabels.get(i), fontSize, yPos(i));
    text(sensorLabels.get(i), xPos(maxValue) + fontSize, yPos(i));
  }
}

// Calculate a y position, taking into account margins and font sizes
int yPos(int index) {
  return rectMargin + fontSize + (index * fontSize*2);
}

// Calculate a y position, taking into account the scale and origin
int xPos(int value) {
  return origin  + int(scale * value);
}
