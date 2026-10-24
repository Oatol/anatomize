package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DragonScroll extends Trigger
   {
      
      public function DragonScroll()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:String = "icechunk";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,Math.random() * 50 * param2.size,-Math.random() * 180 + bodyAngle * Vars.toDegrees);
         var _loc5_:Number = bodyAngle - Vars.PI * 0.5;
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc3_,0,0,Math.sin(_loc5_),Math.cos(_loc5_));
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            GameState.objects.spawnObject("dragonskull",pixelCenter.x,pixelCenter.y - 50,0,param2.flipped,true);
            GameState.objects.spawnObject("dragonskull2",pixelCenter.x - 24,pixelCenter.y - 20,0,param2.flipped,true);
            param2.dead = true;
         }
      }
   }
}

