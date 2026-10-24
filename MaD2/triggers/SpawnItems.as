package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SpawnItems extends Trigger
   {
      
      private var items:Array;
      
      private var posx:Array;
      
      private var posy:Array;
      
      private var forceX:Array;
      
      private var forceY:Array;
      
      private var forceR:b2Vec2;
      
      private var rot:Array;
      
      private var scale:Array;
      
      private var weight:Array;
      
      protected var destroyOriginal:Boolean = true;
      
      protected var temp:Number = 0;
      
      protected var velMulti:Number = 1;
      
      protected var totallyRandomScale:Number = 0;
      
      protected var randomScale:Number = 0;
      
      protected var randomPos:Boolean = false;
      
      protected var otherInstead:Boolean = false;
      
      protected var ignoreSame:Boolean = false;
      
      protected var triggerItems:Boolean = false;
      
      protected var other:b2Body;
      
      protected var properties:String;
      
      protected var customs:Object;
      
      public function SpawnItems()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.customs = ud.ParseTriggerCustom();
         this.posx = [0];
         this.posy = [0];
         if(this.customs["items"])
         {
            this.items = this.customs["items"].split(",");
         }
         if(this.customs["posX"])
         {
            this.posx = this.customs["posX"].split(",");
         }
         if(this.customs["posY"])
         {
            this.posy = this.customs["posY"].split(",");
         }
         if(this.customs["rot"])
         {
            this.rot = this.customs["rot"].split(",");
         }
         if(this.customs["scale"])
         {
            this.scale = this.customs["scale"].split(",");
         }
         if(this.customs["forceX"])
         {
            this.forceX = this.customs["forceX"].split(",");
         }
         if(this.customs["forceY"])
         {
            this.forceY = this.customs["forceY"].split(",");
         }
         if(this.customs["weight"])
         {
            this.weight = this.customs["weight"].split(",");
         }
         if(this.customs["destroy"])
         {
            this.destroyOriginal = GeneralUtils.toBool(this.customs["destroy"]);
         }
         if(this.customs["temporary"])
         {
            if(GeneralUtils.toBool(this.customs["temporary"]))
            {
               this.temp = 20;
            }
         }
         if(this.customs["duration"])
         {
            this.temp = this.customs["duration"];
         }
         if(this.customs["velocityMultiplier"])
         {
            this.velMulti = Number(this.customs["velocityMultiplier"]);
         }
         if(this.customs["randomScale"])
         {
            this.totallyRandomScale = this.customs["randomScale"];
         }
         if(this.customs["scaleRandom"])
         {
            this.randomScale = this.customs["scaleRandom"];
         }
         if(this.customs["randomPos"])
         {
            this.randomPos = GeneralUtils.toBool(this.customs["randomPos"]);
         }
         if(this.customs["posRandom"])
         {
            this.randomPos = GeneralUtils.toBool(this.customs["posRandom"]);
         }
         if(this.customs["other"])
         {
            this.otherInstead = GeneralUtils.toBool(this.customs["other"]);
         }
         if(this.customs["ignoreSame"])
         {
            this.ignoreSame = GeneralUtils.toBool(this.customs["ignoreSame"]);
         }
         if(this.customs["properties"])
         {
            this.properties = this.customs["properties"];
         }
         if(this.customs["triggered"])
         {
            this.triggerItems = GeneralUtils.toBool(this.customs["triggered"]);
         }
         if(GeneralUtils.isStringVector(this.customs["forceR"]))
         {
            this.forceR = GeneralUtils.toVec(this.customs["forceR"]);
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Body = null;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         super.trigger(param1,param2);
         if(!this.items)
         {
            param2.triggered = false;
         }
         var _loc3_:b2Body = param1;
         if(this.otherInstead && Boolean(this.other))
         {
            _loc3_ = this.other;
         }
         var _loc4_:Number = _loc3_.GetAngularVelocity();
         var _loc5_:b2Vec2 = _loc3_.GetLinearVelocity().Copy();
         var _loc6_:Number = this.velMulti;
         if(param2.triggerForce)
         {
            _loc6_ *= param2.triggerForce * 0.01;
         }
         _loc4_ *= _loc6_;
         _loc5_.Multiply(_loc6_);
         if(this.destroyOriginal)
         {
            Body.Destroy(param1,"explosion");
         }
         var _loc8_:Number = GameState.objects.spawnScale;
         var _loc9_:Number = Vars.objDensity;
         var _loc10_:int = 0;
         while(_loc10_ < this.items.length)
         {
            _loc11_ = 1;
            if(Boolean(this.scale) && Boolean(this.scale[_loc10_]))
            {
               _loc11_ = Number(this.scale[_loc10_]);
            }
            if(this.randomScale)
            {
               _loc11_ += Math.random() * this.randomScale - this.randomScale * 0.5;
            }
            if(this.totallyRandomScale)
            {
               _loc11_ = Math.random() * this.totallyRandomScale;
            }
            GameState.objects.spawnScale = _loc11_;
            if(this.randomPos)
            {
               _loc12_ = BoxUtils.randomPointOnBody(_loc3_,true);
            }
            else
            {
               _loc12_ = BoxUtils.rotateVec(new b2Vec2(Number(this.posx[_loc10_]),Number(this.posy[_loc10_])),_loc3_.GetAngle());
               _loc12_.Add(BoxUtils.pixelPosition(_loc3_));
            }
            _loc13_ = 0;
            if(Boolean(this.rot) && Boolean(this.rot[_loc10_]))
            {
               _loc13_ = Number(this.rot[_loc10_]);
            }
            if(Boolean(this.weight) && Boolean(this.weight[_loc10_]))
            {
               Vars.objDensity = this.weight[_loc10_];
            }
            _loc14_ = _loc3_.GetAngle() * Vars.toDegrees + _loc13_;
            _loc7_ = GameState.objects.spawnObject(this.items[_loc10_],_loc12_.x,_loc12_.y,_loc14_,false,true,param2.skin);
            _loc7_.SetAngularVelocity(_loc4_);
            _loc7_.SetLinearVelocity(_loc5_);
            _loc15_ = 0;
            _loc16_ = 0;
            if(Boolean(this.forceX) && Boolean(this.forceX[_loc10_]))
            {
               _loc15_ = Number(this.forceX[_loc10_]);
            }
            if(Boolean(this.forceY) && Boolean(this.forceY[_loc10_]))
            {
               _loc16_ = Number(this.forceX[_loc10_]);
            }
            if(this.forceR)
            {
               _loc15_ += Math.random() * this.forceR.x;
               _loc16_ += Math.random() * this.forceR.y;
            }
            _loc7_.ApplyForce(new b2Vec2(_loc15_,_loc16_),_loc7_.GetWorldCenter());
            if(this.properties)
            {
               userData(_loc7_.GetUserData()).setProperties(this.properties);
            }
            if(this.ignoreSame)
            {
               userData(_loc7_.GetUserData()).ignore = userData(_loc7_.GetUserData()).name;
            }
            if(this.triggerItems)
            {
               userData(_loc7_.GetUserData()).triggered = true;
            }
            if(this.temp > 0)
            {
               userData(_loc7_.GetUserData()).trigger = new TempProjectile(this.temp * 0.75 + Math.random() * this.temp * 0.5);
               userData(_loc7_.GetUserData()).triggered = true;
               userData(_loc7_.GetUserData()).triggerLock = true;
            }
            _loc10_++;
         }
         Vars.objDensity = _loc9_;
         GameState.objects.spawnScale = _loc8_;
      }
   }
}

