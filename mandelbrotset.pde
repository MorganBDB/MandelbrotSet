// Morgan Brooke-deBock //<>//
// December 20 2022
// Code to calculate and display the Mandelbrot set

// Features:
//   Everypixel on the screen represents a complex number
//   The pixel is colored black if it is in the Mandelbrot set
//   Otherwise, the pixel will be some other color (I will experiment with this)
//   I want to be able to zoom into the Mandelbrot set, and see regions in greater detail

int steps;
float mouseRE;
float mouseIM;
void setup() {
  colorMode(HSB);
  size(1080, 1080);
  steps = 1;
}

void draw() {
  background(0);
  showMandelbrot(steps);
  steps++;
}

int inMandelbrot(float RE, float IM, int maxIterations) {
  // Function checks if a given complex number is in the Mandelbrot set.
  // inputs: RE and IM are the real and imaginary parts of the complex number
  //         maxIterations is the maximum number of iterations in the mandelbrot construction
  //
  // The function will return the number of iterations it took for the input number to grow to an
  //     absolute value greater than 2 (after which point, we can guarentee the number go to infinity)
  //
  // If the number still has not grown greater than 2 after maxIterations, we simply return maxIterations
  //
  // Therefore, if the functions returns maxIterations, then we say the input number is in the mandelbrot set.
  // But if the function returns a number less that maxIterations, we know the number is not inside the mandelbrot set.


  float firstRE = RE;
  float firstIM = IM;
  for (int i = 0; i < maxIterations; i++) {
    float[] squared = complexMult(RE, IM, RE, IM); // Square the complex number
    RE = squared[0] + firstRE;                     // Add the real part of the seed number onto the real part of the squared number
    IM = squared[1] + firstIM;                     // Add the imaginary of the seed number onto the imaginary part of the squared number
    if (sqrt(RE*RE + IM*IM) > 2) {
      return i;
    }
  }
  return maxIterations;
}

void dotsAndSticks(float RE, float IM, int maxIterations) {
  // Dots and sticks visualization of the mandlebrot set iterations
  float firstRE = RE;
  float firstIM = IM;
  
  float firstX = map(firstRE, -2, 1, 0, width);
  float firstY = map(firstIM, -1.5, 1.5, 0, height);
  stroke(255);
  noFill();
  beginShape();
  vertex(firstX, firstY);
  for (int i = 0; i < maxIterations; i++) {
    float[] squared = complexMult(RE, IM, RE, IM); // Square the complex number
    RE = squared[0] + firstRE;                     // Add the real part of the seed number onto the real part of the squared number
    IM = squared[1] + firstIM;                     // Add the imaginary of the seed number onto the imaginary part of the squared number

    float xVal = map(RE, -2, 1, 0, width);
    float yVal = map(IM, -1.5, 1.5, 0, height);
    
    vertex(xVal, yVal);
  }
  endShape();
}

void showMandelbrot(int maxIterations) {
  // Function to display the Mandelbrot set.

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float RE = map(x, 0, width, -2, 1);
      float IM = map(y, 0, height, -1.5, 1.5);
      int mandelResult = inMandelbrot(RE, IM, maxIterations);
      if (mandelResult == maxIterations) {
        pixels[x + y * width] = color(0);
      } else {
        float hueVal = map(mandelResult, 0, maxIterations, 100, 220);
        float brightVal = map(mandelResult, 0, maxIterations, 50, 255);
        float satVal = map(mandelResult, 0, maxIterations, 0, 255);
        pixels[x + y * width] = color(hueVal, 255, brightVal);
      }
    }
  }
  updatePixels();
}

float[] complexMult(float RE1, float IM1, float RE2, float IM2) {
  // Function to multiplt two complex number together.
  // inputs: RE1 is the real part of the first number
  //         IM1 is the imaginary part of the second number
  //         RE2 is the real part of the second number
  //         IM2 is the imaginary part of the second number
  //
  // Returns a float array with two items. The first item is the real part of the multiplied output.
  // The second item is the imaginary part of the multiplied output.

  float newRE;
  float newIM;
  float[] result = new float[2];

  newRE = (RE1 * RE2) - (IM1 * IM2);
  newIM = (RE1 * IM2) + (IM1 * RE2);

  result[0] = newRE;
  result[1] = newIM;


  return result;
}

void mouseDragged() {
}
