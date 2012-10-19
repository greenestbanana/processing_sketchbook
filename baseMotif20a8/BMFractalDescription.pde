
public class BMFractalDescription
{
  String name;
  int sweepStyle;
  int defaultIterations;
  ArrayList defaultBase;
  ArrayList defaultMotif;
  
  BMFractalDescription (String theName, int theSweepStyle, int theDefaultIterations, 
                        ArrayList theDefaultBase, ArrayList theDefaultMotif)
  {
    this.name = theName;
    this.sweepStyle = theSweepStyle;
    this.defaultIterations = theDefaultIterations;
    this.defaultBase = theDefaultBase;
    this.defaultMotif = theDefaultMotif;
  }
}
