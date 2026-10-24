package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ArmourPauldron extends Armour
   {
      
      public function ArmourPauldron(param1:b2Body, param2:Number)
      {
         super(param1,param2);
         attachTarget = "doll_arm";
      }
      
      override protected function Attach(param1:b2Body) : Boolean
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Body = null;
         var _loc2_:Array = BoxUtils.selectCompound(param1);
         for each(_loc4_ in _loc2_)
         {
            if(userData(_loc4_.GetUserData()).name == "doll_head")
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(!_loc3_)
         {
            return false;
         }
         var _loc5_:b2Vec2 = new b2Vec2(0,-1);
         var _loc6_:b2Vec2 = new b2Vec2(0,1);
         _loc5_ = BoxUtils.rotateVec(_loc5_,_loc3_.GetAngle());
         _loc6_ = BoxUtils.rotateVec(_loc6_,_loc3_.GetAngle());
         _loc5_.Add(_loc3_.GetPosition());
         _loc6_.Add(_loc3_.GetPosition());
         var _loc7_:Number = GeneralUtils.determinant(_loc5_.x,_loc5_.y,_loc6_.x,_loc6_.y,param1.GetPosition().x,param1.GetPosition().y);
         if(_loc7_ > 0)
         {
            equipAngle = Math.PI * 0.5;
            ud.triggerPos.x *= -1;
         }
         else
         {
            equipAngle = -Math.PI * 0.5;
         }
         Position(param1);
         return super.Attach(param1);
      }
   }
}

