package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class GlitchGrenade extends Trigger
   {
      
      public function GlitchGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         super.trigger(param1,param2);
         param2.dead = true;
         sounds.play("firespread_shoot");
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            Body.Glitch(_loc4_,false);
            Body.Glitch(_loc4_,false);
            Body.Glitch(_loc4_,false);
         }
         _loc5_ = Item(O.getItem("glitchgrenade")).colours;
         _loc6_ = 0;
         for(; _loc6_ < 100; _loc6_++)
         {
            _loc8_ = _loc5_[int(_loc5_.length * Math.random())];
            if(_loc8_ is String)
            {
               _loc7_ = _loc8_;
            }
            else if(_loc8_ is ShapeUserData)
            {
               if(ShapeUserData(_loc8_).invisible)
               {
                  continue;
               }
               _loc7_ = ShapeUserData(_loc8_).name;
            }
            GameState.particles.addSimpleParticles(pixelCenter.x + Math.random() * 10 - 5,pixelCenter.y + Math.random() * 10 - 5,1,uint("0xFF" + _loc7_),Math.random() * bodyVel.x * 0.2,Math.random() * bodyVel.y * 0.2,Math.random() * 2,Math.random() * 2);
         }
      }
   }
}

