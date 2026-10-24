package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DoorLever extends Trigger
   {
      
      internal var originalGroup:int = -9999;
      
      public function DoorLever()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc6_:userData = null;
         var _loc7_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.graphic.scaleY *= -1;
         param2.triggered = false;
         if(param2.connected.length == 0)
         {
            return;
         }
         var _loc3_:int = int(param2.connected.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param2.connected[_loc5_];
            if(_loc4_)
            {
               _loc6_ = userData(_loc4_.GetUserData());
               if(_loc6_.group < 0)
               {
                  if(_loc6_.group > -1000)
                  {
                     _loc6_.group -= 1000;
                     if(!param2.triggerForce)
                     {
                        _loc6_.graphic.alpha = 0.2;
                     }
                     else
                     {
                        _loc6_.graphic.alpha = param2.triggerForce * 0.01;
                     }
                  }
                  else
                  {
                     _loc6_.group += 1000;
                     if(_loc6_.graphic.alpha != 0)
                     {
                        _loc6_.graphic.alpha = _loc6_.alpha;
                     }
                  }
               }
               else if(_loc6_.group >= 1000)
               {
                  _loc6_.group -= 1000;
                  if(_loc6_.graphic.alpha != 0)
                  {
                     _loc6_.graphic.alpha = _loc6_.alpha;
                  }
               }
               else
               {
                  _loc6_.group += 1000;
                  if(!param2.triggerForce)
                  {
                     _loc6_.graphic.alpha = 0.2;
                  }
                  else
                  {
                     _loc6_.graphic.alpha = param2.triggerForce * 0.01;
                  }
               }
               _loc7_ = _loc4_.GetPosition().Copy();
               if(_loc7_.x != 0 || _loc7_.y != 0)
               {
                  _loc4_.SetXForm(new b2Vec2(),_loc4_.GetAngle());
                  _loc4_.SetXForm(_loc7_,_loc4_.GetAngle());
               }
            }
            _loc5_++;
         }
      }
   }
}

