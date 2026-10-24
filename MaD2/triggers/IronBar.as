package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class IronBar extends Transmute
   {
      
      internal var blades:Array = ["recurveblade","seaxblade","sharpfingerblade","neckblade","bowieblade","karambitblade","kukriblade"];
      
      public function IronBar()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(ud.triggerState == 0)
         {
            return;
         }
         if(ud.triggerState == 1)
         {
            item = this.blades[int(Math.random() * this.blades.length)];
         }
         else if(ud.triggerState == 2)
         {
            item = "bananaknife";
         }
         super.trigger(param1,param2);
         var _loc3_:int = 0;
         while(_loc3_ < 20)
         {
            BoxUtils.randomParticlesOnBody(body,"rocky",2);
            _loc3_++;
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
         if(_loc7_.name.indexOf("hammer") != -1)
         {
            ud.triggered = true;
            ud.triggerState = 1;
         }
         if(_loc7_.name.indexOf("banana") != -1)
         {
            ud.triggered = true;
            ud.triggerState = 2;
         }
         return true;
      }
   }
}

