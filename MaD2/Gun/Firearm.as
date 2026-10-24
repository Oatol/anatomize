package Gun
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import triggers.Gun;
   
   public class Firearm
   {
      
      public var modified:Boolean = false;
      
      protected var _readyToFire:Boolean = false;
      
      protected var reloaded:Boolean = false;
      
      protected var _bullet:Bullet;
      
      protected var _casing:Casing;
      
      protected var _magazine:Magazine;
      
      protected var _body:b2Body;
      
      protected var _chamberTime:int;
      
      protected var _originalChamberTime:int;
      
      protected var _chamberDone:Number;
      
      protected var _currentBullet:int;
      
      protected var _reloadTime:Number;
      
      protected var _originalReloadTime:Number;
      
      protected var _reloadDone:Number;
      
      protected var _barrelPos:Vector.<Line>;
      
      protected var _shootForce:int;
      
      protected var _casingPos:Vector.<Line>;
      
      protected var _casingEject:b2Vec2;
      
      protected var _casingForce:int;
      
      protected var _magazineSize:int = 9999;
      
      protected var _magazinePos:Vector.<Line>;
      
      protected var _magazineEject:b2Vec2;
      
      protected var _magazineForce:int;
      
      protected var _bulletProperties:Array;
      
      protected var _recoil:int;
      
      protected var _scatter:Number;
      
      protected var _bulletAmount:int;
      
      protected var _burstAmount:int;
      
      protected var _burstDelay:Number;
      
      protected var _currentBurst:int;
      
      protected var _bulletSize:Number;
      
      protected var _shootingPos:b2Vec2;
      
      protected var _shootingAngle:Number;
      
      protected var _bulletAngle:Number;
      
      protected var _casingAngle:Number;
      
      protected var _magazineAngle:Number;
      
      protected var _centroid:b2Vec2;
      
      protected var _soundNames:Array;
      
      protected var _soundVolumes:Array;
      
      protected var _randomBulletAngle:Number;
      
      protected var _randomBulletSize:Number;
      
      protected var _casingReload:Boolean = false;
      
      public var disableAfterFiring:Boolean = true;
      
      public var destroyAfterFiring:Boolean = false;
      
      public var allowBarrelAttachments:Boolean = true;
      
      private var _datPos:b2Vec2;
      
      public var datPosFlipped:b2Vec2;
      
      protected var gun:Gun;
      
      public var bulletType:String;
      
      public function Firearm(param1:String, param2:b2Body, param3:int, param4:int, param5:int, param6:int, param7:String = "None", param8:Number = 1, param9:int = 1, param10:Number = 0, param11:Number = 0)
      {
         super();
         this.bulletType = param7;
         this._body = param2;
         this._soundNames = new Array();
         this._soundVolumes = new Array();
         this._barrelPos = new Vector.<Line>();
         this._casingPos = new Vector.<Line>();
         this._magazinePos = new Vector.<Line>();
         this._bulletProperties = new Array();
         this.gun = new Gun(this);
         userData(this._body.GetUserData()).trigger = this.gun;
         this._centroid = new b2Vec2();
         this.InitGun(param3,param3,param4,param5,param6,param8,param9,1,param11,param10);
         userData(this._body.GetUserData()).trigger.init(param2,param2.GetUserData());
      }
      
      public function InitGun(param1:int, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:int, param8:int, param9:Number, param10:Number) : void
      {
         this.chamberTime = param1;
         this._reloadTime = param2;
         this._shootForce = param3;
         this._recoil = param4;
         this._scatter = param5;
         this._bulletSize = param6;
         this._bulletAmount = param7;
         this._magazineSize = param8;
         this._shootingAngle = param9;
         this._bulletAngle = param10;
         this._chamberDone = 0;
         this._reloadDone = 0;
         this._readyToFire = true;
         this._burstAmount = 1;
         this._currentBurst = 0;
         this._burstDelay = 2;
         this._magazineForce = 1;
         this._casingForce = 1;
         this._currentBullet = 0;
         this._randomBulletAngle = 0;
         this._randomBulletSize = 0;
         this.chamber();
      }
      
      public function SetBulletProperty(param1:String, param2:Boolean) : void
      {
         this.modified = true;
         var _loc3_:int = this.bulletProperties.indexOf(param1);
         if(param2)
         {
            if(_loc3_ != -1)
            {
               return;
            }
            this.bulletProperties.push(param1);
         }
         else
         {
            if(_loc3_ == -1)
            {
               return;
            }
            this.bulletProperties.splice(_loc3_,1);
         }
      }
      
      public function SetProperty(param1:String, param2:Number) : *
      {
         if(param1 == "")
         {
            return;
         }
         if(!this[param1])
         {
            return;
         }
         this.modified = true;
         this[param1] = param2;
      }
      
      private function XMLFormat(param1:String, param2:*) : void
      {
         var _loc3_:String = "                  ";
         _loc3_ = _loc3_.substr(param1.length);
      }
      
      private function generateXML() : void
      {
         var _loc1_:String = userData(this._body.GetUserData()).name;
         var _loc2_:String = GeneralUtils.objectToName(_loc1_);
         this.XMLFormat("label",_loc2_);
         this.XMLFormat("object",_loc1_);
         this.XMLFormat("magazineSize",this._magazineSize);
         this.XMLFormat("reloadTime",this._reloadTime);
         this.XMLFormat("cycleTime",this._chamberTime);
         this.XMLFormat("burstAmount",this._burstAmount);
         this.XMLFormat("burstTime",this._burstDelay);
         this.XMLFormat("bulletModel",this.bulletType);
         this.XMLFormat("bulletAmount",this._bulletAmount);
         this.XMLFormat("bulletForce",this._shootForce);
         this.XMLFormat("bulletRecoil",this._recoil);
         this.XMLFormat("bulletScatter",this._scatter);
         this.XMLFormat("bulletSize",this._bulletSize);
         this.XMLFormat("muzzleX",this.datPos.x);
         this.XMLFormat("muzzleY",this.datPos.y);
         this.XMLFormat("muzzleXFlip",this.datPosFlipped.x);
         this.XMLFormat("sounds",this.soundNames.join(","));
         this.XMLFormat("volumes",this.soundVolumes.join(","));
         this.XMLFormat("casingModel",false);
         this.XMLFormat("casingX",this.datPos.x);
         this.XMLFormat("casingY",this.datPos.y);
         this.XMLFormat("casingXFlip",this.datPosFlipped.x);
         this.XMLFormat("magazineModel",false);
         this.XMLFormat("magazineX",this.datPos.x);
         this.XMLFormat("magazineY",this.datPos.y);
         this.XMLFormat("magazineXFlip",this.datPosFlipped.x);
         this.XMLFormat("lab",true);
         this.XMLFormat("barrelAttachments",true);
         this.XMLFormat("continuousTrigger",true);
         this.XMLFormat("casingReload",false);
      }
      
      public function shoot() : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         if(!this.readyToFire)
         {
            return false;
         }
         this.updateShootPos();
         if(!this._shootingPos)
         {
            return false;
         }
         this._readyToFire = false;
         this._chamberDone = 0;
         var _loc1_:int = 1;
         if(userData(this._body.GetUserData()).flipped)
         {
            _loc1_ = -1;
         }
         var _loc2_:Number = this.body.GetAngle() + this._shootingAngle * _loc1_ * Vars.toRadians;
         var _loc3_:Number = Math.random() * this._scatter - this._scatter * 0.5;
         _loc3_ *= Math.PI / 180;
         var _loc4_:Number = Math.cos(_loc2_);
         var _loc5_:Number = Math.sin(_loc2_);
         var _loc6_:Number = userData(this._body.GetUserData()).size;
         if(this.bulletType != "None")
         {
            _loc7_ = this._bulletAngle;
            _loc8_ = this._bulletSize * _loc6_;
            _loc8_ = _loc8_ + (Math.random() * this._randomBulletSize - this._randomBulletSize * 0.5);
            GameState.objects.addbullet(this.bulletType,this._shootingPos.x,this._shootingPos.y,_loc2_ + Vars.PI,this._bulletAmount,_loc8_,new b2Vec2(_loc1_ * -this._shootForce * _loc4_,_loc1_ * -this.shootForce * _loc5_),this.scatter,this.body,_loc7_);
         }
         if(!Main.instance.m_mouseJoint || Boolean(Main.instance.m_mouseJoint) && Boolean(this.body != Main.instance.m_mouseJoint.GetBody2()))
         {
            if(!Tool.isAim || Tool.isAim && Main.instance.selectedBodies.indexOf(this.body) == -1)
            {
               this.body.WakeUp();
               this.body.ApplyImpulse(new b2Vec2(_loc1_ * this.recoil * _loc4_,_loc1_ * this.recoil * _loc5_),this._shootingPos);
            }
         }
         if(Boolean(this._soundNames) && this._soundNames.length > 0)
         {
            _loc9_ = this._shootingPos.Copy();
            _loc9_.Multiply(Physics.scale);
            if(this._soundNames.length == 1)
            {
               sounds.play(this._soundNames[0],this._body,_loc9_,this._soundVolumes[0]);
            }
            else
            {
               sounds.randomWithVolume(this._soundNames,this._body,_loc9_,this._soundVolumes);
            }
         }
         if(this.disableAfterFiring)
         {
            userData(this._body.GetUserData()).triggered = false;
         }
         ++this._currentBullet;
         if(this._currentBullet >= this._magazineSize)
         {
            this._reloadDone = 0;
            this.reloaded = false;
         }
         if(this._burstAmount > 1)
         {
            ++this._currentBurst;
            if(this._currentBurst >= this._burstAmount)
            {
               if(this.destroyAfterFiring)
               {
                  userData(this._body.GetUserData()).dead = true;
               }
               this._currentBurst = 0;
               this._chamberTime = this._burstDelay;
               userData(this._body.GetUserData()).triggered = false;
            }
            else
            {
               this._chamberTime = this._originalChamberTime;
               userData(this._body.GetUserData()).triggered = true;
            }
         }
         else if(this.destroyAfterFiring)
         {
            userData(this._body.GetUserData()).dead = true;
         }
         return true;
      }
      
      public function reload() : void
      {
         var _loc1_:int = 0;
         if(this.reloaded)
         {
            this.chamber();
            return;
         }
         this._reloadDone += TimeLord.speed;
         if(this._reloadDone == int(this._reloadTime * 0.5))
         {
            if(this._casingReload)
            {
               _loc1_ = 0;
               while(_loc1_ < this._magazineSize)
               {
                  this.throwCasing();
                  _loc1_++;
               }
            }
            else
            {
               this.throwMagazine();
            }
         }
         if(this._reloadDone >= this._reloadTime)
         {
            this.reloaded = true;
            this._currentBullet = 0;
            this._chamberDone = this._originalChamberTime;
            this._currentBurst = 0;
            if(this.disableAfterFiring)
            {
               userData(this._body.GetUserData()).triggered = false;
            }
         }
      }
      
      public function forceReload() : void
      {
         this.forceFireDone();
         this.forceReloaded();
      }
      
      public function chamber() : void
      {
         if(this.readyToFire)
         {
            return;
         }
         this._chamberDone += TimeLord.speed;
         if(!this._casingReload)
         {
            if(this._chamberDone == int(this._chamberTime * 0.8))
            {
               this.throwCasing();
            }
         }
         if(this._chamberDone >= this._chamberTime)
         {
            this._readyToFire = true;
         }
      }
      
      private function throwCasing() : void
      {
         if(this._casingPos.length == 0)
         {
            return;
         }
         this.updateCasingPos();
         var _loc1_:int = 1;
         if(userData(this._body.GetUserData()).flipped)
         {
            _loc1_ = -1;
         }
         var _loc2_:Number = this._casingAngle;
         var _loc3_:Number = Math.cos(_loc2_);
         var _loc4_:Number = Math.sin(_loc2_);
         var _loc5_:Number = userData(this._body.GetUserData()).size;
      }
      
      private function throwMagazine() : void
      {
         if(this._magazinePos.length == 0)
         {
            return;
         }
         this.updateMagazinePos();
         var _loc1_:int = 1;
         if(userData(this._body.GetUserData()).flipped)
         {
            _loc1_ = -1;
         }
         var _loc2_:Number = this._magazineAngle;
         var _loc3_:Number = Math.cos(_loc2_);
         var _loc4_:Number = Math.sin(_loc2_);
         var _loc5_:Number = userData(this._body.GetUserData()).size;
      }
      
      private function forceFireDone() : void
      {
         this._chamberDone = this._chamberTime;
         this._readyToFire = true;
      }
      
      private function forceReloaded() : void
      {
         this._reloadDone = this._reloadTime;
         this.reloaded = true;
      }
      
      private function updateGenericPos(param1:Vector.<Line>) : Array
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc2_:b2Vec2 = this._body.GetPosition();
         var _loc3_:Number = this._body.GetAngle();
         var _loc4_:Number = userData(this._body.GetUserData()).size;
         var _loc5_:int = Math.random() * param1.length >> 0;
         var _loc6_:b2Vec2 = param1[_loc5_].p1.Copy();
         var _loc7_:b2Vec2 = param1[_loc5_].p2.Copy();
         var _loc8_:Number = Math.atan2(_loc6_.y - this.centroid.y,_loc6_.x - this.centroid.x);
         var _loc9_:Number = Math.atan2(_loc7_.y - this.centroid.y,_loc7_.x - this.centroid.x);
         var _loc10_:Number = _loc4_ * (Math.sqrt(BoxUtils.vectorDist(_loc6_,this.centroid)) + 10);
         var _loc11_:Number = _loc4_ * (Math.sqrt(BoxUtils.vectorDist(_loc7_,this.centroid)) + 10);
         _loc6_ = GeneralUtils.pointOnCircle(this.centroid.x,this.centroid.y,_loc10_,_loc3_ + _loc8_);
         _loc7_ = GeneralUtils.pointOnCircle(this.centroid.x,this.centroid.y,_loc11_,_loc3_ + _loc9_);
         var _loc12_:Number = Math.atan2(_loc6_.y - _loc7_.y,_loc6_.x - _loc7_.x) + Math.PI * 0.5;
         var _loc13_:Number = _loc7_.y - _loc6_.y;
         var _loc14_:Number = _loc7_.x - _loc6_.x;
         if(_loc14_ != 0 && _loc13_ != 0)
         {
            _loc17_ = _loc13_ / _loc14_;
            _loc15_ = _loc6_.x + Math.random() * _loc14_;
            _loc16_ = _loc6_.y + _loc17_ * (_loc15_ - _loc6_.x);
         }
         else if(_loc14_ == 0)
         {
            _loc15_ = _loc6_.x;
            _loc16_ = _loc6_.y + (_loc7_.y - _loc6_.y) * Math.random();
         }
         else if(_loc13_ == 0)
         {
            _loc16_ = _loc6_.x + (_loc7_.x - _loc6_.x) * Math.random();
            _loc16_ = _loc6_.y;
         }
         _loc15_ -= this._centroid.x - _loc2_.x * Physics.scale;
         _loc16_ -= this._centroid.y - _loc2_.y * Physics.scale;
         return [new b2Vec2(_loc15_,_loc16_),_loc12_];
      }
      
      private function updateCasingPos() : void
      {
         var _loc1_:Array = this.updateGenericPos(this._casingPos);
         this._casingEject = _loc1_[0];
         this._casingAngle = _loc1_[1];
      }
      
      private function updateMagazinePos() : void
      {
         var _loc1_:Array = this.updateGenericPos(this._magazinePos);
         this._magazineEject = _loc1_[0];
         this._magazineAngle = _loc1_[1];
      }
      
      private function updateShootPos() : void
      {
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc1_:b2Vec2 = this.body.GetPosition();
         var _loc2_:Number = this.body.GetAngle();
         var _loc3_:Number = Math.cos(_loc2_);
         var _loc4_:Number = Math.sin(_loc2_);
         var _loc5_:Number = userData(this.body.GetUserData()).size;
         if(!this.datPos || !this.datPosFlipped)
         {
            this._shootingPos = _loc1_;
            return;
         }
         if(!userData(this.body.GetUserData()).flipped)
         {
            _loc6_ = new b2Vec2(this.datPosFlipped.x * _loc5_,this.datPosFlipped.y * _loc5_);
            _loc7_ = BoxUtils.rotateVec(_loc6_,_loc2_);
         }
         else
         {
            _loc6_ = new b2Vec2(this.datPos.x * _loc5_,this.datPos.y * _loc5_);
            _loc7_ = BoxUtils.rotateVec(_loc6_,_loc2_);
         }
         this._shootingPos = new b2Vec2(_loc1_.x + _loc7_.x,_loc1_.y + _loc7_.y);
      }
      
      public function attachSound(param1:String, param2:Number = 1) : void
      {
         this._soundNames.push(param1);
         this._soundVolumes.push(param2);
      }
      
      public function attachSounds(param1:Array, param2:Array) : *
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = 1;
            _loc3_ = param1[_loc5_];
            if(sounds.soundNames.indexOf(_loc3_) == -1)
            {
               _loc3_ = "whaawhaa";
            }
            _loc4_ = Number(param2[_loc5_]);
            if(isNaN(_loc4_))
            {
               _loc4_ = Number(param2[0]);
            }
            if(isNaN(_loc4_))
            {
               _loc4_ = 1;
            }
            this.attachSound(_loc3_,_loc4_);
            _loc5_++;
         }
      }
      
      public function get soundNames() : Array
      {
         return this._soundNames;
      }
      
      public function get soundVolumes() : Array
      {
         return this._soundVolumes;
      }
      
      public function clearSounds() : void
      {
         this._soundNames = new Array();
         this._soundVolumes = new Array();
      }
      
      public function get pos() : b2Vec2
      {
         return this._body.GetPosition();
      }
      
      public function get barrelPos() : b2Vec2
      {
         if(!userData(this.body.GetUserData()).flipped)
         {
            return this.datPosFlipped.Copy();
         }
         return this.datPos.Copy();
      }
      
      public function get shootPos() : b2Vec2
      {
         this.updateShootPos();
         return this._shootingPos;
      }
      
      public function set shootPos(param1:b2Vec2) : void
      {
         this.datPos = param1;
         this.datPosFlipped = new b2Vec2(-param1.x,param1.y);
      }
      
      public function get shootForce() : int
      {
         return this._shootForce;
      }
      
      public function set shootForce(param1:int) : void
      {
         this._shootForce = param1;
      }
      
      public function AddCasingEject(param1:b2Vec2, param2:b2Vec2) : void
      {
         this._casingPos.push(new Line(param1,param2));
      }
      
      public function AddMagazineEject(param1:b2Vec2, param2:b2Vec2) : void
      {
         this._magazinePos.push(new Line(param1,param2));
      }
      
      public function AddBarrel(param1:b2Vec2, param2:b2Vec2) : void
      {
         this._barrelPos.push(new Line(param1,param2));
      }
      
      public function AddBullet(param1:Bullet) : void
      {
         this._bullet = param1;
      }
      
      public function AddCasing(param1:Casing) : void
      {
         this._casing = param1;
      }
      
      public function AddMagazine(param1:Magazine) : void
      {
         this._magazine = param1;
      }
      
      public function get centroid() : b2Vec2
      {
         return this._centroid;
      }
      
      public function set centroid(param1:b2Vec2) : void
      {
         this._centroid = param1;
      }
      
      public function get bulletSize() : Number
      {
         return this._bulletSize;
      }
      
      public function set bulletSize(param1:Number) : void
      {
         this._bulletSize = param1;
      }
      
      public function get chamberTime() : int
      {
         return this._chamberTime;
      }
      
      public function set chamberTime(param1:int) : void
      {
         this._chamberTime = param1;
         this._originalChamberTime = param1;
      }
      
      public function get scatter() : Number
      {
         return this._scatter;
      }
      
      public function set scatter(param1:Number) : void
      {
         this._scatter = param1;
      }
      
      public function get burstAmount() : int
      {
         return this._burstAmount;
      }
      
      public function set burstAmount(param1:int) : void
      {
         if(this.magazineSize < this.burstAmount)
         {
            this.magazineSize = this.burstAmount;
         }
         this._burstAmount = param1;
         this._currentBurst = 0;
      }
      
      public function get burstDelay() : int
      {
         return this._burstDelay;
      }
      
      public function set burstDelay(param1:int) : void
      {
         this._burstDelay = param1;
      }
      
      public function get casingForce() : int
      {
         return this._casingForce;
      }
      
      public function set casingForce(param1:int) : void
      {
         this._casingForce = param1;
      }
      
      public function set magazineForce(param1:int) : void
      {
         this._magazineForce = param1;
      }
      
      public function get magazineSize() : int
      {
         return this._magazineSize;
      }
      
      public function set magazineSize(param1:int) : void
      {
         this._magazineSize = param1;
      }
      
      public function get reloadTime() : Number
      {
         return this._reloadTime;
      }
      
      public function set reloadTime(param1:Number) : void
      {
         this._reloadTime = param1;
      }
      
      public function get bullet() : Bullet
      {
         return this._bullet;
      }
      
      public function get casing() : Casing
      {
         return this._casing;
      }
      
      public function get body() : b2Body
      {
         return this._body;
      }
      
      public function get magazine() : Magazine
      {
         return this._magazine;
      }
      
      public function get bulletAmount() : int
      {
         return this._bulletAmount;
      }
      
      public function set bulletAmount(param1:int) : void
      {
         this._bulletAmount = param1;
      }
      
      public function get reloadDone() : Number
      {
         return this._reloadDone;
      }
      
      public function set reloadDone(param1:Number) : void
      {
         this._reloadDone = param1;
      }
      
      public function get readyToFire() : Boolean
      {
         return this._readyToFire;
      }
      
      public function get recoil() : int
      {
         return this._recoil;
      }
      
      public function set recoil(param1:int) : void
      {
         this._recoil = param1;
      }
      
      public function get datPos() : b2Vec2
      {
         return this._datPos;
      }
      
      public function set datPos(param1:b2Vec2) : void
      {
         this._datPos = param1;
         this.AddBarrel(this._datPos,this._datPos);
      }
      
      public function get casingReload() : Boolean
      {
         return this._casingReload;
      }
      
      public function set casingReload(param1:Boolean) : void
      {
         this._casingReload = param1;
      }
      
      public function get bulletProperties() : Array
      {
         return this._bulletProperties;
      }
      
      public function set bulletProperties(param1:Array) : void
      {
         this._bulletProperties = param1;
      }
      
      public function get randomBulletAngle() : Number
      {
         return this._randomBulletAngle;
      }
      
      public function set randomBulletAngle(param1:Number) : void
      {
         this._randomBulletAngle = param1;
      }
      
      public function get randomBulletSize() : Number
      {
         return this._randomBulletSize;
      }
      
      public function set randomBulletSize(param1:Number) : void
      {
         this._randomBulletSize = param1;
      }
   }
}

