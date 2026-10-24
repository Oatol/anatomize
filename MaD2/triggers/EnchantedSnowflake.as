package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class EnchantedSnowflake extends Trigger
   {
      
      internal var snowfall:ParticleSystem;
      
      public function EnchantedSnowflake()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.snowfall = new ParticleSystem("snow",GameState.width,GameState.height,R.getSprite("p_gas"));
         this.snowfall.useWorldGravity = false;
         this.snowfall.particleGravity = 0.1;
         this.snowfall.particleFade = 1;
         this.snowfall.particleFadeRandom = 1;
         this.snowfall.particleHealth = 5000;
         this.snowfall.particleRestitution = 0;
         this.snowfall.particleFriction = 0.9;
         this.snowfall.particleWander = 0.5;
         this.snowfall.particleCollide = false;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:ParticleSystem = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Boolean = false;
         for each(_loc4_ in GameState.environment.public::particleSystems)
         {
            if(_loc4_.name == "snow")
            {
               _loc3_ = true;
               this.snowfall = _loc4_;
               break;
            }
         }
         if(!_loc3_)
         {
            GameState.environment.public::particleSystems.push(this.snowfall);
         }
         var _loc5_:String = "snow";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
         }
         if(Math.random() < triggerForce / 100)
         {
            _loc6_ = GameState.environment.borderLeft + Math.random() * (GameState.environment.borderRight + GameState.width * 0.5);
            _loc7_ = -Main.instance.m_sprite.y + Math.random() * -10 - 5;
            if(_loc5_ != "snow")
            {
               GameState.particles.addParticles(_loc6_,_loc7_,1,_loc5_,0,0,1,1);
            }
            else
            {
               this.snowfall.addParticles(1,_loc6_,_loc7_,0,0,4,4);
            }
         }
      }
   }
}

