package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ModifyGravity extends ModifyForce
   {
      
      public function ModifyGravity(param1:Number)
      {
         super(0,Vars.gravity * param1);
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         BoxUtils.randomParticlesOnBody(param1,"gravity");
      }
   }
}

