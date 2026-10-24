package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class AnimateHead extends Trigger
   {
      
      internal var armour:Armour;
      
      private var needsReAnimating:Boolean = false;
      
      public function AnimateHead(param1:b2Body)
      {
         super();
         var _loc2_:userData = userData(param1.GetUserData());
         this.armour = _loc2_.armour;
         if(this.armour)
         {
            this.armour.OnAttach = this.attach;
            this.armour.OnDetach = this.detach;
         }
         _loc2_.triggered = false;
         _loc2_.triggerLock = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         if(this.needsReAnimating)
         {
            _loc3_ = BoxUtils.selectCompound(this.armour.attachedBody);
            _loc3_.push(this.armour.attachedBody);
            userData(this.armour.attachedBody.GetUserData()).head = true;
            for each(_loc5_ in _loc3_)
            {
               _loc4_ = userData(_loc5_.GetUserData());
               if(_loc4_)
               {
                  Body.Animate(_loc5_);
               }
            }
            ud.triggered = false;
            ud.triggerLock = true;
            this.needsReAnimating = false;
         }
      }
      
      internal function attach() : void
      {
         if(!this.armour.attachedBody)
         {
            return;
         }
         this.needsReAnimating = true;
         ud.triggerLock = false;
         ud.triggered = true;
      }
      
      internal function detach() : void
      {
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         if(!this.armour.attachedBody)
         {
            return;
         }
         var _loc1_:Array = BoxUtils.selectCompound(this.armour.attachedBody);
         _loc1_.push(this.armour.attachedBody);
         userData(this.armour.attachedBody.GetUserData()).head = true;
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = userData(_loc3_.GetUserData());
            if(_loc2_)
            {
               _loc2_.animated = false;
            }
         }
      }
   }
}

