package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PortalPipe extends Trigger
   {
      
      public var prevtp:Vector.<b2Body> = new Vector.<b2Body>();
      
      public function PortalPipe()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc9_:b2Body = null;
         var _loc10_:userData = null;
         var _loc11_:Array = null;
         var _loc12_:b2Body = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.connected.length == 0)
         {
            return;
         }
         var _loc3_:* = int(this.prevtp.length - 1);
         while(_loc3_ >= 0)
         {
            if(!this.prevtp[_loc3_] || !this.prevtp[_loc3_].GetUserData() || userData(this.prevtp[_loc3_].GetUserData()).dead || BoxUtils.vectorDist(this.prevtp[_loc3_].GetPosition(),bodyCenter) > 1000 / Physics.scale)
            {
               userData(this.prevtp[_loc3_].GetUserData()).ignored.splice(userData(this.prevtp[_loc3_].GetUserData()).ignored.indexOf(param1),1);
               this.prevtp.splice(_loc3_,1);
            }
            _loc3_--;
         }
         var _loc4_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < param2.connected.length)
         {
            _loc5_ = param2.connected[_loc6_];
            if(userData(_loc5_.GetUserData()).name == "portalpipe")
            {
               _loc4_.push(_loc5_);
            }
            _loc6_++;
         }
         if(_loc4_.length == 0)
         {
            return;
         }
         _loc5_ = _loc4_[int(Math.random() * _loc4_.length)];
         var _loc7_:Number = 30 * param2.size / Physics.scale;
         var _loc8_:Array = Body.GetAround(param1,_loc7_,_loc7_);
         for each(_loc9_ in _loc8_)
         {
            _loc10_ = userData(_loc9_.GetUserData());
            if(_loc10_.name != "portalpipe")
            {
               if(this.prevtp.indexOf(_loc9_) == -1)
               {
                  _loc11_ = BoxUtils.selectCompound(_loc9_);
                  for each(_loc12_ in _loc11_)
                  {
                     if(userData(_loc12_.GetUserData()).ignored.indexOf(_loc5_) == -1)
                     {
                        userData(_loc12_.GetUserData()).ignored.push(_loc5_);
                     }
                     _loc13_ = BoxUtils.rotateVec(param2.triggerPos,_loc5_.GetAngle());
                     _loc13_.Multiply(userData(_loc5_.GetUserData()).triggerForce);
                     _loc14_ = _loc5_.GetPosition().Copy();
                     if(_loc11_.length > 1)
                     {
                        _loc14_ = new b2Vec2(_loc5_.GetPosition().x - (param1.GetPosition().x - _loc12_.GetPosition().x),_loc5_.GetPosition().y - (param1.GetPosition().y - _loc12_.GetPosition().y));
                     }
                     _loc12_.SetXForm(_loc14_,_loc12_.GetAngle());
                     _loc12_.SetLinearVelocity(_loc13_);
                     PortalPipe(userData(_loc5_.GetUserData()).trigger).prevtp.push(_loc12_);
                  }
               }
            }
         }
      }
   }
}

