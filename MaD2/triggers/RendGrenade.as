package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class RendGrenade extends Trigger
   {
      
      public function RendGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         super.trigger(param1,param2);
         var _loc6_:Number = triggerRadius * param2.size;
         var _loc7_:int = triggerForce >> 0;
         if(_loc7_ > 100)
         {
            _loc7_ = 100;
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc5_ = Math.random() * 24 + 4;
            _loc3_ = new b2Vec2(pixelCenter.x + Math.random() * _loc6_ - _loc6_ * 0.5,pixelCenter.y + Math.random() * _loc6_ - _loc6_ * 0.5);
            _loc4_ = new b2Vec2(pixelCenter.x + Math.random() * _loc6_ - _loc6_ * 0.5,pixelCenter.y + Math.random() * _loc6_ - _loc6_ * 0.5);
            GameState.madeby = "rendgrenade";
            GameState.cutter.ExcludeSingle(param1);
            GameState.cutter.CustomCut(_loc3_,_loc4_,1,_loc5_,360);
            _loc8_++;
         }
         if(triggerForce > 20)
         {
            sounds.play("cut1",param1,pixelCenter);
            param2.dead = true;
            Body.Disintegrate(param1,"slice",100,40 * param2.size,40 * param2.size);
         }
         else
         {
            param2.dead = true;
         }
      }
   }
}

