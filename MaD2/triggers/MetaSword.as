package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class MetaSword extends Trigger
   {
      
      public function MetaSword()
      {
         super();
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         var _loc4_:String = null;
         if(!ud)
         {
            return;
         }
         if(!ud.triggered)
         {
            return;
         }
         if(ud.triggerDuration > 0)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         ud.triggerDuration = ud.originalTriggerDuration;
         var _loc5_:Array = ["explosive","implosive","sticky","sharp","breakable","crumble","brittle","zerograv","antigrav","magnet","sensor","alive","flaming","freezing","shocking","healing","dispelling","gusting","killing","draining","poisoning","ghost","unbreakable","invisible"];
         _loc4_ = _loc5_[_loc5_.length * Math.random() >> 0];
         _loc3_.setProperties(_loc4_);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
      }
   }
}

