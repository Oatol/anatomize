package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Radioactive extends Trigger
   {
      
      internal var clones:int = 0;
      
      internal var canDuplicate:Boolean = true;
      
      internal var canParticles:Boolean = true;
      
      public function Radioactive(param1:Boolean = true, param2:Boolean = true)
      {
         super();
         this.canDuplicate = param1;
         this.canParticles = param2;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         var _loc5_:b2Body = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         super.trigger(param1,param2);
         if(Math.random() * TimeLord.speed < TimeLord.speed * 0.1)
         {
            if(this.canParticles)
            {
               _loc6_ = "radioactive";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc6_ = param2.pfx.getParticle();
               }
               BoxUtils.randomParticlesOnBody(param1,_loc6_,2);
            }
            else
            {
               GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"sparkle",0,0,1,1);
            }
            _loc3_ = param2.triggerRadius;
            _loc4_ = Body.GetAround(param1,_loc3_,_loc3_,false);
            for each(_loc5_ in _loc4_)
            {
               Body.Radiation(_loc5_);
            }
            if(this.canDuplicate && this.clones < 10 && !param1.IsSleeping() && Math.random() > 0.9)
            {
               ++this.clones;
               _loc7_ = Vars.objDensity;
               Vars.objDensity = 0;
               _loc8_ = GameState.objects.delayedSpawnObject("portal2",pixelCenter.x,pixelCenter.y - 50);
               Vars.objDensity = _loc7_;
               _loc9_ = userData(_loc8_.GetUserData());
               _loc9_.trigger = new Radioactive(false);
               _loc9_.ignore = "radioactivebarrel";
               _loc9_.triggerRadius = triggerRadius * 0.5;
               _loc9_.triggered = true;
               _loc9_.zerograv = true;
               _loc9_.graphic.alpha = 0;
               _loc9_.saveable = false;
               _loc9_.ghost = true;
            }
         }
      }
   }
}

