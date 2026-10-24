package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class AmmoBelt extends MiscAttachment
   {
      
      private var origReload:int;
      
      public function AmmoBelt()
      {
         super();
         hand1 = new b2Vec2(0,-15 / Physics.scale);
         ray1 = new b2Vec2(0,-25 / Physics.scale);
         rayRange = 4;
         attachmentID = 1000004;
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(param2 != "weldjoint" && param2 != "equip")
         {
            return true;
         }
         if(!super.OnJoint(param1,param2))
         {
            return false;
         }
         if(!(userData(param1.GetUserData()).trigger is Gun))
         {
            return true;
         }
         if(isAttached(param1))
         {
            return false;
         }
         if(!attachedFirearm)
         {
            return false;
         }
         this.origReload = attachedFirearm.reloadTime;
         var _loc3_:Number = ud.triggerForce * 0.01;
         attachedFirearm.reloadTime = this.origReload * (1 - _loc3_);
         if(attachedFirearm.reloadTime < 1)
         {
            attachedFirearm.reloadTime = 1;
         }
         return true;
      }
      
      override public function OnDelete() : void
      {
         if(gunBody)
         {
            attachedFirearm.reloadTime = this.origReload;
         }
         super.OnDelete();
      }
   }
}

