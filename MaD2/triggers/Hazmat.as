package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Hazmat extends Trigger
   {
      
      internal var armour:Armour;
      
      public function Hazmat(param1:b2Body)
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
      
      internal function attach() : void
      {
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         if(!this.armour.attachedBody)
         {
            return;
         }
         var _loc1_:Array = BoxUtils.selectCompound(this.armour.attachedBody);
         _loc1_.push(this.armour.attachedBody);
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = userData(_loc3_.GetUserData());
            if(!(!_loc2_ || !_loc2_.alive))
            {
               if(_loc2_.name == this.armour.attachTarget)
               {
                  _loc2_.resistBlighting = true;
                  _loc2_.resistPoison = true;
                  _loc2_.resistRadioactive = true;
                  if(_loc2_.trigger is ToxinMelt)
                  {
                     _loc2_.triggerLock = false;
                     _loc2_.trigger.reset();
                     _loc2_.health += 10;
                  }
               }
            }
         }
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
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = userData(_loc3_.GetUserData());
            if(!(!_loc2_ || !_loc2_.alive))
            {
               if(_loc2_.name == this.armour.attachTarget)
               {
                  _loc2_.resistBlighting = false;
                  _loc2_.resistPoison = false;
                  _loc2_.resistRadioactive = false;
               }
            }
         }
      }
   }
}

