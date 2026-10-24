package
{
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2ContactListener;
   import Gun.Firearm;
   import com.anegmetex.Soundmanager.sounds;
   import environment.OpenWorld;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import shiny.PFXCollision;
   import shiny.PFXCollisionExplosion;
   import triggers.AerosolCan;
   import triggers.Bass;
   import triggers.Bee;
   import triggers.ConcussSpray;
   import triggers.Concussion;
   import triggers.ConveyorBelt;
   import triggers.Crit;
   import triggers.Disintegrate;
   import triggers.DisintegratePowder;
   import triggers.Electrified;
   import triggers.Explode;
   import triggers.FierySword;
   import triggers.Gun;
   import triggers.Implode;
   import triggers.ModifyGravity;
   import triggers.Poisoned;
   import triggers.Regen;
   import triggers.Trail;
   
   public class CustomContactListener extends b2ContactListener
   {
      
      public var bloodArray:Array;
      
      public var cutArray:Array;
      
      public var chunkArray:Array;
      
      private var temphealth:Number;
      
      private var newhealth:Number;
      
      private var cutFrom:b2Vec2;
      
      private var cutTo:b2Vec2;
      
      private var cutRange:Number;
      
      private var body1:b2Body;
      
      private var body2:b2Body;
      
      private var ud1:userData;
      
      private var ud2:userData;
      
      public var contacts:* = 0;
      
      public function CustomContactListener()
      {
         super();
         this.bloodArray = [];
         this.cutArray = [];
         this.chunkArray = [];
      }
      
      private function addBlood(param1:b2Body, param2:int, param3:b2Vec2, param4:b2Vec2 = null, param5:b2Vec2 = null, param6:Boolean = true, param7:Boolean = true) : *
      {
         if(!param4)
         {
            param4 = new b2Vec2();
         }
         this.bloodArray.push([param1,param2,param3,param4,param5,param6,param7]);
      }
      
      public function addCut(param1:String, param2:b2Vec2, param3:b2Vec2, param4:Number, param5:Number, param6:Vector.<b2Body>, param7:Vector.<b2Body>) : *
      {
         this.cutArray.push([param1,param2,param3,param4,param5,param6,param7]);
      }
      
      private function eitherName(param1:String) : int
      {
         var _loc2_:String = this.ud1.name;
         var _loc3_:String = this.ud2.name;
         if(_loc2_ == param1)
         {
            return 1;
         }
         if(_loc3_ == param1)
         {
            return 2;
         }
         if(_loc2_ == param1 && _loc3_ == param1)
         {
            return 3;
         }
         return 0;
      }
      
      private function otherBody(param1:b2Body) : b2Body
      {
         if(param1 == this.body1)
         {
            return this.body2;
         }
         return this.body1;
      }
      
      private function otherUD(param1:userData) : userData
      {
         if(param1 == this.ud1)
         {
            return this.ud2;
         }
         return this.ud1;
      }
      
      private function velo(param1:b2Body) : b2Vec2
      {
         return param1.GetLinearVelocity().Copy();
      }
      
      override public function Add(param1:b2ContactPoint) : void
      {
         var _loc20_:int = 0;
         var _loc23_:b2Body = null;
         var _loc24_:b2Body = null;
         var _loc25_:userData = null;
         var _loc26_:userData = null;
         var _loc31_:Array = null;
         var _loc32_:int = 0;
         var _loc33_:BitmapData = null;
         var _loc34_:b2Vec2 = null;
         var _loc35_:Sprite = null;
         var _loc36_:Boolean = false;
         var _loc37_:b2Vec2 = null;
         var _loc38_:b2Vec2 = null;
         var _loc39_:Vector.<b2Body> = null;
         var _loc40_:Vector.<b2Body> = null;
         var _loc41_:b2Body = null;
         var _loc42_:int = 0;
         var _loc43_:Vector.<b2Body> = null;
         var _loc44_:Number = NaN;
         var _loc45_:Array = null;
         var _loc46_:b2Body = null;
         var _loc47_:int = 0;
         var _loc48_:b2Vec2 = null;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:b2Vec2 = null;
         var _loc52_:int = 0;
         var _loc53_:b2Vec2 = null;
         var _loc54_:b2Vec2 = null;
         var _loc55_:b2Vec2 = null;
         var _loc56_:b2Vec2 = null;
         var _loc57_:int = 0;
         var _loc58_:Array = null;
         var _loc59_:b2Body = null;
         var _loc60_:b2Vec2 = null;
         var _loc61_:Array = null;
         var _loc62_:b2Body = null;
         var _loc63_:userData = null;
         var _loc64_:Number = NaN;
         var _loc65_:Number = NaN;
         var _loc66_:Number = NaN;
         var _loc67_:Number = NaN;
         var _loc68_:Number = NaN;
         var _loc69_:b2Vec2 = null;
         var _loc70_:b2Vec2 = null;
         var _loc71_:Vector.<b2Body> = null;
         var _loc72_:Boolean = false;
         var _loc73_:b2Body = null;
         var _loc74_:b2Vec2 = null;
         var _loc75_:b2Vec2 = null;
         var _loc76_:Vector.<b2Body> = null;
         var _loc77_:b2WeldJoint = null;
         var _loc78_:b2Vec2 = null;
         var _loc79_:b2Vec2 = null;
         var _loc80_:Array = null;
         var _loc81_:userData = null;
         var _loc82_:b2Body = null;
         var _loc83_:userData = null;
         var _loc84_:ShapeUserData = null;
         var _loc85_:b2Body = null;
         var _loc86_:String = null;
         var _loc87_:Array = null;
         var _loc88_:Number = NaN;
         var _loc89_:Number = NaN;
         var _loc90_:Boolean = false;
         var _loc91_:Number = NaN;
         var _loc92_:b2Vec2 = null;
         var _loc93_:Number = NaN;
         var _loc94_:Number = NaN;
         var _loc95_:Number = NaN;
         var _loc96_:Number = NaN;
         var _loc97_:Number = NaN;
         var _loc98_:Number = NaN;
         var _loc99_:b2Vec2 = null;
         var _loc100_:b2Body = null;
         var _loc101_:Number = NaN;
         var _loc102_:int = 0;
         var _loc103_:userData = null;
         var _loc104_:Number = NaN;
         var _loc105_:b2Vec2 = null;
         var _loc106_:int = 0;
         var _loc107_:uint = 0;
         var _loc108_:Boolean = false;
         var _loc109_:int = 0;
         var _loc110_:b2Vec2 = null;
         var _loc111_:Array = null;
         var _loc112_:userData = null;
         var _loc113_:Number = NaN;
         var _loc114_:Number = NaN;
         var _loc115_:int = 0;
         if(!GameState.contact || GameState.paused)
         {
            return;
         }
         if(this.contacts > Vars.collisionsMax)
         {
            return;
         }
         var _loc2_:Number = param1.velocity.Length();
         this.body1 = param1.shape1.GetBody();
         this.body2 = param1.shape2.GetBody();
         this.ud1 = userData(this.body1.GetUserData());
         this.ud2 = userData(this.body2.GetUserData());
         if(this.ud1.ignored.indexOf(this.body2) != -1)
         {
            return;
         }
         if(this.ud2.ignored.indexOf(this.body1) != -1)
         {
            return;
         }
         if(!this.body1.IsStatic() && !this.body2.IsStatic())
         {
            ++this.contacts;
         }
         var _loc3_:b2Vec2 = this.body1.GetLinearVelocity().Copy();
         var _loc4_:b2Vec2 = this.body2.GetLinearVelocity().Copy();
         var _loc5_:Number = this.body1.GetMass();
         var _loc6_:Number = this.body2.GetMass();
         var _loc7_:Number = Math.abs(_loc3_.x * _loc5_) + Math.abs(_loc4_.x * _loc6_);
         var _loc8_:Number = Math.abs(_loc3_.y * _loc5_) + Math.abs(_loc4_.y * _loc6_);
         var _loc9_:Number = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
         if(this.ud1.id != -1 && this.ud2.id != -1 && this.ud1.id == this.ud2.id)
         {
            _loc9_ *= 0.1;
         }
         if(_loc5_ == 0)
         {
            if(_loc4_.Length() < 50)
            {
               _loc9_ *= 0.1;
            }
            else
            {
               _loc9_ *= _loc4_.Length();
            }
         }
         if(_loc6_ == 0)
         {
            if(_loc3_.Length() < 50)
            {
               _loc9_ *= 0.1;
            }
            else
            {
               _loc9_ *= _loc3_.Length();
            }
         }
         if(this.ud1.killOnContact && !this.ud2.killOnContact)
         {
            this.ud1.dead = true;
         }
         if(this.ud2.killOnContact && !this.ud1.killOnContact)
         {
            this.ud2.dead = true;
         }
         if(this.ud1.implosive && this.ud1.explosive)
         {
            this.ud1.trigger = new DisintegratePowder(1000,100);
            this.ud1.triggered = true;
            return;
         }
         if(this.ud2.implosive && this.ud2.explosive)
         {
            this.ud2.trigger = new DisintegratePowder(1000,100);
            this.ud2.triggered = true;
            return;
         }
         if(this.ud1.triggerOnContact)
         {
            this.ud1.triggered = true;
         }
         if(this.ud2.triggerOnContact)
         {
            this.ud2.triggered = true;
         }
         if(this.ud1.name != "wall" && this.ud2.name != "wall")
         {
            if(this.ud1.ghost && !this.ud2.ghostCollide)
            {
               return;
            }
            if(this.ud2.ghost && !this.ud1.ghostCollide)
            {
               return;
            }
         }
         if(this.ud1.ghostOnContact)
         {
            this.ud1.ghost = true;
         }
         if(this.ud2.ghostOnContact)
         {
            this.ud2.ghost = true;
         }
         if(this.ud1.triggerContact > 0 && _loc9_ > this.ud1.triggerContact)
         {
            this.ud1.triggered = true;
         }
         if(this.ud2.triggerContact > 0 && _loc9_ > this.ud2.triggerContact)
         {
            this.ud2.triggered = true;
         }
         var _loc10_:b2Vec2 = param1.position.Copy();
         var _loc11_:b2Vec2 = param1.position.Copy();
         _loc11_.Multiply(Physics.scale);
         var _loc12_:Number = _loc10_.x;
         var _loc13_:Number = _loc10_.y;
         var _loc14_:ShapeUserData = ShapeUserData(param1.shape1.GetUserData());
         var _loc15_:ShapeUserData = ShapeUserData(param1.shape2.GetUserData());
         var _loc16_:String = this.ud1.name;
         var _loc17_:String = this.ud2.name;
         var _loc18_:String = _loc14_.name;
         var _loc19_:String = _loc15_.name;
         if(Boolean(this.ud1.pfx) && this.ud1.pfx is PFXCollision)
         {
            PFXCollision(this.ud1.pfx).collided = _loc11_;
         }
         if(Boolean(this.ud2.pfx) && this.ud2.pfx is PFXCollision)
         {
            PFXCollision(this.ud2.pfx).collided = _loc11_;
         }
         if(_loc9_ > 5)
         {
            if(Boolean(this.ud1.pfx) && this.ud1.pfx is PFXCollisionExplosion)
            {
               PFXCollisionExplosion(this.ud1.pfx).collided = _loc11_;
            }
            if(Boolean(this.ud2.pfx) && this.ud2.pfx is PFXCollisionExplosion)
            {
               PFXCollisionExplosion(this.ud2.pfx).collided = _loc11_;
            }
         }
         if(this.ud1.triggerColour)
         {
            if(Boolean(this.ud1.trigger) && this.ud1.triggerColour.toLowerCase() == _loc18_.toLowerCase())
            {
               this.ud1.trigger.OnCollision(this.body2,_loc15_,_loc14_,_loc9_,_loc10_,param1.normal.Copy());
            }
         }
         else if(Boolean(this.ud1.trigger) && Boolean(!_loc15_.sensor) && !this.ud2.resistCollision)
         {
            if(!this.ud1.trigger.OnCollision(this.body2,_loc15_,_loc14_,_loc9_,_loc10_,param1.normal.Copy()))
            {
               return;
            }
         }
         if(this.ud2.triggerColour)
         {
            if(Boolean(this.ud2.trigger) && this.ud2.triggerColour.toLowerCase() == _loc19_.toLowerCase())
            {
               this.ud2.trigger.OnCollision(this.body1,_loc14_,_loc15_,_loc9_,_loc10_,param1.normal.Copy());
            }
         }
         else if(Boolean(this.ud2.trigger) && Boolean(!_loc14_.sensor) && !this.ud1.resistCollision)
         {
            if(!this.ud2.trigger.OnCollision(this.body1,_loc14_,_loc15_,_loc9_,_loc10_,param1.normal.Copy()))
            {
               return;
            }
         }
         if(Boolean(this.ud1.trigger) && _loc14_.sharp)
         {
            this.ud1.trigger.OnSharp(this.body2,_loc9_);
         }
         if(Boolean(this.ud2.trigger) && _loc15_.sharp)
         {
            this.ud2.trigger.OnSharp(this.body1,_loc9_);
         }
         if(this.ud1.alive || this.ud2.alive)
         {
            if(this.ud1.alive && !this.ud2.alive)
            {
               _loc31_ = BoxUtils.selectCompound(this.body1);
               _loc32_ = _loc31_.indexOf(this.body2);
               if(_loc32_ != -1)
               {
                  _loc9_ *= 0.1;
               }
            }
            else if(this.ud2.alive && !this.ud1.alive)
            {
               _loc31_ = BoxUtils.selectCompound(this.body2);
               _loc32_ = _loc31_.indexOf(this.body1);
               if(_loc32_ != -1)
               {
                  _loc9_ *= 0.1;
               }
            }
         }
         if(_loc16_ == "trash" && _loc17_ != "wall")
         {
            this.ud2.dead = true;
            return;
         }
         if(_loc17_ == "trash" && _loc16_ != "wall")
         {
            this.ud1.dead = true;
            return;
         }
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         _loc20_ = this.eitherName("blooddrop");
         if(_loc20_ == 1 || _loc20_ == 2)
         {
            if(_loc20_ == 1)
            {
               _loc23_ = this.body1;
               _loc25_ = this.ud1;
            }
            else
            {
               _loc23_ = this.body2;
               _loc25_ = this.ud2;
            }
            _loc24_ = this.otherBody(_loc23_);
            _loc26_ = this.otherUD(_loc25_);
            _loc33_ = BoxUtils.getEffectBMD(_loc24_);
            if(_loc33_)
            {
               _loc34_ = _loc24_.GetLocalPoint(_loc10_).Copy();
               _loc34_.Multiply(Physics.scale);
               _loc34_.x -= Bitmap(_loc26_.graphic.getChildByName("effects")).x;
               _loc34_.y -= Bitmap(_loc26_.graphic.getChildByName("effects")).y;
               _loc35_ = new Sprite();
               _loc35_.graphics.beginFill(_loc25_.bloodColour,Math.random() * 0.7);
               _loc35_.graphics.drawCircle(_loc34_.x,_loc34_.y,Math.random() * 2 + 2);
               _loc33_.draw(_loc35_);
            }
            _loc25_.dead = true;
            return;
         }
         var _loc27_:Boolean = _loc14_.sharp || this.ud1.sharp;
         var _loc28_:Boolean = _loc15_.sharp || this.ud2.sharp;
         if(this.ud1.blunt)
         {
            _loc27_ = false;
         }
         if(this.ud2.blunt)
         {
            _loc28_ = false;
         }
         if(_loc27_ || _loc28_)
         {
            _loc36_ = true;
            if(_loc27_ && _loc28_)
            {
               _loc21_ = 0;
               _loc22_ = 2;
            }
            else
            {
               _loc21_ = _loc27_ ? 0 : 1;
               _loc22_ = _loc21_ + 1;
            }
            while(_loc21_ < _loc22_)
            {
               if(_loc21_ == 0)
               {
                  _loc23_ = this.body1;
                  _loc25_ = this.ud1;
               }
               else
               {
                  _loc23_ = this.body2;
                  _loc25_ = this.ud2;
               }
               _loc24_ = this.otherBody(_loc23_);
               _loc26_ = this.otherUD(_loc25_);
               if(_loc26_.alive || Boolean(_loc26_.armour))
               {
                  if(_loc9_ > 10 && _loc9_ < 50)
                  {
                     if(_loc26_.health > 30 && _loc26_.temperature > 0 && !_loc26_.resistBleed && _loc26_.multiSharpDamage > 0)
                     {
                        this.addBlood(_loc24_,1,_loc10_);
                        _loc37_ = _loc24_.GetLocalPoint(_loc10_);
                        _loc26_.bleeding.push([_loc37_,_loc37_,param1.normal.Copy(),_loc9_ * 0.01 * _loc26_.multiSharpDamage]);
                        sounds.play("stab3",null,_loc11_,Math.random() * 0.5 + 0.25,false);
                        _loc36_ = false;
                     }
                  }
               }
               if(_loc2_ > 25 * _loc26_.multiStabForce || _loc9_ > 150 * _loc26_.multiStabForce)
               {
                  _loc38_ = this.velo(_loc23_);
                  this.cutFrom = new b2Vec2((_loc12_ - (_loc24_.GetPosition().x - _loc12_) * 0.1) * Physics.scale,(_loc13_ - (_loc24_.GetPosition().y - _loc13_) * 0.1) * Physics.scale);
                  this.cutTo = _loc11_.Copy();
                  this.cutTo.Add(_loc38_);
                  this.cutRange = _loc38_.Length() * _loc23_.GetMass() * 0.02 + _loc38_.Length() * 0.05;
                  this.cutRange *= _loc25_.multiSharpDamage;
                  _loc39_ = new Vector.<b2Body>();
                  _loc39_.push(_loc24_);
                  _loc40_ = new Vector.<b2Body>();
                  _loc40_.push(_loc23_);
                  this.addCut("blade",this.cutFrom,this.cutTo,this.cutRange,0,_loc39_,_loc40_);
                  if(!_loc25_.soft && _loc2_ > 10 && !_loc26_.alive && !_loc26_.soft)
                  {
                     GameState.particles.addParticles(_loc12_ * Physics.scale,_loc13_ * Physics.scale,1,"sparkle",-(param1.normal.x * _loc38_.x * 0.2 + (param1.normal.x < 0 ? 1 : -1) * _loc38_.x * 0.2),-(param1.normal.y * _loc38_.y * 0.2 + (param1.normal.y < 0 ? 1 : -1) * _loc38_.y * 0.2),4,4);
                  }
               }
               if(_loc26_.alive && _loc9_ > 25 * _loc26_.multiStabForce)
               {
                  Body.Stab(_loc23_,_loc24_,param1);
               }
               _loc21_++;
            }
         }
         if(World.toggleSlomo == 1 && !GameState.slomo)
         {
            if(_loc9_ > 1000)
            {
               TimeLord.slowTo(50);
            }
         }
         if(this.ud1.implosive && this.ud2.explosive)
         {
            this.ud1.triggered = true;
            this.ud1.trigger = new Implode();
            this.ud2.triggered = true;
            this.ud2.trigger = new Explode();
            return;
         }
         if(this.ud2.implosive && this.ud1.explosive)
         {
            this.ud1.triggered = true;
            this.ud1.trigger = new Explode();
            this.ud2.triggered = true;
            this.ud2.trigger = new Implode();
            return;
         }
         if(_loc16_ == "triggertouch")
         {
            this.ud2.triggered = true;
         }
         else if(_loc17_ == "triggertouch")
         {
            this.ud1.triggered = true;
         }
         else if(_loc16_ == "untriggertouch")
         {
            this.ud2.triggered = false;
         }
         else if(_loc17_ == "untriggertouch")
         {
            this.ud1.triggered = false;
         }
         else
         {
            if(_loc16_ == "smgRound" && _loc17_ != "smgRound")
            {
               this.addBlood(this.body2,Math.random() * Math.random() * 20,_loc10_,new b2Vec2(_loc7_ * 0.01,_loc8_ * 0.01),new b2Vec2(2,2),false);
               this.ud2.trigger = new Electrified();
               this.ud2.triggered = true;
               this.ud2.triggerDuration = 10;
               if(this.ud2.alive)
               {
                  this.ud2.health -= 20;
               }
               this.ud1.dead = true;
               return;
            }
            if(_loc17_ == "smgRound" && _loc16_ != "smgRound")
            {
               this.addBlood(this.body1,Math.random() * Math.random() * 20,_loc10_,new b2Vec2(_loc7_ * 0.01,_loc8_ * 0.01),new b2Vec2(2,2),false);
               this.ud1.trigger = new Electrified();
               this.ud1.triggered = true;
               this.ud1.triggerDuration = 10;
               if(this.ud1.alive)
               {
                  this.ud1.health -= 20;
               }
               this.ud2.dead = true;
               return;
            }
            if(_loc16_ == "taserRound")
            {
               this.ud2.trigger = new Electrified();
               this.ud2.triggered = true;
               this.ud2.triggerDuration = 300;
               this.ud1.dead = true;
               return;
            }
            if(_loc17_ == "taserRound")
            {
               this.ud1.trigger = new Electrified();
               this.ud1.triggered = true;
               this.ud1.triggerDuration = 300;
               this.ud2.dead = true;
               return;
            }
            if(_loc16_ == "flare" && (_loc17_ == "water" || _loc17_ == "extinguish"))
            {
               this.ud1.trigger = null;
               this.ud1.triggered = false;
            }
            else if(_loc17_ == "flare" && (_loc16_ == "water" || _loc16_ == "extinguish"))
            {
               this.ud2.trigger = null;
               this.ud2.triggered = false;
            }
            else if(_loc16_ == "bass" && _loc17_ != "bass")
            {
               this.ud1.dead = true;
               if(this.ud2.alive)
               {
                  this.ud2.triggerPos = _loc3_.Copy();
                  this.ud2.trigger = new Bass();
                  this.ud2.triggerDuration = Math.random() * 30 + 30;
                  this.ud2.triggered = true;
                  this.ud2.triggerLock = true;
                  return;
               }
            }
            else if(_loc17_ == "bass" && _loc16_ != "bass")
            {
               this.ud2.dead = true;
               if(this.ud1.alive)
               {
                  this.ud1.triggerPos = _loc4_.Copy();
                  this.ud1.trigger = new Bass();
                  this.ud1.triggerDuration = Math.random() * 30 + 30;
                  this.ud1.triggered = true;
                  this.ud1.triggerLock = true;
                  return;
               }
            }
            else if(_loc16_ == "powder")
            {
               this.ud1.dead = true;
               if(!this.body2.IsStatic())
               {
                  this.ud2.trigger = new DisintegratePowder(100,0.5,true);
                  this.ud2.triggered = true;
               }
            }
            else if(_loc17_ == "powder")
            {
               this.ud2.dead = true;
               if(!this.body1.IsStatic())
               {
                  this.ud1.trigger = new DisintegratePowder(100,0.5,true);
                  this.ud1.triggered = true;
               }
            }
            else if(_loc16_ == "gravity" || _loc16_ == "levity")
            {
               this.ud1.dead = true;
               if(!this.body2.IsStatic() && !this.ud2.resistGravity)
               {
                  for each(_loc41_ in BoxUtils.selectCompound(this.body2))
                  {
                     userData(_loc41_.GetUserData()).trigger = new ModifyGravity(_loc16_ == "gravity" ? 3 : -1);
                     userData(_loc41_.GetUserData()).triggerDuration = this.ud1.triggerDuration;
                     userData(_loc41_.GetUserData()).triggered = true;
                  }
               }
            }
            else if(_loc17_ == "gravity" || _loc17_ == "levity")
            {
               this.ud2.dead = true;
               if(!this.body1.IsStatic() && !this.ud1.resistGravity)
               {
                  for each(_loc41_ in BoxUtils.selectCompound(this.body1))
                  {
                     userData(_loc41_.GetUserData()).trigger = new ModifyGravity(_loc17_ == "gravity" ? 3 : -1);
                     userData(_loc41_.GetUserData()).triggerDuration = 120;
                     userData(_loc41_.GetUserData()).triggerDuration = this.ud2.triggerDuration;
                     userData(_loc41_.GetUserData()).triggered = true;
                  }
               }
            }
            else if(_loc16_ == "stasis")
            {
               this.ud1.dead = true;
               if(!this.body2.IsStatic())
               {
                  for each(_loc41_ in BoxUtils.selectCompound(this.body2))
                  {
                     Body.Stasis(_loc41_,120);
                  }
               }
            }
            else if(_loc17_ == "stasis")
            {
               this.ud2.dead = true;
               if(!this.body1.IsStatic())
               {
                  for each(_loc41_ in BoxUtils.selectCompound(this.body1))
                  {
                     Body.Stasis(_loc41_,120);
                  }
               }
            }
            else if(_loc16_ == "sleep")
            {
               Body.Concuss(this.body1,300);
            }
            else if(_loc17_ == "sleep")
            {
               Body.Concuss(this.body2,300);
            }
            else if(_loc16_ == "burninggasoline")
            {
               this.ud1.dead = true;
               if(!this.body2.IsStatic())
               {
                  this.ud2.temperature += 5;
               }
            }
            else if(_loc17_ == "burninggasoline")
            {
               this.ud2.dead = true;
               if(!this.body1.IsStatic())
               {
                  this.ud1.temperature += 5;
               }
            }
            else if(this.ud1.trigger is ConcussSpray)
            {
               if(this.ud1.trigger is ConcussSpray && this.ud2.alive)
               {
                  this.ud2.trigger = new Concussion(300,this.ud1.name == "doll_head");
                  this.ud2.triggered = true;
               }
               _loc33_ = BoxUtils.getEffectBMD(this.body2);
               if(_loc16_ == "ffffff")
               {
                  _loc16_ = "fffffd";
               }
               if(_loc33_)
               {
                  _loc34_ = this.body2.GetLocalPoint(_loc10_).Copy();
                  _loc35_ = new Sprite();
                  _loc42_ = 0;
                  while(_loc42_ < 20 * this.ud1.size)
                  {
                     _loc35_.graphics.beginFill(uint("0xFF" + _loc16_),Math.random() * 0.4 + 0.2);
                     _loc35_.graphics.drawCircle(_loc34_.x * Physics.scale + _loc33_.width * 0.5 + (Math.random() * 2 * _loc42_ - _loc42_) * this.ud1.size,_loc34_.y * Physics.scale + _loc33_.height * 0.5 + (Math.random() * 2 * _loc42_ - _loc42_) * this.ud1.size,(Math.random() * 4 + 1) * this.ud1.size);
                     _loc42_++;
                  }
                  _loc33_.draw(_loc35_);
               }
            }
            else if(this.ud2.trigger is ConcussSpray)
            {
               if(this.ud2.trigger is ConcussSpray && this.ud1.alive)
               {
                  this.ud1.trigger = new Concussion(300,this.ud1.name == "doll_head");
                  this.ud1.triggered = true;
               }
               _loc33_ = BoxUtils.getEffectBMD(this.body1);
               if(_loc17_ == "ffffff")
               {
                  _loc17_ = "fffffd";
               }
               if(_loc33_)
               {
                  _loc34_ = this.body1.GetLocalPoint(_loc10_).Copy();
                  _loc35_ = new Sprite();
                  _loc42_ = 0;
                  while(_loc42_ < 20 * this.ud2.size)
                  {
                     _loc35_.graphics.beginFill(uint("0xFF" + _loc17_),Math.random() * 0.4 + 0.2);
                     _loc35_.graphics.drawCircle(_loc34_.x * Physics.scale + _loc33_.width * 0.5 + (Math.random() * 2 * _loc42_ - _loc42_) * this.ud2.size,_loc34_.y * Physics.scale + _loc33_.height * 0.5 + (Math.random() * 2 * _loc42_ - _loc42_) * this.ud2.size,(Math.random() * 4 + 1) * this.ud2.size);
                     _loc42_++;
                  }
                  _loc33_.draw(_loc35_);
               }
            }
            else if(this.ud1.name == "decoration")
            {
               Body.Decorate(this.body2);
               this.ud1.dead = true;
            }
            else if(this.ud2.name == "decoration")
            {
               Body.Decorate(this.body1);
               this.ud2.dead = true;
            }
            else if(_loc16_ == "cannonball")
            {
               if(_loc2_ > 100)
               {
                  Main.instance.brittleArray.push(this.body2);
               }
            }
            else if(_loc17_ == "cannonball")
            {
               if(_loc2_ > 100)
               {
                  Main.instance.brittleArray.push(this.body1);
               }
            }
            else if(_loc16_ == "beepod" && this.ud1.trigger is Bee)
            {
               if(Math.random() > 0.9)
               {
                  this.ud1.dead = true;
               }
               if(this.ud2.alive)
               {
                  this.addBlood(this.body2,5.1,_loc10_,new b2Vec2(),new b2Vec2(),false);
                  this.body2.ApplyForce(new b2Vec2(Math.random() * 100 - 50,Math.random() * 100 - 50),_loc10_);
                  Bee(this.ud1.trigger).sting(this.body2,_loc11_);
               }
            }
            else if(_loc17_ == "beepod" && this.ud2.trigger is Bee)
            {
               if(Math.random() > 0.9)
               {
                  this.ud2.dead = true;
               }
               if(this.ud1.alive)
               {
                  this.addBlood(this.body1,5.1,_loc10_,new b2Vec2(),new b2Vec2(),false);
                  this.body2.ApplyForce(new b2Vec2(Math.random() * 100 - 50,Math.random() * 100 - 50),_loc10_);
                  Bee(this.ud2.trigger).sting(this.body1,_loc11_);
               }
            }
            else
            {
               if(_loc16_ == "clustershrapnel")
               {
                  this.cutTo = new b2Vec2((_loc12_ - (this.body1.GetPosition().x - _loc12_) * 0.1) * Physics.scale,(_loc13_ - (this.body1.GetPosition().y - _loc13_) * 0.1) * Physics.scale);
                  this.cutFrom = new b2Vec2((_loc12_ - (this.body2.GetPosition().x - _loc12_) * 0.1) * Physics.scale,(_loc13_ - (this.body2.GetPosition().y - _loc13_) * 0.1) * Physics.scale);
                  this.cutRange = 100;
                  _loc43_ = new Vector.<b2Body>();
                  _loc43_.push(this.body1);
                  this.addCut("shrapnel",this.cutFrom,this.cutTo,this.cutRange,0,new Vector.<b2Body>(),_loc43_);
                  this.ud1.dead = true;
                  return;
               }
               if(_loc17_ == "clustershrapnel")
               {
                  this.cutFrom = new b2Vec2((_loc12_ - (this.body1.GetPosition().x - _loc12_) * 0.1) * Physics.scale,(_loc13_ - (this.body1.GetPosition().y - _loc13_) * 0.1) * Physics.scale);
                  this.cutTo = new b2Vec2((_loc12_ - (this.body2.GetPosition().x - _loc12_) * 0.1) * Physics.scale,(_loc13_ - (this.body2.GetPosition().y - _loc13_) * 0.1) * Physics.scale);
                  this.cutRange = 100;
                  _loc43_ = new Vector.<b2Body>();
                  _loc43_.push(this.body2);
                  this.addCut("shrapnel",this.cutFrom,this.cutTo,this.cutRange,0,new Vector.<b2Body>(),_loc43_);
                  this.ud2.dead = true;
                  return;
               }
               if(_loc16_ == "radianthammer" && _loc18_ == "b5b5b5" || _loc17_ == "radianthammer" && _loc19_ == "b5b5b5" || _loc16_ == "powerfist" && _loc18_ == "444444" || _loc17_ == "powerfist" && _loc19_ == "444444")
               {
                  if(_loc16_ == "powerfist" || _loc17_ == "powerfist")
                  {
                     _loc47_ = 0;
                     while(_loc47_ < 20)
                     {
                        GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"forcefield",Math.random() * 10 - 5,Math.random() * 10 - 5,1,1);
                        GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"gravity",Math.random() * 8 - 4,Math.random() * 8 - 4,1,1);
                        _loc47_++;
                     }
                  }
                  _loc44_ = 100 / Physics.scale;
                  _loc45_ = Body.GetMultiple(new b2Vec2(_loc10_.x - _loc44_ * 0.5,_loc10_.y - _loc44_ * 0.5),_loc44_,_loc44_,false);
                  for each(_loc46_ in _loc45_)
                  {
                     if(userData(_loc46_.GetUserData()).name != "radianthammer")
                     {
                        _loc48_ = new b2Vec2(_loc46_.GetWorldCenter().x * Physics.scale - _loc11_.x,_loc46_.GetWorldCenter().y * Physics.scale - _loc11_.y);
                        _loc49_ = _loc48_.Normalize();
                        _loc50_ = (_loc44_ * Physics.scale - _loc49_) / (_loc44_ * Physics.scale) * 12000;
                        _loc51_ = new b2Vec2(_loc48_.x * _loc50_,_loc48_.y * _loc50_);
                        _loc46_.ApplyForce(_loc51_,_loc46_.GetWorldCenter());
                     }
                  }
               }
            }
         }
         if(!this.ud1.triggered)
         {
            if(_loc16_ == "windstaff" && _loc18_ == "ccf4f0")
            {
               this.ud1.triggered = true;
               this.ud1.triggerState = -1;
            }
            else if(_loc16_ == "healstaff" && _loc18_ == "ffe66b")
            {
               this.ud1.triggered = true;
               this.ud1.triggerState = -1;
            }
            else if(_loc16_ == "firestaff" && _loc18_ == "ef5d00")
            {
               this.ud1.triggered = true;
               this.ud1.triggerState = -1;
            }
            else if(_loc16_ == "icestaff" && _loc18_ == "91c2ff")
            {
               this.ud1.triggered = true;
               this.ud1.triggerState = -1;
            }
            else if(_loc16_ == "boomstaff" && _loc18_ == "d8b91e")
            {
               this.ud1.triggered = true;
               this.ud1.triggerState = -1;
            }
            else if(_loc16_ == "shockstaff" && _loc18_ == "11e8ff")
            {
               this.ud1.triggered = true;
               this.ud1.triggerState = -1;
            }
         }
         if(!this.ud2.triggered)
         {
            if(_loc17_ == "windstaff" && _loc19_ == "ccf4f0")
            {
               this.ud2.triggered = true;
               this.ud2.triggerState = -1;
            }
            else if(_loc17_ == "healstaff" && _loc19_ == "ffe66b")
            {
               this.ud2.triggered = true;
               this.ud2.triggerState = -1;
            }
            else if(_loc17_ == "firestaff" && _loc19_ == "ef5d00")
            {
               this.ud2.triggered = true;
               this.ud2.triggerState = -1;
            }
            else if(_loc17_ == "icestaff" && _loc19_ == "91c2ff")
            {
               this.ud2.triggered = true;
               this.ud2.triggerState = -1;
            }
            else if(_loc17_ == "boomstaff" && _loc19_ == "d8b91e")
            {
               this.ud2.triggered = true;
               this.ud2.triggerState = -1;
            }
            else if(_loc17_ == "shockstaff" && _loc19_ == "11e8ff")
            {
               this.ud2.triggered = true;
               this.ud2.triggerState = -1;
            }
         }
         if(!this.ud2.resistFlame && !this.body2.IsStatic() && (this.ud1.flaming || _loc16_ == "firesword" && _loc18_ == "ef5d00"))
         {
            this.ud2.temperature += 100;
            _loc47_ = 0;
            while(_loc47_ < 5 + Math.random() * 20)
            {
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomParticlesOnBody(this.body2,"smoke",0.1 + Math.random() * Math.random() * 2);
               }
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomParticlesOnBody(this.body2,"fire2",0.1 + Math.random() * Math.random() * 2);
               }
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomParticlesOnBody(this.body2,"fire3",0.1 + Math.random() * Math.random() * 2);
               }
               _loc47_++;
            }
         }
         if(!this.ud2.resistFreeze && (this.ud1.freezing || _loc16_ == "frostsword" && _loc18_ == "91c2ff"))
         {
            if(this.ud1.triggerDuration == 0 && _loc9_ > 100 && !this.body2.IsStatic())
            {
               this.ud2.temperature -= 75;
               this.ud1.triggerDuration = 30;
               _loc47_ = 0;
               while(_loc47_ < 20)
               {
                  GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"crystal",Math.random() * 20 - 10,Math.random() * 20 - 10,1,1);
                  _loc47_++;
               }
            }
            else
            {
               this.ud2.temperature -= 10;
               GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"crystal",Math.random() * 4 - 2,Math.random() * 4 - 2,1,1);
            }
            if(!this.ud2.brittle || this.ud2.temperature < 0 && this.ud2.temperature > -50)
            {
               Body.Freeze(this.body2);
            }
         }
         if(!this.ud2.resistGust && (this.ud1.gusting || _loc16_ == "windsword" && _loc18_ == "ccf4f0"))
         {
            _loc44_ = 200 / Physics.scale;
            _loc45_ = Body.GetMultiple(new b2Vec2(_loc10_.x - _loc44_ * 0.5,_loc10_.y - _loc44_ * 0.5),_loc44_,_loc44_,false);
            for each(_loc46_ in _loc45_)
            {
               if(_loc46_ != this.body1)
               {
                  if(!userData(_loc46_.GetUserData()).resistGust)
                  {
                     if(!userData(this.body1.GetUserData()).isStabbing(_loc46_))
                     {
                        _loc48_ = new b2Vec2(_loc46_.GetWorldCenter().x * Physics.scale - _loc11_.x,_loc46_.GetWorldCenter().y * Physics.scale - _loc11_.y);
                        _loc49_ = _loc48_.Normalize();
                        _loc50_ = (_loc44_ * Physics.scale - _loc49_) / (_loc44_ * Physics.scale) * 5000;
                        _loc51_ = new b2Vec2(_loc48_.x * _loc50_,_loc48_.y * _loc50_);
                        _loc46_.ApplyForce(_loc51_,_loc46_.GetWorldCenter());
                     }
                  }
               }
            }
         }
         if(!this.ud2.resistHeal && (this.ud1.healing || _loc16_ == "lifesword" && _loc18_ == "ffe66b"))
         {
            if(this.ud2.alive)
            {
               this.ud2.health += Math.min(50,_loc9_ * 0.4);
               if(this.ud2.health > this.ud2.maxhealth)
               {
                  this.ud2.health = this.ud2.maxhealth;
               }
            }
            GameState.particles.addParticles(_loc10_.x * Physics.scale,_loc10_.y * Physics.scale,1,"heal",_loc3_.x * 0.1,_loc3_.y * 0.1,1,1);
         }
         if(!this.ud2.resistDrain && (this.ud1.draining || _loc16_ == "bloodsword" && _loc18_ == "b50404"))
         {
            if(this.ud2.alive)
            {
               _loc52_ = 0;
               while(_loc52_ < 10)
               {
                  _loc53_ = new b2Vec2(0,-(Math.random() * 90 - 30) * this.ud1.size / Physics.scale);
                  _loc54_ = BoxUtils.rotateVec(_loc53_,this.body1.GetAngle());
                  _loc54_.Add(this.body1.GetWorldCenter().Copy());
                  _loc55_ = BoxUtils.rotateVec(new b2Vec2(Math.random() * this.ud2.width - this.ud2.width * 0.5,Math.random() * this.ud2.height - this.ud2.height * 0.5),this.body2.GetAngle());
                  _loc56_ = new b2Vec2(this.body2.GetPosition().x * Physics.scale + _loc55_.x,this.body2.GetPosition().y * Physics.scale + _loc55_.y);
                  _loc56_.Multiply(1 / Physics.scale);
                  this.addBlood(this.body2,1,_loc56_,new b2Vec2(_loc54_.x - _loc56_.x,_loc54_.y - _loc56_.y));
                  _loc52_++;
               }
               if(this.ud1.alive)
               {
                  this.ud1.health += 100;
               }
               Body.Radiation(this.body2,false);
               if(this.ud2.health <= 0)
               {
                  this.ud2.health = 0;
                  this.ud2.trigger = new Disintegrate("blood",this.ud2.maxhealth * 0.5);
                  this.ud2.triggered = true;
               }
            }
            else
            {
               this.addBlood(this.body2,1,_loc11_,new b2Vec2(),new b2Vec2(2,2));
            }
         }
         if(!this.ud2.resistKill && (this.ud1.killing || _loc16_ == "deathsword" && _loc18_ == "333333"))
         {
            if(this.ud2.alive)
            {
               this.ud2.health = 0;
               _loc33_ = BoxUtils.getEffectBMD(this.body2);
               if(_loc33_)
               {
                  _loc57_ = 0;
                  while(_loc57_ < 50)
                  {
                     _loc34_ = this.body2.GetLocalPoint(_loc10_).Copy();
                     _loc34_ = GeneralUtils.pointOnCircle(_loc34_.x,_loc34_.y,Math.random() * _loc57_,Math.random() * 360);
                     _loc34_.Multiply(Physics.scale);
                     _loc34_.x -= Bitmap(this.ud2.graphic.getChildByName("effects")).x;
                     _loc34_.y -= Bitmap(this.ud2.graphic.getChildByName("effects")).y;
                     _loc33_.copyPixels(R.getSprite(Math.random() > 0.8 ? "p_blood" : "p_dark"),new Rectangle(0,0,8,8),new Point(_loc34_.x,_loc34_.y),null,null,true);
                     _loc57_++;
                  }
               }
            }
         }
         if(!this.ud2.resistDispel && (this.ud1.dispelling || _loc16_ == "lightsword" && _loc18_ == "fff9c6"))
         {
            if(this.ud1.triggerDuration == 0 && _loc9_ > 80)
            {
               this.ud1.triggerDuration = 20;
               Shadows.lightPos = _loc11_;
               Shadows.lightRadius = 100;
               Main.instance.drawShadowsFor(Body.GetMultiple(new b2Vec2(_loc10_.x - 150 / Physics.scale,_loc10_.y - 150 / Physics.scale),300 / Physics.scale,300 / Physics.scale),10);
               _loc58_ = BoxUtils.selectCompound(this.body2);
               for each(_loc59_ in _loc58_)
               {
                  Body.Dispel(_loc59_);
               }
               _loc47_ = 0;
               while(_loc47_ < 10)
               {
                  GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"light",Math.random() * 60 - 30,Math.random() * 60 - 30,1,1);
                  _loc47_++;
               }
            }
            else
            {
               GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"light",Math.random() * 60 - 30,Math.random() * 60 - 30,1,1);
            }
         }
         if(!this.ud2.resistShock && (this.ud1.shocking || _loc16_ == "shocksword" && _loc18_ == "11e8ff"))
         {
            _loc44_ = 160 / Physics.scale;
            _loc60_ = _loc11_;
            _loc61_ = Body.GetMultiple(new b2Vec2(_loc60_.x / Physics.scale - _loc44_ * 0.5,_loc60_.y / Physics.scale - _loc44_ * 0.5),_loc44_,_loc44_,false);
            _loc62_ = _loc61_[Math.random() * _loc61_.length >> 0];
            if((Boolean(_loc62_)) && Boolean(_loc62_ != this.body1) && !userData(_loc62_.GetUserData()).resistShock)
            {
               _loc63_ = userData(_loc62_.GetUserData());
               _loc63_.trigger = new Electrified();
               _loc63_.triggered = true;
               _loc63_.triggerDuration = 60;
               _loc54_ = GeneralUtils.pointOnCircle(_loc60_.x,_loc60_.y,20 * this.ud1.size,Math.random() * 360);
               _loc56_ = _loc62_.GetWorldCenter().Copy();
               _loc56_.Multiply(Physics.scale);
               _loc64_ = (_loc56_.y - _loc60_.y) / (_loc56_.x - _loc60_.x);
               _loc52_ = 0;
               while(_loc52_ < 20)
               {
                  _loc65_ = _loc54_.x + _loc52_ / 20 * (_loc56_.x - _loc54_.x);
                  _loc66_ = _loc54_.y + _loc64_ * (_loc65_ - _loc54_.x);
                  GameState.particles.addParticles(_loc65_,_loc66_,1,"shock",(-_loc54_.x + _loc65_) * 0.05,(-_loc54_.y + _loc66_) * 0.05,2,2);
                  _loc52_++;
               }
            }
         }
         if(this.ud1.rending || this.ud2.rending)
         {
            _loc67_ = 40;
            _loc68_ = Math.random() * 12 + 2;
            _loc69_ = new b2Vec2(_loc11_.x + Math.random() * _loc67_ - _loc67_ * 0.5,_loc11_.y + Math.random() * _loc67_ - _loc67_ * 0.5);
            _loc70_ = new b2Vec2(_loc11_.x + Math.random() * _loc67_ - _loc67_ * 0.5,_loc11_.y + Math.random() * _loc67_ - _loc67_ * 0.5);
            _loc71_ = new Vector.<b2Body>();
            if(this.ud1.rending)
            {
               _loc71_.push(this.body2);
            }
            if(this.ud2.rending)
            {
               _loc71_.push(this.body1);
            }
            this.addCut("rendgrenade",_loc69_,_loc70_,_loc68_,360,_loc71_,new Vector.<b2Body>());
         }
         if(this.ud1.alchemying)
         {
            if(!this.body2.IsStatic())
            {
               _loc72_ = this.ud2.alchemying;
               this.ud2.copyElemental(this.ud1);
               if(!_loc72_)
               {
                  this.ud2.alchemying = false;
               }
            }
         }
         if(this.ud2.alchemying)
         {
            if(!this.body1.IsStatic())
            {
               _loc72_ = this.ud1.alchemying;
               this.ud1.copyElemental(this.ud2);
               if(!_loc72_)
               {
                  this.ud1.alchemying = false;
               }
            }
         }
         if(this.ud1.spreading)
         {
            if(!this.body2.IsStatic())
            {
               this.ud2.copyElemental(this.ud1);
            }
         }
         if(this.ud2.spreading)
         {
            if(!this.body1.IsStatic())
            {
               this.ud1.copyElemental(this.ud2);
            }
         }
         if(this.ud1.transmuting)
         {
            if(Math.random() > 0.9)
            {
               Body.Transmuted(this.body2);
            }
         }
         if(this.ud2.transmuting)
         {
            if(Math.random() > 0.9)
            {
               Body.Transmuted(this.body1);
            }
         }
         if(this.ud1.critting && this.ud2.alive)
         {
            if(Math.random() > 0.95)
            {
               this.ud2.trigger = new Crit();
               this.ud2.triggered = true;
            }
         }
         if(this.ud2.critting && this.ud1.alive)
         {
            if(Math.random() > 0.95)
            {
               this.ud1.trigger = new Crit();
               this.ud1.triggered = true;
            }
         }
         if(this.ud1.deleting)
         {
            this.ud2.dead = true;
         }
         if(this.ud2.deleting)
         {
            this.ud1.dead = true;
         }
         if(this.ud1.triggering)
         {
            this.ud2.triggered = !this.ud2.triggered;
         }
         if(this.ud2.triggering)
         {
            this.ud1.triggered = !this.ud1.triggered;
         }
         if(this.ud1.relaying)
         {
            for each(_loc73_ in this.ud1.connected)
            {
               userData(_loc73_.GetUserData()).triggered = !userData(_loc73_.GetUserData()).triggered;
            }
         }
         if(this.ud2.relaying)
         {
            for each(_loc73_ in this.ud2.connected)
            {
               userData(_loc73_.GetUserData()).triggered = !userData(_loc73_.GetUserData()).triggered;
            }
         }
         if(this.ud1.janitoring)
         {
            if(this.ud2.hasBeenCut)
            {
               this.ud2.trigger = new DisintegratePowder(100,2,true);
               this.ud2.triggerLock = false;
               this.ud2.triggered = true;
               this.ud2.triggerLock = true;
            }
         }
         if(this.ud2.janitoring)
         {
            if(this.ud1.hasBeenCut)
            {
               this.ud1.trigger = new DisintegratePowder(100,2,true);
               this.ud1.triggerLock = false;
               this.ud1.triggered = true;
               this.ud1.triggerLock = true;
            }
         }
         if(this.ud1.cleaning)
         {
            _loc33_ = BoxUtils.getEffectBMD(this.body2);
            if(_loc33_)
            {
               _loc33_.colorTransform(_loc33_.rect,new ColorTransform(1,1,1,0.7));
            }
         }
         if(this.ud2.cleaning)
         {
            _loc33_ = BoxUtils.getEffectBMD(this.body1);
            if(_loc33_)
            {
               _loc33_.colorTransform(_loc33_.rect,new ColorTransform(1,1,1,0.7));
            }
         }
         if(this.ud1.hyping)
         {
            Body.Hype(this.body2);
         }
         if(this.ud2.hyping)
         {
            Body.Hype(this.body1);
         }
         if(this.ud1.suspending)
         {
            Body.Stasis(this.body2,12);
         }
         if(this.ud2.suspending)
         {
            Body.Stasis(this.body1,12);
         }
         if(this.ud1.banning)
         {
            this.ud2.trigger = new Disintegrate("error",10,20);
            this.ud2.triggerLock = false;
            this.ud2.triggered = true;
         }
         if(this.ud2.banning)
         {
            this.ud1.trigger = new Disintegrate("error",10,20);
            this.ud1.triggerLock = false;
            this.ud1.triggered = true;
         }
         if(this.ud1.blighting)
         {
            Body.Blight(this.body2,Math.random() * 20 + 10);
            Body.BlightEffect(this.body2,_loc11_);
         }
         if(this.ud2.blighting)
         {
            Body.Blight(this.body1,Math.random() * 20 + 10);
            Body.BlightEffect(this.body1,_loc11_);
         }
         if(this.ud1.cauterizing)
         {
            Body.Cauterize(this.body2);
         }
         if(this.ud2.cauterizing)
         {
            Body.Cauterize(this.body1);
         }
         if(this.ud1.disintegrator)
         {
            Body.Powder(this.body2);
         }
         if(this.ud2.disintegrator)
         {
            Body.Powder(this.body1);
         }
         if(this.ud1.disintegrating)
         {
            Body.Powder(this.body1);
         }
         if(this.ud2.disintegrating)
         {
            Body.Powder(this.body2);
         }
         if(this.ud1.drying)
         {
            Body.Sandstone(this.body2);
         }
         if(this.ud2.drying)
         {
            Body.Sandstone(this.body1);
         }
         if(this.ud1.frostfiring)
         {
            Body.Frostfire(this.body2);
         }
         if(this.ud2.frostfiring)
         {
            Body.Frostfire(this.body1);
         }
         if(this.ud1.frying)
         {
            Body.Deepfry(this.body2);
         }
         if(this.ud2.frying)
         {
            Body.Deepfry(this.body1);
         }
         if(this.ud1.glassing)
         {
            Body.Glass(this.body2);
         }
         if(this.ud2.glassing)
         {
            Body.Glass(this.body1);
         }
         if(this.ud1.glitching)
         {
            Body.Glitch(this.body2,true,this.body1);
         }
         if(this.ud2.glitching)
         {
            Body.Glitch(this.body1,true,this.body2);
         }
         if(this.ud1.petrifying)
         {
            Body.Petrify(this.body2);
         }
         if(this.ud2.petrifying)
         {
            Body.Petrify(this.body1);
         }
         if(this.ud1.concussing)
         {
            Body.Concuss(this.body2,120);
         }
         if(this.ud2.concussing)
         {
            Body.Concuss(this.body1,120);
         }
         if(this.ud1.sanguine)
         {
            Body.Exsanguinate(this.body2);
         }
         if(this.ud2.sanguine)
         {
            Body.Exsanguinate(this.body1);
         }
         if(this.ud1.scorching)
         {
            Body.Lava(this.body2);
         }
         if(this.ud2.scorching)
         {
            Body.Lava(this.body1);
         }
         if(this.ud1.wetting)
         {
            Body.Wet(this.body2,_loc11_);
         }
         if(this.ud2.wetting)
         {
            Body.Wet(this.body1,_loc11_);
         }
         if(this.ud1.ultrasharp)
         {
            _loc74_ = this.body2.GetPosition().Copy();
            _loc74_.Multiply(Physics.scale);
            _loc75_ = new b2Vec2((_loc10_.x + (this.body1.GetPosition().x - _loc10_.x) * 0.01) * Physics.scale,(_loc10_.y + (this.body1.GetPosition().y - _loc10_.y) * 0.05) * Physics.scale);
            _loc76_ = new Vector.<b2Body>();
            _loc76_.push(this.body2);
            this.addCut("chainsaw",_loc75_,_loc74_,100,0,_loc76_,new Vector.<b2Body>());
         }
         if(this.ud2.ultrasharp)
         {
            _loc74_ = this.body1.GetPosition().Copy();
            _loc74_.Multiply(Physics.scale);
            _loc75_ = new b2Vec2((_loc10_.x + (this.body2.GetPosition().x - _loc10_.x) * 0.01) * Physics.scale,(_loc10_.y + (this.body2.GetPosition().y - _loc10_.y) * 0.05) * Physics.scale);
            _loc76_ = new Vector.<b2Body>();
            _loc76_.push(this.body1);
            this.addCut("chainsaw",_loc75_,_loc74_,100,0,_loc76_,new Vector.<b2Body>());
         }
         if(this.ud1.trigger is FierySword && _loc14_.sharp)
         {
            this.addBlood(this.body2,10,_loc10_,null,null,false);
            FierySword(this.ud1.trigger).Effect(this.body2);
         }
         else if(this.ud2.trigger is FierySword && _loc15_.sharp)
         {
            this.addBlood(this.body1,10,_loc10_,null,null,false);
            FierySword(this.ud2.trigger).Effect(this.body1);
         }
         if(!this.ud1.resistFlame && !this.body1.IsStatic() && (this.ud2.flaming || _loc17_ == "firesword" && _loc19_ == "ef5d00"))
         {
            this.ud1.temperature += 200;
            _loc47_ = 0;
            while(_loc47_ < 5 + Math.random() * 20)
            {
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomParticlesOnBody(this.body1,"smoke",0.1 + Math.random() * Math.random() * 2);
               }
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomParticlesOnBody(this.body1,"fire2",0.1 + Math.random() * Math.random() * 2);
               }
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomParticlesOnBody(this.body1,"fire3",0.1 + Math.random() * Math.random() * 2);
               }
               _loc47_++;
            }
         }
         if(!this.ud1.resistFreeze && (this.ud2.freezing || _loc17_ == "frostsword" && _loc19_ == "91c2ff"))
         {
            if(this.ud2.triggerDuration == 0 && _loc9_ > 100 && !this.body1.IsStatic())
            {
               this.ud1.temperature -= 75;
               this.ud2.triggerDuration = 30;
               _loc47_ = 0;
               while(_loc47_ < 20)
               {
                  GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"crystal",Math.random() * 20 - 10,Math.random() * 20 - 10,1,1);
                  _loc47_++;
               }
            }
            else
            {
               this.ud1.temperature -= 10;
               GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"crystal",Math.random() * 4 - 2,Math.random() * 4 - 2,1,1);
            }
            if(!this.ud1.brittle || this.ud1.temperature < 0 && this.ud1.temperature > -50)
            {
               Body.Freeze(this.body1);
            }
         }
         if(!this.ud1.resistGust && (this.ud2.gusting || _loc17_ == "windsword" && _loc19_ == "ccf4f0"))
         {
            _loc44_ = 200 / Physics.scale;
            _loc45_ = Body.GetMultiple(new b2Vec2(_loc10_.x - _loc44_ * 0.5,_loc10_.y - _loc44_ * 0.5),_loc44_,_loc44_,false);
            for each(_loc46_ in _loc45_)
            {
               if(_loc46_ != this.body2)
               {
                  if(!userData(_loc46_.GetUserData()).resistGust)
                  {
                     if(!userData(this.body2.GetUserData()).isStabbing(_loc46_))
                     {
                        _loc48_ = new b2Vec2(_loc46_.GetWorldCenter().x * Physics.scale - _loc11_.x,_loc46_.GetWorldCenter().y * Physics.scale - _loc11_.y);
                        _loc49_ = _loc48_.Normalize();
                        _loc50_ = (_loc44_ * Physics.scale - _loc49_) / (_loc44_ * Physics.scale) * 5000;
                        _loc51_ = new b2Vec2(_loc48_.x * _loc50_,_loc48_.y * _loc50_);
                        _loc46_.ApplyForce(_loc51_,_loc46_.GetWorldCenter());
                     }
                  }
               }
            }
         }
         if(!this.ud1.resistHeal && (this.ud2.healing || _loc17_ == "lifesword" && _loc19_ == "ffe66b"))
         {
            if(this.ud1.alive)
            {
               this.ud1.health += Math.min(50,_loc9_ * 0.4);
               if(this.ud1.health > this.ud1.maxhealth)
               {
                  this.ud1.health = this.ud1.maxhealth;
               }
            }
            GameState.particles.addParticles(_loc10_.x * Physics.scale,_loc10_.y * Physics.scale,1,"heal",_loc4_.x * 0.1,_loc4_.y * 0.1,1,1);
         }
         if(!this.ud1.resistDrain && (this.ud2.draining || _loc17_ == "bloodsword" && _loc19_ == "b50404"))
         {
            if(this.ud1.alive)
            {
               _loc52_ = 0;
               while(_loc52_ < 10)
               {
                  _loc53_ = new b2Vec2(0,-(Math.random() * 90 - 30) * this.ud2.size / Physics.scale);
                  _loc54_ = BoxUtils.rotateVec(_loc53_,this.body1.GetAngle());
                  _loc54_.Add(this.body1.GetWorldCenter().Copy());
                  _loc55_ = BoxUtils.rotateVec(new b2Vec2(Math.random() * this.ud1.width - this.ud1.width * 0.5,Math.random() * this.ud1.height - this.ud1.height * 0.5),this.body1.GetAngle());
                  _loc56_ = new b2Vec2(this.body1.GetPosition().x * Physics.scale + _loc55_.x,this.body1.GetPosition().y * Physics.scale + _loc55_.y);
                  _loc56_.Multiply(1 / Physics.scale);
                  this.addBlood(this.body1,1,_loc56_,new b2Vec2(_loc54_.x - _loc56_.x,_loc54_.y - _loc56_.y));
                  _loc52_++;
               }
               if(this.ud2.alive)
               {
                  this.ud2.health += 100;
               }
               Body.Radiation(this.body1,false);
               if(this.ud1.health <= 0)
               {
                  this.ud1.health = 0;
                  this.ud1.trigger = new Disintegrate("blood",this.ud1.maxhealth * 0.5);
                  this.ud1.triggered = true;
               }
            }
            else
            {
               this.addBlood(this.body1,1,_loc11_,new b2Vec2(),new b2Vec2(2,2));
            }
         }
         if(!this.ud1.resistKill && (this.ud2.killing || _loc17_ == "deathsword" && _loc19_ == "333333"))
         {
            if(this.ud1.alive)
            {
               this.ud1.health = 0;
               _loc33_ = BoxUtils.getEffectBMD(this.body1);
               if(_loc33_)
               {
                  _loc57_ = 0;
                  while(_loc57_ < 50)
                  {
                     _loc34_ = this.body1.GetLocalPoint(_loc10_).Copy();
                     _loc34_ = GeneralUtils.pointOnCircle(_loc34_.x,_loc34_.y,Math.random() * _loc57_,Math.random() * 360);
                     _loc34_.Multiply(Physics.scale);
                     _loc34_.x -= Bitmap(this.ud1.graphic.getChildByName("effects")).x;
                     _loc34_.y -= Bitmap(this.ud1.graphic.getChildByName("effects")).y;
                     _loc33_.copyPixels(R.getSprite(Math.random() > 0.8 ? "p_blood" : "p_dark"),new Rectangle(0,0,8,8),new Point(_loc34_.x,_loc34_.y),null,null,true);
                     _loc57_++;
                  }
               }
            }
         }
         if(!this.ud1.resistDispel && (this.ud2.dispelling || _loc17_ == "lightsword" && _loc19_ == "fff9c6"))
         {
            if(this.ud2.triggerDuration == 0 && _loc9_ > 80)
            {
               this.ud2.triggerDuration = 20;
               Shadows.lightPos = _loc11_;
               Shadows.lightRadius = 100;
               Main.instance.drawShadowsFor(Body.GetMultiple(new b2Vec2(_loc10_.x - 150 / Physics.scale,_loc10_.y - 150 / Physics.scale),300 / Physics.scale,300 / Physics.scale),10);
               _loc58_ = BoxUtils.selectCompound(this.body1);
               for each(_loc59_ in _loc58_)
               {
                  Body.Dispel(_loc59_);
               }
               _loc47_ = 0;
               while(_loc47_ < 10)
               {
                  GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"light",Math.random() * 60 - 30,Math.random() * 60 - 30,1,1);
                  _loc47_++;
               }
            }
            else
            {
               GameState.particles.addParticles(_loc11_.x,_loc11_.y,2,"light",Math.random() * 60 - 30,Math.random() * 60 - 30,1,1);
            }
         }
         if(!this.ud1.resistShock && (this.ud2.shocking || _loc17_ == "shocksword" && _loc19_ == "11e8ff"))
         {
            _loc44_ = 160 / Physics.scale;
            _loc60_ = _loc11_;
            _loc61_ = Body.GetMultiple(new b2Vec2(_loc60_.x / Physics.scale - _loc44_ * 0.5,_loc60_.y / Physics.scale - _loc44_ * 0.5),_loc44_,_loc44_,false);
            _loc62_ = _loc61_[Math.random() * _loc61_.length >> 0];
            if((Boolean(_loc62_)) && Boolean(_loc62_ != this.body2) && !userData(_loc62_.GetUserData()).resistShock)
            {
               _loc63_ = userData(_loc62_.GetUserData());
               _loc63_.trigger = new Electrified();
               _loc63_.triggered = true;
               _loc63_.triggerDuration = 60;
               _loc54_ = GeneralUtils.pointOnCircle(_loc60_.x,_loc60_.y,20 * this.ud2.size,Math.random() * 360);
               _loc56_ = _loc62_.GetWorldCenter().Copy();
               _loc56_.Multiply(Physics.scale);
               _loc64_ = (_loc56_.y - _loc60_.y) / (_loc56_.x - _loc60_.x);
               _loc52_ = 0;
               while(_loc52_ < 20)
               {
                  _loc65_ = _loc54_.x + _loc52_ / 20 * (_loc56_.x - _loc54_.x);
                  _loc66_ = _loc54_.y + _loc64_ * (_loc65_ - _loc54_.x);
                  GameState.particles.addParticles(_loc65_,_loc66_,1,"shock",(-_loc54_.x + _loc65_) * 0.05,(-_loc54_.y + _loc66_) * 0.05,2,2);
                  _loc52_++;
               }
            }
         }
         if(!this.ud2.resistPoison && (this.ud1.poisoning || _loc16_ == "poisonsword" && _loc18_ == "117b0c"))
         {
            if(this.ud2.alive)
            {
               this.ud2.trigger = new Poisoned();
               this.ud2.triggered = true;
               this.ud2.triggerDuration = Math.random() * 120 + 120;
            }
         }
         else if(!this.ud1.resistPoison && (this.ud2.poisoning || _loc17_ == "poisonsword" && _loc19_ == "117b0c"))
         {
            if(this.ud1.alive)
            {
               this.ud1.trigger = new Poisoned();
               this.ud1.triggered = true;
               this.ud1.triggerDuration = Math.random() * 120 + 120;
            }
         }
         if(this.ud1.weldOnContact && !this.body2.IsStatic())
         {
            _loc77_ = Joints.Weld("weldjoint",this.body1,this.body2,this.body2.GetPosition(),0);
            if(_loc77_)
            {
               jointUserData(_loc77_.GetUserData()).lineVisible = false;
            }
            this.ud1.weldOnContact = false;
         }
         if(this.ud2.weldOnContact && !this.body1.IsStatic())
         {
            _loc77_ = Joints.Weld("weldjoint",this.body2,this.body1,this.body1.GetPosition(),0);
            if(_loc77_)
            {
               jointUserData(_loc77_.GetUserData()).lineVisible = false;
            }
            this.ud2.weldOnContact = false;
         }
         if(this.ud1.explosive && !this.ud2.explosive && _loc17_ != "wall")
         {
            if(_loc6_ > 1)
            {
               this.ud1.triggerLock = false;
               this.ud1.trigger = new Explode();
               this.ud1.triggered = true;
               this.ud1.dead = false;
            }
         }
         else if(this.ud2.explosive && !this.ud1.explosive && _loc16_ != "wall")
         {
            if(_loc5_ > 1)
            {
               this.ud2.triggerLock = false;
               this.ud2.trigger = new Explode();
               this.ud2.triggered = true;
               this.ud2.dead = false;
            }
         }
         else if(this.ud1.implosive && !this.ud2.implosive && _loc17_ != "wall")
         {
            if(_loc6_ > 1)
            {
               this.ud1.triggered = true;
               this.ud1.trigger = new Implode();
            }
         }
         else if(this.ud2.implosive && !this.ud1.implosive && _loc16_ != "wall")
         {
            if(_loc5_ > 1)
            {
               this.ud2.triggered = true;
               this.ud2.trigger = new Implode();
            }
         }
         if(_loc14_.sticky && !_loc15_.sensor || _loc15_.sticky && !_loc14_.sensor)
         {
            if(Math.abs(_loc3_.x) + Math.abs(_loc4_.x) > 30 || Math.abs(_loc3_.y) + Math.abs(_loc4_.y) > 30)
            {
               _loc78_ = new b2Vec2(_loc12_ + (this.body1.GetPosition().x - _loc12_) * 0.1,_loc13_ + (this.body1.GetPosition().y - _loc13_) * 0.1);
               _loc79_ = new b2Vec2(_loc12_ + (this.body2.GetPosition().x - _loc12_) * 0.1,_loc13_ + (this.body2.GetPosition().y - _loc13_) * 0.1);
               Main.instance.jointArray.push(this.body1,this.body2,_loc78_,_loc79_,_loc10_);
               if(_loc14_.sticky)
               {
                  if(Boolean(this.ud1) && Boolean(this.ud1.trigger))
                  {
                     this.ud1.trigger.OnStick(this.body2);
                  }
               }
               else if(Boolean(this.ud2) && Boolean(this.ud2.trigger))
               {
                  this.ud2.trigger.OnStick(this.body1);
               }
            }
         }
         if(_loc16_ == "blowdart" && _loc18_ == "838383")
         {
            if(this.ud2.alive)
            {
               this.ud2.trigger = new Poisoned();
               this.ud2.triggered = true;
               this.ud2.triggerDuration = Math.random() * 120 + 120;
            }
         }
         else if(_loc17_ == "blowdart" && _loc19_ == "838383")
         {
            if(this.ud1.alive)
            {
               this.ud1.trigger = new Poisoned();
               this.ud1.triggered = true;
               this.ud1.triggerDuration = Math.random() * 120 + 120;
            }
         }
         else if(_loc16_ == "trapdart" && _loc18_ == "545454")
         {
            if(this.ud2.alive)
            {
               this.ud2.trigger = new Poisoned();
               this.ud2.triggered = true;
               this.ud2.triggerDuration = Math.random() * 120 + 120;
            }
         }
         else if(_loc17_ == "trapdart" && _loc19_ == "545454")
         {
            if(this.ud1.alive)
            {
               this.ud1.trigger = new Poisoned();
               this.ud1.triggered = true;
               this.ud1.triggerDuration = Math.random() * 120 + 120;
            }
         }
         else if(_loc16_ == "tranqdart" && _loc18_ == "545454")
         {
            if(this.ud2.alive)
            {
               _loc80_ = BoxUtils.selectCompound(this.body2);
               for each(_loc82_ in _loc80_)
               {
                  _loc81_ = userData(_loc82_.GetUserData());
                  _loc81_.trigger = new Concussion(1200);
                  _loc81_.triggered = true;
               }
            }
         }
         else if(_loc17_ == "tranqdart" && _loc19_ == "545454")
         {
            if(this.ud1.alive)
            {
               _loc80_ = BoxUtils.selectCompound(this.body1);
               for each(_loc82_ in _loc80_)
               {
                  _loc81_ = userData(_loc82_.GetUserData());
                  _loc81_.trigger = new Concussion(1200);
                  _loc81_.triggered = true;
               }
            }
         }
         else if(_loc16_ == "deathdart" && _loc18_ == "545454")
         {
            if(this.ud2.alive)
            {
               this.ud2.health = 0;
            }
         }
         else if(_loc17_ == "deathdart" && _loc19_ == "545454")
         {
            if(this.ud1.alive)
            {
               this.ud1.health = 0;
            }
         }
         if(_loc18_ == "800101" && _loc17_ != "wall")
         {
            this.ud1.triggered = true;
            return;
         }
         if(_loc19_ == "800101" && _loc16_ != "wall")
         {
            this.ud2.triggered = true;
            return;
         }
         if(_loc16_ == "barrel")
         {
            if(_loc9_ > 1000 || String(_loc17_).substr(0,6) == "bullet" && _loc9_ > 100)
            {
               this.ud1.triggered = true;
               this.ud1.trigger = new Explode();
               return;
            }
         }
         if(_loc17_ == "barrel")
         {
            if(_loc9_ > 1000 || String(_loc16_).substr(0,6) == "bullet" && _loc9_ > 100)
            {
               this.ud2.triggered = true;
               this.ud2.trigger = new Explode();
               return;
            }
         }
         if(_loc16_ == "methane")
         {
            if(_loc9_ > 1000 || String(_loc17_).substr(0,6) == "bullet" && _loc9_ > 30)
            {
               this.ud1.triggered = true;
               this.ud1.trigger = new Explode();
               return;
            }
         }
         if(_loc17_ == "methane")
         {
            if(_loc9_ > 1000 || String(_loc16_).substr(0,6) == "bullet" && _loc9_ > 30)
            {
               this.ud2.triggered = true;
               this.ud2.trigger = new Explode();
               return;
            }
         }
         if(_loc16_ == "aerosol")
         {
            if(_loc9_ > 250 || _loc17_.substr(0,6) == "bullet" && _loc9_ > 10)
            {
               this.ud1.triggered = true;
               this.ud1.trigger = new AerosolCan();
               return;
            }
         }
         if(_loc17_ == "aerosol")
         {
            if(_loc9_ > 250 || String(_loc16_).substr(0,6) == "bullet" && _loc9_ > 10)
            {
               this.ud2.triggered = true;
               this.ud2.trigger = new AerosolCan();
               return;
            }
         }
         if(_loc16_ == "steamarrow" && _loc14_.sharp)
         {
            this.addBlood(this.body2,50,_loc10_,new b2Vec2(_loc3_.x * 0.05,_loc3_.y * 0.05),new b2Vec2(2,2));
            this.body1.GetLinearVelocity().Multiply(0.9);
            if(this.body1.GetLinearVelocity().Length() < 50)
            {
               this.ud1.trigger = new Disintegrate("air",100,1);
               this.ud1.triggered = true;
            }
         }
         else if(_loc17_ == "steamarrow" && _loc15_.sharp)
         {
            this.addBlood(this.body1,50,_loc10_,new b2Vec2(_loc4_.x * 0.05,_loc4_.y * 0.05),new b2Vec2(2,2));
            this.body2.GetLinearVelocity().Multiply(0.9);
            if(this.body2.GetLinearVelocity().Length() < 50)
            {
               this.ud2.trigger = new Disintegrate("air",100,1);
               this.ud2.triggered = true;
            }
         }
         if(_loc16_ == "stimpack" && _loc18_ == "443636")
         {
            if(this.ud1.trigger is Gun && Firearm(Gun(this.ud1.trigger).firearm).shoot())
            {
               if(this.ud2.alive)
               {
                  this.ud2.health += 50;
                  this.ud2.trigger = new Regen();
                  this.ud2.triggered = true;
                  this.ud2.triggerDuration = 120 + Math.random() * 120;
                  new Bee().sting(this.body2,_loc11_,Math.random() * 5 + 1);
               }
            }
         }
         else if(_loc17_ == "stimpack" && _loc19_ == "443636")
         {
            if(this.ud2.trigger is Gun && Firearm(Gun(this.ud2.trigger).firearm).shoot())
            {
               if(this.ud1.alive)
               {
                  this.ud1.health += 50;
                  this.ud1.trigger = new Regen();
                  this.ud1.triggered = true;
                  this.ud1.triggerDuration = 120 + Math.random() * 120;
                  new Bee().sting(this.body1,_loc11_,Math.random() * 5 + 1);
               }
            }
         }
         var _loc29_:Boolean = String(_loc16_).substr(0,6) == "bullet" && !this.ud2.bulletproof;
         var _loc30_:Boolean = String(_loc17_).substr(0,6) == "bullet" && !this.ud1.bulletproof;
         if(_loc29_ || _loc30_)
         {
            if(_loc29_ && _loc30_)
            {
               return;
            }
            if(_loc29_)
            {
               _loc41_ = this.body1;
               _loc85_ = this.body2;
               _loc84_ = ShapeUserData(param1.shape2.GetUserData());
            }
            else
            {
               _loc41_ = this.body2;
               _loc85_ = this.body1;
               _loc84_ = ShapeUserData(param1.shape1.GetUserData());
            }
            _loc83_ = _loc41_.GetUserData() as userData;
            _loc26_ = _loc85_.GetUserData() as userData;
            _loc38_ = _loc41_.GetLinearVelocity().Copy();
            if(!_loc83_.triggerForce || _loc83_.triggerForce == 0)
            {
               return;
            }
            if(_loc26_.bulletproof)
            {
               return;
            }
            _loc86_ = String(_loc83_.name).substr(7,3);
            if(_loc86_ == "fla")
            {
               _loc83_.dead = true;
               if(_loc26_.temperature < 1000 && !_loc85_.IsStatic())
               {
                  _loc26_.temperature += 100;
               }
               this.addBlood(_loc41_,Math.random() * 6,_loc10_,new b2Vec2(_loc7_ * 0.01,_loc8_ * 0.01),new b2Vec2(),false);
               return;
            }
            if(_loc38_.Length() < 50)
            {
               _loc83_.dead = true;
            }
            _loc87_ = ["bulletwall1","bulletwall2","bulletwall3"];
            _loc88_ = 0.2 + Math.random() * 0.4;
            if(_loc26_.alive)
            {
               _loc87_ = ["bat1","bat2","bat3"];
               _loc88_ = 0.2 + Math.random() * 0.6;
            }
            sounds.random(_loc87_,null,_loc11_,_loc88_,false);
            if(!_loc26_.alive && !_loc26_.soft)
            {
               GameState.particles.addParticles(_loc12_ * Physics.scale,_loc13_ * Physics.scale,_loc86_ == "sho" ? 1 : 4,"sparkle",-(param1.normal.x * _loc38_.x * 0.2 + (param1.normal.x < 0 ? 1 : -1) * _loc38_.x * 0.2),-(param1.normal.y * _loc38_.y * 0.2 + (param1.normal.y < 0 ? 1 : -1) * _loc38_.y * 0.2),4,4);
            }
            _loc89_ = _loc83_.triggerForce * _loc83_.size * 10 * _loc26_.multiBulletDamage;
            if(_loc26_.name == "doll_head")
            {
               _loc89_ *= 20;
            }
            if(!_loc85_.IsStatic() && (!_loc26_.alive && !_loc26_.armour || _loc26_.health - _loc89_ <= 0))
            {
               if(_loc26_.alive || Boolean(_loc26_.armour))
               {
                  _loc26_.health = 0;
               }
               _loc75_ = new b2Vec2(_loc41_.GetPosition().x * Physics.scale - _loc38_.x * 0.01,_loc41_.GetPosition().y * Physics.scale - _loc38_.y * 0.01);
               _loc74_ = new b2Vec2(_loc12_ * Physics.scale,_loc13_ * Physics.scale);
               this.cutRange = 100;
               _loc71_ = new Vector.<b2Body>();
               _loc71_.push(_loc85_);
               this.addCut("bullet",_loc75_,_loc74_,this.cutRange,0,_loc71_,new Vector.<b2Body>());
            }
            else if((Boolean(_loc26_.alive) || Boolean(_loc26_.armour)) && _loc85_.GetMass() > 0.1)
            {
               if(_loc26_.armour)
               {
                  _loc26_.armour.DamageBullet(_loc89_,_loc10_,_loc38_);
               }
               else
               {
                  this.addBlood(_loc85_,_loc89_ * 0.8,_loc10_,new b2Vec2(Math.random() * _loc38_.x * 0.03,Math.random() * _loc38_.y * 0.03),new b2Vec2(_loc38_.x * 0.001 + 1,_loc38_.y * 0.001 + 1));
                  this.addBlood(_loc85_,_loc89_ * 0.2,_loc10_,new b2Vec2(Math.random() * -_loc38_.x * 0.005,Math.random() * -_loc38_.y * 0.005),new b2Vec2(_loc38_.x * 0.001 + 1,_loc38_.y * 0.001 + 1));
                  if(_loc26_.alive)
                  {
                     Body.BulletHole(_loc85_,_loc41_,param1);
                  }
               }
            }
            if((Boolean(_loc26_.alive || _loc26_.armour) || Boolean(_loc26_.soft)) && (!_loc83_.trigger || _loc83_.trigger is Trail))
            {
               Body.BulletPenetrate(_loc41_,_loc85_,param1);
            }
            if(!_loc26_.soft && !_loc26_.alive)
            {
               _loc90_ = false;
               _loc38_ = _loc38_.Copy();
               _loc91_ = 2 * MathUtils.dotProduct(_loc38_,param1.normal);
               _loc92_ = _loc38_.Copy();
               _loc92_.Subtract(new b2Vec2(param1.normal.x * _loc91_,param1.normal.y * _loc91_));
               _loc93_ = _loc38_.x * _loc92_.y - _loc92_.x * _loc4_.y;
               _loc94_ = _loc38_.x * _loc92_.x + _loc38_.y * _loc92_.y;
               _loc95_ = Math.atan2(_loc93_,_loc94_) * Vars.toDegrees;
               if(Math.abs(_loc95_) > 30)
               {
                  _loc90_ = true;
               }
               if(Boolean(_loc26_.armour) && !_loc26_.armour.protectFromCuts)
               {
                  _loc90_ = false;
               }
               if(_loc90_)
               {
                  if(_loc84_.sharp)
                  {
                     if(Math.random() > 0.25)
                     {
                        _loc83_.dead = true;
                     }
                  }
                  else
                  {
                     _loc83_.dead = true;
                  }
               }
               else
               {
                  _loc87_ = ["ricochet1","ricochet2","ricochet3"];
                  sounds.random(_loc87_,null,_loc11_,0.2 + Math.random() * 0.4,true);
               }
            }
            if(_loc26_.conductivity == 0.01)
            {
               _loc26_.temperature += Math.random();
            }
            if(_loc26_.armour)
            {
               _loc26_.armour.bulletHole(_loc10_,_loc38_);
            }
         }
         if(this.ud1.breakable)
         {
            _loc96_ = 1;
            if(this.body2.IsStatic())
            {
               _loc96_ = 20;
            }
            if(this.ud2.breakable)
            {
               _loc96_ = 10;
            }
            if(_loc9_ > 250 * _loc96_)
            {
               _loc99_ = new b2Vec2((_loc12_ - (this.body1.GetPosition().x - _loc12_) * 0.01) * Physics.scale,(_loc13_ - (this.body1.GetPosition().y - _loc13_) * 0.01) * Physics.scale);
               _loc97_ = (_loc12_ + (this.body2.GetPosition().x - _loc12_) * (Math.random() * 0.9 + 0.1)) * Physics.scale;
               _loc98_ = (_loc13_ + (this.body2.GetPosition().y - _loc13_) * (Math.random() * 0.9 + 0.1)) * Physics.scale;
               _loc76_ = new Vector.<b2Body>();
               _loc76_.push(this.body1);
               this.addCut("breakable",new b2Vec2(_loc97_,_loc98_),_loc99_,100,1,_loc76_,new Vector.<b2Body>());
            }
         }
         if(this.ud2.breakable)
         {
            _loc96_ = 1;
            if(this.body1.IsStatic())
            {
               _loc96_ = 20;
            }
            else if(this.ud1.breakable)
            {
               _loc96_ = 10;
            }
            if(_loc9_ > 250 * _loc96_)
            {
               _loc99_ = new b2Vec2((_loc12_ - (this.body2.GetPosition().x - _loc12_) * 0.01) * Physics.scale,(_loc13_ - (this.body2.GetPosition().y - _loc13_) * 0.01) * Physics.scale);
               _loc97_ = (_loc12_ + (this.body1.GetPosition().x - _loc12_) * (Math.random() * 0.9 + 0.1)) * Physics.scale;
               _loc98_ = (_loc13_ + (this.body1.GetPosition().y - _loc13_) * (Math.random() * 0.9 + 0.1)) * Physics.scale;
               _loc76_ = new Vector.<b2Body>();
               _loc76_.push(this.body2);
               this.addCut("breakable",new b2Vec2(_loc97_,_loc98_),_loc99_,100,1,_loc76_,new Vector.<b2Body>());
            }
         }
         if(this.ud1.crumble)
         {
            if(_loc9_ > 100)
            {
               _loc97_ = (_loc12_ - (this.body1.GetPosition().x - _loc12_) * 0.1) * Physics.scale;
               _loc98_ = (_loc13_ - (this.body1.GetPosition().y - _loc13_) * 0.1) * Physics.scale;
               _loc99_ = new b2Vec2((_loc12_ - (this.body2.GetPosition().x - _loc12_) * 0.1) * Physics.scale,(_loc13_ - (this.body2.GetPosition().y - _loc13_) * 0.1) * Physics.scale);
               _loc76_ = new Vector.<b2Body>();
               _loc76_.push(this.body1);
               this.addCut("breakable",new b2Vec2(_loc97_,_loc98_),_loc99_,100,1,_loc76_,new Vector.<b2Body>());
            }
         }
         if(this.ud2.crumble)
         {
            if(_loc9_ > 100)
            {
               _loc97_ = (_loc12_ - (this.body2.GetPosition().x - _loc12_) * 0.1) * Physics.scale;
               _loc98_ = (_loc13_ - (this.body2.GetPosition().y - _loc13_) * 0.1) * Physics.scale;
               _loc99_ = new b2Vec2((_loc12_ - (this.body1.GetPosition().x - _loc12_) * 0.1) * Physics.scale,(_loc13_ - (this.body1.GetPosition().y - _loc13_) * 0.1) * Physics.scale);
               _loc76_ = new Vector.<b2Body>();
               _loc76_.push(this.body2);
               this.addCut("breakable",new b2Vec2(_loc97_,_loc98_),_loc99_,100,1,_loc76_,new Vector.<b2Body>());
            }
         }
         if(this.ud1.brittle)
         {
            if(_loc2_ > 120 || _loc9_ > 1000)
            {
               Main.instance.brittleArray.push(this.body1);
            }
         }
         if(this.ud2.brittle)
         {
            if(_loc2_ > 120 || _loc9_ > 1000)
            {
               Main.instance.brittleArray.push(this.body2);
            }
         }
         if(Boolean(this.ud1.alive || this.ud2.alive) || Boolean(this.ud1.armour) || Boolean(this.ud2.armour))
         {
            _loc102_ = 0;
            while(_loc102_ < 2)
            {
               if(!(_loc14_.sensor || _loc15_.sensor))
               {
                  if(_loc102_ == 0)
                  {
                     _loc100_ = this.body1;
                  }
                  if(_loc102_ == 1)
                  {
                     _loc100_ = this.body2;
                  }
                  _loc103_ = userData(_loc100_.GetUserData());
                  _loc26_ = userData(this.otherBody(_loc100_).GetUserData());
                  _loc101_ = _loc103_.size;
                  if(_loc9_ > 100 * _loc101_)
                  {
                     _loc104_ = _loc9_;
                     _loc105_ = new b2Vec2(_loc7_ * 0.001,_loc8_ * 0.001);
                     _loc105_.x += _loc100_.GetLinearVelocity().x * 0.1;
                     _loc105_.y += _loc100_.GetLinearVelocity().y * 0.1;
                     if(_loc105_.x > 100)
                     {
                        _loc105_.x = 100;
                     }
                     if(_loc105_.y > 100)
                     {
                        _loc105_.y = 100;
                     }
                     _loc106_ = _loc104_ * 0.02 / _loc101_ >> 0;
                     _loc107_ = _loc103_.bloodColour;
                     if(_loc103_.armour)
                     {
                        _loc103_.armour.DamageBlunt(_loc106_,_loc10_,_loc105_);
                        break;
                     }
                     if(!(Boolean(this.ud1.armour) || Boolean(this.ud2.armour)))
                     {
                        if(_loc103_.alive)
                        {
                           _loc108_ = _loc104_ > 500;
                           if(_loc106_ > 15)
                           {
                              _loc106_ = 15;
                           }
                           _loc109_ = 1;
                           while(_loc109_ <= _loc106_)
                           {
                              _loc110_ = new b2Vec2(Math.random() * Math.random() * _loc109_ * 0.5,Math.random() * Math.random() * _loc109_ * 0.5);
                              _loc110_.Multiply(Math.min(10,_loc103_.multiBluntDamage));
                              this.addBlood(_loc100_,10 * _loc109_ * _loc103_.multiBluntDamage,_loc10_,_loc105_,_loc110_,_loc108_,_loc109_ == _loc106_);
                              _loc109_++;
                           }
                           if(_loc103_.health > 0)
                           {
                              if(_loc9_ > 250 && World.toggleSlomo == 1 && !GameState.slomo)
                              {
                                 TimeLord.slowTo(50);
                              }
                              if(!(this.ud1.stainless || this.ud2.stainless))
                              {
                                 if(_loc9_ > 200 && World.toggleGore == 1 && _loc103_.temperature > -10)
                                 {
                                    if(World.toggleExtraGore)
                                    {
                                       _loc111_ = Body.GetMultiple(new b2Vec2(_loc10_.x - Math.min(10,_loc106_),_loc10_.y - Math.min(10,_loc106_)),Math.min(20,_loc106_ * 2),Math.min(20,_loc106_ * 2),true);
                                       if(_loc111_.indexOf(this.body1) == -1)
                                       {
                                          _loc111_.push(this.body1);
                                       }
                                       if(_loc111_.indexOf(this.body2) == -1)
                                       {
                                          _loc111_.push(this.body2);
                                       }
                                    }
                                    else
                                    {
                                       _loc111_ = [this.body1,this.body2];
                                    }
                                    for each(_loc73_ in _loc111_)
                                    {
                                       _loc33_ = BoxUtils.getEffectBMD(_loc73_);
                                       if(_loc33_)
                                       {
                                          _loc34_ = _loc73_.GetLocalPoint(_loc10_).Copy();
                                          _loc35_ = new Sprite();
                                          _loc112_ = userData(_loc73_.GetUserData());
                                          _loc113_ = Bitmap(_loc112_.graphic.getChildByName("effects")).x;
                                          _loc114_ = Bitmap(_loc112_.graphic.getChildByName("effects")).y;
                                          _loc115_ = _loc9_ * 0.002;
                                          if(World.toggleExtraGore)
                                          {
                                             _loc115_ = _loc9_ * 0.01;
                                          }
                                          if(_loc115_ > 50)
                                          {
                                             _loc115_ = 50;
                                          }
                                          _loc42_ = 0;
                                          while(_loc42_ < _loc115_)
                                          {
                                             _loc35_.graphics.beginFill(GraphicUtils.scalehex(_loc107_,0.8 + Math.random() * 0.4),1);
                                             _loc35_.graphics.drawCircle(_loc34_.x * Physics.scale - _loc113_ + Math.random() * Math.random() * (Math.random() * _loc106_ * _loc42_ - _loc42_ * _loc106_ * 0.5),_loc34_.y * Physics.scale - _loc114_ + Math.random() * Math.random() * (Math.random() * _loc106_ * _loc42_ - _loc42_ * _loc106_ * 0.5),Math.random() * (1 + (Math.random() * 8 + 2) * _loc106_ / 50));
                                             _loc42_++;
                                          }
                                          _loc33_.draw(_loc35_);
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
               _loc102_++;
            }
         }
         if(this.ud1.burning && !this.ud2.sharp && _loc3_.Length() > 10)
         {
            this.ud1.temperature -= 10;
         }
         if(this.ud2.burning && !this.ud1.sharp && _loc4_.Length() > 10)
         {
            this.ud2.temperature -= 10;
         }
         if(this.ud1.sticky && !_loc15_.sensor || this.ud2.sticky && !_loc14_.sensor)
         {
            if(Math.abs(_loc3_.x) + Math.abs(_loc4_.x) > 5 || Math.abs(_loc3_.y) + Math.abs(_loc4_.y) > 5)
            {
               if(this.ud2.sticky && (_loc5_ > 1 || _loc5_ == 0) || this.ud1.sticky && (_loc6_ > 1 || _loc6_ == 0))
               {
                  _loc78_ = new b2Vec2(_loc12_ + (this.body1.GetPosition().x - _loc12_) / 20,_loc13_ + (this.body1.GetPosition().y - _loc13_) / 20);
                  _loc79_ = new b2Vec2(_loc12_ + (this.body2.GetPosition().x - _loc12_) / 20,_loc13_ + (this.body2.GetPosition().y - _loc13_) / 20);
                  Main.instance.jointArray.push(this.body1,this.body2,_loc78_,_loc79_,_loc10_);
                  if(this.ud1.sticky)
                  {
                     if(Boolean(this.ud1) && Boolean(this.ud1.trigger))
                     {
                        this.ud1.trigger.OnStick(this.body2);
                     }
                  }
                  else if(Boolean(this.ud2) && Boolean(this.ud2.trigger))
                  {
                     this.ud2.trigger.OnStick(this.body1);
                  }
               }
               if(_loc9_ > 10)
               {
                  if(_loc16_ == "arcgrenade" && !this.body2.IsStatic() && !this.ud1.triggered)
                  {
                     this.ud1.triggered = true;
                  }
                  if(_loc17_ == "arcgrenade" && !this.body1.IsStatic() && !this.ud2.triggered)
                  {
                     this.ud2.triggered = true;
                  }
               }
            }
         }
         if(sounds.enabled && !_loc14_.sensor && !_loc15_.sensor)
         {
            if(this.ud1.alive || this.ud2.alive)
            {
               if(!this.ud1.blunt && !this.ud2.blunt && (_loc14_.sharp && this.ud2.temperature > 0 || _loc15_.sharp && this.ud1.temperature > 0 || this.ud1.sharp || this.ud2.sharp))
               {
                  if(_loc9_ > 100)
                  {
                     sounds.random(["stab4","stab5"],null,_loc11_,Math.random() * 0.4 + 0.2,false);
                  }
                  else if(_loc9_ > 20)
                  {
                     sounds.random(["stab1","stab2"],null,_loc11_,Math.random() * 0.4 + 0.2,false);
                  }
               }
               else if(_loc9_ < 200 && (!this.ud1.alive || !this.ud2.alive))
               {
                  sounds.random(["touch4","touch5"],null,_loc11_,Math.min(0.75,_loc9_ / 5),false);
               }
               else if(this.ud1.alive && this.ud1.temperature < -10 || this.ud2.alive && this.ud2.temperature < -10)
               {
                  sounds.play("hitfrozen",null,_loc11_,Math.min(1,_loc9_ / 200),false);
               }
               else if(_loc3_.Length() > 12 || _loc4_.Length() > 12)
               {
                  if(_loc9_ >= 100 && _loc9_ < 600)
                  {
                     _loc87_ = ["bat1","bat2","bat3"];
                     sounds.random(_loc87_,null,_loc11_,Math.min(1,_loc9_ / 400),false);
                  }
                  else if(_loc9_ >= 600)
                  {
                     _loc87_ = ["hit26","hit27","hit28","hit29"];
                     sounds.random(_loc87_,null,_loc11_,Math.min(1,_loc9_ / 400),false);
                  }
               }
            }
            else
            {
               sounds.random(["touch2","touch3"],null,_loc11_,Math.min(0.15,_loc9_ / 100),false);
            }
         }
         super.Add(param1);
      }
      
      override public function Persist(param1:b2ContactPoint) : void
      {
         var _loc16_:Boolean = false;
         var _loc17_:Array = null;
         var _loc18_:Boolean = false;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:b2Body = null;
         var _loc22_:Boolean = false;
         var _loc23_:userData = null;
         var _loc24_:b2Body = null;
         var _loc25_:Number = NaN;
         var _loc26_:b2Vec2 = null;
         var _loc27_:b2Vec2 = null;
         var _loc28_:b2Vec2 = null;
         var _loc29_:Boolean = false;
         var _loc30_:Array = null;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         if(GameState.paused)
         {
            return;
         }
         var _loc2_:ShapeUserData = ShapeUserData(param1.shape1.GetUserData());
         var _loc3_:ShapeUserData = ShapeUserData(param1.shape2.GetUserData());
         var _loc4_:b2Body = param1.shape1.GetBody();
         var _loc5_:b2Body = param1.shape2.GetBody();
         var _loc6_:userData = userData(_loc4_.GetUserData());
         var _loc7_:userData = userData(_loc5_.GetUserData());
         var _loc8_:String = _loc6_.name;
         var _loc9_:String = _loc7_.name;
         var _loc10_:String = _loc2_.name;
         var _loc11_:String = _loc3_.name;
         var _loc12_:Number = _loc6_.conductivity;
         var _loc13_:Number = _loc7_.conductivity;
         var _loc14_:b2Vec2 = param1.position;
         var _loc15_:b2Vec2 = param1.normal;
         if(_loc6_.burning || _loc7_.burning)
         {
            _loc5_.WakeUp();
            _loc4_.WakeUp();
         }
         if(World.toggleStabi == 1 && _loc6_.id != _loc7_.id && Math.abs(_loc15_.x) < 0.5)
         {
            if(Boolean(_loc6_.alive) || Boolean(_loc6_.armour) || _loc6_.animated)
            {
               if(param1.shape2.GetFriction() < 0.1)
               {
                  return;
               }
               if(!_loc5_.IsStatic() && _loc5_.GetLinearVelocity().Length() > 0.1)
               {
                  return;
               }
               if(_loc4_.GetLinearVelocity().Length() > 10)
               {
                  return;
               }
               if(!_loc6_.antigrav && _loc4_.GetPosition().y > param1.position.y || _loc6_.antigrav && _loc4_.GetPosition().y < param1.position.y)
               {
                  return;
               }
               _loc16_ = false;
               if(Boolean(!_loc6_.animated) && Boolean(_loc6_.trigger) && _loc6_.trigger is Concussion)
               {
                  _loc16_ = true;
               }
               _loc17_ = BoxUtils.selectCompound(_loc4_);
               _loc18_ = false;
               _loc19_ = 0;
               _loc20_ = 0;
               _loc22_ = false;
               for each(_loc24_ in _loc17_)
               {
                  if(_loc24_ == _loc5_)
                  {
                     return;
                  }
                  _loc23_ = userData(_loc24_.GetUserData());
                  _loc19_ += _loc23_.health;
                  if(_loc23_.animated)
                  {
                     _loc20_ += 1000;
                  }
                  else if(_loc23_.parentmaxhealth)
                  {
                     _loc20_ += _loc23_.parentmaxhealth;
                  }
                  else
                  {
                     _loc20_ += _loc23_.maxhealth;
                  }
                  if(_loc23_.animated)
                  {
                     _loc18_ = true;
                     break;
                  }
                  if(_loc23_.name == "doll_head")
                  {
                     _loc18_ = true;
                     _loc21_ = _loc24_;
                     if(Boolean(userData(_loc21_.GetUserData()).trigger) && userData(_loc21_.GetUserData()).trigger is Concussion)
                     {
                        _loc22_ = true;
                     }
                  }
               }
               if(_loc18_ && (!_loc29_ || _loc29_ && _loc17_.length > 4))
               {
                  for each(_loc24_ in _loc17_)
                  {
                     _loc23_ = userData(_loc24_.GetUserData());
                     _loc23_.stabilise = true;
                     _loc25_ = 1 * _loc23_.multiStanding;
                     if(!_loc23_.animated)
                     {
                        if(_loc20_ != 0)
                        {
                           _loc25_ *= _loc19_ / _loc20_;
                        }
                        if(_loc23_.maxhealth != 0)
                        {
                           _loc25_ *= _loc23_.health / _loc23_.maxhealth;
                        }
                        if(Boolean(_loc21_) && _loc21_.GetUserData().maxhealth != 0)
                        {
                           _loc25_ *= _loc21_.GetUserData().health / _loc21_.GetUserData().maxhealth;
                        }
                        if(_loc22_)
                        {
                           _loc25_ *= 0.25;
                        }
                     }
                     if(_loc24_ == _loc4_)
                     {
                        _loc27_ = _loc24_.GetLinearVelocity().Copy();
                        _loc27_.Multiply(1 - 0.2 * _loc25_);
                        _loc24_.SetLinearVelocity(_loc27_);
                     }
                     else if(_loc23_.name != "mjolnir")
                     {
                        if(_loc23_.name != "parachute")
                        {
                           if(_loc23_.name != "dragonstooth")
                           {
                              if(!(_loc7_.sensor || _loc3_.sensor))
                              {
                                 if(!_loc6_.animated || Boolean(_loc21_) && Boolean(!userData(_loc21_.GetUserData()).animated))
                                 {
                                    if(_loc23_.temperature < 0 && !_loc23_.resistFreeze)
                                    {
                                       continue;
                                    }
                                    if(_loc23_.trigger is Concussion || _loc23_.trigger is Electrified)
                                    {
                                       continue;
                                    }
                                 }
                                 if(!((_loc8_ == "doll_foot" || _loc8_ == "doll_leg" || _loc8_ == "doll_body") && (_loc23_.name == "doll_hand" || _loc23_.name == "doll_arm")))
                                 {
                                    if(!((_loc8_ == "doll_hand" || _loc8_ == "doll_arm" || _loc8_ == "doll_body") && (_loc23_.name == "doll_foot" || _loc23_.name == "doll_leg")))
                                    {
                                       _loc26_ = new b2Vec2(0,0);
                                       _loc26_.y = Tweak.standForce * _loc24_.GetMass();
                                       _loc27_ = _loc24_.GetLinearVelocity().Copy();
                                       _loc27_.Multiply(1 - 0.05 * _loc25_);
                                       if(_loc23_.name == _loc8_ && _loc8_ != "doll_head")
                                       {
                                          _loc27_ = _loc4_.GetLinearVelocity().Copy();
                                          _loc27_.y += 5 * (_loc23_.antigrav ? -1 : 1) * _loc25_;
                                       }
                                       else if(!_loc23_.alive)
                                       {
                                          _loc26_.y = Vars.gravity * _loc24_.GetMass() * -(1 / 0.95);
                                          if(_loc24_.GetLinearVelocity().Length() < 2)
                                          {
                                             _loc27_.x = 0;
                                             _loc27_.y = 0;
                                          }
                                       }
                                       if(GameState.environment is OpenWorld)
                                       {
                                          _loc27_.x = _loc24_.GetLinearVelocity().x;
                                       }
                                       _loc28_ = _loc24_.GetWorldCenter().Copy();
                                       if(_loc24_ == _loc4_)
                                       {
                                          _loc28_ = _loc24_.GetLocalPoint(_loc14_);
                                       }
                                       _loc26_.y *= _loc23_.antigrav ? -1 : 1;
                                       if(_loc16_)
                                       {
                                          _loc26_.Multiply(Math.random());
                                       }
                                       _loc26_.y *= _loc25_;
                                       _loc24_.SetLinearVelocity(_loc27_);
                                       _loc24_.ApplyForce(_loc26_,_loc28_);
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            if(Boolean(_loc7_.alive) || Boolean(_loc7_.armour) || _loc7_.animated)
            {
               if(param1.shape1.GetFriction() < 0.1)
               {
                  return;
               }
               if(!_loc4_.IsStatic() && _loc4_.GetLinearVelocity().Length() > 0.1)
               {
                  return;
               }
               if(_loc5_.GetLinearVelocity().Length() > 10)
               {
                  return;
               }
               if(!_loc7_.antigrav && _loc5_.GetPosition().y > param1.position.y || _loc7_.antigrav && _loc5_.GetPosition().y < param1.position.y)
               {
                  return;
               }
               _loc16_ = false;
               if(Boolean(!_loc7_.animated) && Boolean(_loc7_.trigger) && _loc7_.trigger is Concussion)
               {
                  _loc16_ = true;
               }
               _loc17_ = BoxUtils.selectCompound(_loc5_);
               _loc18_ = false;
               _loc29_ = true;
               _loc19_ = 0;
               _loc20_ = 0;
               for each(_loc24_ in _loc17_)
               {
                  if(_loc24_ == _loc4_)
                  {
                     return;
                  }
                  _loc23_ = userData(_loc24_.GetUserData());
                  _loc19_ += _loc23_.health;
                  if(_loc23_.animated)
                  {
                     _loc20_ += 1000;
                  }
                  else if(_loc23_.parentmaxhealth)
                  {
                     _loc20_ += _loc23_.parentmaxhealth;
                  }
                  else
                  {
                     _loc20_ += _loc23_.maxhealth;
                  }
                  if(_loc23_.animated)
                  {
                     _loc18_ = true;
                     _loc29_ = false;
                     break;
                  }
                  if(_loc23_.name == "doll_head")
                  {
                     _loc18_ = true;
                     _loc21_ = _loc24_;
                  }
               }
               if(_loc18_ && (!_loc29_ || _loc29_ && _loc17_.length > 4))
               {
                  for each(_loc24_ in _loc17_)
                  {
                     _loc23_ = userData(_loc24_.GetUserData());
                     _loc23_.stabilise = true;
                     _loc25_ = 1 * _loc23_.multiStanding;
                     if(!_loc23_.animated)
                     {
                        if(_loc20_ != 0)
                        {
                           _loc25_ *= _loc19_ / _loc20_;
                        }
                        if(_loc23_.maxhealth != 0)
                        {
                           _loc25_ *= _loc23_.health / _loc23_.maxhealth;
                        }
                        if(Boolean(_loc21_) && _loc21_.GetUserData().maxhealth != 0)
                        {
                           _loc25_ *= _loc21_.GetUserData().health / _loc21_.GetUserData().maxhealth;
                        }
                        if(_loc22_)
                        {
                           _loc25_ *= 0.25;
                        }
                     }
                     if(_loc24_ == _loc5_)
                     {
                        _loc27_ = _loc24_.GetLinearVelocity().Copy();
                        _loc27_.Multiply(1 - 0.2 * _loc25_);
                        _loc24_.SetLinearVelocity(_loc27_);
                     }
                     else if(_loc23_.name != "mjolnir")
                     {
                        if(_loc23_.name != "parachute")
                        {
                           if(_loc23_.name != "dragonstooth")
                           {
                              if(!(_loc6_.sensor || _loc2_.sensor))
                              {
                                 if(!_loc7_.animated || Boolean(_loc21_) && Boolean(!userData(_loc21_.GetUserData()).animated))
                                 {
                                    if(_loc23_.temperature < 0 && !_loc23_.resistFreeze)
                                    {
                                       continue;
                                    }
                                    if(_loc23_.trigger is Concussion || _loc23_.trigger is Electrified)
                                    {
                                       continue;
                                    }
                                 }
                                 if(!((_loc9_ == "doll_foot" || _loc9_ == "doll_leg" || _loc9_ == "doll_body") && (_loc23_.name == "doll_hand" || _loc23_.name == "doll_arm")))
                                 {
                                    if(!((_loc9_ == "doll_hand" || _loc9_ == "doll_arm" || _loc9_ == "doll_body") && (_loc23_.name == "doll_foot" || _loc23_.name == "doll_leg")))
                                    {
                                       _loc23_.stabilise = true;
                                       _loc26_ = new b2Vec2(0,0);
                                       _loc26_.y = Tweak.standForce * _loc24_.GetMass();
                                       _loc27_ = _loc24_.GetLinearVelocity().Copy();
                                       _loc27_.Multiply(1 - 0.05 * _loc25_);
                                       if(_loc23_.name == _loc9_ && _loc9_ != "doll_head")
                                       {
                                          _loc27_ = _loc4_.GetLinearVelocity().Copy();
                                          _loc27_.y += 5 * (_loc23_.antigrav ? -1 : 1) * _loc25_;
                                       }
                                       else if(!_loc23_.alive)
                                       {
                                          _loc26_.y = Vars.gravity * _loc24_.GetMass() * -(1 / 0.95) * _loc25_;
                                          if(_loc24_.GetLinearVelocity().Length() < 2)
                                          {
                                             _loc27_.x = 0;
                                             _loc27_.y = 0;
                                          }
                                       }
                                       if(GameState.environment is OpenWorld)
                                       {
                                          _loc27_.x = _loc24_.GetLinearVelocity().x;
                                       }
                                       _loc28_ = _loc24_.GetWorldCenter().Copy();
                                       if(_loc24_ == _loc5_)
                                       {
                                          _loc28_ = _loc24_.GetLocalPoint(_loc14_);
                                       }
                                       _loc26_.y *= _loc23_.antigrav ? -1 : 1;
                                       if(_loc16_)
                                       {
                                          _loc26_.Multiply(Math.random());
                                       }
                                       _loc26_.y *= _loc25_;
                                       _loc24_.SetLinearVelocity(_loc27_);
                                       _loc24_.ApplyForce(_loc26_,_loc28_);
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         if(_loc6_.concussing)
         {
            Body.Concuss(_loc5_,120);
         }
         if(_loc7_.concussing)
         {
            Body.Concuss(_loc4_,120);
         }
         if(_loc8_ != "wall" && _loc9_ != "wall")
         {
            if(_loc8_ == "button" && _loc10_ == "800101")
            {
               _loc6_.triggered = true;
               _loc6_.triggerDuration = _loc6_.originalTriggerDuration;
               _loc5_.WakeUp();
               return;
            }
            if(_loc9_ == "button" && _loc11_ == "800101")
            {
               _loc7_.triggered = true;
               _loc7_.triggerDuration = _loc7_.originalTriggerDuration;
               _loc4_.WakeUp();
               return;
            }
            if(_loc8_ == "randombutton" && _loc10_ == "784927")
            {
               _loc6_.triggered = true;
               _loc6_.triggerDuration = _loc6_.originalTriggerDuration;
               _loc5_.WakeUp();
               return;
            }
            if(_loc9_ == "randombutton" && _loc11_ == "784927")
            {
               _loc7_.triggered = true;
               _loc7_.triggerDuration = _loc7_.originalTriggerDuration;
               _loc4_.WakeUp();
               return;
            }
            if(Boolean(_loc6_.triggered && _loc6_.trigger) && Boolean(_loc6_.trigger is ConveyorBelt) && _loc10_ == "272727")
            {
               ConveyorBelt(_loc6_.trigger).Add(_loc5_);
               _loc6_.triggerDuration = 10;
               _loc5_.WakeUp();
               return;
            }
            if(_loc7_.triggered && _loc7_.trigger is ConveyorBelt && _loc11_ == "272727")
            {
               ConveyorBelt(_loc7_.trigger).Add(_loc4_);
               _loc7_.triggerDuration = 10;
               _loc4_.WakeUp();
               return;
            }
            if(Boolean(_loc6_.triggered && _loc6_.trigger) && Boolean(_loc6_.trigger is ConveyorBelt) && _loc10_ == "505050")
            {
               ConveyorBelt(_loc6_.trigger).Add(_loc5_);
               _loc6_.triggerDuration = 10;
               _loc5_.WakeUp();
               return;
            }
            if(_loc7_.triggered && _loc7_.trigger is ConveyorBelt && _loc11_ == "505050")
            {
               ConveyorBelt(_loc7_.trigger).Add(_loc4_);
               _loc7_.triggerDuration = 10;
               _loc4_.WakeUp();
               return;
            }
         }
         else if(_loc8_ == "triggertouch")
         {
            _loc7_.triggered = true;
         }
         else if(_loc9_ == "triggertouch")
         {
            _loc6_.triggered = true;
         }
         else if(_loc8_ == "untriggertouch")
         {
            _loc7_.triggered = false;
         }
         else if(_loc9_ == "untriggertouch")
         {
            _loc6_.triggered = false;
         }
         if((_loc8_ == "hoverboard" || _loc8_ == "scale") && !_loc5_.IsStatic())
         {
            _loc6_.triggerForce = 0;
            _loc30_ = BoxUtils.selectCompound(_loc5_);
            for each(_loc24_ in _loc30_)
            {
               _loc6_.triggerForce += _loc24_.GetMass();
            }
         }
         else if((_loc9_ == "hoverboard" || _loc9_ == "scale") && !_loc4_.IsStatic())
         {
            _loc7_.triggerForce = 0;
            _loc30_ = BoxUtils.selectCompound(_loc4_);
            for each(_loc24_ in _loc30_)
            {
               _loc7_.triggerForce += _loc24_.GetMass();
            }
         }
         if(_loc8_ == "syringe" && _loc7_.alive && _loc10_ == "a6a6a6")
         {
            if(!_loc6_.triggered && _loc7_.health > 0)
            {
               _loc6_.health += 1;
               this.addBlood(_loc5_,1,_loc14_);
            }
            if(_loc6_.connected.indexOf(_loc5_) == -1)
            {
               _loc6_.connected.push(_loc5_);
            }
         }
         else if(_loc9_ == "syringe" && _loc6_.alive && _loc11_ == "a6a6a6")
         {
            if(!_loc7_.triggered && _loc6_.health > 0)
            {
               _loc7_.health += 1;
               this.addBlood(_loc4_,1,_loc14_);
            }
            if(_loc7_.connected.indexOf(_loc4_) == -1)
            {
               _loc7_.connected.push(_loc4_);
            }
         }
         if(_loc8_ == "pulverizer" && _loc2_.sticky)
         {
            _loc6_.triggered = true;
         }
         else if(_loc9_ == "pulverizer" && _loc3_.sticky)
         {
            _loc7_.triggered = true;
         }
         if(_loc8_ == "mist" && (_loc10_ == "547e73" || _loc10_ == "45675e"))
         {
            if(_loc7_.hasBeenCut || _loc7_.health < 50)
            {
               _loc7_.trigger = new DisintegratePowder(50,0.5);
               _loc7_.triggered = true;
               _loc7_.triggerForce = 50;
            }
         }
         else if(_loc9_ == "mist" && (_loc11_ == "547e73" || _loc11_ == "45675e"))
         {
            if(_loc6_.hasBeenCut || _loc6_.health < 50)
            {
               _loc6_.trigger = new DisintegratePowder(50,0.5);
               _loc6_.triggered = true;
            }
         }
         if(_loc8_ != "wall" && _loc9_ != "wall")
         {
            if(_loc12_ > 0 && _loc13_ > 0)
            {
               _loc31_ = _loc6_.temperature;
               _loc32_ = _loc7_.temperature;
               _loc33_ = _loc31_ - _loc32_;
               if(Math.abs(_loc33_) > 3)
               {
                  _loc6_.temperature -= _loc33_ * _loc12_;
                  _loc7_.temperature += _loc33_ * _loc13_;
               }
            }
         }
         super.Persist(param1);
      }
      
      override public function Remove(param1:b2ContactPoint) : void
      {
         var _loc2_:b2Body = param1.shape1.GetBody();
         var _loc3_:b2Body = param1.shape2.GetBody();
         var _loc4_:userData = userData(_loc2_.GetUserData());
         var _loc5_:userData = userData(_loc3_.GetUserData());
         var _loc6_:ShapeUserData = ShapeUserData(param1.shape1.GetUserData());
         var _loc7_:ShapeUserData = ShapeUserData(param1.shape2.GetUserData());
         var _loc8_:String = _loc4_.name;
         var _loc9_:String = _loc5_.name;
         if(_loc8_ == "syringe")
         {
            _loc4_.connected = new Vector.<b2Body>();
         }
         if(_loc9_ == "syringe")
         {
            _loc5_.connected = new Vector.<b2Body>();
         }
         if(_loc4_.trigger)
         {
            _loc4_.trigger.OnCollisionEnd(_loc3_,param1);
         }
         if(_loc5_.trigger)
         {
            _loc5_.trigger.OnCollisionEnd(_loc2_,param1);
         }
      }
   }
}

