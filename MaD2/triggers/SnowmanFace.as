package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class SnowmanFace extends ArmourHelmet
   {
      
      internal var allowed:Array = ["doll_head","snowblock1"];
      
      public function SnowmanFace(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function Position(param1:b2Body) : void
      {
         equipAngle = Math.random() * Vars.PI * 2;
         ud.triggerPos.x *= userData(param1.GetUserData()).width / 24;
         ud.triggerPos.y *= userData(param1.GetUserData()).height / 24;
         super.Position(param1);
      }
      
      override protected function equip(param1:b2Body, param2:Boolean = false) : Boolean
      {
         var _loc3_:userData = userData(param1.GetUserData());
         if(this.AttachCheck(_loc3_.name))
         {
            if(isAttached(param1))
            {
               return false;
            }
            this.Position(param1);
            return Attach(param1);
         }
         return false;
      }
      
      override protected function EquipCheck(param1:b2Body) : Boolean
      {
         var _loc2_:Boolean = userData(param1.GetUserData()).armour != null;
         return !_loc2_;
      }
      
      override protected function AttachCheck(param1:String) : Boolean
      {
         return true;
      }
   }
}

