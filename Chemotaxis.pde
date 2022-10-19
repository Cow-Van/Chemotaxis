public final float totalUnits = 75;
public final float killRange = 20;
public final int rockColor = #00ff00;
public final int paperColor = #ff0000;
public final int scissorColor = #4444ff;

public final float speed = 0.1;
public final float wid = 15;
public final float hei = 15;
public final float randomMove = 5 * speed;
public final float explorationMove = 20 * speed;
public final float allyMove = 10 * speed;
public final float preyMove = 10 * speed;
public final float predatorMove = 15 * speed;
public final float allyDistance = 50;
public final float preyDistance = 200;
public final float predatorDistance = 150;

public final ArrayList<Rock> rocks = new ArrayList();
public final ArrayList<Paper> papers = new ArrayList();
public final ArrayList<Scissor> scissors = new ArrayList();

public void setup() {
  size(750, 750);
  
  for (int i = 0; i < totalUnits; i++) {
    double d = Math.random();
    if (d < 1/3d) {
      rocks.add(new Rock((float) (Math.random() * (width - 20)), (float) (Math.random() * (height - 20)), rockColor));
    } else if (d < 2/3d) {
      papers.add(new Paper((float) (Math.random() * (width - 20)), (float) (Math.random() * (height - 20)), paperColor));
    } else {
      scissors.add(new Scissor((float) (Math.random() * (width - 20)), (float) (Math.random() * (height - 20)), scissorColor));
    }
  }
}

public void draw() {   
  background(#ffffff);
  
  ArrayList<Rock> rocksToAdd = new ArrayList();
  ArrayList<Rock> rocksToRemove = new ArrayList();
  ArrayList<Paper> papersToAdd = new ArrayList();
  ArrayList<Paper> papersToRemove = new ArrayList();
  ArrayList<Scissor> scissorsToAdd = new ArrayList();
  ArrayList<Scissor> scissorsToRemove = new ArrayList();
  
  if (papers.size() > 0) {
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      Paper closestPredator = rock.closestPaper();
      
      if (dist(rock.getX(), rock.getY(), closestPredator.getX(), closestPredator.getY()) < killRange) {
        rocksToRemove.add(rock);
        papersToAdd.add(new Paper(rock.getX(), rock.getY(), paperColor));
      }
    }
  }
  
  if (scissors.size() > 0) {
    for (int i = 0; i < papers.size(); i++) {
      Paper paper = papers.get(i);
      
      Scissor closestPredator = paper.closestScissor();
      
      if (dist(paper.getX(), paper.getY(), closestPredator.getX(), closestPredator.getY()) < killRange) {
        papersToRemove.add(paper);
        scissorsToAdd.add(new Scissor(paper.getX(), paper.getY(), scissorColor));
      }
    }
  }
  
  if (rocks.size() > 0) {
    for (int i = 0; i < scissors.size(); i++) {
      Scissor scissor = scissors.get(i);
      
      Rock closestPredator = scissor.closestRock();
      
      if (dist(scissor.getX(), scissor.getY(), closestPredator.getX(), closestPredator.getY()) < killRange) {
        scissorsToRemove.add(scissor);
        rocksToAdd.add(new Rock(scissor.getX(), scissor.getY(), rockColor));
      }
    }
  }
  
  rocks.removeAll(rocksToRemove);
  papers.removeAll(papersToRemove);
  scissors.removeAll(scissorsToRemove);
  
  rocks.addAll(rocksToAdd);
  papers.addAll(papersToAdd);
  scissors.addAll(scissorsToAdd);
  
  for (int i = 0; i < rocks.size(); i++) {
    Rock rock = rocks.get(i);
    
    rock.move();
    rock.show();
  }
  
  for (int i = 0; i < papers.size(); i++) {
    Paper paper = papers.get(i);
    
    paper.move();
    paper.show();
  }
  
  for (int i = 0; i < scissors.size(); i++) {
    Scissor scissor = scissors.get(i);
    
    scissor.move();
    scissor.show();
  }
}

public class Rock {
  private float x;
  private float y;
  private int c;
  
  public Rock(float x, float y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }
  
