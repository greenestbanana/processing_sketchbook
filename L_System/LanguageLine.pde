
class LanguageLine implements LanguageOperation {
  int totalLineCount;
  color[] spectrum;
  
  LanguageLine(int pointCount) {
    totalLineCount = pointCount;
    
    spectrum = new color[7];
    
    spectrum[0] = #FF0000;
    spectrum[1] = #FFFF00;
    spectrum[2] = #00FF00;
    spectrum[3] = #00FFFF;
    spectrum[4] = #0000FF;
    spectrum[5] = #FF00FF;
    spectrum[6] = #FF0000;
  }
  
  void languageIterated(PVector oldPoint, PVector newPoint, int curLineCount) {
    stroke(lineColor(curLineCount, totalLineCount));
    fill(lineColor(curLineCount, totalLineCount));
    line(((float)Math.floor(oldPoint.x)) + 0.5f, ((float)Math.floor(oldPoint.y)) + 0.5f, 
         ((float)Math.floor(newPoint.x)) + 0.5f, ((float)Math.floor(newPoint.y)) + 0.5f);
  }
  
  color lineColor(int currentSequence, int maxSequence)
  {
    int spectrumSlots = spectrum.length - 1;

    int lowerIndex = floor(((float)currentSequence / (float)maxSequence) * spectrumSlots);
    int upperIndex = ceil(((float)currentSequence / (float)maxSequence) * spectrumSlots);
    float remainder = upperIndex - (((float)currentSequence / (float)maxSequence) * spectrumSlots);
    remainder = 1.0f - remainder;

    int rLower = spectrum[lowerIndex] >> 16 & 0xff;  
    int gLower = spectrum[lowerIndex] >> 8 & 0xff;  
    int bLower = spectrum[lowerIndex] & 0xff;

    int rUpper = spectrum[upperIndex] >> 16 & 0xff; 
    int gUpper = spectrum[upperIndex] >> 8 & 0xff;
    int bUpper = spectrum[upperIndex] & 0xff;

    int rInterp = ceil((float)(rUpper - rLower) * remainder) + rLower;
    int gInterp = ceil((float)(gUpper - gLower) * remainder) + gLower;
    int bInterp = ceil((float)(bUpper - bLower) * remainder) + bLower;

    return color(rInterp, gInterp, bInterp);
  }
}
