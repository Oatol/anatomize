package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GateInput extends GateLogic
   {
      
      public function GateInput()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         output = true;
      }
      
      override public function OnSaveCustom() : void
      {
         super.OnSaveCustom();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(output)
         {
            Effect();
         }
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         output = !output;
         ud.triggerCustom = output ? "1" : "0";
      }
      
      override public function OnLoadCustom() : void
      {
         super.OnLoadCustom();
         output = true;
         if(ud.triggerCustom == "0")
         {
            output = false;
         }
      }
      
      override public function onUntrigger() : void
      {
         output = !output;
         ud.triggerCustom = output ? "1" : "0";
         ud._triggered = true;
      }
   }
}

