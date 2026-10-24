package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PaperShredder extends Trigger
   {
      
      public function PaperShredder()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:Array = null;
         var _loc18_:b2Body = null;
         var _loc19_:userData = null;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         _loc4_ = param2.triggerPos.Copy();
         _loc4_.Multiply(param2.size);
         _loc4_.x *= _loc3_;
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         _loc5_.Add(pixelCenter);
         var _loc6_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc7_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc8_:Number = bodyCenter.x * Physics.scale;
         var _loc9_:Number = bodyCenter.y * Physics.scale;
         var _loc10_:int = 1;
         while(_loc10_ < 5)
         {
            _loc11_ = new b2Vec2(-25 * param2.size + _loc10_ * 10 * param2.size,-35 * param2.size);
            _loc12_ = new b2Vec2(-25 * param2.size + _loc10_ * 10 * param2.size,-40 * param2.size);
            _loc13_ = BoxUtils.rotateVec(_loc11_,bodyAngle);
            _loc14_ = BoxUtils.rotateVec(_loc12_,bodyAngle);
            _loc15_ = new b2Vec2(_loc8_ + _loc13_.x,_loc9_ + _loc13_.y);
            _loc16_ = new b2Vec2(_loc8_ + _loc14_.x,_loc9_ + _loc14_.y);
            _loc17_ = GameState.cutter.CustomRaycast(_loc15_,20 * param2.size,_loc16_,true);
            _loc18_ = _loc17_[0] as b2Body;
            if(_loc18_)
            {
               _loc19_ = userData(_loc18_.GetUserData());
               _loc20_ = ["paperairplane","papercoffeecup","paperball","mail","folder","creditcard","book","paper","toiletpaperroll","toiletpaper","toiletpaper2"];
               if(_loc20_.indexOf(_loc19_.name) == -1)
               {
                  return;
               }
               _loc21_ = 0;
               while(_loc21_ < 4)
               {
                  BoxUtils.randomParticlesOnBody(_loc18_,"paper");
                  _loc21_++;
               }
               if(Math.random() > 0.98)
               {
                  Body.Destroy(_loc18_,"functionality");
               }
            }
            _loc10_++;
         }
      }
   }
}

