class Bombe {
  public int xCor;
  public float yCor;
  public int w;
  public int h;

  Bombe(int xValue, int yValue, int wValue, int hValue) {
    xCor = xValue;
    yCor = yValue;
    w = wValue;
    h = hValue;
  }

  public void drop(float speed) {
    yCor += speed;
    if (yCor > height) {
      yCor = -random(100, 1000);
      xCor = (int) random(width - 30);
    }
  }

  public void display() {
    fill(0, 128, 255);
    rect(xCor, yCor, w, h, 5);
  }
}
