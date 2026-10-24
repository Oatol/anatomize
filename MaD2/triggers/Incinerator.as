package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Incinerator extends Trigger
   {
      
      internal var coal:Number = 0;
      
      public function Incinerator()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc8_:b2Body = null;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         _loc4_ = new b2Vec2(6,-164);
         _loc4_.Multiply(param2.size);
         _loc4_.x *= _loc3_;
         _loc5_ = BoxUtils.rotateVec(_loc4_,bodyAngle);
         _loc5_.Add(pixelCenter);
         if(Math.random() > 0.9)
         {
            _loc9_ = "bigSmoke";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc9_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc9_,0,0,1,1);
         }
         _loc4_ = param2.triggerPos.Copy();
         _loc4_.Multiply(param2.size);
         _loc4_.x *= _loc3_;
         _loc5_ = BoxUtils.rotateVec(_loc4_.Copy(),bodyAngle);
         _loc5_.Add(pixelCenter);
         _loc4_ = new b2Vec2(80,100);
         _loc4_.Multiply(param2.size);
         _loc4_.x *= _loc3_;
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         _loc6_.Add(pixelCenter);
         var _loc7_:Array = Body.GetAroundPoint(_loc5_,25,25);
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_ != param1)
            {
               if(Math.random() > 0.9)
               {
                  Body.Disintegrate(_loc8_,"fire2",20,5,5);
                  this.coal += Math.random() * 20;
                  if(this.coal > 20)
                  {
                     this.coal -= 20;
                     _loc10_ = GameState.objects.spawnScale;
                     GameState.objects.spawnScale = 0.4 + Math.random() * Math.random() * 0.8;
                     GameState.objects.spawnObject("coal",_loc6_.x,_loc6_.y,Math.random() * Vars.PI * 2,Math.random() > 0.5,true);
                     GameState.objects.spawnScale = _loc10_;
                  }
               }
            }
         }
      }
   }
}

