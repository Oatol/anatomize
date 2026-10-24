package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class VoodooDoll extends Trigger
   {
      
      public function VoodooDoll()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:b2Body = null;
         var _loc7_:Array = null;
         super.trigger(param1,param2);
         var _loc4_:Vector.<b2Body> = param2.connected;
         for each(_loc5_ in _loc4_)
         {
            _loc3_ = userData(_loc5_.GetUserData());
            if(_loc3_.name == "voodoodoll")
            {
               _loc3_.disconnect(param1);
               param2.disconnect(_loc5_);
            }
         }
         if(param2.bleeding.length > 0)
         {
            for each(_loc5_ in _loc4_)
            {
               _loc3_ = userData(_loc5_.GetUserData());
               _loc7_ = param2.bleeding[0];
               _loc3_.bleeding.push([new b2Vec2(),new b2Vec2(),_loc7_[2],_loc7_[3]]);
            }
            param2.bleeding = [];
         }
         if(param2.burning)
         {
            for each(_loc5_ in _loc4_)
            {
               _loc3_ = userData(_loc5_.GetUserData());
               _loc3_.temperature += 1000;
            }
            param2.burning = false;
            param2.temperature = 20;
         }
         if(param2.temperature <= 0)
         {
            for each(_loc5_ in _loc4_)
            {
               if(userData(_loc5_.GetUserData()).temperature > 0)
               {
                  Body.Freeze(_loc5_,-50);
               }
            }
            param2.temperature = 20;
         }
         var _loc6_:Number = param2.health - param2.maxhealth;
         if(_loc6_ < 0)
         {
            for each(_loc5_ in _loc4_)
            {
               userData(_loc5_.GetUserData()).health = userData(_loc5_.GetUserData()).health + _loc6_;
            }
            param2.health = param2.maxhealth;
         }
         if(bodyVel.Length() > 40)
         {
            for each(_loc5_ in _loc4_)
            {
               _loc5_.SetLinearVelocity(new b2Vec2(bodyVel.x * 3,bodyVel.y * 3));
            }
         }
         if(param1.GetAngularVelocity() > 10)
         {
            for each(_loc5_ in _loc4_)
            {
               _loc5_.SetAngularVelocity(param1.GetAngularVelocity() * 10);
            }
         }
      }
      
      override public function OnCut() : Boolean
      {
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc1_:Vector.<b2Body> = ud.connected;
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = userData(_loc3_.GetUserData());
            Body.Damage(_loc3_,200);
            if(_loc2_.health <= 0)
            {
               Body.brittle(_loc3_);
            }
         }
         return false;
      }
   }
}

