package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class DrainBullet extends GenericBullet
   {
      
      public function DrainBullet()
      {
         super(null);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius;
         var _loc4_:Array = Body.GetAroundPoint(pixelCenter,_loc3_,_loc3_,false);
         var _loc5_:Boolean = false;
         for each(_loc6_ in _loc4_)
         {
            _loc7_ = userData(_loc6_.GetUserData());
            if(_loc7_.alive)
            {
               _loc5_ = true;
               _loc8_ = pixelCenter.Copy();
               _loc9_ = _loc6_.GetWorldCenter().Copy();
               _loc9_.Multiply(Physics.scale);
               _loc10_ = (_loc9_.y - _loc8_.y) / (_loc9_.x - _loc8_.x);
               _loc11_ = 0;
               while(_loc11_ < 4)
               {
                  _loc12_ = _loc8_.x + _loc11_ / 4 * (_loc9_.x - _loc8_.x);
                  _loc13_ = _loc8_.y + _loc10_ * (_loc12_ - _loc8_.x);
                  Body.BloodParticles(_loc6_,new b2Vec2(_loc12_,_loc13_),new b2Vec2((_loc8_.x - _loc12_) * 0.1,(_loc8_.y - _loc13_) * 0.1),new b2Vec2(0.1,0.1));
                  _loc11_++;
               }
               _loc7_.health *= 0.95;
               _loc7_.health -= 8;
            }
         }
         if(_loc5_)
         {
            _loc14_ = 1 + Math.random() * 4;
            sounds.play("drain" + _loc14_.toString(),null,pixelCenter,0.5,false);
         }
         if(Math.random() > 0.7)
         {
            _loc15_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ * 0.5,Math.random() * 360);
            GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,"blood",(pixelCenter.x - _loc15_.x) * 0.1 + bodyVel.x * 0.1,(pixelCenter.y - _loc15_.y) * 0.1 + bodyVel.y * 0.1,0,0);
         }
      }
   }
}

