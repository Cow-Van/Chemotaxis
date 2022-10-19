public ArrayList<Rock> rocks = new ArrayList();
public ArrayList<Paper> papers = new ArrayList();

public void setup() {
  size(500, 500);

  rocks.add(new Rock(100, 100, #000000));
}

public void draw() {    
  for (Rock rock : rocks) {
    rock.move();
    rock.show();
  }
}

public class Rock {
  private int x;
  private int y;
  private int c;

  public Rock(int x, int y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }

  public void move() {
    x = mouseX;
    y = mouseY;
  }

  public void show() {
    fill(c);

    rect(x, y, 20, 20);
    closestPaper().c = #444444;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  private float[] increments() {
    return null;
  }

  private Paper closestPaper() {
    Paper closestPaper = null;
    float closestDistance = MAX_FLOAT;

    for (Paper paper : papers) {
      if (closestPaper == null || distance(paper.getX(), paper.getY()) < closestDistance) {
        closestPaper = paper;
      }
    }

    return closestPaper;
  }

  private float distance(int x, int y) {
    return sqrt(pow(x - this.x, 2) + pow(y - this.y, 2));
  }
}

public class Paper {
  private int x;
  private int y;
  int c;

  public Paper(int x, int y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }

  public void move() {

  }

  public void show() {
    fill(c);
    rect(x, y, 20, 20);
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }
}
