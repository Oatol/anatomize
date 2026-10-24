package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneTrapper extends Trigger
   {
      
      private var trapped:Boolean = false;
      
      private var targetBody:b2Body;
      
      public function DroneTrapper()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         ud.layer = 2;
         GraphicUtils.addGraphicToLayer(ud);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc8_:userData = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Body = null;
         super.trigger(param1,param2);
         if(this.targetBody)
         {
            if(userData(this.targetBody.GetUserData()).dead)
            {
               this.targetBody = null;
               this.trapped = false;
               return;
            }
            body.WakeUp();
            _loc3_ = new b2Vec2(Math.random() * 100 - 50,Math.random() * 100 - 50);
            _loc3_.Multiply(body.GetMass());
            body.ApplyForce(_loc3_,body.GetWorldCenter());
            if(!this.trapped)
            {
               this.trapped = true;
               this.targetBody.SetXForm(bodyCenter,0);
            }
            if(BoxUtils.vectorDist(this.targetBody.GetWorldCenter(),bodyCenter) > 5 * ud.size)
            {
               this.targetBody = null;
               this.trapped = false;
               return;
            }
         }
         var _loc4_:b2Vec2 = ud.triggerPos.Copy();
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,triggerRadius,triggerRadius);
         for each(_loc10_ in _loc7_)
         {
            _loc8_ = userData(_loc10_.GetUserData());
            if(_loc8_.trigger is Drone)
            {
               _loc9_ = _loc10_.GetWorldCenter();
               _loc3_ = _loc6_.Copy();
               _loc3_.Multiply(1 / Physics.scale);
               _loc3_.Subtract(_loc9_);
               _loc3_.Multiply(triggerForce * _loc10_.GetMass() * 0.1);
               _loc10_.ApplyForce(_loc3_,_loc9_);
            }
         }
      }
      
      override public function onUntrigger() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         super.onUntrigger();
         if(this.targetBody)
         {
            _loc1_ = ud.triggerPos.Copy();
            _loc2_ = BoxUtils.rotateVec(_loc1_,bodyAngle);
            _loc3_ = new b2Vec2(pixelCenter.x + _loc2_.x,pixelCenter.y + _loc2_.y);
            _loc3_.Multiply(1 / Physics.scale);
            userData(this.targetBody.GetUserData()).triggered = true;
            this.targetBody.SetXForm(_loc3_,bodyAngle);
            this.targetBody = null;
            this.trapped = false;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            return true;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(Boolean(_loc7_.trigger) && _loc7_.trigger is Drone)
         {
            this.targetBody = param1;
            userData(this.targetBody.GetUserData()).triggered = false;
         }
         return true;
      }
   }
}

