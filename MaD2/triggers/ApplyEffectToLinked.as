package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ApplyEffectToLinked extends Trigger
   {
      
      internal var once:Boolean = false;
      
      internal var randomly:Number = 0;
      
      internal var particle:String = "none";
      
      internal var effect:String = "none";
      
      public function ApplyEffectToLinked()
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
         var _loc3_:b2Body = null;
         var _loc4_:b2Vec2 = null;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            if(param2.ignored.indexOf(_loc3_) == -1)
            {
               if(!(this.randomly > 0 && Math.random() > this.randomly))
               {
                  _loc4_ = _loc3_.GetWorldCenter().Copy();
                  _loc4_.Multiply(Physics.scale);
                  Body.ApplyEffect(_loc3_,this.effect,_loc4_,param1);
                  if(this.once)
                  {
                     param2.ignored.push(_loc3_);
                  }
                  if(this.effect != "none")
                  {
                     BoxUtils.randomSlopeParticles(this.effect,pixelCenter,_loc4_);
                  }
               }
            }
         }
      }
   }
}

