// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  PVector p_acceleration;
  PVector p_velocity;
  int fillc;
  float p_lifespan;

  ParticleSystem(PVector position) {
    p_acceleration = new PVector(0, -0.05);
    p_velocity = new PVector(random(-0.5, 0.5), random(-2, 0));
    fillc = #FFFFFF;
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void configureLook(float lifespan, int new_fillc, PVector acceleration, PVector velocity) {
     
    fillc = new_fillc;
    p_acceleration = acceleration.copy();
    p_velocity = velocity.copy();
    p_lifespan = lifespan;
    
    //for (int i = particles.size()-1; i >= 0; i--) {
    //  Particle p = particles.get(i);
    //  p.acceleration = acceleration.copy();
    //  p.velocity = velocity.copy();
    //  p.fillc = fillc;
    //}
    
  }

  void addParticle() {
    Particle p = new Particle(origin);
    
    //p_acceleration.x = 0;
    //p_acceleration.y = -0.05;
    //p_velocity.x = random(-0.5, 0.5);
    //p_velocity.y = random(-2, 0);
    
    p.acceleration = p_acceleration.copy();
    p.velocity = p_velocity.copy();
    p.fillc = fillc;
    p.lifespan = p_lifespan;
    particles.add(p);
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  void newLocation(PVector position) {
    origin = position.copy();
  }
}