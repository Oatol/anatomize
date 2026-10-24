package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DebilityPotion extends Trigger
   {
      
      public function DebilityPotion()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(_loc4_.alive)
            {
               _loc4_.maxhealth *= 0.5;
               if(_loc4_.maxhealth < 1)
               {
                  _loc4_.maxhealth = 1;
               }
               if(_loc4_.health > _loc4_.maxhealth)
               {
                  _loc4_.health = _loc4_.maxhealth;
               }
               _loc6_ = "stoneskull";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc6_ = param2.pfx.getParticle();
               }
               _loc7_ = 0;
               while(_loc7_ < 4)
               {
                  BoxUtils.randomParticlesOnBody(_loc5_,_loc6_);
                  _loc7_++;
               }
            }
         }
         param2.dead = true;
         Body.Disintegrate(param1,"sprinkle",20,12,12);
      }
   }
}

