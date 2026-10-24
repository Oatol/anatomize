package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class BlueBlood extends Trigger
   {
      
      internal var colour:String = "0B3ABC";
      
      public function BlueBlood()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc4_:b2Body = null;
         var _loc5_:uint = 0;
         super.trigger(param1,param2);
         ud.triggered = false;
         for each(_loc4_ in param2.connected)
         {
            _loc3_ = userData(_loc4_.GetUserData());
            if(!(!_loc3_ || !_loc3_.alive))
            {
               _loc5_ = uint("0x" + this.colour);
               if(Boolean(ud.skin) && ud.skin.length > 0)
               {
                  _loc5_ = BoxUtils.getSkinColour(ud.skin,this.colour);
               }
               _loc3_.bloodColour = _loc5_;
            }
         }
      }
      
      override public function OnDelete() : void
      {
         var _loc1_:userData = null;
         var _loc2_:b2Body = null;
         super.OnDelete();
         for each(_loc2_ in ud.connected)
         {
            _loc1_ = userData(_loc2_.GetUserData());
            if(!(!_loc1_ || !_loc1_.alive))
            {
               _loc1_.bloodColour = Tweak.bloodColour;
            }
         }
      }
   }
}