  public void move() {
    boolean explore = true;
    
    Rock closestAlly = closestRock();
    Paper closestPredator = closestPaper();
    Scissor closestPrey = closestScissor();
    
    if (closestAlly != null && dist(closestAlly.getX(), closestAlly.getY(), x, y) < allyDistance) {
      float angle = vector(closestAlly.getX(), closestAlly.getY());
      
      x += (sin(angle) + Math.random()) * allyMove - allyMove / 2f;
      y += (cos(angle) + Math.random()) * allyMove - allyMove / 2f;
    }
    
    if (closestPredator != null && dist(closestPredator.getX(), closestPredator.getY(), x, y) < predatorDistance) {
      float angle = vector(closestPredator.getX(), closestPredator.getY());
      
      x += (sin(angle) + Math.random()) * predatorMove - predatorMove / 2f;
      y += (cos(angle) + Math.random()) * predatorMove - predatorMove / 2f;
      
      explore = false;
    }
    
    if (closestPrey != null && dist(closestPrey.getX(), closestPrey.getY(), x, y) < preyDistance) {
      float angle = vector(closestPrey.getX(), closestPrey.getY()) + PI;
      
      x += (sin(angle) + Math.random()) * preyMove - preyMove / 2f;
      y += (cos(angle) + Math.random()) * preyMove - preyMove / 2f; 
      
      explore = false;
    }
    
    if (explore) {
      x += (Math.random() * explorationMove) - explorationMove / 2f;
      y += (Math.random() * explorationMove) - explorationMove / 2f;
    }
    
    x += (Math.random() * randomMove) - randomMove / 2f;
    y += (Math.random() * randomMove) - randomMove / 2f;
    
    if (x < 0) {
      x = 0;
    }
    
    if (y < 0) {
      y = 0;
    }
    
    if (x + wid > width) {
      x = width - wid;
    }
    
    if (y + hei > height) {
      y = height - hei;
    }
  }
  
  public void show() {
    fill(c);
    
    rect(x, y, wid, hei);
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  private float[] increments() {
    return null;
  }
  
  public Rock closestRock() {
    Rock closestRock = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      
      float rockDistance = dist(x, y, rock.getX(), rock.getY());
      
      if (closestRock == null || rockDistance < closestDistance) {
        closestDistance = rockDistance;
        closestRock = rock;
      }
    }
    
    return closestRock;
  }
  
  public Paper closestPaper() {
    Paper closestPaper = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < papers.size(); i++) {
      Paper paper = papers.get(i);
      
      float paperDistance = dist(this.x, this.y, paper.getX(), paper.getY());
      
      if (closestPaper == null || paperDistance < closestDistance) {
        closestDistance = paperDistance;
        closestPaper = paper;
      }
    }
    
    return closestPaper;
  }
  
  public Scissor closestScissor() {
    Scissor closestScissor = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < scissors.size(); i++) {
      Scissor scissor = scissors.get(i);
      
      float scissorDistance = dist(x, y, scissor.getX(), scissor.getY());
      
      if (closestScissor == null || scissorDistance < closestDistance) {
        closestDistance = scissorDistance;
        closestScissor = scissor;
      }
    }
    
    return closestScissor;
  }
  
  private float vector(float x, float y) {
    if (dist(x, y, this.x, this.y) == 0) {
      return (float) (Math.random() * TWO_PI);
    }
    
    return acos((this.y - y) / dist(x, y, this.x, this.y)) * ((this.x - x < 0) ? -1 : 1);
  }
}

public class Paper {
  private float x;
  private float y;
  private int c;
  
  public Paper(float x, float y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }
  
  public void move() {
    boolean explore = true;
    
    Paper closestAlly = closestPaper();
    Scissor closestPredator = closestScissor();
    Rock closestPrey = closestRock();
    
    if (closestAlly != null && dist(closestAlly.getX(), closestAlly.getY(), x, y) < allyDistance) {
      float angle = vector(closestAlly.getX(), closestAlly.getY());
      
      x += (sin(angle) + Math.random()) * allyMove - allyMove / 2f;
      y += (cos(angle) + Math.random()) * allyMove - allyMove / 2f;
    }
    
    if (closestPredator != null && dist(closestPredator.getX(), closestPredator.getY(), x, y) < predatorDistance) {
      float angle = vector(closestPredator.getX(), closestPredator.getY());
      
      x += (sin(angle) + Math.random()) * predatorMove - predatorMove / 2f;
      y += (cos(angle) + Math.random()) * predatorMove - predatorMove / 2f;
      
      explore = false;
    }
    
    if (closestPrey != null && dist(closestPrey.getX(), closestPrey.getY(), x, y) < preyDistance) {
      float angle = vector(closestPrey.getX(), closestPrey.getY()) + PI;
      
      x += (sin(angle) + Math.random()) * preyMove - preyMove / 2f;
      y += (cos(angle) + Math.random()) * preyMove - preyMove / 2f; 
      
      explore = false;
    }
    
    if (explore) {
      x += (Math.random() * explorationMove) - explorationMove / 2f;
      y += (Math.random() * explorationMove) - explorationMove / 2f;
    }
    
    x += (Math.random() * randomMove) - randomMove / 2f;
    y += (Math.random() * randomMove) - randomMove / 2f;
    
    if (x < 0) {
      x = 0;
    }
    
    if (y < 0) {
      y = 0;
    }
    
    if (x + wid > width) {
      x = width - wid;
    }
    
    if (y + hei > height) {
      y = height - hei;
    }
  }
  
  public void show() {
    fill(c);
    
    rect(x, y, wid, hei);
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  private float[] increments() {
    return null;
  }
  
  public Rock closestRock() {
    Rock closestRock = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      
      float rockDistance = dist(x, y, rock.getX(), rock.getY());
      
      if (closestRock == null || rockDistance < closestDistance) {
        closestDistance = rockDistance;
        closestRock = rock;
      }
    }
    
    return closestRock;
  }
  
