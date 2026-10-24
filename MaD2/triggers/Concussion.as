package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Concussion extends Trigger
   {
      
      public var duration:Number;
      
      public var particles:Boolean = false;
      
      public function Concussion(param1:Number = 120, param2:Boolean = false)
      {
         super();
         temporary = true;
         this.duration = param1;
         this.particles = param2;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:String = null;
         var _loc4_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.resistConcuss)
         {
            param2.trigger.reset();
            param2.triggered = false;
            param1.WakeUp();
            return;
         }
         this.duration -= TimeLord.speed;
         if(this.duration > 0)
         {
            param2.stabilise = false;
            if(this.particles && param2.health > param2.maxhealth * 0.5)
            {
               if(Math.random() > 0.975)
               {
                  _loc3_ = "sleep";
                  if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                  {
                     _loc3_ = param2.pfx.getParticle();
                  }
                  _loc4_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,10 * param2.size,Math.random() * 360);
                  GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc3_,(pixelCenter.x - _loc4_.x) * 0.01 + bodyVel.x * 0.1,(pixelCenter.y - _loc4_.y) * 0.01 + bodyVel.y * 0.1,1,1);
               }
            }
         }
         else if(param2.trigger is Equip)
         {
            param2.trigger = new Unequip();
         }
         else
         {
            param2.trigger.reset();
            param2.triggered = false;
            param1.WakeUp();
         }
      }
   }
}

