package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DecoyMine extends Trigger
   {
      
      public function DecoyMine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(param2.triggerPos.Copy(),bodyAngle);
         _loc3_.Add(pixelCenter);
         var _loc4_:Array = Body.GetAroundPoint(_loc3_,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         if(_loc4_.length > 1)
         {
            _loc5_ = "air";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc5_ = param2.pfx.getParticle();
            }
            _loc6_ = 0;
            while(_loc6_ < 30)
            {
               GameState.particles.addParticles(pixelCenter.x + Math.random() * 20 - 10,pixelCenter.y + Math.random() * 20 - 10,1,_loc5_,0,0,8,8);
               _loc6_++;
            }
            _loc7_ = BoxUtils.rotateVec(new b2Vec2(0,-80 * param2.size),bodyAngle);
            _loc7_.Add(pixelCenter);
            param2.dead = true;
            _loc8_ = GameState.objects.spawnScale;
            GameState.objects.spawnScale = param2.size;
            _loc9_ = GameState.objects.spawnObject("decoydoll",_loc7_.x,_loc7_.y,bodyAngle * Vars.toDegrees,false,true);
            GameState.objects.spawnScale = _loc8_;
         }
      }
   }
}

