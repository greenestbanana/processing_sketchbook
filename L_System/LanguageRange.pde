
class LanguageRange implements LanguageOperation {
  PVector minPoint;
  PVector maxPoint;
  int pointCount;
  
  LanguageRange() {
    minPoint = new PVector(0,0);
    maxPoint = new PVector(0,0);
    pointCount = 0;
  }
  
  void languageIterated(PVector oldPoint, PVector newPoint, int curLineCount) {
    maxPoint.set(max(maxPoint.x, newPoint.x), max(maxPoint.y, newPoint.y), 0.0);
    minPoint.set(min(minPoint.x, newPoint.x), min(minPoint.y, newPoint.y), 0.0); 
    pointCount = curLineCount;
  }
}
