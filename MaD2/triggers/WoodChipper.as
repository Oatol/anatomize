package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WoodChipper extends Trigger
   {
      
      public function WoodChipper()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc11_:String = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:b2Vec2 = null;
         var _loc18_:Array = null;
         var _loc19_:b2Body = null;
         var _loc20_:int = 0;
         var _loc21_:Item = null;
         var _loc22_:String = null;
         var _loc23_:* = undefined;
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
         if(Math.random() > 0.9)
         {
            _loc11_ = "smoke";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc11_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc11_,-_loc3_ * Math.cos(bodyAngle) * Math.random() * 5,-_loc3_ * Math.sin(bodyAngle) * Math.random() * 5,1,1);
         }
         var _loc6_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc7_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc8_:Number = bodyCenter.x * Physics.scale;
         var _loc9_:Number = bodyCenter.y * Physics.scale;
         var _loc10_:int = 1;
         while(_loc10_ < 5)
         {
            _loc12_ = new b2Vec2(-25 * param2.size + _loc10_ * 10 * param2.size,-35 * param2.size);
            _loc13_ = new b2Vec2(-25 * param2.size + _loc10_ * 10 * param2.size,-40 * param2.size);
            _loc14_ = BoxUtils.rotateVec(_loc12_,bodyAngle);
            _loc15_ = BoxUtils.rotateVec(_loc13_,bodyAngle);
            _loc16_ = new b2Vec2(_loc8_ + _loc14_.x,_loc9_ + _loc14_.y);
            _loc17_ = new b2Vec2(_loc8_ + _loc15_.x,_loc9_ + _loc15_.y);
            GameState.cutter.ExcludeSingle(param1);
            _loc18_ = GameState.cutter.CustomRaycast(_loc16_,20 * param2.size,_loc17_,true);
            _loc19_ = _loc18_[0] as b2Body;
            if((Boolean(_loc19_)) && _loc19_ != param1)
            {
               if(userData(_loc19_.GetUserData()).alive)
               {
                  _loc20_ = 0;
                  while(_loc20_ < 50)
                  {
                     GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,"blood",-_loc3_ * Math.cos(bodyAngle) * _loc20_ * 0.2,-_loc3_ * Math.sin(bodyAngle) * _loc20_ * 0.2,1,1);
                     _loc20_++;
                  }
                  Body.Destroy(_loc19_,"functionality");
               }
               else
               {
                  if(O.getItem(userData(_loc19_.GetUserData()).name))
                  {
                     _loc21_ = O.getItem(userData(_loc19_.GetUserData()).name);
                     _loc20_ = 0;
                     for(; _loc20_ < 10; _loc20_++)
                     {
                        _loc23_ = _loc21_.colours[int(_loc21_.colours.length * Math.random())];
                        if(_loc23_ is String)
                        {
                           _loc22_ = _loc23_;
                        }
                        else if(_loc23_ is ShapeUserData)
                        {
                           if(ShapeUserData(_loc23_).invisible)
                           {
                              continue;
                           }
                           _loc22_ = ShapeUserData(_loc23_).name;
                        }
                        GameState.particles.addSimpleParticles(_loc5_.x,_loc5_.y,1,uint("0xFF" + _loc22_),-_loc3_ * Math.cos(bodyAngle) * Math.random() * 10,-_loc3_ * Math.sin(bodyAngle) * Math.random() * 10,Math.random() * 2,Math.random() * 2);
                     }
                  }
                  if(Math.random() > 0.95)
                  {
                     Body.Destroy(_loc19_,"functionality");
                  }
               }
            }
            _loc10_++;
         }
      }
   }
}

