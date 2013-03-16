class SavedPosition {
  PVector position;
  float angle;
  
  SavedPosition(PVector thePosition, float theAngle) {
    this.position = new PVector(thePosition.x, thePosition.y);
    this.angle = theAngle;
  }
}
