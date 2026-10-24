package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MilkCookie extends Trigger
   {
      
      public function MilkCookie()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(ud.triggerState == 0)
         {
            return;
         }
         ud.trigger = new Disintegrate("fried",100,10);
         var _loc3_:Number = Vars.objSize;
         var _loc4_:b2Body = GameState.objects.spawnObject("christmasbooster",pixelCenter.x,-100);
         Vars.objSize = 0.2;
         var _loc5_:b2Body = GameState.objects.spawnObject("parachute",pixelCenter.x,-140);
         Vars.objSize = _loc3_;
         if(_loc4_)
         {
            userData(_loc4_.GetUserData()).ignore = "!projectiles";
            userData(_loc4_.GetUserData()).triggerState = 1;
            userData(_loc4_.GetUserData()).triggered = true;
         }
         if(_loc5_)
         {
            userData(_loc5_.GetUserData()).ignore = "!projectiles";
            userData(_loc5_.GetUserData()).triggerState = 2;
            userData(_loc5_.GetUserData()).triggered = true;
            userData(_loc5_.GetUserData()).triggerForce = 75;
            userData(_loc5_.GetUserData()).triggerRadius = 400;
         }
         if(Boolean(_loc4_) && Boolean(_loc5_))
         {
            jointUserData(Joints.Distance("ropejoint",_loc4_,_loc5_,new b2Vec2(_loc4_.GetPosition().x - 0.2,_loc4_.GetPosition().y - 0.5),new b2Vec2(_loc5_.GetPosition().x - 0.5,_loc5_.GetPosition().y + 0.2)).GetUserData()).lineWidth = 1;
            jointUserData(Joints.Distance("ropejoint",_loc4_,_loc5_,new b2Vec2(_loc4_.GetPosition().x + 0.2,_loc4_.GetPosition().y - 0.5),new b2Vec2(_loc5_.GetPosition().x + 0.5,_loc5_.GetPosition().y + 0.2)).GetUserData()).lineWidth = 1;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!ud || ud.triggerState == 1)
         {
            return false;
         }
         if(!param1)
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return false;
         }
         if(_loc7_.name == "EEEEEE")
         {
            if(!GameState.ui.genericToolTip.running)
            {
               GameState.ui.showTooltip(ud.graphic,"The milk-soaked cookie disintegrates into crumbs in a sudden blur of red.\nYou hear a heavily-dopplered \'HOHOOHOOOOOOO!\',\nas if bellowed by someone travelling at just under the speed of sound.\n\n",10,8000,300);
            }
            ud.triggerLock = false;
            ud.triggerState = 1;
            ud.triggered = true;
            return false;
         }
         if(param4 > 100)
         {
            ud.trigger = new Disintegrate("fried",100,2);
            ud.triggered = true;
         }
         return true;
      }
   }
}

