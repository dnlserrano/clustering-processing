int MAX_DISTANCE = 50;
int MIN_CLUSTER_SIZE = 20;
int MAX_CLUSTER_SIZE = 40;

PImage img;
boolean[] pxls;

int newPosition() {
  for (int i = 0; i < pxls.length; i++) {
    if (!pxls[i]) {
      pxls[i] = true;
      return i;
    }
  }
  return -1; // should never happen
}

void randomClusters() {
  print("processing clusters");
  int i = 0;
  while (i < img.pixels.length) {
    // get first pixels from list of all non-used pixels
    int pixel = newPosition();
    // random maximum cluster size
    int maxSize = (int) random(MIN_CLUSTER_SIZE, MAX_CLUSTER_SIZE);
    // create cluster from pixel p of size c
    ArrayList<Integer> cluster = createCluster(pixel, maxSize);
    // average cluster color
    color c = avgColor(cluster);
    // recolor pixels from cluster
    recolor(c, cluster);
    // update pixels done
    i += cluster.size();
  }
  println();
}

color avgColor(ArrayList<Integer> cluster) {
  color c;
  float r, g, b;
  r = g = b = 0;
  int size = cluster.size();
  for (int i = 0; i < size; i++) {
    c = color(img.pixels[cluster.get(i)]);
    r += red(c);
    g += green(c);
    b += blue(c);
  }
  r /= size;
  g /= size;
  b /= size;
  return color((int) r, (int) g, (int) b);
}

void recolor(color c, ArrayList<Integer> cluster) {
  for (int i = 0; i < cluster.size(); i++) {
    img.pixels[cluster.get(i)] = c;
  }
}

ArrayList<Integer> children(int parent) {
  ArrayList<Integer> children = new ArrayList<Integer>();
  int row = row(parent);
  int column = column(parent);
  // NW neighbor
  if (row > 0 && column > 0) {
    int child = parent - img.height - 1;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  // N neighbor
  if (row > 0) {
    int child = parent - img.height;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  // NE neighbor
  if (row > 0 && column < img.height - 1) {
    int child = parent - img.height + 1;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  // W neighbor
  if (column > 0) {
    int child = parent - 1;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  // E neighbor
  if (column < img.height - 1) {
    int child = parent + 1;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  // SW neighbor
  if (row < img.width - 1 && column > 0) {
    int child = parent + img.height - 1;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  // S neighbor
  if (row < img.width - 1) {
    int child = parent + img.height;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  // SE neighbor
  if (row < img.width - 1 && column < img.height - 1) {
    int child = parent + img.height + 1;
    if (child > 0 && child < pixels.length) {
      children.add(child);
    }
  }
  return children;
}

ArrayList<Integer> createCluster(int seed, int maxSize) {
  print(".");
  ArrayList<Integer> cluster = new ArrayList<Integer>();
  cluster.add(seed);
  color reference = img.pixels[seed];
  while (cluster.size() < maxSize && wayOut(cluster, reference)) {
    int random = (int) random(0, cluster.size());
    int next = findNext(cluster.get(random), reference);
    if (next != -1) {
      cluster.add(next);
      pxls[next] = true;
      reference = newReference(reference, img.pixels[next], cluster.size());
    }
  }
  return cluster;
}

color newReference(color reference, color newColor, int size) {
  float rR = red(reference);
  float rG = green(reference);
  float rB = blue(reference);
  float ncR = red(newColor);
  float ncG = green(newColor);
  float ncB = blue(newColor);
  float avgR = (rR * (size - 1) + ncR) / size;
  float avgG = (rG * (size - 1) + ncG) / size;
  float avgB = (rB * (size - 1) + ncB) / size;
  return color(avgR, avgG, avgB);
}

int findNext(int parent, color reference) {
  ArrayList<Integer> children = children(parent);
  for (int child : children) {
    if (!pxls[child] && closeColor(reference, child)) {
      return child;
    }
  }
  return -1;
}

boolean wayOut(ArrayList<Integer> cluster, color reference) {
  for (int parent : cluster) {
    ArrayList<Integer> children = children(parent);
    for (int child : children) {
      if (!pxls[child] && closeColor(reference, child)) {
        return true;
      }
    }
  }
  return false;
}

int row(int pos) {
  return pos / img.width;
}

int column(int pos) {
  return pos % img.height;
}

boolean closeColor(color reference, int pixel) {
  if (pixel < 0 || pixel > img.pixels.length - 1) {
    return false;
  }
  // closeness is measured by using Euclidean distance in 3D (RGB)
  color c = img.pixels[pixel];
  float rDist2 = pow(red(c) - red(reference), 2);
  float gDist2 = pow(green(c) - green(reference), 2);
  float bDist2 = pow(blue(c) - blue(reference), 2);
  float result = sqrt(rDist2 + gDist2 + bDist2);
  if (result < MAX_DISTANCE) {
    return true;
  } else {
    return false;
  }
}

void pixelsFlags() {
  pxls = new boolean[img.pixels.length];
  for (int i = 0; i < img.pixels.length; i++) {
    pxls[i] = false;
  }
}

void setup() {
  img = loadImage("file.jpg");
  size(img.width, img.height);
  loadPixels();
  pixelsFlags();
  randomClusters();
  updatePixels();
}

void draw() {
  image(img, 0, 0);
}

