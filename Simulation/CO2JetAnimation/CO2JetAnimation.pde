/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity, and fade out over time.
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */

PImage bg;
PImage sprite;
PVector sprite_pos;
int sprite_pos_min_x = -400;
int sprite_pos_max_x = 920;

ParticleSystem spritegas;
PVector spritegas_vec;

ParticleSystem jet1;
ParticleSystem jet2;
ParticleSystem jet2b;
ParticleSystem jet3;
ParticleSystem jet4;
ParticleSystem jet5;
ParticleSystem jet6;
ParticleSystem jet7;
PVector vjet1;
PVector vjet2;
PVector vjet2b;
PVector vjet3;
PVector vjet4;
PVector vjet5;
PVector vjet6;
PVector vjet7;

void setup() {
  size(920, 250);
  
  bg = loadImage("anim_bg.png");
  
  vjet1 = new PVector(59, 193);
  vjet2 = new PVector(335, 220);
  vjet2b = new PVector(305, 220);
  vjet3 = new PVector(439, 182);
  vjet4 = new PVector(549, 183);
  vjet5 = new PVector(629, 184);
  vjet6 = new PVector(744, 186);
  vjet7 = new PVector(854, 187);
  
  jet1 = new ParticleSystem(vjet1);
  jet2 = new ParticleSystem(vjet2);
  jet2b = new ParticleSystem(vjet2b);
  jet3 = new ParticleSystem(vjet3);
  jet4 = new ParticleSystem(vjet4);
  jet5 = new ParticleSystem(vjet5);
  jet6 = new ParticleSystem(vjet6);
  jet7 = new ParticleSystem(vjet7);
  
  
  sprite = loadImage("atmosphinder_sprite.png");
  sprite_pos = new PVector(-400, 0);
  sprite_pos.x = 300;
  
  spritegas_vec = new PVector(sprite_pos.x+100, sprite_pos.y+100);
  spritegas = new ParticleSystem(spritegas_vec);
  
}

void draw() {
  background(0);
  image(bg, 0, 0);
  
  jet1.addParticle();
  jet1.configureLook(60, #836043, new PVector(0.03, -0.05), new PVector(random(-0.5, 0.5), random(-2, 0)));
  jet1.run();
  
  jet3.addParticle();
  jet3.configureLook(90, #593922, new PVector(0.03, -0.05), new PVector(random(-0.5, 0.5), random(-2, 0)));
  jet3.run();
  
  jet4.addParticle();
  jet4.configureLook(190, #714a2d, new PVector(0.03, -0.05), new PVector(random(-0.5, 0.5), random(-2, 0)));
  jet4.run();
  
  jet5.addParticle();
  jet5.configureLook(60, #bd9f5f, new PVector(0.03, -0.05), new PVector(random(-0.5, 0.5), random(-2, 0)));
  jet5.run();
  
  jet6.addParticle();
  jet6.configureLook(60, #61391a, new PVector(0.03, -0.05), new PVector(random(-0.5, 0.5), random(-2, 0)));
  jet6.run();
  
  jet7.addParticle();
  jet7.configureLook(190, #6c4923, new PVector(0.03, -0.05), new PVector(random(-0.5, 0.5), random(-2, 0)));
  jet7.run();
  
  // -- lil rover --
  image(sprite, sprite_pos.x, sprite_pos.y);
  sprite_pos.x++;
  if(sprite_pos.x >= sprite_pos_max_x) {
    sprite_pos.x = sprite_pos_min_x;
  }
  
  spritegas.addParticle();
  spritegas.configureLook(100, #cbe6ef, new PVector(-0.05, 0.01), 
    new PVector(random(-0.1, 0.1), random(-1, 0)));
  spritegas.run();
  spritegas_vec.x = sprite_pos.x+50;
  spritegas_vec.y = sprite_pos.y+180;
  spritegas.newLocation(spritegas_vec);
  // ----
  
  jet2.addParticle();
  jet2.configureLook(240, #604430, new PVector(0.02, -0.05), new PVector(random(-0.8, 0.8), random(-2, 0)));
  jet2.run();
  
  jet2b.addParticle();
  jet2b.configureLook(240, #604430, new PVector(0.02, -0.05), new PVector(random(-0.8, 0.8), random(-2, 0)));
  jet2b.run();
  
}

void mouseClicked() {
  println(mouseX + ", " + mouseY); 
}