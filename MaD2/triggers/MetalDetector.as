package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MetalDetector extends Trigger
   {
      
      internal var targetName:String;
      
      public function MetalDetector()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:userData = null;
         var _loc9_:userData = null;
         var _loc10_:b2Body = null;
         super.trigger(param1,param2);
         if(!this.targetName && param2.connected.length > 0)
         {
            _loc8_ = userData(param2.connected[0].GetUserData());
            this.targetName = _loc8_.name;
            _loc8_.disconnect(param1);
            param2.disconnect(param2.connected[0]);
            param2.triggerCustom = this.targetName;
            param2.triggerForce = 1;
            return;
         }
         if(param2.triggerForce == 0)
         {
            this.targetName = null;
            param2.disconnectAll();
            param2.triggerForce = 2;
            return;
         }
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(triggerPos.x * _loc3_,triggerPos.y),bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x * param2.size,pixelCenter.y + _loc4_.y * param2.size);
         var _loc6_:Array = Body.GetAroundPoint(_loc5_,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc7_:Boolean = false;
         if(_loc6_.length > 0)
         {
            for each(_loc10_ in _loc6_)
            {
               if(_loc10_ != param1)
               {
                  _loc9_ = userData(_loc10_.GetUserData());
                  if(_loc9_.name == this.targetName)
                  {
                     this.triggerConnected(true);
                     return;
                  }
               }
            }
         }
         this.triggerConnected(false);
      }
      
      internal function triggerConnected(param1:Boolean) : void
      {
         var _loc2_:b2Body = null;
         for each(_loc2_ in ud.connected)
         {
            userData(_loc2_.GetUserData()).triggered = param1;
         }
      }
      
      override public function OnLoadCustom() : void
      {
         super.OnLoadCustom();
         if(ud.triggerCustom)
         {
            this.targetName = ud.triggerCustom;
         }
      }
   }
}

