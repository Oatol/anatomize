package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Disc extends GenericBullet
   {
      
      private var customs:Object;
      
      internal var particles:Array = ["laser"];
      
      protected var sfx:Array = ["explosion5"];
      
      internal var cuts:int = 10;
      
      internal var particleSpread:Number = 100;
      
      public function Disc()
      {
         super(null);
      }
      
      override protected function safeExplode() : void
      {
         var _loc6_:Vector.<MyLittleParticle> = null;
         var _loc7_:MyLittleParticle = null;
         super.safeExplode();
         var _loc1_:Vector.<Array> = ud.skin;
         var _loc2_:uint = 15281429;
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            _loc2_ = BoxUtils.getSkinColour(_loc1_,"e92d15");
         }
         if(_loc2_ == 16711935)
         {
            _loc2_ = 15281429;
         }
         var _loc3_:int = 100;
         if(!this.customs)
         {
            this.customs = ud.ParseTriggerCustom();
         }
         if(this.customs["particlesExplosion"])
         {
            _loc3_ = int(this.customs["particlesExplosion"]);
         }
         if(this.customs["particleSpread"])
         {
            this.particleSpread = this.customs["particleSpread"];
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = GameState.particles.addParticles(pixelCenter.x + Math.random() * 5,pixelCenter.y + Math.random() * 5,1,this.particles[Math.random() * this.particles.length >> 0],bodyVel.x * this.particleSpread * 0.1,bodyVel.y * this.particleSpread * 0.1,Math.random() * this.particleSpread,Math.random() * this.particleSpread);
            if((Boolean(_loc6_)) && _loc6_.length > 0)
            {
               for each(_loc7_ in _loc6_)
               {
                  _loc7_.colour = (Math.random() * 255 << 24) + _loc2_;
                  _loc7_.wanderX = Math.random() * 10 - 5;
                  _loc7_.wanderY = Math.random() * 10 - 5;
               }
            }
            _loc4_++;
         }
         if(this.customs["cuts"])
         {
            if(this.customs["cuts"] == "true")
            {
               this.cuts = 10;
            }
            else
            {
               this.cuts = Number(this.customs["cuts"]);
            }
         }
         if(this.customs["sounds"])
         {
            this.sfx = this.customs["sounds"].split(",");
         }
         sounds.random(this.sfx,body,pixelCenter,Math.random() * 0.1 + 0.2);
         Body.Destroy(body,"explosion");
         var _loc5_:Number = 1000;
         if(ud.triggerForce)
         {
            _loc5_ = ud.triggerForce;
         }
         if(ud.triggerRadius > 0)
         {
            World.explode("disc",pixelCenter,_loc5_,ud.triggerRadius,false,this.cuts,"normal");
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:Vector.<MyLittleParticle> = null;
         var _loc8_:MyLittleParticle = null;
         super.trigger(param1,param2);
         var _loc3_:Vector.<Array> = param2.skin;
         var _loc4_:uint = 15281429;
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = BoxUtils.getSkinColour(_loc3_,"e92d15");
         }
         if(!this.customs)
         {
            this.customs = param2.ParseTriggerCustom();
            if(this.customs["particles"])
            {
               this.particles = this.customs["particles"].split(",");
            }
         }
         var _loc5_:int = 10;
         if(this.customs["particlesTrigger"])
         {
            _loc5_ = int(this.customs["particlesTrigger"]);
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = GameState.particles.addParticles(pixelCenter.x + Math.random() * 5,pixelCenter.y + Math.random() * 5,1,this.particles[Math.random() * this.particles.length >> 0],bodyVel.x * 0.1,bodyVel.y * 0.1,1,1);
            if((Boolean(_loc7_)) && _loc7_.length > 0)
            {
               for each(_loc8_ in _loc7_)
               {
                  _loc8_.colour = (Math.random() * 255 << 24) + _loc4_;
               }
            }
            _loc6_++;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(userData(param1.GetUserData()).name == ud.ignore)
         {
            return false;
         }
         if(ud.triggerCustom)
         {
            if(!this.customs)
            {
               this.customs = ud.ParseTriggerCustom();
            }
            if(Boolean(this.customs["burn"]) && Boolean(this.customs["damage"]))
            {
               _loc7_ = Number(this.customs["damage"]);
               _loc8_ = 20;
               if(Number(this.customs["burnradius"]))
               {
                  _loc8_ = Number(this.customs["burnradius"]);
               }
               Body.Burn(param1,param5,Math.random() * _loc7_ + _loc7_ * 0.5,Number(this.customs["burn"]),_loc8_);
            }
         }
         explode();
         return true;
      }
   }
}

