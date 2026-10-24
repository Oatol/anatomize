package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class Water extends GenericBullet
   {
      
      public function Water()
      {
         super("water");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:b2Body = null;
         var _loc13_:int = 0;
         var _loc14_:b2Vec2 = null;
         var _loc15_:uint = 0;
         var _loc16_:int = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         ud.dead = true;
         var _loc8_:b2Vec2 = param5.Copy();
         _loc8_.Multiply(Physics.scale);
         Body.Wet(param1,_loc8_);
         if(_loc7_.burning)
         {
            if(ud.name == "extinguish")
            {
               _loc11_ = BoxUtils.selectCompound(param1);
               for each(_loc12_ in _loc11_)
               {
                  if(_loc12_.GetUserData().burning)
                  {
                     _loc12_.GetUserData().temperature = _loc12_.GetUserData().temperature - (Math.random() * 20 + 10);
                     if(_loc12_.GetUserData().temperature < 5)
                     {
                        _loc12_.GetUserData().temperature = 5;
                     }
                  }
               }
            }
            else
            {
               _loc7_.temperature -= 60;
               if(_loc7_.temperature < 5)
               {
                  _loc7_.temperature = 5;
               }
            }
            _loc10_ = 0;
            while(_loc10_ < 10)
            {
               GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,"poof",0,-4,1,2);
               _loc10_++;
            }
         }
         else if(ud.name == "water")
         {
            _loc13_ = 0;
            while(_loc13_ < 10)
            {
               GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,particle,0,0,1,1);
               _loc13_++;
            }
         }
         var _loc9_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc9_)
         {
            _loc14_ = param1.GetLocalPoint(param5).Copy();
            _loc15_ = 0;
            if(ud.name == "extinguish")
            {
               _loc15_ = (Math.random() * 255 << 24) + 14540253;
            }
            _loc9_.lock();
            _loc16_ = 0;
            while(_loc16_ < 100 * ud.size)
            {
               _loc9_.setPixel32(_loc14_.x * Physics.scale + (Math.random() * _loc16_ * 0.5 - _loc16_ * 0.25) * ud.size + _loc9_.width * 0.5,_loc14_.y * Physics.scale + (Math.random() * _loc16_ * 0.5 - _loc16_ * 0.25) * ud.size + _loc9_.height * 0.5,_loc15_);
               _loc16_++;
            }
            _loc9_.unlock();
         }
         return true;
      }
   }
}

