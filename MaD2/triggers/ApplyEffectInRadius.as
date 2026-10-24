package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ApplyEffectInRadius extends Trigger
   {
      
      internal var customs:Object;
      
      internal var once:Boolean = false;
      
      internal var randomly:Number = 0;
      
      internal var particle:String = "none";
      
      internal var effect:String = "none";
      
      public function ApplyEffectInRadius()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:Object = param2.ParseTriggerCustom();
         this.once = GeneralUtils.toBool(_loc3_["once"]);
         this.randomly = GeneralUtils.ObjValue(0,_loc3_["randomly"]);
         this.particle = GeneralUtils.ObjValue("none",_loc3_["particle"]);
         this.effect = GeneralUtils.ObjValue(ud.triggerCustom,_loc3_["effect"]);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(this.randomly > 0 && Math.random() > this.randomly)
         {
            return;
         }
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         for each(_loc4_ in _loc3_)
         {
            if(param2.ignored.indexOf(_loc4_) == -1)
            {
               if(!(this.randomly > 0 && Math.random() > this.randomly))
               {
                  _loc5_ = pixelCenter;
                  Body.ApplyEffect(_loc4_,this.effect,_loc5_,param1);
                  if(this.once)
                  {
                     param2.ignored.push(_loc4_);
                  }
               }
            }
         }
         if(this.effect != "none")
         {
            BoxUtils.AoEParticles(param1,this.particle);
         }
      }
   }
}

