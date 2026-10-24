package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SuddenlyAim extends Trigger
   {
      
      internal var dir:Number = 1;
      
      public function SuddenlyAim()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = triggerPos;
         var _loc4_:b2Vec2 = param1.GetPosition();
         var _loc5_:Number = _loc3_.x - _loc4_.x;
         var _loc6_:Number = _loc3_.y - _loc4_.y;
         _loc7_ = param1.GetLinearVelocity();
         if(Math.random() > 0.9)
         {
            _loc7_.x += Math.random() * 100 - 50;
            _loc7_.y += Math.random() * 100 - 50;
         }
         var _loc8_:b2Body = param2.connected[0];
         if(userData(_loc8_.GetUserData()).dead || userData(_loc8_.GetUserData()).hasBeenCut)
         {
            param2.killOnContact = true;
            return;
         }
         var _loc9_:Number = _loc8_.GetPosition().x * Physics.scale;
         var _loc10_:Number = _loc8_.GetPosition().y * Physics.scale;
         var _loc11_:Number = _loc8_.GetAngle();
         if(userData(_loc8_.GetUserData()).flipped)
         {
            _loc11_ += Vars.PI;
         }
         var _loc12_:b2Vec2 = BoxUtils.rotateVec(userData(_loc8_.GetUserData()).triggerPos,_loc11_);
         _loc9_ += _loc12_.x;
         _loc10_ += _loc12_.y;
         if(pixelCenter.y > _loc10_ + 100)
         {
            bodyCenter.y = (_loc10_ + 100) / Physics.scale;
            _loc7_.y *= -1;
         }
         else if(pixelCenter.y < _loc10_ - 100)
         {
            bodyCenter.y = (_loc10_ - 100) / Physics.scale;
            _loc7_.y *= -1;
         }
         if(pixelCenter.x > _loc9_ + 100)
         {
            bodyCenter.x = (_loc9_ + 100) / Physics.scale;
            _loc7_.x *= -1;
         }
         else if(pixelCenter.x < _loc9_ - 100)
         {
            bodyCenter.x = (_loc9_ - 100) / Physics.scale;
            _loc7_.x *= -1;
         }
         param1.SetXForm(bodyCenter,Math.atan2(param1.GetLinearVelocity().y,param1.GetLinearVelocity().x));
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(Math.random() > 0.95)
         {
            ud.trigger = new DisintegratePowder(10,10);
         }
         return true;
      }
   }
}

