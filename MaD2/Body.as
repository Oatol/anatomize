package
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2PrismaticJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Gun.Firearm;
   import caurina.transitions.Tweener;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import triggers.Balloon;
   import triggers.Boomerang;
   import triggers.ClusterBall;
   import triggers.Concussion;
   import triggers.Disintegrate;
   import triggers.DisintegrateIntoItems;
   import triggers.DisintegrateOnNextHit;
   import triggers.DisintegratePowder;
   import triggers.Drone;
   import triggers.DroneBee;
   import triggers.DroneBuild;
   import triggers.DroneBullet;
   import triggers.DroneClean;
   import triggers.DroneExplosive;
   import triggers.DroneFlame;
   import triggers.DroneHammer;
   import triggers.DroneLaser;
   import triggers.DronePaint;
   import triggers.DronePin;
   import triggers.DronePotato;
   import triggers.DroneRocket;
   import triggers.DroneShield;
   import triggers.DroneToxic;
   import triggers.Egg;
   import triggers.Electrified;
   import triggers.Equip;
   import triggers.Frisbee;
   import triggers.GibChunk;
   import triggers.Hyped;
   import triggers.IdentityDisc;
   import triggers.Infested;
   import triggers.Invincible;
   import triggers.Lavad;
   import triggers.NoBall;
   import triggers.Poisoned;
   import triggers.Sanded;
   import triggers.Smiter;
   import triggers.Snare;
   import triggers.SportsBall;
   import triggers.Stasis;
   import triggers.TempProjectile;
   import triggers.ToxinMelt;
   import triggers.Transmute;
   import triggers.Wander;
   
   public class Body
   {
      
      public function Body()
      {
         super();
      }
      
      public static function Damage(param1:b2Body, param2:Number, param3:b2Vec2 = null, param4:b2Vec2 = null, param5:b2Vec2 = null, param6:Boolean = true, param7:Boolean = true) : void
      {
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:uint = 0;
         var _loc15_:b2Vec2 = null;
         var _loc16_:int = 0;
         var _loc17_:Array = null;
         var _loc18_:b2Body = null;
         param1.WakeUp();
         if(param2 == 0)
         {
            return;
         }
         var _loc8_:userData = userData(param1.GetUserData());
         if(!_loc8_.alive && !_loc8_.armour)
         {
            return;
         }
         if(_loc8_.dead)
         {
            return;
         }
         if(_loc8_.name == "deleted")
         {
            return;
         }
         param2 *= _loc8_.multiGlobalDamage;
         if(World.toggleRagdollBreak == 1 && _loc8_.health <= 0 && param2 > 2 && _loc8_.alive && !_loc8_.unbreakable && !_loc8_.resistAliveBreak)
         {
            _loc8_.health = 0;
            if(World.toggleBodypartGibs == 1)
            {
               if(param6 && param2 > 5)
               {
                  if(Main.instance.brittleArray.indexOf(param1) == -1)
                  {
                     _loc10_ = "blood";
                     if(_loc8_.trigger is Poisoned)
                     {
                        _loc10_ = "poison";
                     }
                     if(_loc8_.temperature < -10)
                     {
                        _loc10_ = "crystal";
                     }
                     if(_loc8_.burning)
                     {
                        _loc10_ = "smoke";
                     }
                     if(World.toggleGibsGib == 1 && param1.GetMass() < 0.4)
                     {
                        _loc11_ = 10 + param2;
                        if(_loc11_ > 50)
                        {
                           _loc11_ = 50;
                        }
                        Gib(param1,0.1,0.4 + Math.random() * 0.3,0.2);
                        Disintegrate(param1,_loc10_,_loc11_,2,2);
                     }
                     else
                     {
                        Main.instance.brittleArray.push(param1);
                     }
                     return;
                  }
               }
            }
            if(World.toggleGibsGib == 1)
            {
               if(param2 > 5 || param1.GetMass() < 1 && param2 > 2)
               {
                  _loc12_ = "blood";
                  if(_loc8_.trigger is Poisoned)
                  {
                     _loc12_ = "poison";
                  }
                  if(_loc8_.temperature < -10)
                  {
                     _loc12_ = "crystal";
                  }
                  _loc8_.trigger = new triggers.Disintegrate(_loc12_,20 + param2,2);
                  _loc8_.triggered = true;
                  Gib(param1,1,Math.max(Math.min(0.6,Math.random() * param1.GetMass()),0.4),0.2);
               }
            }
            return;
         }
         _loc8_.health -= param2;
         if(param2 > 11 && World.toggleSlomo == 1 && !GameState.slomo)
         {
            TimeLord.slowTo(param2);
         }
         if(World.toggleGore == 0)
         {
            return;
         }
         if(_loc8_.temperature <= 0)
         {
            return;
         }
         if(!param3)
         {
            param3 = param1.GetWorldCenter();
         }
         var _loc9_:b2Vec2 = param1.GetWorldPoint(param1.GetLocalPoint(param3));
         if(!param4)
         {
            param4 = new b2Vec2();
         }
         if(!param5)
         {
            param5 = new b2Vec2(1,1);
         }
         if(param6)
         {
            if(param2 < 1 && param2 > 0)
            {
               param2 = 1;
            }
            _loc12_ = "blood";
            if(_loc8_.originalTrigger is Balloon)
            {
               _loc12_ = "air";
               param4.x *= -1;
               param4.y *= -1;
            }
            else if(_loc8_.armour)
            {
               _loc12_ = "sparkle";
            }
            _loc13_ = param2;
            if(_loc13_ != 1)
            {
               _loc13_ *= 0.1;
            }
            if(_loc13_ > 50)
            {
               _loc13_ = 50;
            }
            if(_loc13_ <= 1)
            {
               _loc13_ = 1;
            }
            if(_loc8_.bloodColour)
            {
               _loc14_ = Tweak.bloodColour;
               Tweak.bloodColour = _loc8_.bloodColour;
            }
            _loc15_ = new b2Vec2();
            _loc16_ = 0;
            while(_loc16_ < _loc13_)
            {
               _loc15_.x = _loc9_.x * Physics.scale + (4 * Math.random() - 2);
               _loc15_.y = _loc9_.y * Physics.scale + (4 * Math.random() - 2);
               GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,_loc12_,param4.x,param4.y,param5.x,param5.y);
               _loc16_++;
            }
            if(_loc14_)
            {
               Tweak.bloodColour = _loc14_;
            }
         }
         if(param7)
         {
            if(param2 > 200 * _loc8_.multiConcussion)
            {
               if(_loc8_.name == "doll_head")
               {
                  _loc17_ = BoxUtils.selectCompound(param1,false);
                  for each(_loc18_ in _loc17_)
                  {
                     Concuss(_loc18_,param2 * 0.5);
                  }
               }
               else
               {
                  Concuss(param1,param2 * 0.5);
               }
            }
         }
         if(_loc8_.unequipDead)
         {
            if(_loc8_.health <= _loc8_.maxhealth * 0.1)
            {
               RemoveEquipJointsNextFrame(param1);
            }
         }
      }
      
      public static function Move(param1:Vector.<b2Body>, param2:Number, param3:Number) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         for each(_loc4_ in param1)
         {
            _loc5_ = _loc4_.GetPosition().Copy();
            _loc5_.x += param2 / Physics.scale;
            _loc5_.y += param3 / Physics.scale;
            _loc4_.SetXForm(_loc5_,_loc4_.GetAngle());
         }
      }
      
      public static function Concuss(param1:b2Body, param2:Number) : *
      {
         var _loc3_:userData = userData(param1.GetUserData());
         if(World.toggleDollSleep != 1)
         {
            return;
         }
         if(!_loc3_.alive)
         {
            return;
         }
         if(_loc3_.resistConcuss)
         {
            return;
         }
         if(_loc3_.trigger is Concussion)
         {
            Concussion(_loc3_.trigger).duration = Concussion(_loc3_.trigger).duration + param2;
         }
         else
         {
            _loc3_.stabilise = false;
            _loc3_.trigger = new Concussion(param2 * 8 + Math.random() * param2 * 4);
            _loc3_.triggered = true;
         }
         if(_loc3_.unequipConcuss)
         {
            RemoveEquipJointsNextFrame(param1);
         }
      }
      
      public static function GetOne(param1:Number, param2:Number, param3:Boolean = false, param4:Boolean = false) : b2Body
      {
         var _loc9_:Boolean = false;
         var _loc11_:b2Body = null;
         var _loc12_:userData = null;
         var _loc13_:int = 0;
         var _loc14_:b2Shape = null;
         var _loc15_:Boolean = false;
         var _loc5_:b2AABB = new b2AABB();
         _loc5_.lowerBound.Set(param1 - 0.001,param2 - 0.001);
         _loc5_.upperBound.Set(param1 + 0.001,param2 + 0.001);
         var _loc6_:int = 100;
         var _loc7_:Array = new Array();
         var _loc8_:int = Physics.world.Query(_loc5_,_loc7_,_loc6_);
         var _loc10_:int = 0;
         for(; _loc10_ < 2; _loc10_++)
         {
            if(!(_loc10_ == 0 && !GameState.prioritizeSelection))
            {
               if(!(_loc10_ == 0 && !param4))
               {
                  _loc13_ = 0;
                  while(_loc13_ < _loc8_)
                  {
                     _loc11_ = b2Body(_loc7_[_loc13_].GetBody());
                     _loc9_ = _loc11_.IsStatic();
                     if(!_loc9_ || _loc9_ && param3)
                     {
                        _loc12_ = userData(_loc11_.GetUserData());
                        if(_loc12_.name != "wall")
                        {
                           if(!(param4 && _loc12_.locked))
                           {
                              _loc14_ = _loc7_[_loc13_] as b2Shape;
                              _loc15_ = _loc14_.TestPoint(_loc11_.GetXForm(),new b2Vec2(param1,param2));
                              if(_loc15_)
                              {
                                 if(_loc10_ == 0)
                                 {
                                    if(Tool.isSelect)
                                    {
                                       if(Main.instance.selectedBodies.indexOf(_loc11_) != -1)
                                       {
                                          continue;
                                       }
                                    }
                                    else if(Main.instance.selectedBodies.indexOf(_loc11_) == -1)
                                    {
                                       continue;
                                    }
                                 }
                                 if(!(_loc9_ && GameState.environment.defaultBodies.indexOf(_loc11_) != -1))
                                 {
                                    if(_loc11_ != Main.instance.previousBody)
                                    {
                                       if(_loc11_ != Main.instance.jointBody)
                                       {
                                          return _loc11_;
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                     _loc13_++;
                  }
               }
            }
         }
         return null;
      }
      
      public static function GetMultiple(param1:b2Vec2, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : Array
      {
         var _loc11_:b2Body = null;
         var _loc12_:userData = null;
         var _loc7_:b2AABB = new b2AABB();
         _loc7_.lowerBound.Set(param1.x,param1.y);
         _loc7_.upperBound.Set(param1.x + param2,param1.y + param3);
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:int = Physics.world.Query(_loc7_,_loc8_,Tweak.maxSelectedBodies);
         var _loc13_:int = 0;
         for(; _loc13_ < _loc10_; _loc13_++)
         {
            _loc11_ = b2Shape(_loc8_[_loc13_]).GetBody();
            if(!(!param4 && _loc11_.IsStatic()))
            {
               if(!(param5 && !_loc11_.IsStatic()))
               {
                  if(_loc9_.indexOf(_loc11_) == -1)
                  {
                     _loc12_ = userData(_loc11_.GetUserData());
                     if(_loc12_)
                     {
                        if(_loc12_.name == "wall")
                        {
                           continue;
                        }
                        if(_loc12_.name == "blooddrop")
                        {
                           continue;
                        }
                        if(!Tool.isDetail && param6 && _loc12_.locked)
                        {
                           continue;
                        }
                     }
                     if(!(_loc11_.IsStatic() && GameState.environment.defaultBodies.indexOf(_loc11_) != -1))
                     {
                        _loc9_.push(_loc11_);
                     }
                  }
               }
            }
         }
         return _loc9_;
      }
      
      public static function GetAround(param1:b2Body, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = false) : Array
      {
         var _loc6_:b2Vec2 = param1.GetWorldCenter().Copy();
         param2 /= Physics.scale;
         param3 /= Physics.scale;
         var _loc7_:Array = GetMultiple(new b2Vec2(_loc6_.x - param2,_loc6_.y - param3),param2 * 2,param3 * 2,param4,param5);
         var _loc8_:int = _loc7_.indexOf(param1);
         if(_loc8_ != -1)
         {
            _loc7_.splice(_loc8_,1);
         }
         return _loc7_;
      }
      
      public static function RemoveJointsNextFrame(param1:b2Body) : void
      {
         var _loc2_:b2JointEdge = param1.GetJointList();
         while(_loc2_)
         {
            jointUserData(_loc2_.joint.GetUserData()).dead = true;
            _loc2_ = _loc2_.next;
         }
      }
      
      public static function RemoveEquipJointsNextFrame(param1:b2Body) : void
      {
         var _loc2_:b2JointEdge = param1.GetJointList();
         while(_loc2_)
         {
            if(jointUserData(_loc2_.joint.GetUserData()).name == "equip")
            {
               jointUserData(_loc2_.joint.GetUserData()).dead = true;
            }
            _loc2_ = _loc2_.next;
         }
      }
      
      public static function RemoveJoints(param1:b2Body) : void
      {
         var _loc4_:b2Joint = null;
         var _loc2_:Array = [];
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            if(jointUserData(_loc3_.joint.GetUserData()).name == "mouse")
            {
               Main.instance.m_mouseJoint = null;
            }
            _loc2_.push(_loc3_.joint);
            _loc3_ = _loc3_.next;
         }
         for each(_loc4_ in _loc2_)
         {
            Physics.world.DestroyJoint(_loc4_);
         }
      }
      
      public static function GetAroundPoint(param1:b2Vec2, param2:Number, param3:Number, param4:Boolean = false) : Array
      {
         var _loc5_:b2Vec2 = new b2Vec2(param1.x - param2,param1.y - param3);
         _loc5_.Multiply(1 / Physics.scale);
         param2 /= Physics.scale;
         param3 /= Physics.scale;
         return GetMultiple(_loc5_,param2 * 2,param3 * 2,param4);
      }
      
      public static function SelectArea(param1:b2Vec2, param2:b2Vec2, param3:Boolean = false, param4:Boolean = false) : Vector.<b2Body>
      {
         var _loc12_:b2Body = null;
         if(!param1 || !param2)
         {
            return new Vector.<b2Body>();
         }
         var _loc5_:Number = param1.x - param2.x;
         var _loc6_:Number = param1.y - param2.y;
         if(_loc5_ == 0 || _loc6_ == 0)
         {
            return new Vector.<b2Body>();
         }
         var _loc7_:b2Vec2 = new b2Vec2();
         if(_loc5_ > 0)
         {
            _loc7_.x = param2.x;
         }
         else
         {
            _loc7_.x = param1.x;
         }
         if(_loc6_ > 0)
         {
            _loc7_.y = param2.y;
         }
         else
         {
            _loc7_.y = param1.y;
         }
         var _loc8_:Number = _loc5_ > 0 ? _loc5_ : -_loc5_;
         var _loc9_:Number = _loc6_ > 0 ? _loc6_ : -_loc6_;
         var _loc10_:Array = Body.GetMultiple(_loc7_,_loc8_,_loc9_,param3,false,param4);
         var _loc11_:Vector.<b2Body> = new Vector.<b2Body>();
         for each(_loc12_ in _loc10_)
         {
            if(!(_loc12_.IsStatic() && GameState.environment.defaultBodies.indexOf(_loc12_) != -1))
            {
               _loc11_.push(_loc12_);
            }
         }
         return _loc11_;
      }
      
      public static function Flip(param1:b2Body) : b2Body
      {
         var _loc2_:userData = userData(param1.GetUserData());
         if(_loc2_.hasBeenCut)
         {
            return null;
         }
         GameState.flipping = true;
         Main.instance.flipped = !_loc2_.flipped;
         var _loc3_:Number = param1.GetAngle() * Vars.toDegrees;
         var _loc4_:b2Vec2 = param1.GetPosition();
         var _loc5_:String = _loc2_.name;
         var _loc6_:Number = Vars.objSize;
         var _loc7_:Boolean = !_loc2_.flipped;
         Vars.objSize = _loc2_.size;
         var _loc8_:BitmapData = BoxUtils.getEffectBMD(param1);
         var _loc9_:Vector.<Array> = GameState.objects.spawnSkin;
         if(_loc2_.vanilla)
         {
            Properties.forceObjVanilla = 1;
         }
         if(_loc2_.skin)
         {
            GameState.objects.spawnSkin = _loc2_.skin;
         }
         Main.instance.forceFlip = true;
         var _loc10_:b2Body = GameState.objects.spawnObject(_loc5_,_loc4_.x * Physics.scale,_loc4_.y * Physics.scale,_loc3_,_loc7_,true);
         Main.instance.forceFlip = false;
         if(_loc2_.skin)
         {
            GameState.objects.spawnSkin = _loc9_;
         }
         if(_loc2_.vanilla)
         {
            Properties.forceObjVanilla = 0;
         }
         var _loc11_:Vector.<b2Body> = _loc2_.connected;
         var _loc12_:userData = userData(_loc10_.GetUserData());
         if(!_loc12_)
         {
            throw new Error("UserData not set! (Did spawnObject return a body?)");
         }
         _loc12_.copyProperties(_loc2_,param1);
         _loc12_.flipped = !_loc12_.flipped;
         _loc2_.reconnect(_loc10_);
         _loc12_.ignored = _loc2_.ignored.slice();
         if(_loc8_)
         {
            BoxUtils.getEffectBM(_loc10_).bitmapData = GeneralUtils.flipBMD(_loc8_);
         }
         var _loc13_:Array = BoxUtils.bodyToVertices(_loc10_);
         _loc12_.hull = GameState.hullHandler.convexHull(_loc13_);
         if(Main.instance.detailBody == param1)
         {
            Main.instance.detailBody = _loc10_;
         }
         Destroy(param1,"flip");
         Vars.objSize = _loc6_;
         GameState.flipping = false;
         return _loc10_;
      }
      
      public static function Destroy(param1:b2Body, param2:String, param3:Boolean = false) : void
      {
         var bud:userData;
         var farr:Vector.<Firearm>;
         var findex:int;
         var j:int;
         var sindex:int;
         var joints:Array;
         var jointstest:Array;
         var i:int;
         var fx:BitmapData = null;
         var dind:int = 0;
         var jl:b2JointEdge = null;
         var an1:b2Vec2 = null;
         var an2:b2Vec2 = null;
         var jb1:b2Body = null;
         var jb2:b2Body = null;
         var jud1:userData = null;
         var jud2:userData = null;
         var blp:b2Vec2 = null;
         var b1x:* = undefined;
         var b1y:* = undefined;
         var b2x:* = undefined;
         var b2y:* = undefined;
         var jud:jointUserData = null;
         var jointName:String = null;
         var body1:b2Body = null;
         var body2:b2Body = null;
         var newName1:String = null;
         var newName2:String = null;
         var oldName1:String = null;
         var oldName2:String = null;
         var djd:b2DistanceJointDef = null;
         var redoneJoint:b2Joint = null;
         var bud1:userData = null;
         var bud2:userData = null;
         var oldUD:jointUserData = null;
         var body:b2Body = param1;
         var source:String = param2;
         var force:Boolean = param3;
         if(!body)
         {
            return;
         }
         if(body == Physics.world.GetGroundBody())
         {
            return;
         }
         bud = userData(body.GetUserData());
         if(!bud)
         {
            return;
         }
         if(Boolean(bud.trigger) || Boolean(bud.armour))
         {
            try
            {
               if(source != "reset")
               {
                  if(bud.trigger)
                  {
                     bud.trigger.OnDelete();
                  }
                  if(bud.armour)
                  {
                     bud.armour.OnDelete();
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         if(!force && Boolean(GameState.environment))
         {
            if(GameState.environment.public::wallBodies.indexOf(body) != -1)
            {
               fx = BoxUtils.getEffectBMD(body);
               if(fx)
               {
                  fx.fillRect(fx.rect,0);
               }
               return;
            }
         }
         if(Boolean(GameState.environment) && source != "environment change")
         {
            dind = GameState.environment.defaultBodies.indexOf(body);
            if(dind != -1)
            {
               GameState.environment.defaultBodies.splice(dind,1);
            }
         }
         if(Boolean(Main.instance.m_mouseJoint) && body == Main.instance.m_mouseJoint.GetBody2())
         {
            Physics.world.DestroyJoint(Main.instance.m_mouseJoint);
            Main.instance.m_mouseJoint = null;
         }
         farr = Main.instance.firearmArray;
         findex = -1;
         j = 0;
         while(j < farr.length)
         {
            if(farr[j].body == body)
            {
               findex = j;
               break;
            }
            j++;
         }
         if(findex != -1)
         {
            Main.instance.firearmArray.splice(findex,1);
         }
         sindex = Main.instance.selectedBodies.indexOf(body);
         if(sindex != -1)
         {
            Main.instance.selectedBodies.splice(sindex,1);
         }
         if(Main.instance.detailBody == body)
         {
            GameState.ui.menuDetails.forceClosed();
            Main.instance.detailBody = null;
            if(GameState.menuHandler.getMenu("Properties").title == "Detail Properties")
            {
               GameState.menuHandler.getMenu("Properties").close();
            }
         }
         if(bud)
         {
            bud.disconnectAll();
         }
         if(Boolean(bud) && bud.ignored.length > 0)
         {
            bud.unignoreAll();
         }
         joints = new Array();
         jointstest = new Array();
         if(GameState.cutting || GameState.resizing || GameState.flipping)
         {
            jl = body.GetJointList();
            while(jl)
            {
               an1 = jl.joint.GetAnchor1().Copy();
               an2 = jl.joint.GetAnchor2().Copy();
               jb1 = jl.joint.GetBody1();
               jb2 = jl.joint.GetBody2();
               jud1 = userData(jb1.GetUserData());
               jud2 = userData(jb2.GetUserData());
               if(jud1.armour)
               {
                  jud1.armour.OnDelete();
               }
               if(jud2.armour)
               {
                  jud2.armour.OnDelete();
               }
               if(jointUserData(jl.joint.GetUserData()).name == "weldjoint")
               {
                  an1 = jb1.GetPosition().Copy();
                  an2 = jb2.GetPosition().Copy();
               }
               if(jud1.health > 0)
               {
                  if(jud2.health > 0)
                  {
                     joints.push([jointUserData(jl.joint.GetUserData()),an1,an2,jb1,jb2]);
                     jointstest.push(jl.joint);
                  }
               }
               jl = jl.next;
            }
         }
         else if(Boolean(bud) && bud.alive)
         {
            if(source != "tool_delete")
            {
               jl = body.GetJointList();
               while(jl)
               {
                  if(jointUserData(jl.joint.GetUserData()).name == "rag")
                  {
                     if(jl.joint.GetBody1() == body)
                     {
                        blp = jl.joint.GetBody2().GetLocalPoint(jl.joint.GetAnchor2().Copy());
                        userData(jl.joint.GetBody2().GetUserData()).bleeding.push([blp,blp,jl.joint.GetAnchor2().Copy().Subtract(jl.joint.GetAnchor1().Copy()),100]);
                     }
                     else
                     {
                        blp = jl.joint.GetBody1().GetLocalPoint(jl.joint.GetAnchor1().Copy());
                        userData(jl.joint.GetBody1().GetUserData()).bleeding.push([blp,blp,jl.joint.GetAnchor1().Copy().Subtract(jl.joint.GetAnchor2().Copy()),100]);
                     }
                  }
                  jl = jl.next;
               }
            }
         }
         if(body == GameState.followBody)
         {
            GameState.followBody = null;
         }
         Main.instance.CameraUncull();
         if(Boolean(bud) && Boolean(bud.graphic) && Boolean(bud.graphic.parent))
         {
            if(bud.graphic.parent.contains(bud.graphic))
            {
               bud.graphic.parent.removeChild(bud.graphic);
            }
         }
         Physics.world.DestroyBody(body);
         bud.name = "deleted";
         bud.dead = true;
         Main.instance.CameraCull();
         i = 0;
         for(; i < joints.length; i++)
         {
            b1x = b2Vec2(joints[i][1]).x;
            b1y = b2Vec2(joints[i][1]).y;
            b2x = b2Vec2(joints[i][2]).x;
            b2y = b2Vec2(joints[i][2]).y;
            jud = jointUserData(joints[i][0]);
            jointName = jud.name;
            body1 = Body.GetOne(b1x,b1y,true);
            body2 = Body.GetOne(b2x,b2y,true);
            if(body1 == body2)
            {
               Main.instance.previousBody = body1;
               body2 = Body.GetOne(b2x,b2y,true);
            }
            newName1 = "nope";
            newName2 = "nope";
            if(body1)
            {
               newName1 = userData(body1.GetUserData()).name;
            }
            if(body2)
            {
               newName2 = userData(body2.GetUserData()).name;
            }
            oldName1 = userData(b2Body(joints[i][3]).GetUserData()).name;
            oldName2 = userData(b2Body(joints[i][4]).GetUserData()).name;
            if(!(newName1 == "nope" && newName2 == "nope"))
            {
               if(!(newName1 == "deleted" || newName2 == "deleted"))
               {
                  if(!(jointName == "weldjoint" && (newName1 == "nope" || newName2 == "nope")))
                  {
                     if(!(jointName == "weldjoint" && (newName1 == "shrapnel" || newName2 == "shrapnel")))
                     {
                        if(oldName1 == "deleted" && oldName2 != "ground" && oldName2 != newName2)
                        {
                           if(newName2 != "shrapnel")
                           {
                              continue;
                           }
                        }
                        if(oldName2 == "deleted" && oldName1 != "ground" && oldName1 != newName1)
                        {
                           if(newName1 != "shrapnel")
                           {
                              continue;
                           }
                        }
                        if(!(!body1 && !body2))
                        {
                           if(!body1 || !body2)
                           {
                              if(!body1)
                              {
                                 body1 = Physics.world.GetGroundBody();
                              }
                              else if(!body2)
                              {
                                 body2 = Physics.world.GetGroundBody();
                              }
                           }
                           if(body1 == body2 && jud.name != "weldjoint")
                           {
                              body2 = Physics.world.GetGroundBody();
                           }
                           if(jointName == "ropejoint")
                           {
                              redoneJoint = Joints.Distance("ropejoint",body1,body2,new b2Vec2(b1x,b1y),new b2Vec2(b2x,b2y),b2DistanceJoint(jointstest[i]).m_frequencyHz,b2DistanceJoint(jointstest[i]).m_dampingRatio,true);
                           }
                           else if(jointName == "objjoint")
                           {
                              redoneJoint = Joints.Distance("objjoint",body1,body2,new b2Vec2(b1x,b1y),new b2Vec2(b2x,b2y),0,0,true);
                           }
                           else if(jointName == "weldjoint")
                           {
                              redoneJoint = Joints.Weld("weldjoint",body1,body2,new b2Vec2(b1x,b1y));
                           }
                           else if(jointName == "bgjoint")
                           {
                              if(body1 != Physics.world.GetGroundBody())
                              {
                                 redoneJoint = Joints.Pin("bgjoint",body1,new b2Vec2(b1x,b1y),Tweak.jointForce);
                              }
                              else if(body2 != Physics.world.GetGroundBody())
                              {
                                 redoneJoint = Joints.Pin("bgjoint",body2,new b2Vec2(b2x,b2y),Tweak.jointForce);
                              }
                           }
                           else if(jointName == "equip")
                           {
                              bud1 = userData(body1.GetUserData());
                              bud2 = userData(body2.GetUserData());
                              if(bud1.name == "doll_hand" || bud1.name == "doll_head")
                              {
                                 bud1.trigger = new Equip();
                                 bud1.triggered = true;
                              }
                              if(bud2.name == "doll_hand" || bud2.name == "doll_head")
                              {
                                 bud2.trigger = new Equip();
                                 bud2.triggered = true;
                              }
                           }
                           if(redoneJoint)
                           {
                              jud = redoneJoint.GetUserData();
                              oldUD = jointUserData(b2Joint(jointstest[i]).GetUserData());
                              jud.lineVisible = oldUD.lineVisible;
                              jud.lineWidth = oldUD.lineWidth;
                              jud.lineColour = oldUD.lineColour;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public static function Powder(param1:b2Body, param2:int = 100, param3:Number = 0.1, param4:Boolean = true) : *
      {
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc5_:userData = userData(param1.GetUserData());
         if(!_loc5_)
         {
            return;
         }
         if(_loc5_.resistDisintegrating)
         {
            return;
         }
         _loc5_.trigger = new DisintegratePowder(param2,param3,param4);
         _loc5_.triggered = true;
      }
      
      public static function Transmuted(param1:b2Body) : *
      {
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         _loc2_.trigger = new Transmute();
         _loc2_.triggered = true;
      }
      
      public static function Disintegrate(param1:b2Body, param2:String, param3:int = 100, param4:Number = 0, param5:Number = 0) : *
      {
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         if(param1.IsStatic())
         {
            return;
         }
         var _loc6_:userData = userData(param1.GetUserData());
         if(!_loc6_)
         {
            return;
         }
         if(_loc6_.resistDisintegrating)
         {
            return;
         }
         var _loc7_:Array = [];
         if(Boolean(_loc6_.width) && Boolean(_loc6_.height))
         {
            _loc7_.push(_loc6_.width);
            _loc7_.push(_loc6_.height);
         }
         else
         {
            BoxUtils.bodyDimensions(param1);
         }
         var _loc8_:b2Vec2 = param1.GetPosition();
         var _loc9_:Number = param1.GetAngle();
         var _loc10_:int = _loc7_[0] * _loc7_[1];
         if(_loc10_ > param3)
         {
            _loc10_ = param3;
         }
         var _loc11_:String = _loc6_.name;
         while(_loc11_.length < 6)
         {
            _loc11_ = "0" + _loc11_;
         }
         var _loc12_:uint = Tweak.bloodColour;
         if(param2 == "blood")
         {
            Tweak.bloodColour = _loc6_.bloodColour;
         }
         var _loc13_:Number = param1.GetLinearVelocity().x;
         var _loc14_:Number = param1.GetLinearVelocity().y;
         var _loc15_:int = 0;
         while(_loc15_ < _loc10_)
         {
            _loc16_ = Math.random() * _loc7_[0] - _loc7_[0] * 0.5;
            _loc17_ = Math.random() * _loc7_[1] - _loc7_[1] * 0.5;
            _loc18_ = _loc8_.x * Physics.scale + (_loc16_ * Math.cos(_loc9_) - _loc17_ * Math.sin(_loc9_));
            _loc19_ = _loc8_.y * Physics.scale + (_loc16_ * Math.sin(_loc9_) + _loc17_ * Math.cos(_loc9_));
            if(param2 == "inherit")
            {
               GameState.particles.addSimpleParticles(_loc18_,_loc19_,1,uint("0xFF" + _loc11_),_loc13_ * 0.15,_loc14_ * 0.15,Math.random() * param4,Math.random() * param5);
            }
            else
            {
               GameState.particles.addParticles(_loc18_,_loc19_,1,param2,_loc13_ * 0.15,_loc14_ * 0.15,Math.random() * param4,Math.random() * param5);
            }
            _loc15_++;
         }
         Tweak.bloodColour = _loc12_;
         _loc6_.dead = true;
      }
      
      public static function Decorate(param1:b2Body) : void
      {
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc2_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         var _loc4_:b2Vec2 = BoxUtils.randomPointOnBody(param1);
         _loc4_.Multiply(Physics.scale);
         _loc4_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
         _loc4_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
         var _loc5_:Number = Math.random();
         var _loc6_:b2Vec2 = new b2Vec2();
         if(Boolean(_loc3_.width) && Boolean(_loc3_.height))
         {
            _loc6_ = new b2Vec2(Math.random() * _loc3_.width,Math.random() * _loc3_.height);
         }
         else
         {
            _loc6_ = new b2Vec2(_loc4_.x + Math.random() * 50 - 25,_loc4_.y + Math.random() * 50 - 25);
         }
         if(_loc5_ < 0.1)
         {
            _loc7_ = _loc4_;
            _loc8_ = _loc6_;
            _loc9_ = (_loc7_.y - _loc8_.y) / (_loc7_.x - _loc8_.x);
            _loc10_ = 0;
            while(_loc10_ < 50)
            {
               _loc11_ = _loc7_.x + _loc10_ / 50 * (_loc8_.x - _loc7_.x);
               _loc12_ = _loc7_.y + _loc9_ * (_loc11_ - _loc7_.x);
               _loc2_.copyPixels(R.getSprite("p_sparkly"),new Rectangle(0,0,8,8),new Point(_loc11_,_loc12_),null,null,true);
               _loc10_++;
            }
         }
         else if(_loc5_ > 0.1 && _loc5_ < 0.55)
         {
            _loc2_.copyPixels(R.getSprite("p_ornament1"),new Rectangle(0,0,8,8),new Point(_loc6_.x,_loc6_.y),null,null,true);
         }
         else
         {
            _loc2_.copyPixels(R.getSprite("p_ornament2"),new Rectangle(0,0,8,8),new Point(_loc6_.x,_loc6_.y),null,null,true);
         }
      }
      
      public static function Decompose(param1:b2Body) : Vector.<b2Body>
      {
         var _loc6_:b2PolygonShape = null;
         var _loc7_:Array = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2BodyDef = null;
         var _loc10_:String = null;
         var _loc11_:b2Body = null;
         var _loc12_:userData = null;
         var _loc13_:b2PolygonDef = null;
         var _loc2_:Vector.<b2Body> = new Vector.<b2Body>();
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:* = param1.m_shapeCount;
         var _loc4_:* = param1.GetShapeList();
         var _loc5_:b2Shape = param1.GetShapeList();
         while(_loc5_)
         {
            if(!(_loc5_ is b2CircleShape))
            {
               _loc6_ = _loc5_ as b2PolygonShape;
               _loc7_ = _loc6_.GetVertices();
               _loc7_.splice(_loc6_.GetVertexCount(),_loc7_.length - _loc6_.GetVertexCount());
               _loc8_ = GeneralUtils.arrayCentroid(_loc7_);
               _loc9_ = new b2BodyDef();
               _loc9_.position.Set(_loc8_.x,_loc8_.y);
               _loc9_.linearDamping = Vars.objDampLinear;
               _loc9_.angularDamping = Vars.objDampAngular;
               _loc10_ = ShapeUserData(_loc5_.GetUserData()).name;
               if(ShapeUserData(_loc5_.GetUserData()).invisible)
               {
                  _loc10_ = "777777";
               }
               _loc9_.userData = Properties.objectProperties(_loc10_);
               if(Boolean(userData(param1.GetUserData()).skin) && userData(param1.GetUserData()).skin.length > 0)
               {
                  _loc10_ = BoxUtils.getSkinColour(userData(param1.GetUserData()).skin,_loc10_).toString(16);
               }
               _loc11_ = Physics.world.CreateBody(_loc9_);
               _loc12_ = userData(_loc11_.GetUserData());
               _loc12_.saveable = false;
               _loc13_ = new b2PolygonDef();
               _loc13_.density = 1;
               _loc13_.friction = 0.3;
               _loc13_.restitution = 0.3;
               _loc13_.vertexCount = _loc6_.GetVertexCount();
               _loc7_ = BoxUtils.shiftVectorArray(_loc7_,new b2Vec2(-_loc8_.x,-_loc8_.y));
               _loc13_.vertices = _loc7_;
               _loc13_.userData = Properties.shapeProperties(_loc10_);
               _loc11_.CreateShape(_loc13_);
               _loc11_.SetMassFromShapes();
               _loc11_.SetAngularVelocity(param1.GetAngularVelocity());
               _loc11_.SetLinearVelocity(param1.GetLinearVelocity());
               _loc11_.SetXForm(new b2Vec2(param1.GetPosition().x + _loc8_.x,param1.GetPosition().y + _loc8_.y),_loc11_.GetAngle());
               BoxUtils.updateBodyDimensions(_loc11_);
               _loc12_.graphic = BoxUtils.bodyToSprite(_loc11_,_loc12_.size);
               _loc12_.graphic.x -= _loc11_.GetPosition().x * Physics.scale;
               _loc12_.graphic.y -= _loc11_.GetPosition().y * Physics.scale;
               Main.instance.itemSprite.addChild(_loc12_.graphic);
               _loc2_.push(_loc11_);
            }
            _loc5_ = _loc5_.GetNext();
         }
         BoxUtils.rotateAroundPoint(param1.GetPosition(),param1.GetAngle(),_loc2_);
         Destroy(param1,"decomposition");
         return _loc2_;
      }
      
      public static function Scale(param1:b2Body, param2:Number, param3:Boolean = true) : b2Body
      {
         var _loc5_:Number = NaN;
         var _loc12_:b2Body = null;
         var _loc13_:userData = null;
         var _loc16_:String = null;
         var _loc25_:BitmapData = null;
         var _loc26_:String = null;
         var _loc27_:b2RevoluteJoint = null;
         var _loc4_:userData = userData(param1.GetUserData());
         if(!_loc4_)
         {
            return null;
         }
         if(_loc4_.hasBeenCut)
         {
            return null;
         }
         if(!_loc4_.saveable)
         {
            return null;
         }
         GameState.resizing = true;
         if(param3)
         {
            _loc5_ = _loc4_.size * param2;
         }
         else
         {
            _loc5_ = param2;
         }
         if(_loc5_ > Tweak.ScaleMax)
         {
            _loc5_ = Tweak.ScaleMax;
         }
         if(_loc5_ < Tweak.ScaleMin)
         {
            _loc5_ = Tweak.ScaleMin;
         }
         var _loc6_:String = userData(param1.GetUserData()).name;
         var _loc7_:Number = param1.GetAngle();
         var _loc8_:b2Vec2 = param1.GetLinearVelocity();
         var _loc9_:Number = param1.GetAngularVelocity();
         var _loc10_:b2Vec2 = param1.GetPosition();
         var _loc11_:Number = param1.GetShapeList().m_density * param2;
         if(_loc6_ == "shrapnel")
         {
            return null;
         }
         var _loc14_:Number = Vars.objSize;
         Vars.objSize = _loc5_;
         var _loc15_:Boolean = _loc4_.flipped;
         _loc16_ = _loc6_;
         var _loc17_:Vector.<Array> = GameState.objects.spawnSkin;
         if(_loc4_.skin)
         {
            GameState.objects.spawnSkin = _loc4_.skin;
         }
         if(_loc4_.stainless)
         {
            Properties.forceObjStain = 1;
         }
         var _loc18_:Number = Vars.objAngle;
         Vars.objAngle = 0;
         _loc12_ = GameState.objects.spawnObject(_loc16_,_loc10_.x * Physics.scale,_loc10_.y * Physics.scale,_loc7_ * Vars.toDegrees,_loc15_,true,_loc4_.skin);
         Vars.objAngle = _loc18_;
         Properties.forceObjStain = 0;
         Vars.objSize = _loc14_;
         GameState.objects.spawnSkin = _loc17_;
         if(!_loc12_)
         {
            return null;
         }
         _loc13_ = userData(_loc12_.GetUserData());
         if(_loc13_)
         {
            _loc13_.copyProperties(_loc4_,_loc12_);
            if(_loc13_.invisible)
            {
               _loc13_.graphic.alpha = 0;
            }
            var _loc19_:Array = BoxUtils.bodyToVertices(_loc12_);
            _loc13_.hull = GameState.hullHandler.convexHull(_loc19_);
            var _loc20_:int = Main.instance.selectedBodies.indexOf(param1);
            if(_loc20_ != -1)
            {
               Main.instance.selectedBodies.splice(_loc20_,1);
               Main.instance.selectedBodies.push(_loc12_);
            }
            if(Main.instance.detailBody == param1)
            {
               Main.instance.detailBody = _loc12_;
            }
            _loc4_.reconnect(_loc12_);
            _loc4_.reignore(_loc12_);
            var _loc21_:b2Body = _loc12_;
            var _loc22_:b2Body = _loc12_;
            var _loc23_:b2JointEdge = param1.GetJointList();
            while(_loc23_)
            {
               if(!(userData(_loc23_.joint.m_body1.GetUserData()).name == "ground" || userData(_loc23_.joint.m_body2.GetUserData()).name == "ground"))
               {
                  _loc26_ = jointUserData(_loc23_.joint.GetUserData()).name;
                  if(_loc26_ == "rag" || _loc26_ == "revolute" || _loc26_ == "ana")
                  {
                     if(_loc23_.joint.m_body1 == param1)
                     {
                        _loc21_ = _loc23_.joint.m_body2;
                     }
                     else
                     {
                        _loc21_ = _loc23_.joint.m_body1;
                     }
                     _loc27_ = Joints.Revolution("rag",_loc21_,_loc22_,_loc23_.joint.GetAnchor1().x * Physics.scale,_loc23_.joint.GetAnchor1().y * Physics.scale,jointUserData(_loc23_.joint.GetUserData()).lowerAngle,jointUserData(_loc23_.joint.GetUserData()).upperAngle);
                     if(_loc27_)
                     {
                        jointUserData(_loc27_.GetUserData()).forceLimit = jointUserData(_loc23_.joint.GetUserData()).forceLimit;
                     }
                  }
               }
               _loc23_ = _loc23_.next;
            }
            var _loc24_:BitmapData = BoxUtils.getEffectBMD(param1);
            if(_loc24_)
            {
               _loc25_ = GeneralUtils.scaleBMD(_loc24_.clone(),param2);
            }
            Body.Destroy(param1,"resize");
            if(_loc12_)
            {
               _loc12_.SetLinearVelocity(_loc8_);
               _loc12_.SetAngularVelocity(_loc9_);
               _loc13_.size = _loc5_;
               if(Boolean(_loc24_) && Boolean(_loc25_))
               {
                  BoxUtils.getEffectBMD(_loc12_).draw(_loc25_);
               }
               if(_loc13_.graphic)
               {
                  _loc13_.graphic.alpha = _loc13_.alpha;
               }
            }
            GameState.resizing = false;
            GraphicUtils.addGraphicToLayer(_loc13_);
            return _loc12_;
         }
         throw new Error("UserData not set! (Did spawnObject return a body?)");
      }
      
      public static function Radioactive(param1:b2Body, param2:Number = 100) : *
      {
         var _loc6_:b2Body = null;
         var _loc7_:String = null;
         if(Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
         {
            return;
         }
         if(!param1)
         {
            return;
         }
         var _loc3_:userData = param1.GetUserData() as userData;
         if(!_loc3_)
         {
            return;
         }
         if(Math.random() > 0.2)
         {
            _loc7_ = "sparkle";
            if(Boolean(_loc3_.pfx) && _loc3_.pfx.replaceDefault)
            {
               _loc7_ = _loc3_.pfx.getParticle();
            }
            BoxUtils.randomParticlesOnBody(param1,_loc7_,4);
         }
         else
         {
            _loc7_ = "radioactive";
            if(Boolean(_loc3_.pfx) && _loc3_.pfx.replaceDefault)
            {
               _loc7_ = _loc3_.pfx.getParticle();
            }
            BoxUtils.randomParticlesOnBody(param1,_loc7_,1);
         }
         var _loc4_:Number = param2;
         var _loc5_:Array = Body.GetAround(param1,_loc4_,_loc4_,false);
         for each(_loc6_ in _loc5_)
         {
            Body.Radiation(_loc6_);
         }
      }
      
      public static function Radiation(param1:b2Body, param2:Boolean = true) : *
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:userData = param1.GetUserData() as userData;
         if(!_loc3_)
         {
            return;
         }
         if(!_loc3_.alive)
         {
            return;
         }
         if(param2 && _loc3_.resistRadioactive)
         {
            return;
         }
         _loc3_.health -= (25 + _loc3_.health * 0.0001) * TimeLord.speed;
         var _loc4_:b2Vec2 = param1.GetPosition();
         if(World.toggleGore == 0)
         {
            return;
         }
         if(Math.random() > 0.99)
         {
            if((_loc3_.soft || _loc3_.ignition == 50) && _loc3_.health <= 1)
            {
               if(param1.GetMass() < 0.75)
               {
                  _loc3_.trigger = new triggers.Disintegrate("blood",20,0.1);
                  _loc3_.triggered = true;
               }
               else
               {
                  Main.instance.brittleArray.push(param1);
               }
            }
         }
         RadiationEffect(param1);
      }
      
      public static function RadiationEffect(param1:b2Body) : *
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(_loc2_.bloodColour,Math.random());
         _loc5_ = -10 + Math.random() * (_loc2_.width + 20);
         _loc6_ = -10 + Math.random() * (_loc2_.height + 20);
         _loc4_.graphics.drawCircle(_loc5_,_loc6_,Math.random() * 4);
         _loc4_.graphics.endFill();
         _loc3_.draw(_loc4_);
      }
      
      public static function RandomEffect(param1:b2Body) : *
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = param1.GetUserData() as userData;
         var _loc3_:Array = ["Lava","Snared","Sandstone","Exsanguinate","Cookie","Mutate","Drone","Cauterize","Stasis","Blight","Food","Bling","Dispel","Growth","Frostfire","Glitch","Deepfry","Gib","Faceplant","Rainbow","Animate","Upgrade","Protect","Ghost","Glass","Wet","Petrify","Freeze","Clone","Kill","FixBrokenItem","Worm","Bite","Poison","Toxic","Brick","Burn"];
         ApplyEffect(param1,_loc3_[_loc3_.length * Math.random() >> 0],BoxUtils.pixelPosition(param1));
      }
      
      public static function RainbowEffect(param1:b2Body) : *
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Sprite = new Sprite();
         var _loc7_:Array = [16711680,16742144,16768256,65280,255,9055202,818675];
         _loc4_.graphics.beginFill(_loc7_[_loc7_.length * Math.random() >> 0],Math.random());
         _loc5_ = -10 + Math.random() * (_loc2_.width + 20);
         _loc6_ = -10 + Math.random() * (_loc2_.height + 20);
         _loc4_.graphics.drawCircle(_loc5_,_loc6_,Math.random() * 4);
         _loc4_.graphics.endFill();
         _loc3_.draw(_loc4_);
      }
      
      public static function brittle(param1:b2Body) : *
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.unbreakable)
         {
            return;
         }
         if(_loc2_.resistCutting)
         {
            return;
         }
         var _loc3_:Number = 10;
         var _loc4_:* = BoxUtils.bodyDimensions(param1);
         _loc3_ = _loc4_[0] > _loc4_[1] ? Number(_loc4_[0]) : Number(_loc4_[1]);
         var _loc5_:Vector.<b2Body> = new Vector.<b2Body>();
         _loc5_.push(param1);
         GameState.madeby = "brittle";
         var _loc6_:Number = Math.random() * 360;
         var _loc7_:Number = Math.random() * 360;
         var _loc8_:Number = _loc6_ - _loc7_;
         while((_loc8_ > 0 ? _loc8_ : -_loc8_) < 60)
         {
            _loc7_ = Math.random() * 360;
            _loc8_ = _loc6_ - _loc7_;
         }
         var _loc9_:b2Vec2 = GeneralUtils.pointOnCircle(param1.GetPosition().x * Physics.scale,param1.GetPosition().y * Physics.scale,_loc3_,_loc6_);
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(param1.GetPosition().x * Physics.scale,param1.GetPosition().y * Physics.scale,_loc3_,_loc7_);
         GameState.cutter.Include(_loc5_);
         GameState.cutter.Cut(1,_loc9_,_loc10_,_loc3_ * 2,0);
         Physics.contactFilter.cutInclude = new Vector.<b2Body>();
      }
      
      public static function Sting(param1:b2Body, param2:b2Vec2) : void
      {
         var _loc5_:Sprite = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:userData = userData(param1.GetUserData());
         Body.Damage(param1,_loc3_.maxhealth * 0.01,param2,null,null,false,false);
         if(Math.random() > 0.99)
         {
            Body.Poison(param1,param2,10);
            if(_loc3_.trigger is Poisoned)
            {
               Poisoned(_loc3_.trigger).particles = false;
               Poisoned(_loc3_.trigger).sound = false;
            }
         }
         sounds.play("stab1",param1,param2,0.2 + Math.random() * 0.2);
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc4_)
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(0,0,0);
            param2.Multiply(1 / Physics.scale);
            _loc6_ = param1.GetLocalPoint(param2).Copy();
            _loc6_.Multiply(Physics.scale);
            _loc6_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
            _loc6_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
            _loc7_ = _loc6_.x + Math.random() * 20 - 10;
            _loc8_ = _loc6_.y + Math.random() * 20 - 10;
            _loc5_.graphics.beginFill(_loc3_.bloodColour,Math.random());
            _loc5_.graphics.drawCircle(_loc7_,_loc8_,2);
            _loc5_.graphics.endFill();
            _loc5_.graphics.beginFill(GraphicUtils.scalehex(_loc3_.bloodColour,0.7),Math.random());
            _loc5_.graphics.drawCircle(_loc7_,_loc8_,1);
            _loc5_.graphics.endFill();
            _loc4_.draw(_loc5_);
         }
      }
      
      public static function Lava(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.resistScorching)
         {
            return;
         }
         if(!_loc2_.trigger || Boolean(_loc2_.trigger) && Boolean(!(_loc2_.trigger is Lavad)))
         {
            _loc2_.ignition = 500;
            if(_loc2_.temperature < 200)
            {
               _loc2_.temperature = 200;
            }
            _loc2_.trigger = new Lavad();
            _loc2_.triggerLock = false;
            _loc2_.triggered = true;
            _loc2_.triggerLock = true;
            _loc2_.saveable = false;
         }
         _loc2_.temperature += 50;
      }
      
      public static function Snared(param1:b2Body, param2:Number = 30) : void
      {
         var _loc3_:userData = userData(param1.GetUserData());
         if(_loc3_.resistSnare)
         {
            return;
         }
         _loc3_.trigger = new Snare();
         _loc3_.triggered = true;
         _loc3_.triggerDuration = param2;
      }
      
      public static function Sandstone(param1:b2Body) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.resistDrying)
         {
            return;
         }
         if(_loc2_.projectile)
         {
            return;
         }
         if(!(_loc2_.trigger is Sanded))
         {
            Body.Freeze(param1,_loc2_.temperature);
            _loc2_.trigger = new Sanded();
            _loc2_.triggerLock = false;
            _loc2_.triggered = true;
            _loc2_.brittle = true;
            _loc2_.alive = false;
            _loc2_.resistBleed = true;
            _loc2_.saveable = false;
            _loc3_ = BoxUtils.getEffectBMD(param1);
            if(_loc3_)
            {
               _loc3_.colorTransform(_loc3_.rect,new ColorTransform(1,1,1,0.7));
               _loc4_ = _loc3_.clone();
               _loc5_ = Math.floor(Math.random() * 10) + 50;
               _loc3_.copyPixels(_loc4_,_loc3_.rect,new Point(),null,null,true);
               _loc6_ = 0;
               while(_loc6_ < 20)
               {
                  _loc3_.copyPixels(R.getSprite("p_dust"),new Rectangle(0,0,8,8),new Point(-4 + Math.random() * _loc2_.width,-4 + Math.random() * _loc2_.height),null,null,true);
                  _loc6_++;
               }
            }
         }
      }
      
      public static function Exsanguinate(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.alive)
         {
            return;
         }
         if(_loc2_.resistBleed)
         {
            return;
         }
         var _loc3_:b2Vec2 = new b2Vec2();
         var _loc4_:b2Vec2 = new b2Vec2();
         _loc3_.x = Math.random() * (_loc2_.width * 1.2) - _loc2_.width * 0.6;
         _loc3_.y = Math.random() * (_loc2_.height * 1.2) - _loc2_.height * 0.6;
         _loc4_.x = Math.random() * (_loc2_.width * 1.2) - _loc2_.width * 0.6;
         _loc4_.y = Math.random() * (_loc2_.height * 1.2) - _loc2_.height * 0.6;
         Wound(param1,_loc3_,_loc4_);
      }
      
      public static function Wound(param1:b2Body, param2:b2Vec2, param3:b2Vec2) : *
      {
         var _loc10_:Sprite = null;
         var _loc11_:b2Vec2 = null;
         var _loc4_:Number = param2.x;
         var _loc5_:Number = param2.y;
         var _loc6_:Number = param3.x;
         var _loc7_:Number = param3.y;
         var _loc8_:userData = userData(param1.GetUserData());
         _loc8_.bleeding.push([new b2Vec2(_loc4_ / Physics.scale,_loc5_ / Physics.scale),new b2Vec2(_loc6_ / Physics.scale,_loc7_ / Physics.scale),new b2Vec2(),2]);
         if(Math.random() > 0.6)
         {
            sounds.random(["cut1","cut2","cut5","cut7"],null,param1.GetPosition(),Math.random() * 0.15 + 0.25);
         }
         var _loc9_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc9_)
         {
            _loc10_ = new Sprite();
            _loc11_ = new b2Vec2();
            _loc11_.x -= Bitmap(_loc8_.graphic.getChildByName("effects")).x;
            _loc11_.y -= Bitmap(_loc8_.graphic.getChildByName("effects")).y;
            _loc10_.graphics.lineStyle(Math.random() * 2 + 2,_loc8_.bloodColour,Math.random() * 0.4 + 0.6);
            _loc10_.graphics.moveTo(_loc4_ + _loc11_.x,_loc5_ + _loc11_.y);
            _loc10_.graphics.lineTo(_loc6_ + _loc11_.x,_loc7_ + _loc11_.y);
            _loc9_.draw(_loc10_);
         }
      }
      
      public static function Cookie(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(Math.random() > 0.5)
         {
            return;
         }
         if(Math.random() > 0.95)
         {
            _loc2_.trigger = new Transmute("cookie");
            _loc2_.triggered = true;
            return;
         }
         CookieEffect(param1);
      }
      
      public static function CookieEffect(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.lineStyle(0,0,0);
         var _loc5_:b2Vec2 = new b2Vec2();
         _loc5_.Multiply(Physics.scale);
         _loc5_.x -= Bitmap(_loc2_.graphic.getChildByName("effects")).x;
         _loc5_.y -= Bitmap(_loc2_.graphic.getChildByName("effects")).y;
         var _loc6_:uint = BoxUtils.getSkinColour(_loc2_.skin,"CF9049");
         if(_loc6_ == 16711935)
         {
            _loc6_ = 13602889;
         }
         var _loc7_:uint = BoxUtils.getSkinColour(_loc2_.skin,"51270D");
         if(_loc7_ == 16711935)
         {
            _loc7_ = 5318413;
         }
         _loc4_.graphics.beginFill(_loc6_,1);
         var _loc8_:Number = _loc5_.x + (Math.random() * _loc2_.width - _loc2_.width * 0.5);
         var _loc9_:Number = _loc5_.y + (Math.random() * _loc2_.height - _loc2_.height * 0.5);
         _loc4_.graphics.drawCircle(_loc8_,_loc9_,Math.random() * 8 + 4);
         var _loc10_:int = 0;
         while(_loc10_ < Math.random() * 4)
         {
            _loc4_.graphics.beginFill(_loc7_,1);
            _loc4_.graphics.drawCircle(_loc8_ + Math.random() * 16 - 8,_loc9_ + Math.random() * 16 - 8,Math.random() * 3 + 1);
            _loc10_++;
         }
         _loc4_.graphics.endFill();
         _loc3_.draw(_loc4_);
      }
      
      public static function Mutate(param1:b2Body) : void
      {
         var _loc8_:b2JointEdge = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.alive)
         {
            return;
         }
         if(!_loc2_.saveable)
         {
            return;
         }
         if(Math.random() > 0.75)
         {
            _loc8_ = param1.GetJointList();
            while(_loc8_)
            {
               if(jointUserData(_loc8_.joint.GetUserData()).name == "mutate")
               {
                  userData(_loc8_.other.GetUserData()).trigger = new triggers.Disintegrate("blood",10,1);
                  userData(_loc8_.other.GetUserData()).triggered = true;
                  return;
               }
               _loc8_ = _loc8_.next;
            }
         }
         var _loc3_:b2Vec2 = param1.GetWorldCenter().Copy();
         _loc3_.Multiply(Physics.scale);
         _loc3_.x += Math.random() * 50 - 25;
         _loc3_.y += Math.random() * 50 - 25;
         var _loc4_:Number = GameState.objects.spawnScale;
         GameState.objects.spawnScale = Math.random() * Math.random() * 1.8 + 0.6;
         var _loc5_:Vector.<Array> = _loc2_.skin.slice();
         var _loc6_:Vector.<Array> = GameState.objects.spawnSkin;
         GameState.objects.spawnSkin = _loc5_;
         var _loc7_:b2Body = GameState.objects.delayedSpawnObject(_loc2_.name,_loc3_.x,_loc3_.y,Math.random() * 360,false,true);
         GameState.objects.spawnSkin = _loc6_;
         GameState.objects.spawnScale = _loc4_;
         if(_loc7_)
         {
            Joints.Weld("mutate",param1,_loc7_,_loc7_.GetWorldCenter(),1000,false);
         }
      }
      
      public static function Drone(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.resistDroning)
         {
            return;
         }
         if(_loc2_.trigger is triggers.Drone)
         {
            return;
         }
         var _loc3_:Array = [DroneClean,DroneExplosive,DroneLaser,DroneHammer,DroneRocket,DroneToxic,DronePin,DronePaint,DroneBullet,DroneBee,DroneBuild,DroneFlame,DronePin,DronePotato,DroneShield];
         var _loc4_:Class = getDefinitionByName(getQualifiedClassName(_loc3_[_loc3_.length * Math.random() >> 0])) as Class;
         _loc2_.trigger = new _loc4_();
         _loc2_.triggered = true;
         _loc2_.triggerRadius = 100;
         _loc2_.triggerDuration = 50;
      }
      
      public static function Cauterize(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         CauterizeEffect(param1);
         _loc2_.bleeding = [];
      }
      
      public static function CauterizeEffect(param1:b2Body) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Array = null;
         var _loc7_:Sprite = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.lock();
         for each(_loc6_ in _loc2_.bleeding)
         {
            _loc4_ = _loc6_[0] as b2Vec2;
            _loc5_ = _loc6_[1] as b2Vec2;
            _loc7_ = new Sprite();
            _loc8_ = BoxUtils.vectorDist(_loc4_,_loc5_) * Physics.scale;
            if(_loc8_ > 10)
            {
               _loc8_ = 10;
            }
            _loc11_ = (_loc5_.y - _loc4_.y) / (_loc5_.x - _loc4_.x);
            _loc13_ = Bitmap(_loc2_.graphic.getChildByName("effects")).x;
            _loc14_ = Bitmap(_loc2_.graphic.getChildByName("effects")).y;
            _loc15_ = 0;
            while(_loc15_ < _loc8_)
            {
               _loc7_.graphics.beginFill(3351074,Math.random() * 0.4 + 0.2);
               _loc16_ = _loc4_.x + _loc15_ / _loc8_ * (_loc5_.x - _loc4_.x);
               _loc17_ = _loc4_.y + _loc11_ * (_loc16_ - _loc4_.x);
               _loc12_ = new b2Vec2(_loc16_,_loc17_);
               _loc12_.Multiply(Physics.scale);
               _loc12_.x -= _loc13_;
               _loc12_.y -= _loc14_;
               _loc7_.graphics.drawCircle(_loc12_.x,_loc12_.y,Math.random() * 3 + 1);
               _loc7_.graphics.endFill();
               _loc15_++;
            }
            _loc3_.draw(_loc7_);
         }
         _loc3_.unlock();
      }
      
      public static function Stasis(param1:b2Body, param2:Number) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.resistStasis)
         {
            return;
         }
         _loc3_.trigger = new triggers.Stasis(param2);
         _loc3_.triggered = true;
      }
      
      public static function Blight(param1:b2Body, param2:Number) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_)
         {
            return;
         }
         if(!_loc3_.alive)
         {
            return;
         }
         if(_loc3_.resistBlighting)
         {
            return;
         }
         _loc3_.health -= _loc3_.maxhealth * 0.01 + (Math.random() * param2 + Math.random() * param2 + param2) * 10;
         if(_loc3_.health <= 0)
         {
            _loc3_.trigger = new ToxinMelt();
            _loc3_.triggerDuration = param2;
            _loc3_.triggered = true;
         }
      }
      
      public static function BlightEffect(param1:b2Body, param2:b2Vec2, param3:String = "64CC12", param4:Vector.<Array> = null) : *
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc5_:userData = userData(param1.GetUserData());
         if(!_loc5_)
         {
            return;
         }
         if(_loc5_.resistBlighting)
         {
            return;
         }
         var _loc6_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc6_)
         {
            return;
         }
         var _loc7_:Sprite = new Sprite();
         _loc7_.graphics.lineStyle(0,0,0);
         var _loc10_:uint = uint("0x" + param3);
         if(Boolean(param4) && param4.length > 0)
         {
            _loc10_ = BoxUtils.getSkinColour(param4,param3);
         }
         var _loc11_:b2Vec2 = b2Body(param1).GetLocalPoint(param2).Copy();
         _loc11_.Multiply(Physics.scale);
         _loc11_.x -= Bitmap(_loc5_.graphic.getChildByName("effects")).x;
         _loc11_.y -= Bitmap(_loc5_.graphic.getChildByName("effects")).y;
         var _loc12_:int = 0;
         while(_loc12_ < 5)
         {
            if(Math.random() > 0.5)
            {
               _loc7_.graphics.beginFill(_loc10_,Math.random());
            }
            else
            {
               _loc7_.graphics.beginFill(GraphicUtils.scalehex(_loc10_,0.9),Math.random());
            }
            _loc8_ = _loc11_.x + Math.random() * 20 - 10;
            _loc9_ = _loc11_.y + Math.random() * 20 - 10;
            _loc7_.graphics.drawCircle(_loc8_,_loc9_,Math.random() * 5);
            _loc7_.graphics.endFill();
            _loc12_++;
         }
         _loc6_.draw(_loc7_);
      }
      
      public static function Food(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.resistTransmuting)
         {
            return;
         }
         var _loc3_:Array = ["apple","bacon","bagofchips","baguette","banana","bellpepper","bottle","bread","burgerbottom","burgertop","cake","can","candybar","canteen","carrot","catfoodcan","cerealsbox","cheesy","cherry","kfcchicken","chicken","chocolatebar","coconut","cookie","corn","doughnut","dragonfruit","egg","eggnog","empirebiscuit","emptycan","frenchfrybox","fruitcake","ginormouscookie","gingerbreadman","doughnut2","chilipepper","hamshank","ham","sausagewithbuns","icecreamball","icecreamcone","icecream","jelly","juicecan","tomato","lasagna","weddingcake","leek","lemon","marshmallowstick","meatball","milkcarton","mistletoe","muffin","olive","onion","orange","pancake","peapod","peach","pear","pickledcucumbers","wrappedcandy","pizzabox","pizza","pomegranate","popsicle","potato","pricklypear","rawchicken","strangeegg","senzubean","sandwich","sausage","petitbeurre","shrimpbullet","snowmancarrot","sodabottle","sodacan","squash","steak","strawberry","independenceburger","arseniclacedpie","toast"
         ,"turkey","turnip","vegetablecrate","watermelonslice"];
         var _loc4_:String = _loc3_[int(Math.random() * _loc3_.length)];
         _loc2_.trigger = new Transmute(_loc4_);
         _loc2_.triggered = true;
      }
      
      public static function Bling(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Array = ["moneypack","diamond","moneysack","goldbar","crystal","trophy","cursedtrophy","pommel","thincrystal"];
         if(_loc3_.indexOf(_loc2_.name) != -1)
         {
            return;
         }
         _loc2_.trigger = new Transmute(_loc3_[_loc3_.length * Math.random() >> 0]);
         _loc2_.triggerLock = false;
         _loc2_.triggered = true;
         var _loc4_:b2Vec2 = param1.GetPosition().Copy();
         _loc4_.Multiply(Physics.scale);
         sounds.play("ching",null,_loc4_);
      }
      
      public static function Crabify(param1:b2Body) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         if(param1.GetMass() < 0.1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != param1)
            {
               if(userData(_loc4_.GetUserData()).alive)
               {
                  userData(_loc4_.GetUserData()).triggerCustom = "items=crab;duration=60;posX=0;posY=0;scale=0.5;scaleRandom=0.2;destroy=0;ignoreSame=1;amount=2;forceX=0;forceY=9000;forceR=500,500;randomPos=1;particle=tinysprinkle;properties=weldOnContact,blunt,ultrasharp,ghostOnContact;weight=100";
                  userData(_loc4_.GetUserData()).trigger = new DisintegrateIntoItems();
                  userData(_loc4_.GetUserData()).triggered = true;
               }
            }
         }
         _loc5_ = param1.GetPosition().Copy();
         _loc5_.Multiply(Physics.scale);
         sounds.play("drain2",null,_loc5_);
      }
      
      public static function Incapacitate(param1:b2Body) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Vec2 = null;
         var _loc2_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc3_ in _loc2_)
         {
            Shock(_loc3_,1200);
            FreezeJoints(_loc3_);
            _loc4_ = new b2Vec2(Math.random() * 2000 - 1000,Math.random() * 2000 - 1000);
            _loc4_.Multiply(_loc3_.GetMass());
            _loc3_.ApplyForce(_loc4_,BoxUtils.randomPointOnBody(_loc3_));
         }
      }
      
      public static function Grasp(param1:b2Body) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:int = 0;
         var _loc7_:b2PrismaticJoint = null;
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         if(param1.GetMass() < 0.1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc4_ in _loc3_)
         {
            userData(_loc4_.GetUserData()).triggerCustom = "items=creeperflower,creeperflower,creepervine;duration=20;posX=0;posY=0;scale=0.5;scaleRandom=0.2;destroy=0;ignoreSame=1;amount=1;forceX=0;forceY=9000;forceR=500,500;randomPos=1;particle=grass;properties=weldOnContact,ghostOnContact;weight=100";
            userData(_loc4_.GetUserData()).trigger = new DisintegrateIntoItems();
            userData(_loc4_.GetUserData()).triggered = true;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
               _loc7_ = Joints.Prismatic("snarejoint",_loc4_,Physics.world.GetGroundBody(),new b2Vec2(),new b2Vec2(_loc4_.GetPosition().x + Math.random() * 2 - 1,_loc4_.GetPosition().y + Math.random() * 2 - 1),90000,new b2Vec2(Math.random() * 2 - 1,Math.random() * 2 - 1));
               _loc7_.SetMaxMotorForce(900000);
               _loc7_.SetMotorSpeed(-100);
               _loc7_.EnableMotor(true);
               _loc6_++;
            }
         }
         _loc5_ = param1.GetPosition().Copy();
         _loc5_.Multiply(Physics.scale);
         sounds.play("drain2",null,_loc5_);
      }
      
      public static function Dispel(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         _loc2_.bleeding = [];
         if(_loc2_.ignition)
         {
            _loc2_.ignition = 100;
         }
         if(_loc2_.temperature < 0)
         {
            _loc2_.temperature = Math.random() * 30 + 10;
            _loc2_.brittle = false;
         }
         else if(_loc2_.temperature > 100)
         {
            _loc2_.temperature = Math.random() * 30 + 10;
         }
         if(Boolean(_loc2_.trigger) && _loc2_.trigger != _loc2_.originalTrigger)
         {
            _loc2_.trigger.reset();
         }
      }
      
      public static function Growth(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.graphic)
         {
            return;
         }
         var _loc3_:b2Vec2 = new b2Vec2();
         var _loc4_:b2Vec2 = new b2Vec2();
         var _loc5_:b2Vec2 = new b2Vec2();
         var _loc6_:b2Vec2 = new b2Vec2();
         var _loc7_:b2Vec2 = new b2Vec2();
         var _loc8_:b2Vec2 = new b2Vec2();
         var _loc9_:uint = GraphicUtils.scalehex(5149504,1 + Math.random() * 0.4 - 0.2);
         _loc3_.x = Math.random() * 40 - 20;
         _loc3_.y = Math.random() * 40 - 20;
         _loc6_.x = Math.random() * 40 - 20;
         _loc6_.y = Math.random() * 40 - 20;
         _loc4_.x = _loc3_.x + Math.random() * 40 - 20;
         _loc4_.y = _loc3_.y + Math.random() * 40 - 20;
         _loc7_.x = _loc3_.x + Math.random() * 40 - 20;
         _loc7_.y = _loc3_.y + Math.random() * 40 - 20;
         _loc5_.x = _loc4_.x + Math.random() * 40 - 20;
         _loc5_.y = _loc4_.y + Math.random() * 40 - 20;
         _loc8_.x = _loc4_.x + Math.random() * 40 - 20;
         _loc8_.y = _loc4_.y + Math.random() * 40 - 20;
         var _loc10_:b2Vec2 = new b2Vec2();
         var _loc11_:Graphics = Sprite(_loc2_.graphic.getChildByName("decals")).graphics;
         _loc11_.lineStyle(4,_loc9_);
         _loc11_.moveTo(_loc10_.x,_loc10_.y);
         _loc11_.curveTo(_loc10_.x + _loc6_.x,_loc10_.y + _loc6_.y,_loc10_.x + _loc3_.x,_loc10_.y + _loc3_.y);
         _loc11_.lineStyle(3,_loc9_);
         _loc11_.curveTo(_loc10_.x + _loc7_.x,_loc10_.y + _loc7_.y,_loc10_.x + _loc4_.x,_loc10_.y + _loc4_.y);
         _loc11_.lineStyle(2,_loc9_);
         _loc11_.curveTo(_loc10_.x + _loc8_.x,_loc10_.y + _loc8_.y,_loc10_.x + _loc5_.x,_loc10_.y + _loc5_.y);
      }
      
      public static function Frostfire(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.resistFrostfiring)
         {
            return;
         }
         if(_loc2_.temperature > 0 || _loc2_.ignition != -100)
         {
            Body.Freeze(param1,-100);
            _loc2_.temperature = -100;
            _loc2_.conductivity = 0.01;
            _loc2_.ignition = -100;
            FrostfireEffect(param1);
            return;
         }
      }
      
      public static function FrostfireEffect(param1:b2Body) : *
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.lock();
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc3_.copyPixels(R.getSprite("p_sprinkle"),new Rectangle(0,0,8,8),new Point(Math.random() * _loc2_.width,Math.random() * _loc2_.height),null,null,true);
            _loc4_++;
         }
         _loc3_.unlock();
      }
      
      public static function Glitch(param1:b2Body, param2:Boolean = true, param3:b2Body = null) : void
      {
         var _loc8_:Object = null;
         var _loc9_:Sprite = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:uint = 0;
         var _loc16_:Vector.<IGraphicsData> = null;
         var _loc17_:IGraphicsData = null;
         var _loc18_:Vector.<Number> = null;
         var _loc19_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc4_:userData = userData(param1.GetUserData());
         if(!_loc4_)
         {
            return;
         }
         if(!_loc4_.graphic)
         {
            return;
         }
         if(_loc4_.resistGlitching)
         {
            return;
         }
         if(_loc4_.effectCounter >= 3)
         {
            return;
         }
         var _loc5_:Sprite = Sprite(_loc4_.graphic.getChildByName("item"));
         var _loc6_:Sprite = Sprite(_loc4_.graphic.getChildByName("decals"));
         if(!_loc5_ || !_loc6_)
         {
            return;
         }
         var _loc7_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         ++_loc4_.effectCounter;
         if(param3)
         {
            _loc8_ = userData(param3.GetUserData()).ParseTriggerCustom();
            if(_loc8_.GlitchColours)
            {
               param2 = GeneralUtils.toBool(_loc8_.GlitchColours);
            }
         }
         if(param2)
         {
            _loc13_ = ["cecece","fdfd00","00f6ff","3eea00","ff05f2","ff0000","0007e8"];
            _loc14_ = 0;
            while(_loc14_ < _loc13_.length)
            {
               _loc15_ = BoxUtils.getSkinColour(_loc4_.skin,_loc13_[_loc14_]);
               if(_loc15_ != 16711935)
               {
                  _loc13_[_loc14_] = _loc15_.toString(16);
               }
               _loc14_++;
            }
         }
         var _loc10_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc10_)
         {
            _loc10_.fillRect(_loc10_.rect,0);
         }
         var _loc11_:Number = 60;
         if(Boolean(_loc8_) && Boolean(_loc8_.GlitchIntensity))
         {
            _loc11_ = Number(_loc8_.GlitchIntensity);
         }
         var _loc12_:int = 0;
         while(_loc12_ < 2)
         {
            if(_loc12_ == 0)
            {
               _loc9_ = _loc5_;
            }
            else
            {
               _loc9_ = _loc6_;
            }
            _loc16_ = _loc9_.graphics.readGraphicsData();
            for each(_loc17_ in _loc16_)
            {
               if(_loc17_ is GraphicsPath)
               {
                  _loc18_ = GraphicsPath(_loc17_).data;
                  _loc19_ = 0;
                  while(_loc19_ < _loc18_.length)
                  {
                     _loc18_[_loc19_] += Math.random() * Math.random() * (Math.random() * _loc11_ - _loc11_ * 0.5);
                     _loc19_++;
                  }
                  GraphicsPath(_loc17_).data = _loc18_;
               }
               if(param2)
               {
                  if(_loc17_ is GraphicsSolidFill)
                  {
                     GraphicsSolidFill(_loc17_).color = uint("0x" + _loc13_[int(Math.random() * _loc13_.length)]);
                  }
               }
            }
            _loc9_.graphics.clear();
            _loc9_.graphics.drawGraphicsData(_loc16_);
            _loc12_++;
         }
      }
      
      public static function HideLayers(param1:b2Body, param2:Array) : void
      {
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc3_.push(0);
            _loc4_.push(0);
            _loc5_++;
         }
         ModifyLayerAlpha(param1,param2,_loc3_,_loc4_);
      }
      
      public static function ModifyLayerAlpha(param1:b2Body, param2:Array, param3:Array, param4:Array) : void
      {
         var _loc10_:IGraphicsData = null;
         if(!param1)
         {
            return;
         }
         var _loc5_:userData = userData(param1.GetUserData());
         if(!_loc5_)
         {
            return;
         }
         if(!_loc5_.graphic)
         {
            return;
         }
         var _loc6_:Sprite = Sprite(_loc5_.graphic.getChildByName("decals"));
         if(!_loc6_)
         {
            return;
         }
         var _loc7_:Vector.<IGraphicsData> = _loc6_.graphics.readGraphicsData();
         var _loc8_:int = -1;
         var _loc9_:int = 0;
         for each(_loc10_ in _loc7_)
         {
            if(_loc10_ is GraphicsSolidFill)
            {
               _loc8_++;
               if(param2.indexOf(_loc8_) != -1)
               {
                  GraphicsSolidFill(_loc10_).alpha = param3[_loc9_];
                  GraphicsSolidFill(_loc10_).color = param4[_loc9_];
                  _loc9_++;
               }
            }
         }
         _loc6_.graphics.clear();
         _loc6_.graphics.drawGraphicsData(_loc7_);
      }
      
      public static function Deepfry(param1:b2Body) : void
      {
         var _loc4_:b2Vec2 = null;
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.resistFrying)
         {
            return;
         }
         param1.WakeUp();
         _loc2_.effectCounter += 0.01;
         var _loc3_:Number = _loc2_.effectCounter;
         if(_loc3_ >= 1)
         {
            return;
         }
         if(_loc2_.alive)
         {
            Body.Damage(param1,10 * (1 + _loc3_) * (1 + _loc3_),null,null,null,false);
         }
         if(_loc2_.temperature < 80)
         {
            if(_loc3_ < 0.9)
            {
               _loc2_.temperature += 2.5;
            }
            else
            {
               _loc2_.temperature += 10;
            }
         }
         DeepfryEffect(param1);
         if(Math.random() > 0.8)
         {
            _loc4_ = param1.GetPosition().Copy();
            _loc4_.Multiply(Physics.scale);
            sounds.play("tinyhiss",null,_loc4_,2,false);
         }
      }
      
      public static function Rust(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.alive)
         {
            return;
         }
         if(_loc2_.resistFrying)
         {
            return;
         }
         param1.WakeUp();
         _loc2_.effectCounter += 0.01;
         var _loc3_:Number = _loc2_.effectCounter;
         if(_loc3_ >= 1)
         {
            _loc2_.brittle = true;
            return;
         }
         if(_loc2_.alive)
         {
            Body.Damage(param1,10 * (1 + _loc3_) * (1 + _loc3_),null,null,null,false);
         }
         RustEffect(param1);
      }
      
      public static function DeepfryEffect(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:Number = _loc2_.effectCounter;
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:BitmapData = _loc4_.clone();
         if(_loc3_ < 0.9)
         {
            _loc4_.fillRect(_loc4_.rect,uint(64 * _loc3_ << 24 | 0x90682B));
         }
         else
         {
            _loc5_.fillRect(_loc4_.rect,uint(64 * _loc3_ << 24 | 0x90682B));
         }
         _loc5_.copyPixels(R.getSprite("p_fried"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc2_.width + 10) - 5,Math.random() * (_loc2_.height + 10) - 5),null,null,true);
         _loc4_.copyPixels(_loc5_,_loc4_.rect,new Point(),null,null,true);
      }
      
      public static function RustEffect(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:Number = _loc2_.effectCounter;
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:BitmapData = _loc4_.clone();
         if(_loc3_ < 0.9)
         {
            _loc4_.fillRect(_loc4_.rect,uint(64 * _loc3_ << 24 | 0x8E423A));
         }
         else
         {
            _loc5_.fillRect(_loc4_.rect,uint(64 * _loc3_ << 24 | 0x501C17));
         }
         _loc5_.copyPixels(R.getSprite("p_rust"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc2_.width + 10) - 5,Math.random() * (_loc2_.height + 10) - 5),null,null,true);
         _loc4_.copyPixels(_loc5_,_loc4_.rect,new Point(),null,null,true);
      }
      
      public static function Gib(param1:b2Body, param2:Number = 10, param3:Number = 1, param4:Number = 0.5) : void
      {
         var _loc8_:b2Body = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:userData = null;
         var _loc16_:String = null;
         var _loc17_:Vector.<Array> = null;
         var _loc18_:b2Vec2 = null;
         if(!param1)
         {
            return;
         }
         var _loc5_:userData = userData(param1.GetUserData());
         if(!_loc5_ || _loc5_.name == "chunk" || !_loc5_.alive)
         {
            return;
         }
         var _loc6_:b2Vec2 = param1.GetPosition().Copy();
         var _loc7_:b2Vec2 = param1.GetLinearVelocity().Copy();
         if(!GameState.fooling)
         {
            _loc7_.Multiply(0.1);
         }
         var _loc9_:int = 3 + Math.random() + Math.random() * 12;
         if(param1.GetMass() < 1)
         {
            _loc9_ = 1;
         }
         var _loc10_:Number = GameState.objects.spawnScale;
         var _loc11_:* = GameState.objects.spawnSkin;
         var _loc12_:int = 0;
         while(_loc12_ < _loc9_)
         {
            _loc13_ = 1 + (Math.random() * 7 >> 0);
            if(GameState.fooling)
            {
               _loc13_ = 101 + (Math.random() * 11 >> 0);
               param3 = 1;
            }
            _loc14_ = "chunk" + _loc13_.toString();
            _loc15_ = Properties.objectProperties(_loc14_);
            _loc16_ = GraphicUtils.scalehex(_loc5_.bloodColour,1.1 - Math.random() * 0.2).toString(16);
            GameState.objects.spawnScale = param3 + (Math.random() * param4 - param4 * 0.5);
            _loc17_ = new Vector.<Array>();
            _loc17_.push(["990000",_loc16_]);
            GameState.objects.spawnSkin = _loc17_;
            _loc8_ = GameState.objects.spawnObject(_loc14_,-1000,-1000,0,Math.random() > 0.5,true,_loc17_);
            if(_loc8_)
            {
               _loc15_ = _loc8_.GetUserData();
               _loc15_.saveable = false;
               _loc15_.soft = true;
               _loc15_.ghost = true;
               _loc15_.trigger = new GibChunk();
               _loc15_.triggered = true;
               _loc15_.projectile = true;
               _loc15_.resistShock = true;
               _loc15_.triggerLock = true;
               _loc15_.hasBeenCut = true;
               _loc8_.SetXForm(_loc6_,Math.random() * 360 * Vars.toRadians);
               _loc15_.name = "chunk";
               _loc15_.ignore = "shrapnel";
               _loc15_.bloodColour = _loc5_.bloodColour;
               _loc18_ = new b2Vec2(Math.random() * param2 - param2 * 0.5,Math.random() * param2 - param2 * 0.5);
               _loc18_.Multiply(_loc8_.GetMass());
               _loc7_.Add(_loc18_);
               _loc8_.ApplyImpulse(_loc7_,_loc8_.GetPosition());
            }
            _loc12_++;
         }
         GameState.objects.spawnScale = _loc10_;
         GameState.objects.spawnSkin = _loc11_;
         sounds.random(["cut2","cut1"],null,param1.GetPosition(),Math.random() * 0.15 + 0.25);
         userData(param1.GetUserData()).dead = true;
      }
      
      public static function HandGrab(param1:b2Body, param2:Number = 100, param3:Number = 150) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Body = null;
         var _loc11_:userData = null;
         var _loc4_:Array = Body.GetAround(param1,param3,param3,false);
         for each(_loc7_ in _loc4_)
         {
            _loc11_ = userData(_loc7_.GetUserData());
            if(_loc11_.name == "doll_hand")
            {
               _loc5_ = _loc7_;
            }
            if(_loc11_.name == "doll_head")
            {
               _loc6_ = _loc7_;
            }
         }
         if(!_loc5_ || !_loc6_)
         {
            return;
         }
         var _loc8_:b2Vec2 = _loc6_.GetPosition().Copy();
         var _loc9_:b2Vec2 = _loc5_.GetPosition().Copy();
         var _loc10_:b2Vec2 = new b2Vec2(_loc9_.x - _loc8_.x,_loc9_.y - _loc8_.y);
         _loc10_.Multiply(param2 * 0.2);
         _loc5_.ApplyForce(_loc10_,_loc7_.GetWorldCenter());
      }
      
      public static function Jump(param1:b2Body, param2:Number = 100, param3:Number = 150) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc4_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            if(_loc6_.name == "doll_leg")
            {
               _loc5_.ApplyForce(new b2Vec2(0,-param2 * _loc5_.GetMass() * 50),_loc5_.GetWorldCenter());
            }
         }
      }
      
      public static function Crouch(param1:b2Body, param2:Number = 100, param3:Number = 150) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc4_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            if(_loc6_.name != "doll_foot")
            {
               _loc5_.ApplyForce(new b2Vec2(0,param2 * _loc5_.GetMass() * 10),_loc5_.GetWorldCenter());
            }
         }
      }
      
      public static function Down(param1:b2Body, param2:Number = 100, param3:Number = 150) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc4_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            _loc5_.ApplyForce(new b2Vec2(0,param2 * _loc5_.GetMass()),_loc5_.GetWorldCenter());
         }
      }
      
      public static function Left(param1:b2Body, param2:Number = 100, param3:Number = 150) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc4_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            _loc5_.ApplyForce(new b2Vec2(-param2 * _loc5_.GetMass(),-_loc5_.GetMass()),_loc5_.GetWorldCenter());
         }
      }
      
      public static function Right(param1:b2Body, param2:Number = 100, param3:Number = 150) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc4_:Array = BoxUtils.selectCompound(param1,false);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            _loc5_.ApplyForce(new b2Vec2(param2 * _loc5_.GetMass(),-_loc5_.GetMass()),_loc5_.GetWorldCenter());
         }
      }
      
      public static function Faceplant(param1:b2Body, param2:b2Vec2, param3:Number = 500) : void
      {
         var _loc5_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc4_:userData = userData(param1.GetUserData());
         if(!_loc4_ || !_loc4_.alive)
         {
            return;
         }
         param1.WakeUp();
         if(_loc4_.name == "doll_head")
         {
            _loc5_ = param2.x - param1.GetWorldCenter().x;
            param1.ApplyTorque(param3 * param1.GetMass() * (_loc5_ > 0 ? -1 : 1));
            param1.ApplyImpulse(new b2Vec2(0,param3 * param1.GetMass()),param1.GetWorldCenter());
         }
         else
         {
            param1.GetLinearVelocity().Multiply(0.8);
         }
      }
      
      public static function Rainbow(param1:b2Body) : void
      {
         var _loc7_:Sprite = null;
         var _loc9_:Vector.<IGraphicsData> = null;
         var _loc10_:int = 0;
         var _loc11_:IGraphicsData = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         var _loc4_:Sprite = Sprite(_loc2_.graphic.getChildByName("item"));
         var _loc5_:Sprite = Sprite(_loc2_.graphic.getChildByName("decals"));
         if(!_loc4_ || !_loc5_)
         {
            return;
         }
         var _loc6_:Array = [16711680,16742144,16768256,65280,255,9055202,818675];
         var _loc8_:int = 0;
         while(_loc8_ < 2)
         {
            if(_loc8_ == 0)
            {
               _loc7_ = _loc4_;
            }
            else
            {
               _loc7_ = _loc5_;
            }
            _loc9_ = _loc7_.graphics.readGraphicsData();
            _loc10_ = int(Math.random() * _loc6_.length);
            for each(_loc11_ in _loc9_)
            {
               if(_loc11_ is GraphicsSolidFill)
               {
                  if(++_loc10_ >= _loc6_.length)
                  {
                     _loc10_ = 0;
                  }
                  GraphicsSolidFill(_loc11_).color = _loc6_[_loc10_];
               }
            }
            GameState.particles.addSimpleParticles(param1.GetPosition().x * Physics.scale,param1.GetPosition().y * Physics.scale,20,4278190080 + _loc6_[_loc10_],0,0,1,1);
            _loc7_.graphics.clear();
            _loc7_.graphics.drawGraphicsData(_loc9_);
            _loc8_++;
         }
      }
      
      public static function Animate(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.animated)
         {
            return;
         }
         if(Boolean(_loc2_.trigger) && _loc2_.trigger is Concussion)
         {
            _loc2_.trigger.reset();
         }
         _loc2_.animated = true;
         if(!_loc2_.alive)
         {
            _loc2_.maxhealth = 1000;
            _loc2_.health = 1000;
         }
      }
      
      public static function ThrowItem(param1:userData, param2:b2Vec2) : void
      {
         if(Boolean(param1) && Boolean(param1.trigger is Boomerang) || param1.trigger is Frisbee)
         {
            param1.triggerPos = param2;
            param1.triggerDuration = 0;
            param1.triggerLock = false;
            param1.triggered = true;
            param1.triggerLock = true;
         }
         else if(param1.trigger is Smiter)
         {
            param1.triggerLock = false;
            param1.triggered = true;
            param1.triggerLock = true;
         }
         else if(param1.trigger is ClusterBall)
         {
            param1.triggerLock = false;
            param1.triggered = true;
            param1.triggerLock = true;
         }
         else if(param1.trigger is NoBall)
         {
            param1.body.SetLinearVelocity(new b2Vec2());
         }
         else if(param1.trigger is SportsBall)
         {
            param1.triggerLock = false;
            param1.triggered = true;
         }
         else if(param1.trigger is IdentityDisc)
         {
            param1.triggerPos = param2;
            param1.triggerDuration = 0;
            param1.triggerLock = false;
            param1.triggered = true;
            param1.triggerLock = true;
            param1.body.m_linearDamping = 0;
         }
      }
      
      public static function Upgrade(param1:b2Body) : void
      {
         var _loc4_:String = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.alive)
         {
            return;
         }
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            if(jointUserData(_loc3_.joint.GetUserData()).name == "armour")
            {
               return;
            }
            _loc3_ = _loc3_.next;
         }
         if(_loc2_.name == "doll_hand")
         {
            _loc4_ = "deadhand";
         }
         else if(_loc2_.name == "doll_foot")
         {
            _loc4_ = "deadfoot";
         }
         else if(_loc2_.name == "doll_head")
         {
            _loc4_ = "deadhead";
         }
         else if(_loc2_.name == "doll_arm")
         {
            _loc4_ = "deadarm";
         }
         else if(_loc2_.name == "doll_leg")
         {
            _loc4_ = "deadleg";
         }
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:b2Vec2 = param1.GetWorldCenter().Copy();
         _loc5_.Multiply(Physics.scale);
         var _loc6_:b2Body = GameState.objects.delayedSpawnObject(_loc4_,_loc5_.x,_loc5_.y,param1.GetAngle(),Math.random() > 0.5,true);
         sounds.random(["cut1","cut2","cut3","cut4","cut5","cut6"],null,_loc5_);
         sounds.random(["cut1","cut2","cut3","cut4","cut5","cut6"],null,_loc5_);
      }
      
      public static function Protect(param1:b2Body, param2:Number = 300) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.resistProtect)
         {
            return;
         }
         _loc3_.trigger = new Invincible();
         _loc3_.triggered = true;
         _loc3_.triggerDuration = param2;
         _loc3_.triggerLock = true;
      }
      
      public static function Ghost(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.ghost)
         {
            return;
         }
         if(_loc2_.resistGhosting)
         {
            return;
         }
         if(_loc2_.ghost)
         {
            return;
         }
         GhostEffect(param1);
         _loc2_.trigger = new Wander(50);
         _loc2_.triggered = true;
         _loc2_.zerograv = true;
         _loc2_.resistBleed = true;
         _loc2_.bleeding = [];
         _loc2_.ghost = true;
      }
      
      public static function GhostEffect(param1:b2Body) : void
      {
         var _loc6_:Sprite = null;
         var _loc8_:Vector.<IGraphicsData> = null;
         var _loc9_:IGraphicsData = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = param1.GetUserData();
         var _loc3_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         var _loc4_:Sprite = Sprite(_loc2_.graphic.getChildByName("item"));
         var _loc5_:Sprite = Sprite(_loc2_.graphic.getChildByName("decals"));
         if(!_loc4_ || !_loc5_)
         {
            return;
         }
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            if(_loc7_ == 0)
            {
               _loc6_ = _loc4_;
            }
            else
            {
               _loc6_ = _loc5_;
            }
            _loc8_ = _loc6_.graphics.readGraphicsData();
            for each(_loc9_ in _loc8_)
            {
               if(_loc9_ is GraphicsSolidFill)
               {
                  GraphicsSolidFill(_loc9_).alpha = Math.random() * 0.2 + 0.2;
                  GraphicsSolidFill(_loc9_).color = 15658734;
               }
            }
            _loc6_.graphics.clear();
            _loc6_.graphics.drawGraphicsData(_loc8_);
            _loc7_++;
         }
      }
      
      public static function Glass(param1:b2Body, param2:Number = 1000) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_)
         {
            return;
         }
         if(!_loc3_.graphic)
         {
            return;
         }
         if(_loc3_.resistGlassing)
         {
            return;
         }
         if(Boolean(_loc3_.trigger) && _loc3_.trigger is DisintegrateOnNextHit)
         {
            return;
         }
         GlassEffect(param1);
         var _loc4_:DisintegrateOnNextHit = new DisintegrateOnNextHit("sprinkle",50,2);
         _loc4_.breakforce = param2;
         _loc3_.trigger = _loc4_;
         _loc3_.triggerLock = false;
         _loc3_.triggered = true;
         _loc3_.alive = false;
      }
      
      public static function GlassEffect(param1:b2Body) : void
      {
         var _loc6_:Sprite = null;
         var _loc8_:Vector.<IGraphicsData> = null;
         var _loc9_:IGraphicsData = null;
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         var _loc4_:Sprite = Sprite(_loc2_.graphic.getChildByName("item"));
         var _loc5_:Sprite = Sprite(_loc2_.graphic.getChildByName("decals"));
         if(!_loc4_ || !_loc5_)
         {
            return;
         }
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            if(_loc7_ == 0)
            {
               _loc6_ = _loc4_;
            }
            else
            {
               _loc6_ = _loc5_;
            }
            _loc8_ = _loc6_.graphics.readGraphicsData();
            for each(_loc9_ in _loc8_)
            {
               if(_loc9_ is GraphicsSolidFill)
               {
                  GraphicsSolidFill(_loc9_).alpha = Math.random() * 0.2 + 0.2;
                  GraphicsSolidFill(_loc9_).color = 6605794;
               }
            }
            _loc6_.graphics.clear();
            _loc6_.graphics.drawGraphicsData(_loc8_);
            _loc7_++;
         }
      }
      
      public static function CopyParticleEffect(param1:b2Body, param2:b2Body) : *
      {
         var ud:userData;
         var poffset:b2Vec2;
         var type:Class = null;
         var from:b2Body = param1;
         var to:b2Body = param2;
         var cud:userData = to.GetUserData();
         if(!from)
         {
            cud.pfx = null;
            return;
         }
         ud = from.GetUserData();
         if(!ud.pfx)
         {
            cud.pfx = null;
            return;
         }
         try
         {
            type = getDefinitionByName(getQualifiedClassName(ud.pfx)) as Class;
         }
         catch(e:*)
         {
            return;
         }
         poffset = to.GetPosition().Copy();
         poffset.Multiply(Physics.scale);
         poffset.Subtract(ud.pfx.offset.Copy());
         poffset.Multiply(1 / Physics.scale);
         cud.pfx = new type(to,poffset);
         ud.pfx.PasteProperties(cud.pfx);
      }
      
      public static function Wet(param1:b2Body, param2:b2Vec2, param3:* = true) : void
      {
         var _loc5_:int = 0;
         var _loc6_:b2Vec2 = null;
         var _loc7_:BitmapData = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:int = 0;
         var _loc4_:userData = userData(param1.GetUserData());
         if(param3)
         {
            if(!_loc4_.burning)
            {
               _loc5_ = 1 + Math.random() * 4;
               sounds.play("drain" + _loc5_.toString(),null,param2,0.25,false);
            }
            else
            {
               sounds.play("hiss",null,param2,0.25,false);
            }
         }
         if(param1.IsStatic())
         {
            return;
         }
         if(!_loc4_)
         {
            return;
         }
         if(_loc4_.burning)
         {
            if(_loc4_.temperature > 5)
            {
               _loc4_.temperature -= 2;
            }
         }
         else
         {
            if(_loc4_.temperature < 37)
            {
               _loc4_.temperature += 0.1;
            }
            else
            {
               _loc4_.temperature -= 0.1;
            }
            _loc6_ = param2.Copy();
            _loc6_.Multiply(1 / Physics.scale);
            _loc7_ = BoxUtils.getEffectBMD(param1);
            if(_loc7_)
            {
               _loc7_.lock();
               _loc8_ = param1.GetLocalPoint(_loc6_);
               _loc9_ = 0;
               while(_loc9_ < 50)
               {
                  _loc7_.setPixel32(_loc8_.x * Physics.scale + (Math.random() * _loc9_ * 1.5 - _loc9_ * 0.75) + _loc7_.width * 0.5,_loc8_.y * Physics.scale + (Math.random() * _loc9_ * 1.5 - _loc9_ * 0.75) + _loc7_.height * 0.5,0);
                  _loc9_++;
               }
               _loc7_.unlock();
            }
         }
         _loc4_.petrified = false;
         _loc4_.sticky = false;
         if(_loc4_.trigger is Concussion)
         {
            _loc4_.trigger.reset();
         }
      }
      
      public static function Petrify(param1:b2Body) : void
      {
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.resistPetrifying)
         {
            return;
         }
         PetrifyEffect(param1);
         if(_loc2_.petrified)
         {
            return;
         }
         _loc2_.petrified = true;
         Body.Freeze(param1,_loc2_.temperature);
         _loc2_.trigger = new Concussion(-1,false);
         _loc2_.trigger.init(param1,_loc2_);
         var _loc3_:b2Vec2 = param1.GetPosition().Copy();
         _loc3_.Multiply(Physics.scale);
         sounds.play("petrify",null,_loc3_,0.3);
      }
      
      public static function PetrifyEffect(param1:b2Body) : void
      {
         if(param1.IsStatic())
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.lock();
         _loc3_.colorTransform(_loc3_.rect,new ColorTransform(1,1,1,0.7));
         var _loc4_:BitmapData = _loc3_.clone();
         var _loc5_:int = Math.floor(Math.random() * 10) + 50;
         _loc3_.copyPixels(_loc4_,_loc3_.rect,new Point(),null,null,true);
         _loc3_.copyPixels(R.getSprite("p_petrify"),new Rectangle(0,0,8,8),new Point(-4 + Math.random() * _loc2_.width,-4 + Math.random() * _loc2_.height),null,null,true);
         _loc3_.unlock();
      }
      
      public static function EMP(param1:b2Body) : void
      {
         var _loc2_:userData = param1.GetUserData();
         if(_loc2_.alive)
         {
            return;
         }
         _loc2_.triggerLock = false;
         _loc2_.trigger = new Electrified();
         _loc2_.triggered = false;
         _loc2_.triggerLock = true;
      }
      
      public static function Shock(param1:b2Body, param2:Number = 30) : void
      {
         userData(param1.GetUserData()).trigger = new Electrified();
         userData(param1.GetUserData()).triggerDuration = param2;
         userData(param1.GetUserData()).triggered = true;
      }
      
      public static function Freeze(param1:b2Body, param2:Number = -50) : void
      {
         if(param1.IsStatic())
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         _loc3_.temperature = param2;
         if(_loc3_.resistFreeze && param2 < 0)
         {
            _loc3_.temperature = 1;
            return;
         }
         _loc3_.brittle = true;
         FreezeJoints(param1);
         if(param2 < 0)
         {
            FreezeEffect(param1);
         }
      }
      
      private static function FreezeJoints(param1:b2Body, param2:Boolean = true) : void
      {
         var _loc6_:b2Joint = null;
         var _loc7_:b2Joint = null;
         var _loc8_:jointUserData = null;
         var _loc9_:b2RevoluteJoint = null;
         var _loc3_:Array = [];
         var _loc4_:Vector.<b2Joint> = new Vector.<b2Joint>();
         var _loc5_:b2JointEdge = param1.GetJointList();
         while(_loc5_)
         {
            _loc4_.push(_loc5_.joint);
            _loc5_ = _loc5_.next;
         }
         for each(_loc6_ in _loc4_)
         {
            _loc8_ = jointUserData(_loc6_.GetUserData());
            if(_loc6_ is b2RevoluteJoint)
            {
               _loc9_ = Joints.Revolution("frozen",_loc6_.m_body1,_loc6_.m_body2,_loc6_.GetAnchor1().x * Physics.scale,_loc6_.GetAnchor1().y * Physics.scale,_loc8_.lowerAngle * 0.05,_loc8_.upperAngle * 0.05,false);
               if(_loc9_)
               {
                  jointUserData(_loc9_.GetUserData()).forceLimit = _loc8_.forceLimit * (param2 ? 0.5 : 1);
                  jointUserData(_loc9_.GetUserData()).defaultFL = _loc8_.defaultFL;
                  jointUserData(_loc9_.GetUserData()).defaultLA = _loc8_.defaultLA;
                  jointUserData(_loc9_.GetUserData()).defaultUA = _loc8_.defaultUA;
               }
               _loc3_.push(_loc6_);
            }
         }
         for each(_loc7_ in _loc3_)
         {
            Physics.world.DestroyJoint(_loc7_);
         }
      }
      
      public static function FreezeEffect(param1:b2Body) : void
      {
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.lock();
         var _loc4_:BitmapData = _loc3_.clone();
         var _loc5_:int = Math.floor(Math.random() * 10) + 30;
         _loc3_.copyPixels(_loc4_,_loc3_.rect,new Point(),null,null,true);
         var _loc6_:int = 0;
         while(_loc6_ < 10)
         {
            _loc3_.copyPixels(R.getSprite("p_crystal"),new Rectangle(0,0,8,8),new Point(Math.random() * _loc2_.width,Math.random() * _loc2_.height),null,null,true);
            _loc6_++;
         }
         _loc3_.unlock();
      }
      
      public static function Clone(param1:b2Body, param2:b2Vec2 = null) : b2Body
      {
         var _loc18_:BitmapData = null;
         var _loc3_:userData = userData(param1.GetUserData());
         var _loc4_:* = GameState.objects.spawnScale;
         var _loc5_:* = GameState.objects.spawnSkin;
         var _loc6_:* = Vars.objSize;
         Vars.objSize = 1;
         GameState.objects.spawnScale = _loc3_.size;
         var _loc7_:Number = Vars.objDensity;
         var _loc8_:Number = Vars.objRestitution;
         var _loc9_:Number = Vars.objFriction;
         var _loc10_:Number = Vars.objDampAngular;
         var _loc11_:Number = Vars.objDampLinear;
         var _loc12_:Number = Vars.objAngle;
         Vars.objDensity = _loc3_.density;
         Vars.objFriction = param1.GetShapeList().GetFriction();
         Vars.objRestitution = param1.GetShapeList().GetRestitution();
         Vars.objDampAngular = param1.m_angularDamping;
         Vars.objDampLinear = param1.m_linearDamping;
         Vars.objAngle = param1.GetAngle() * Vars.toDegrees;
         GameState.objects.spawnSkin = _loc3_.skin;
         if(!param2)
         {
            param2 = new b2Vec2();
            param2.x = param1.GetPosition().x * Physics.scale;
            param2.y = param1.GetPosition().y * Physics.scale - _loc3_.height - 10;
         }
         var _loc13_:int = Properties.forceObjVanilla;
         if(_loc3_.vanilla)
         {
            Properties.forceObjVanilla = 1;
         }
         var _loc14_:b2Body = GameState.objects.spawnObject(_loc3_.name,param2.x,param2.y,0,_loc3_.flipped,true,_loc3_.skin);
         Properties.forceObjVanilla = _loc13_;
         GameState.objects.spawnScale = _loc4_;
         GameState.objects.spawnSkin = _loc5_;
         Vars.objSize = _loc6_;
         Vars.objDensity = _loc7_;
         Vars.objRestitution = _loc8_;
         Vars.objFriction = _loc9_;
         Vars.objDampAngular = _loc10_;
         Vars.objDampLinear = _loc11_;
         Vars.objAngle = _loc12_;
         if(!_loc14_)
         {
            return null;
         }
         var _loc15_:userData = userData(_loc14_.GetUserData());
         _loc15_.copyProperties(_loc3_,param1);
         CopyParticleEffect(param1,_loc14_);
         if(_loc15_.sleepOnSpawn)
         {
            _loc14_.PutToSleep();
         }
         if(_loc15_.invisible)
         {
            _loc15_.graphic.alpha = 0;
         }
         else
         {
            _loc15_.graphic.alpha = 1;
         }
         var _loc16_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc16_)
         {
            _loc18_ = BoxUtils.getEffectBMD(_loc14_);
            _loc18_.copyPixels(_loc16_,_loc16_.rect,new Point());
         }
         GraphicUtils.addGraphicToLayer(_loc15_);
         var _loc17_:Array = BoxUtils.bodyToVertices(_loc14_);
         _loc15_.hull = GameState.hullHandler.convexHull(_loc17_);
         return _loc14_;
      }
      
      public static function Kill(param1:b2Body, param2:b2Vec2) : void
      {
         var _loc5_:int = 0;
         var _loc6_:b2Vec2 = null;
         if(!param1)
         {
            return;
         }
         if(param1.IsStatic())
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(_loc3_.resistKill)
         {
            return;
         }
         if(_loc3_.alive)
         {
            Body.Damage(param1,_loc3_.health);
            var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
            if(_loc4_)
            {
               _loc5_ = 0;
               while(_loc5_ < 10)
               {
                  _loc6_ = param1.GetLocalPoint(new b2Vec2(param2.x / Physics.scale,param2.y / Physics.scale)).Copy();
                  _loc6_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,Math.random() * _loc5_,Math.random() * 360);
                  _loc6_.Multiply(Physics.scale);
                  _loc6_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
                  _loc6_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
                  _loc4_.copyPixels(R.getSprite(Math.random() > 0.8 ? "p_blood" : "p_dark"),new Rectangle(0,0,8,8),new Point(_loc6_.x,_loc6_.y),null,null,true);
                  _loc5_++;
               }
            }
            return;
         }
      }
      
      public static function RandomProperty(param1:b2Body, param2:int = 1) : void
      {
         var _loc4_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param1.IsStatic())
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(_loc3_.name == "wall")
         {
            return;
         }
         var _loc5_:Array = ["alchemying","alive","animated","antigrav","banning","blighting","blunt","breakable","brittle","bulletproof","burning","cleaning","concussing","critting","crumble","deleting","disintegrator","dispelling","draining","drying","explosive","flaming","freezing","frostfiring","frying","glassing","glitching","gusting","healing","hyping","implosive","killing","petrifying","poisoning","radioactive","regenerating","rending","sanguine","scorching","sensor","sharp","shocking","sticky","suspending","transmuting","ultrasharp","webbing","wetting","zerograv"];
         if(param2 == 1)
         {
            _loc4_ = _loc5_[_loc5_.length * Math.random() >> 0];
         }
         else
         {
            _loc4_ = "";
            _loc6_ = 0;
            while(_loc6_ < param2)
            {
               _loc7_ = _loc5_[_loc5_.length * Math.random() >> 0];
               _loc4_ = _loc7_ + ",";
               _loc6_++;
            }
            if(_loc4_.substr(-1) == ",")
            {
               _loc4_ = _loc4_.slice(0,-1);
            }
         }
         _loc3_.setProperties(_loc4_);
      }
      
      public static function FixBrokenItem(param1:b2Body) : void
      {
         var _loc2_:userData = userData(param1.GetUserData());
         var _loc3_:Number = Vars.objSize;
         Vars.objSize = _loc2_.size;
         var _loc4_:b2Body = GameState.objects.spawnObject(_loc2_.itemName,param1.GetPosition().x * Physics.scale,param1.GetPosition().y * Physics.scale,param1.GetAngle() * Vars.toDegrees,_loc2_.flipped,true,_loc2_.skin);
         userData(_loc4_.GetUserData()).triggerCustom = _loc2_.triggerCustom;
         Vars.objSize = _loc3_;
         FixJoints(param1,_loc4_);
         if(_loc2_.bleeding.length > 0)
         {
            _loc2_.bleeding = [];
         }
         Body.RemoveJoints(param1);
         _loc2_.dead = true;
         if(_loc2_.alive)
         {
            Body.Disintegrate(param1,"blood",50,5,5);
         }
         else
         {
            Body.Disintegrate(param1,"poof",50,5,5);
         }
      }
      
      private static function FixJoints(param1:b2Body, param2:b2Body) : void
      {
         var _loc3_:b2Body = null;
         var _loc5_:b2RevoluteJoint = null;
         var _loc4_:b2JointEdge = param1.GetJointList();
         while(_loc4_)
         {
            if(_loc4_.joint is b2RevoluteJoint)
            {
               if(_loc4_.joint.m_body1 == param1)
               {
                  _loc3_ = _loc4_.joint.m_body2;
               }
               else
               {
                  _loc3_ = _loc4_.joint.m_body1;
               }
               _loc5_ = Joints.Revolution("rag",_loc3_,param2,_loc4_.joint.GetAnchor1().x * Physics.scale,_loc4_.joint.GetAnchor1().y * Physics.scale,_loc4_.joint.GetUserData().lowerAngle,_loc4_.joint.GetUserData().upperAngle);
               if(_loc5_)
               {
                  jointUserData(_loc5_.GetUserData()).defaultLA = _loc4_.joint.GetUserData().defaultLA;
                  jointUserData(_loc5_.GetUserData()).defaultUA = _loc4_.joint.GetUserData().defaultUA;
                  jointUserData(_loc5_.GetUserData()).defaultFL = _loc4_.joint.GetUserData().defaultFL;
                  jointUserData(_loc5_.GetUserData()).forceLimit = _loc4_.joint.GetUserData().forceLimit;
               }
            }
            _loc4_ = _loc4_.next;
         }
      }
      
      public static function GrowMissingBodypart(param1:b2Body) : Boolean
      {
         var _loc13_:jointUserData = null;
         var _loc14_:b2Joint = null;
         var _loc16_:String = null;
         var _loc17_:Boolean = false;
         var _loc18_:b2JointEdge = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:b2Vec2 = null;
         var _loc22_:b2Vec2 = null;
         var _loc23_:Boolean = false;
         var _loc24_:Number = NaN;
         var _loc25_:Vector.<Array> = null;
         var _loc26_:b2Body = null;
         var _loc27_:Array = null;
         var _loc28_:b2Vec2 = null;
         var _loc29_:Sprite = null;
         var _loc30_:int = 0;
         var _loc31_:b2Body = null;
         var _loc32_:userData = null;
         var _loc2_:Array = ["head","L_thigh","R_thigh","L_calf","R_calf","shoulders","stomach","hips","L_arm","R_arm","L_hand","R_hand"];
         var _loc3_:Array = ["head","leg","leg","foot","foot","body","body","body","arm","arm","hand","hand"];
         var _loc4_:Array = [new b2Vec2(0,0),new b2Vec2(-10,90),new b2Vec2(10,90),new b2Vec2(-8,125),new b2Vec2(8,125),new b2Vec2(0,28),new b2Vec2(0,43),new b2Vec2(0,58),new b2Vec2(-30,24),new b2Vec2(30,24),new b2Vec2(-57,24),new b2Vec2(57,24)];
         var _loc5_:Array = [300,100,100,100,100,200,200,200,100,100,100,100];
         var _loc6_:Array = [[0,15,-20,20],[0,35,-5,5],[0,50,-5,5],[-8,68,-45,45],[8,68,-45,45],[-8,105,-100,100],[8,105,-100,100],[-18,24,-130,130],[18,24,-130,130],[-45,24,-130,130],[45,24,-130,130]];
         var _loc7_:Object = {
            "head":["shoulders"],
            "shoulders":["L_arm","R_arm","stomach","head"],
            "L_arm":["L_hand","shoulders"],
            "R_arm":["R_hand","shoulders"],
            "stomach":["hips","shoulders"],
            "hips":["stomach","L_thigh","R_thigh"],
            "L_thigh":["hips","L_calf"],
            "R_thigh":["hips","R_calf"],
            "L_calf":["L_thigh"],
            "R_calf":["R_thigh"],
            "L_hand":["L_arm"],
            "R_hand":["R_arm"]
         };
         var _loc8_:Object = {
            "head":[0],
            "shoulders":[7,8,1,0],
            "L_arm":[9,7],
            "R_arm":[10,8],
            "stomach":[2,1],
            "hips":[2,3,4],
            "L_thigh":[3,5],
            "R_thigh":[4,6],
            "L_calf":[5],
            "R_calf":[6],
            "L_hand":[9],
            "R_hand":[10]
         };
         var _loc9_:userData = userData(param1.GetUserData());
         if(!_loc9_.triggerCustom)
         {
            return false;
         }
         var _loc10_:String = _loc9_.name;
         var _loc11_:b2Vec2 = param1.GetPosition().Copy();
         _loc11_.Multiply(Physics.scale);
         var _loc12_:Array = _loc7_[_loc9_.triggerCustom];
         if(!_loc12_)
         {
            return false;
         }
         var _loc15_:int = 0;
         while(_loc15_ < _loc12_.length)
         {
            _loc16_ = _loc12_[_loc15_];
            _loc17_ = false;
            _loc18_ = param1.GetJointList();
            while(_loc18_)
            {
               _loc14_ = _loc18_.joint;
               _loc13_ = jointUserData(_loc14_.GetUserData());
               if(_loc13_.name == "rag")
               {
                  if(_loc14_.GetBody1() == param1)
                  {
                     _loc31_ = _loc14_.GetBody2();
                  }
                  else
                  {
                     _loc31_ = _loc14_.GetBody1();
                  }
                  _loc32_ = userData(_loc31_.GetUserData());
                  if(_loc32_.alive)
                  {
                     if(_loc32_.triggerCustom == _loc16_)
                     {
                        _loc17_ = true;
                        break;
                     }
                  }
               }
               _loc18_ = _loc18_.next;
            }
            if(!_loc17_)
            {
               _loc19_ = _loc2_.indexOf(_loc9_.triggerCustom);
               _loc20_ = _loc2_.indexOf(_loc16_);
               _loc21_ = _loc11_.Copy();
               _loc22_ = b2Vec2(_loc4_[_loc19_]).Copy();
               _loc22_.Subtract(b2Vec2(_loc4_[_loc20_]));
               _loc22_.Multiply(_loc9_.size);
               _loc21_.Subtract(_loc22_);
               _loc23_ = false;
               _loc24_ = Vars.objSize;
               Vars.objSize = _loc9_.size;
               _loc25_ = GameState.objects.spawnSkin;
               GameState.objects.spawnSkin = _loc9_.skin.slice();
               _loc26_ = GameState.objects.spawnObject("doll_" + _loc3_[_loc20_],_loc21_.x,_loc21_.y,0,_loc23_,true,_loc9_.skin);
               userData(_loc26_.GetUserData()).triggerCustom = _loc2_[_loc20_];
               userData(_loc26_.GetUserData()).id = _loc9_.id;
               userData(_loc26_.GetUserData()).maxhealth = _loc5_[_loc20_] * _loc9_.size * 50;
               userData(_loc26_.GetUserData()).health = _loc5_[_loc20_] * _loc9_.size * 50;
               Vars.objSize = _loc24_;
               GameState.objects.spawnSkin = _loc25_;
               if(_loc9_.triggerCustom == "L_arm")
               {
                  userData(_loc26_.GetUserData()).triggerState = -1;
               }
               BoxUtils.rotateAroundPoint(param1.GetPosition(),param1.GetAngle(),[_loc26_]);
               _loc27_ = _loc6_[_loc8_[_loc9_.triggerCustom][_loc15_]];
               _loc28_ = _loc11_.Copy();
               _loc28_.Add(new b2Vec2(_loc27_[0],_loc27_[1]));
               _loc28_.Subtract(_loc4_[_loc19_]);
               _loc28_.x = param1.GetPosition().x * Physics.scale + (-_loc4_[_loc19_].x + _loc27_[0]) * _loc9_.size;
               _loc28_.y = param1.GetPosition().y * Physics.scale + (-_loc4_[_loc19_].y + _loc27_[1]) * _loc9_.size;
               _loc28_ = BoxUtils.rotateVecAroundPoint(_loc28_,param1.GetAngle(),_loc11_);
               Joints.Revolution("rag",_loc26_,param1,_loc28_.x,_loc28_.y,_loc27_[2],_loc27_[3],false,50000);
               _loc29_ = userData(_loc26_.GetUserData()).graphic;
               _loc30_ = 0;
               while(_loc30_ < 10 + Math.random() * 10)
               {
                  BoxUtils.randomParticlesOnBody(_loc26_,"heal",2);
                  _loc30_++;
               }
               if(_loc29_)
               {
                  if(_loc3_[_loc20_] == "leg" || _loc3_[_loc20_] == "foot" || _loc3_[_loc20_] == "body")
                  {
                     _loc29_.scaleX = 0.1;
                     Tweener.addTween(_loc29_,{
                        "scaleX":1,
                        "delay":0.2 + Math.random() * 0.6,
                        "time":(0.2 + Math.random() * 0.4) / TimeLord.timerSpeed,
                        "transition":"easeOutBack"
                     });
                  }
                  else
                  {
                     _loc29_.scaleY = 0.1;
                     Tweener.addTween(_loc29_,{
                        "scaleY":1,
                        "delay":0.2 + Math.random() * 0.6,
                        "time":(0.2 + Math.random() * 0.4) / TimeLord.timerSpeed,
                        "transition":"easeOutBack"
                     });
                  }
               }
               return true;
            }
            _loc15_++;
         }
         return false;
      }
      
      public static function Worm(param1:b2Body) : void
      {
         var _loc2_:userData = param1.GetUserData();
         if(_loc2_.resistBlighting)
         {
            return;
         }
         _loc2_.trigger = new Infested();
         _loc2_.triggered = true;
      }
      
      public static function Slap(param1:b2Body) : b2Vec2
      {
         var _loc5_:Sprite = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:b2Vec2 = new b2Vec2();
         var _loc3_:userData = userData(param1.GetUserData());
         _loc2_.x = Math.random() * _loc3_.width - _loc3_.width * 0.5;
         _loc2_.y = Math.random() * _loc3_.height - _loc3_.height * 0.5;
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc4_)
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(0,0,0);
            _loc6_ = new b2Vec2();
            _loc6_.Multiply(Physics.scale);
            _loc6_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
            _loc6_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
            _loc5_.graphics.beginFill(_loc3_.bloodColour,Math.random() * 0.2 + 0.1);
            _loc7_ = _loc6_.x + _loc2_.x;
            _loc8_ = _loc6_.y + _loc2_.y;
            _loc5_.graphics.drawCircle(_loc7_,_loc8_,Math.random() * 2 + 3);
            _loc5_.graphics.beginFill(GraphicUtils.scalehex(_loc3_.bloodColour,0.5),Math.random() * 0.2 + 0.1);
            _loc5_.graphics.drawCircle(_loc7_ + Math.random() * 2 - 1,_loc8_ + Math.random() * 2 - 1,Math.random() * 2 + 1);
            _loc5_.graphics.endFill();
            _loc4_.draw(_loc5_);
         }
         Damage(param1,Math.random() * 100 + 100);
         return new b2Vec2(_loc7_,_loc8_);
      }
      
      public static function Bite(param1:b2Body) : b2Vec2
      {
         var _loc5_:Sprite = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:b2Vec2 = new b2Vec2();
         var _loc3_:userData = userData(param1.GetUserData());
         _loc2_.x = Math.random() * _loc3_.width - _loc3_.width * 0.5;
         _loc2_.y = Math.random() * _loc3_.height - _loc3_.height * 0.5;
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc4_)
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(0,0,0);
            _loc6_ = new b2Vec2();
            _loc6_.Multiply(Physics.scale);
            _loc6_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
            _loc6_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
            _loc5_.graphics.beginFill(_loc3_.bloodColour,1);
            _loc7_ = _loc6_.x + _loc2_.x;
            _loc8_ = _loc6_.y + _loc2_.y;
            _loc5_.graphics.drawCircle(_loc7_,_loc8_,Math.random() * 2 + 3);
            _loc5_.graphics.beginFill(GraphicUtils.scalehex(_loc3_.bloodColour,0.5),1);
            _loc5_.graphics.drawCircle(_loc7_ + Math.random() * 2 - 1,_loc8_ + Math.random() * 2 - 1,Math.random() * 2 + 1);
            _loc5_.graphics.endFill();
            _loc4_.draw(_loc5_);
         }
         Damage(param1,Math.random() * 1000 + 100);
         _loc2_.Multiply(1 / Physics.scale);
         if(!_loc3_.resistBleed)
         {
            _loc3_.bleeding.push([_loc2_,_loc2_,new b2Vec2(),10]);
         }
         return new b2Vec2(_loc7_,_loc8_);
      }
      
      public static function BloodParticles(param1:b2Body, param2:b2Vec2, param3:b2Vec2 = null, param4:b2Vec2 = null) : void
      {
         if(!param3)
         {
            param3 = new b2Vec2(0,0);
         }
         if(!param4)
         {
            param4 = new b2Vec2(1,1);
         }
         var _loc5_:uint = Tweak.bloodColour;
         var _loc6_:userData = param1.GetUserData();
         if((Boolean(_loc6_)) && Boolean(_loc6_.bloodColour))
         {
            Tweak.bloodColour = _loc6_.bloodColour;
         }
         GameState.particles.addParticles(param2.x,param2.y,1,"blood",param3.x,param3.y,param4.x,param4.y);
         if(_loc5_)
         {
            Tweak.bloodColour = _loc5_;
         }
      }
      
      public static function Poison(param1:b2Body, param2:b2Vec2, param3:Number) : void
      {
         var _loc4_:userData = param1.GetUserData();
         if(_loc4_.resistPoison)
         {
            return;
         }
         _loc4_.trigger = new Poisoned();
         _loc4_.triggerDuration = param3;
         _loc4_.triggered = true;
      }
      
      public static function Toxic(param1:b2Body, param2:b2Vec2) : void
      {
         var _loc3_:userData = param1.GetUserData();
         if(_loc3_.resistPoison)
         {
            return;
         }
         ToxicEffect(param1,param2);
         var _loc4_:Number = _loc3_.maxhealth * 0.1;
         var _loc5_:b2Vec2 = param1.GetLinearVelocity().Copy();
         _loc5_.Multiply(0.01);
         Damage(param1,_loc4_,param2,_loc5_,new b2Vec2(2,2),false);
         if(_loc3_.health - _loc4_ <= _loc3_.maxhealth * 0.5)
         {
            Main.instance.brittleArray.push(param1);
         }
         GameState.particles.addParticles(param1.GetPosition().x * Physics.scale,param1.GetPosition().x * Physics.scale,2,"poison",Math.random() * 20 - 10,Math.random() * 20 - 10,1,1);
         _loc3_.trigger = new Poisoned();
         _loc3_.triggerDuration = 240;
         _loc3_.triggered = true;
      }
      
      public static function ToxicEffect(param1:b2Body, param2:b2Vec2) : void
      {
         var _loc5_:Sprite = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:int = 0;
         var _loc3_:userData = param1.GetUserData();
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc4_)
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(0,0,0);
            _loc6_ = param1.GetLocalPoint(param2).Copy();
            _loc6_.Multiply(Physics.scale);
            _loc6_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
            _loc6_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
            _loc7_ = 0;
            while(_loc7_ < 4)
            {
               if(Math.random() > 0.5)
               {
                  _loc5_.graphics.beginFill(9284969,Math.random());
               }
               else
               {
                  _loc5_.graphics.beginFill(5537551,Math.random());
               }
               _loc5_.graphics.drawCircle(_loc6_.x + Math.random() * 20 - 10,_loc6_.y + Math.random() * 20 - 10,Math.random() * 5 + 1);
               _loc5_.graphics.endFill();
               _loc7_++;
            }
            _loc4_.draw(_loc5_);
         }
      }
      
      public static function BulletPenetrate(param1:b2Body, param2:b2Body, param3:b2ContactPoint) : *
      {
         var _loc4_:userData = param2.GetUserData();
         var _loc5_:userData = param1.GetUserData();
         if(_loc4_.multiBulletPenetration == 0)
         {
            _loc5_.dead = true;
            return;
         }
         Stab(param1,param2,param3,0.02 * _loc4_.multiBulletPenetration,false);
         var _loc6_:b2Vec2 = param1.GetLinearVelocity().Copy();
         _loc6_.Multiply(_loc5_.size * _loc5_.triggerForce);
         _loc6_.Multiply(0.2 / _loc4_.multiBulletPenetration);
         param2.ApplyForce(_loc6_,param2.GetWorldCenter());
      }
      
      public static function Stab(param1:b2Body, param2:b2Body, param3:b2ContactPoint, param4:Number = 1, param5:Boolean = true) : void
      {
         var _loc6_:userData = param1.GetUserData() as userData;
         var _loc7_:userData = param2.GetUserData() as userData;
         if(_loc6_.isStabbing(param2))
         {
            return;
         }
         var _loc8_:StabData = new StabData(param1,param2);
         var _loc9_:b2Vec2 = param3.position.Copy();
         var _loc10_:b2Vec2 = _loc9_.Copy();
         var _loc11_:b2Vec2 = _loc9_.Copy();
         _loc10_.Add(param1.GetLinearVelocity().Copy());
         _loc11_.Subtract(param1.GetLinearVelocity().Copy());
         _loc8_.AddJoint(Joints.Distance("stabjoint",param1,param2,_loc9_,_loc9_,1,0,false,1));
         var _loc12_:Number = 30;
         if(param4 > 0)
         {
            if(param3.velocity.Length() < _loc12_)
            {
               param4 = 0;
            }
         }
         if(!param5 && param4 == 0)
         {
            param4 = 0.001;
         }
         if(param4 > 0)
         {
            _loc8_.AddJoint(Joints.Distance("stabjoint",param1,param2,_loc9_,_loc9_,5 * param4 * _loc7_.multiStabDensity,0.001,false,100 / param4));
            _loc9_.Add(param3.normal);
            _loc8_.AddJoint(Joints.Distance("stabjoint",param1,param2,_loc9_,_loc9_,5 * param4 * _loc7_.multiStabDensity,0.001,false,100 / param4));
         }
         if(param5)
         {
            _loc8_.AddJoint(Joints.Prismatic("stabjoint",param1,param2,param3.position,_loc10_,100));
         }
         param1.GetLinearVelocity().Multiply(Math.max(0,1 - (0.1 + Math.random() * 0.3) * _loc7_.multiStabDensity));
         _loc6_.Stab(_loc8_);
      }
      
      public static function BulletHole(param1:b2Body, param2:b2Body, param3:b2ContactPoint) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:userData = null;
         var _loc9_:BitmapData = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Sprite = null;
         var _loc15_:Bitmap = null;
         var _loc16_:uint = 0;
         var _loc17_:int = 0;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:b2Vec2 = null;
         var _loc21_:int = 0;
         var _loc22_:b2Vec2 = null;
         var _loc23_:Number = NaN;
         var _loc24_:b2Vec2 = null;
         if(World.toggleGore == 0)
         {
            return;
         }
         var _loc4_:b2Vec2 = param3.position.Copy();
         _loc4_.Multiply(Physics.scale);
         var _loc5_:Array = GetAroundPoint(_loc4_,20,20);
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = _loc6_.GetUserData() as userData;
            if(_loc7_.alive)
            {
               if(!_loc7_.armoured)
               {
                  _loc8_ = param2.GetUserData() as userData;
                  _loc9_ = BoxUtils.getEffectBMD(_loc6_);
                  if(!_loc9_)
                  {
                     return;
                  }
                  _loc10_ = param3.position;
                  _loc11_ = param2.GetLinearVelocity();
                  _loc12_ = _loc6_.GetLocalPoint(_loc10_);
                  _loc13_ = _loc6_.GetLocalPoint(new b2Vec2(_loc10_.x + _loc11_.x * 0.005,_loc10_.y + _loc11_.y * 0.005));
                  if(_loc6_ == param1)
                  {
                     _loc23_ = 1;
                     if(_loc8_.triggerForce)
                     {
                        _loc23_ = _loc8_.triggerForce * _loc8_.size;
                     }
                     _loc7_.bleeding.push([_loc12_.Copy(),_loc13_,param3.normal.Copy(),_loc23_]);
                  }
                  _loc14_ = new Sprite();
                  _loc12_ = _loc10_;
                  _loc13_ = new b2Vec2(_loc10_.x + _loc11_.x * 0.01,_loc10_.y + _loc11_.y * 0.01);
                  _loc15_ = BoxUtils.getEffectBM(param1);
                  if(_loc15_)
                  {
                     _loc17_ = 3 + Math.abs(_loc12_.Length() - _loc13_.Length());
                     if(_loc17_ > 20)
                     {
                        _loc17_ = 20;
                     }
                     _loc18_ = Math.min(1 / Physics.scale,(_loc13_.x - _loc12_.x) / _loc17_);
                     _loc19_ = Math.min(1 / Physics.scale,(_loc13_.y - _loc12_.y) / _loc17_);
                     _loc21_ = 0;
                     while(_loc21_ < _loc17_)
                     {
                        _loc16_ = GraphicUtils.scalehex(_loc7_.bloodColour,1.1 - Math.random() * 0.2);
                        _loc20_ = new b2Vec2(_loc12_.x + _loc18_ * _loc21_,_loc12_.y + _loc19_ * _loc21_);
                        _loc22_ = _loc6_.GetLocalPoint(_loc20_).Copy();
                        _loc22_.Multiply(Physics.scale);
                        _loc22_.x -= _loc15_.x;
                        _loc22_.y -= _loc15_.y;
                        _loc14_.graphics.beginFill(_loc16_,0.6 + Math.random() * 0.6);
                        _loc14_.graphics.drawCircle(_loc22_.x,_loc22_.y,1 + 1 / (_loc21_ + 1) * _loc8_.size * 4);
                        _loc14_.graphics.endFill();
                        _loc21_++;
                     }
                     _loc21_ = 0;
                     while(_loc21_ < _loc17_ * 0.5)
                     {
                        _loc16_ = GraphicUtils.scalehex(_loc7_.bloodColour,0.7 - Math.random() * 0.2);
                        _loc20_ = new b2Vec2(_loc12_.x + Math.random() * (_loc18_ * _loc21_),_loc12_.y + Math.random() * (_loc19_ * _loc21_));
                        _loc22_ = _loc6_.GetLocalPoint(_loc20_).Copy();
                        _loc22_.Multiply(Physics.scale);
                        _loc22_.x -= _loc15_.x;
                        _loc22_.y -= _loc15_.y;
                        _loc14_.graphics.beginFill(_loc16_,0.5 + Math.random() * 0.5);
                        _loc14_.graphics.drawCircle(_loc22_.x,_loc22_.y,1 + Math.random() * _loc8_.size * 2);
                        _loc14_.graphics.endFill();
                        _loc21_++;
                     }
                     _loc21_ = 0;
                     while(_loc21_ < 5 + Math.random() * Math.random() * 20)
                     {
                        _loc16_ = GraphicUtils.scalehex(_loc7_.bloodColour,1.1 - Math.random() * 0.2);
                        _loc24_ = BoxUtils.randomPointOnBody(_loc6_);
                        _loc14_.graphics.beginFill(_loc16_,0.5 + Math.random() * 0.5);
                        _loc14_.graphics.drawCircle(_loc24_.x - _loc15_.x,_loc24_.y - _loc15_.y,1 + Math.random() * _loc8_.size * 2);
                        _loc14_.graphics.endFill();
                        _loc21_++;
                     }
                     _loc22_ = _loc6_.GetLocalPoint(_loc10_).Copy();
                     _loc22_.Multiply(Physics.scale);
                     _loc22_.x -= _loc15_.x;
                     _loc22_.y -= _loc15_.y;
                     _loc14_.graphics.beginFill(GraphicUtils.scalehex(_loc16_,0.5),1);
                     _loc14_.graphics.drawCircle(_loc22_.x,_loc22_.y,_loc8_.size * 3);
                     _loc14_.graphics.endFill();
                     _loc9_.draw(_loc14_);
                  }
               }
            }
         }
      }
      
      public static function Brick(param1:b2Body, param2:Number = 6, param3:Number = 0.5, param4:Number = 100, param5:Array = null) : void
      {
         var _loc6_:Vector.<Array> = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Body = null;
         var _loc13_:b2Vec2 = null;
         if(!param1)
         {
            return;
         }
         if(!param5)
         {
            param5 = [15922162,1780276,16108847,12855323,879019,10593698];
         }
         Body.Destroy(param1,"bricked");
         _loc6_ = new Vector.<Array>();
         _loc6_.push(["ca392d","FFFFFF"]);
         _loc6_.push(["e03f33","FFFFFF"]);
         _loc7_ = 0;
         while(_loc7_ < Math.random() * param2 + param2 * 0.5)
         {
            _loc8_ = uint(param5[int(Math.random() * param5.length)]);
            _loc6_ = BoxUtils.replaceSkinColour(_loc6_,"ca392d",GraphicUtils.scalehex(_loc8_,0.9).toString(16));
            _loc6_ = BoxUtils.replaceSkinColour(_loc6_,"e03f33",_loc8_.toString(16));
            _loc9_ = GameState.objects.spawnSkin;
            GameState.objects.spawnSkin = _loc6_;
            _loc10_ = Vars.objSize;
            Vars.objSize = param3;
            _loc11_ = BoxUtils.randomPointOnBody(param1,true);
            _loc12_ = GameState.objects.delayedSpawnObject(Math.random() > 0.5 ? "legobrick" : "smalllegobrick",_loc11_.x,_loc11_.y,Math.random() * 360,false,true);
            GameState.objects.spawnSkin = _loc9_;
            userData(_loc12_.GetUserData()).ignore = "legobrick";
            userData(_loc12_.GetUserData()).trigger = new TempProjectile(60 + Math.random() * 60);
            userData(_loc12_.GetUserData()).triggerOnContact = true;
            _loc13_ = new b2Vec2(Math.random() - 0.5,Math.random() - 0.5);
            _loc13_.Multiply(param4);
            _loc12_.ApplyImpulse(_loc13_,_loc12_.GetWorldCenter());
            Vars.objSize = _loc10_;
            _loc7_++;
         }
      }
      
      public static function Burn(param1:b2Body, param2:b2Vec2, param3:Number, param4:Number = 10, param5:Number = 20) : void
      {
         if(!param1)
         {
            return;
         }
         Damage(param1,param3,param2,null,null,false);
         BurnEffect(param1,param2,param4,param5);
      }
      
      public static function BurnEffect(param1:b2Body, param2:b2Vec2, param3:Number = 10, param4:Number = 20) : void
      {
         var _loc5_:userData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Sprite = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:int = 0;
         _loc5_ = param1.GetUserData();
         _loc6_ = BoxUtils.getEffectBMD(param1);
         if(!_loc6_)
         {
            return;
         }
         _loc6_.lock();
         _loc7_ = new Sprite();
         _loc7_.graphics.lineStyle(0,0,0);
         _loc8_ = param1.GetLocalPoint(param2).Copy();
         _loc8_.Multiply(Physics.scale);
         _loc8_.x -= Bitmap(_loc5_.graphic.getChildByName("effects")).x;
         _loc8_.y -= Bitmap(_loc5_.graphic.getChildByName("effects")).y;
         _loc9_ = 0;
         while(_loc9_ < param3)
         {
            if(Math.random() > 0.5 || !_loc5_.alive)
            {
               _loc7_.graphics.beginFill(1118481,Math.random());
            }
            else
            {
               _loc7_.graphics.beginFill(_loc5_.bloodColour,Math.random());
            }
            _loc7_.graphics.drawRect(_loc8_.x + Math.random() * param4 - param4 * 0.5,_loc8_.y + Math.random() * param4 - param4 * 0.5,Math.random() * 5,Math.random() * 5);
            _loc7_.graphics.endFill();
            _loc9_++;
         }
         _loc6_.draw(_loc7_);
         _loc6_.unlock();
      }
      
      public static function ToggleStatic(param1:b2Body, param2:Boolean) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Body = null;
         _loc3_ = Vars.objDensity;
         if(param2)
         {
            Vars.objDensity = 0;
         }
         _loc4_ = Respawn(param1);
         if(_loc4_)
         {
            userData(_loc4_.GetUserData()).density = Vars.objDensity;
         }
         Vars.objDensity = _loc3_;
      }
      
      public static function Respawn(param1:b2Body) : b2Body
      {
         return Scale(param1,userData(param1.GetUserData()).size,false);
      }
      
      public static function IsAlive(param1:String) : Boolean
      {
         var _loc2_:Array = null;
         _loc2_ = ["ragdoll","alivepane"];
         if(_loc2_.indexOf(param1) != -1)
         {
            return true;
         }
         if(Boolean(param1) && param1.indexOf("doll_") != -1)
         {
            return true;
         }
         if(Properties.forceObjAlive)
         {
            return true;
         }
         return false;
      }
      
      public static function IsGun(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         _loc2_ = GameState.ui.menuLibrary.getTree("buttons").findNode("object",param1);
         if(Boolean(_loc2_.projectile) || Boolean(_loc2_.gun))
         {
            return true;
         }
         return false;
      }
      
      public static function Overwhelm(param1:b2Body) : void
      {
         var _loc2_:userData = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         _loc2_ = param1.GetUserData();
         _loc3_ = _loc2_.overwhelmDamages;
         _loc4_ = int(_loc3_.length);
         _loc5_ = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ += _loc3_[_loc6_];
            _loc6_++;
         }
         if(_loc5_ > 100 * _loc2_.multiConcussion)
         {
            Concuss(param1,Math.min(120,_loc5_ * 0.25));
         }
         _loc2_.overwhelmDamages = [];
         _loc2_.overwhelmAmount = 0;
      }
      
      public static function ApplyEffect(param1:b2Body, param2:String, param3:b2Vec2 = null, param4:b2Body = null) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:userData = null;
         _loc5_ = 60;
         _loc6_ = 100;
         var _loc7_:Number = 100;
         if(param4)
         {
            _loc8_ = param4.GetUserData();
            _loc5_ = _loc8_.triggerDuration;
            _loc6_ = _loc8_.triggerForce;
            _loc7_ = _loc8_.triggerRadius;
         }
         switch(param2.toLowerCase())
         {
            case "cray":
               Crabify(param1);
               break;
            case "sting":
               Sting(param1,param3);
               break;
            case "lava":
               Lava(param1);
               break;
            case "snared":
               Snared(param1,_loc5_);
               break;
            case "sandstone":
               Sandstone(param1);
               break;
            case "exsanguinate":
               Exsanguinate(param1);
               break;
            case "cookie":
               Cookie(param1);
               break;
            case "mutate":
               Mutate(param1);
               break;
            case "drone":
               Drone(param1);
               break;
            case "cauterize":
               Cauterize(param1);
               break;
            case "stasis":
               Stasis(param1,_loc5_);
               break;
            case "blight":
               Blight(param1,_loc5_);
               break;
            case "food":
               Food(param1);
               break;
            case "bling":
               Bling(param1);
               break;
            case "dispel":
               Dispel(param1);
               break;
            case "growth":
               Growth(param1);
               break;
            case "frostfire":
               Frostfire(param1);
               break;
            case "glitch":
               Glitch(param1);
               break;
            case "glitchnocolours":
               Glitch(param1,false);
               break;
            case "deepfry":
               Deepfry(param1);
               break;
            case "rust":
               Rust(param1);
               break;
            case "gib":
               Gib(param1);
               break;
            case "faceplant":
               Faceplant(param1,param3,_loc6_);
               break;
            case "respect":
               HandGrab(param4,_loc6_);
               break;
            case "jump":
               Jump(param1,_loc6_);
               param4.GetUserData().dead = true;
               break;
            case "left":
               Left(param1,_loc6_);
               break;
            case "right":
               Right(param1,_loc6_);
               break;
            case "down":
               Down(param1,_loc6_);
               break;
            case "crouch":
               Crouch(param1,_loc6_);
               param4.GetUserData().dead = true;
               break;
            case "rainbow":
               Rainbow(param1);
               break;
            case "animate":
               Animate(param1);
               break;
            case "upgrade":
               Upgrade(param1);
               break;
            case "protect":
               Protect(param1,_loc5_);
               break;
            case "ghost":
               Ghost(param1);
               break;
            case "glass":
               Glass(param1,_loc6_);
               break;
            case "wet":
               Wet(param1,param3);
               break;
            case "petrify":
               Petrify(param1);
               break;
            case "freeze":
               Freeze(param1);
               break;
            case "clone":
               Clone(param1,param3);
               break;
            case "kill":
               Kill(param1,param3);
               break;
            case "fixbrokenitem":
               FixBrokenItem(param1);
               break;
            case "worm":
               Worm(param1);
               break;
            case "bite":
               Bite(param1);
               break;
            case "poison":
               Poison(param1,param3,_loc5_);
               break;
            case "toxic":
               Toxic(param1,param3);
               break;
            case "brick":
               Brick(param1,6,0.5,_loc6_);
               break;
            case "burn":
               Burn(param1,param3,_loc6_);
               break;
            case "radiation":
               Radiation(param1);
               break;
            case "clingy":
               Clingy(param1,_loc6_);
               break;
            case "shock":
               Shock(param1,_loc5_);
               break;
            case "emp":
               EMP(param1);
         }
      }
      
      public static function VisualEffect(param1:b2Body, param2:String, param3:b2Vec2 = null) : void
      {
         switch(param2)
         {
            case "radiation":
               RadiationEffect(param1);
               break;
            case "cookie":
               CookieEffect(param1);
               break;
            case "cauterize":
               CauterizeEffect(param1);
               break;
            case "blight":
               BlightEffect(param1,param3);
               break;
            case "frostfire":
               FrostfireEffect(param1);
               break;
            case "deepfry":
               DeepfryEffect(param1);
               break;
            case "ghost":
               GhostEffect(param1);
               break;
            case "glass":
               GlassEffect(param1);
               break;
            case "petrify":
               PetrifyEffect(param1);
               break;
            case "freeze":
               FreezeEffect(param1);
               break;
            case "toxic":
               ToxicEffect(param1,param3);
               break;
            case "burn":
               BurnEffect(param1,param3);
         }
      }
      
      public static function MeltIntoPaint(param1:b2Body, param2:Number = 20) : void
      {
         var _loc3_:Item = null;
         var _loc4_:Array = null;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:String = null;
         var _loc10_:b2Body = null;
         var _loc11_:userData = null;
         if(!param1 || !param1.GetUserData() || Boolean(param1.GetUserData().dead))
         {
            return;
         }
         _loc3_ = O.getItem(userData(param1.GetUserData()).itemName);
         if(!_loc3_)
         {
            return;
         }
         _loc4_ = _loc3_.colours;
         _loc5_ = userData(param1.GetUserData()).skin;
         _loc6_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
         _loc7_ = 0;
         for(; _loc7_ < param2; _loc7_++)
         {
            _loc9_ = _loc8_ = _loc4_[int(_loc4_.length * Math.random())];
            if(_loc8_ is ShapeUserData)
            {
               if(ShapeUserData(_loc8_).invisible)
               {
                  continue;
               }
               _loc9_ = ShapeUserData(_loc8_).name;
            }
            if(_loc5_)
            {
               _loc9_ = BoxUtils.getSkinColour(_loc5_,_loc9_).toString(16);
            }
            _loc10_ = GameState.objects.spawnItem(_loc6_,[1],1,"monochrome",0,0,0,[_loc9_]);
            _loc10_.SetLinearVelocity(param1.GetLinearVelocity().Copy());
            _loc10_.ApplyForce(new b2Vec2(Math.random() * 10 - 5,Math.random() * 10 - 5),_loc10_.GetWorldCenter());
            _loc10_.SetXForm(BoxUtils.randomPointOnBody(param1),0);
            _loc11_ = _loc10_.GetUserData();
            _loc11_.saveable = false;
            _loc11_.ignore = "monochrome";
            _loc11_.trigger = new Egg([_loc9_],3,5);
            _loc11_.triggerForce = 1;
            _loc11_.triggerContact = 0.001;
         }
         Disintegrate(param1,"inherit",100,Math.random() * 5,Math.random() * 5);
      }
      
      public static function Clingy(param1:b2Body, param2:Number = 50) : void
      {
         var _loc3_:Array = null;
         var _loc4_:b2Body = null;
         _loc3_ = GetAround(param1,param2,param2);
         for each(_loc4_ in _loc3_)
         {
            if(Math.random() <= 0.5)
            {
               if(_loc4_.GetMass() >= 0.1)
               {
                  if(_loc4_.GetUserData().saveable)
                  {
                     Gummy(param1,_loc4_,uint("0x" + param1.GetUserData().triggerColour));
                  }
               }
            }
         }
      }
      
      public static function Gummy(param1:b2Body, param2:b2Body, param3:uint) : void
      {
         var _loc4_:userData = null;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<Array> = null;
         var _loc10_:b2PrismaticJoint = null;
         _loc4_ = param1.GetUserData();
         var _loc5_:userData = param2.GetUserData();
         var _loc6_:b2Vec2 = BoxUtils.randomPointOnBody(param1);
         var _loc7_:b2Vec2 = BoxUtils.randomPointOnBody(param2);
         _loc8_ = param3;
         _loc9_ = _loc4_.skin;
         if((Boolean(_loc9_)) && _loc9_.length > 0)
         {
            _loc8_ = BoxUtils.getSkinColour(_loc9_,param3.toString(16));
         }
         _loc10_ = Joints.Prismatic("randomjoint",param1,param2,new b2Vec2(),BoxUtils.randomPointOnBody(param1),100000);
         _loc10_.SetMaxMotorForce(1000000);
         _loc10_.SetMotorSpeed(50);
         _loc10_.EnableMotor(true);
         if(_loc10_)
         {
            jointUserData(_loc10_.GetUserData()).lineColour = _loc8_;
            jointUserData(_loc10_.GetUserData()).lineWidth = 4 + Math.random() * 8;
            jointUserData(_loc10_.GetUserData()).lineAlpha = 0.4 + Math.random() * 0.4;
         }
      }
      
      public static function Tentacle(param1:b2Body, param2:b2Body, param3:uint) : void
      {
         var _loc4_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<Array> = null;
         var _loc10_:b2DistanceJoint = null;
         _loc4_ = param1.GetUserData();
         var _loc5_:userData = param2.GetUserData();
         _loc6_ = BoxUtils.randomPointOnBody(param1);
         _loc7_ = BoxUtils.randomPointOnBody(param2);
         _loc8_ = param3;
         _loc9_ = _loc4_.skin;
         if((Boolean(_loc9_)) && _loc9_.length > 0)
         {
            _loc8_ = BoxUtils.getSkinColour(_loc9_,param3.toString(16));
         }
         _loc10_ = Joints.Distance("grapplejoint",param1,param2,_loc6_,_loc7_,10,0.1,false,1000 * param2.GetMass());
         if(_loc10_)
         {
            jointUserData(_loc10_.GetUserData()).lineColour = _loc8_;
            jointUserData(_loc10_.GetUserData()).lineWidth = 4;
            jointUserData(_loc10_.GetUserData()).lineAlpha = 0.7;
         }
      }
      
      public static function Hype(param1:b2Body) : void
      {
         var _loc2_:userData = null;
         if(param1.IsStatic())
         {
            return;
         }
         _loc2_ = param1.GetUserData();
         _loc2_.trigger = new Hyped();
         _loc2_.triggerDuration = 10;
         _loc2_.triggered = true;
      }
   }
}

