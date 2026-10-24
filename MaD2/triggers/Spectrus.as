package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Spectrus extends Trigger
   {
      
      private var maxTentacles:Number = 6;
      
      protected var aliveOnly:Boolean = false;
      
      protected var skinny:uint;
      
      public function Spectrus(param1:uint, param2:Boolean = true)
      {
         super();
         this.skinny = param1;
         this.aliveOnly = param2;
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         if(param1.IsStatic())
         {
            return;
         }
         if(!ud || !ud.triggered)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(this.aliveOnly && !_loc3_.alive)
         {
            return;
         }
         if(Joints.NumJoints(param1) > this.maxTentacles)
         {
            return;
         }
         updateTriggerHelpers();
         Body.Tentacle(body,param1,this.skinny);
      }
   }
}