  public Paper closestPaper() {
    Paper closestPaper = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < papers.size(); i++) {
      Paper paper = papers.get(i);
      
      float paperDistance = dist(this.x, this.y, paper.getX(), paper.getY());
      
      if (closestPaper == null || paperDistance < closestDistance) {
        closestDistance = paperDistance;
        closestPaper = paper;
      }
    }
    
    return closestPaper;
  }
  
  public Scissor closestScissor() {
    Scissor closestScissor = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < scissors.size(); i++) {
      Scissor scissor = scissors.get(i);
      
      float scissorDistance = dist(x, y, scissor.getX(), scissor.getY());
      
      if (closestScissor == null || scissorDistance < closestDistance) {
        closestDistance = scissorDistance;
        closestScissor = scissor;
      }
    }
    
    return closestScissor;
  }
  
  private float vector(float x, float y) {
    if (dist(x, y, this.x, this.y) == 0) {
      return (float) (Math.random() * TWO_PI);
    }
    
    return acos((this.y - y) / dist(x, y, this.x, this.y)) * ((this.x - x < 0) ? -1 : 1);
  }
}

public class Scissor {
  private float x;
  private float y;
  private int c;
  
  public Scissor(float x, float y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }
  
  public void move() {
    boolean explore = true;
    
    Scissor closestAlly = closestScissor();
    Rock closestPredator = closestRock();
    Paper closestPrey = closestPaper();
    
    if (closestAlly != null && dist(closestAlly.getX(), closestAlly.getY(), x, y) < allyDistance) {
      float angle = vector(closestAlly.getX(), closestAlly.getY());
      
      x += (sin(angle) + Math.random()) * allyMove - allyMove / 2f;
      y += (cos(angle) + Math.random()) * allyMove - allyMove / 2f;
    }
    
    if (closestPredator != null && dist(closestPredator.getX(), closestPredator.getY(), x, y) < predatorDistance) {
      float angle = vector(closestPredator.getX(), closestPredator.getY());
      
      x += (sin(angle) + Math.random()) * predatorMove - predatorMove / 2f;
      y += (cos(angle) + Math.random()) * predatorMove - predatorMove / 2f;
      
      explore = false;
    }
    
    if (closestPrey != null && dist(closestPrey.getX(), closestPrey.getY(), x, y) < preyDistance) {
      float angle = vector(closestPrey.getX(), closestPrey.getY()) + PI;
      
      x += (sin(angle) + Math.random()) * preyMove - preyMove / 2f;
      y += (cos(angle) + Math.random()) * preyMove - preyMove / 2f; 
      
      explore = false;
    }
    
    if (explore) {
      x += (Math.random() * explorationMove) - explorationMove / 2f;
      y += (Math.random() * explorationMove) - explorationMove / 2f;
    }
    
    x += (Math.random() * randomMove) - randomMove / 2f;
    y += (Math.random() * randomMove) - randomMove / 2f;
    
    if (x < 0) {
      x = 0;
    }
    
    if (y < 0) {
      y = 0;
    }
    
    if (x + wid > width) {
      x = width - wid;
    }
    
    if (y + hei > height) {
      y = height - hei;
    }
  }
  
  public void show() {
    fill(c);
    
    rect(x, y, wid, hei);
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  private float[] increments() {
    return null;
  }
  
  public Rock closestRock() {
    Rock closestRock = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      
      float rockDistance = dist(x, y, rock.getX(), rock.getY());
      
      if (closestRock == null || rockDistance < closestDistance) {
        closestDistance = rockDistance;
        closestRock = rock;
      }
    }
    
    return closestRock;
  }
  
  public Paper closestPaper() {
    Paper closestPaper = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < papers.size(); i++) {
      Paper paper = papers.get(i);
      
      float paperDistance = dist(this.x, this.y, paper.getX(), paper.getY());
      
      if (closestPaper == null || paperDistance < closestDistance) {
        closestDistance = paperDistance;
        closestPaper = paper;
      }
    }
    
    return closestPaper;
  }
  
  public Scissor closestScissor() {
    Scissor closestScissor = null;
    float closestDistance = Float.MAX_VALUE;
    
    for (int i = 0; i < scissors.size(); i++) {
      Scissor scissor = scissors.get(i);
      
      float scissorDistance = dist(x, y, scissor.getX(), scissor.getY());
      
      if (closestScissor == null || scissorDistance < closestDistance) {
        closestDistance = scissorDistance;
        closestScissor = scissor;
      }
    }
    
    return closestScissor;
  }
  
  private float vector(float x, float y) {
    if (dist(x, y, this.x, this.y) == 0) {
      return (float) (Math.random() * TWO_PI);
    }
    
    return acos((this.y - y) / dist(x, y, this.x, this.y)) * ((this.x - x < 0) ? -1 : 1);
  }
}
