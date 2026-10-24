package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class FirearmReloadRequired extends Gun
   {
      
      internal var reloaded:Number = 1;
      
      internal var customs:Object;
      
      internal var layers:Array;
      
      internal var alphas:Array;
      
      internal var colours:Array;
      
      internal var ammos:Array;
      
      internal var ammo:Number = 5;
      
      public function FirearmReloadRequired(param1:Firearm)
      {
         super(param1);
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc4_:String = null;
         super.init(param1,param2);
         this.customs = ud.ParseTriggerCustom();
         this.ammos = this.customs["ammos"].split(",");
         this.ammo = Number(this.customs["ammoNeeded"]);
         this.layers = GeneralUtils.toIntArray(this.customs["layers"]);
         this.alphas = GeneralUtils.toNumberArray(this.customs["alphas"]);
         var _loc3_:Array = this.customs["colours"].split(",");
         this.colours = [];
         for each(_loc4_ in _loc3_)
         {
            this.colours.push(BoxUtils.getSkinColour(ud.skin,_loc4_));
         }
         Body.ModifyLayerAlpha(body,[this.layers[0]],[0],[this.colours[0]]);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(param2.triggerState == 2)
         {
            param2.triggerDuration += TimeLord.timerSpeed;
            Body.ModifyLayerAlpha(param1,[this.layers[0]],[1 - param2.triggerDuration / param2.originalTriggerDuration],[this.colours[0]]);
            Body.ModifyLayerAlpha(param1,[this.layers[1]],[param2.triggerDuration / param2.originalTriggerDuration],[this.colours[1]]);
            if(param2.triggerDuration >= param2.originalTriggerDuration)
            {
               firearm.forceReload();
               param2.triggered = false;
               param2.triggerState = 0;
               return;
            }
         }
         if(param2.triggerState == 0)
         {
            super.trigger(param1,param2);
            param2.triggerState = 1;
            Body.ModifyLayerAlpha(param1,[this.layers[1]],[this.alphas[1]],[this.colours[1]]);
            this.reloaded = 0.1;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = userData(param1.GetUserData());
         if(Boolean(this.reloaded < 1 && this.ammos.indexOf(_loc7_.name) != -1) && Boolean(ud) && ud.triggerState == 1)
         {
            this.reloaded += 1 / this.ammo;
            if(this.reloaded > 1)
            {
               this.reloaded = 1;
            }
            _loc7_.triggerCustom = "amount=3;particle=spiky";
            _loc7_.name = "notmeatball";
            _loc7_.saveable = false;
            _loc7_.trigger = new DisintegrateIntoParticles();
            _loc7_.triggered = true;
            _loc7_.triggerLock = true;
            Body.ModifyLayerAlpha(body,[this.layers[0]],[this.reloaded],[this.colours[0]]);
            if(this.reloaded >= 1)
            {
               ud.triggerState = 2;
               ud.triggered = true;
               ud.triggerDuration = 1;
            }
         }
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
   }
}

