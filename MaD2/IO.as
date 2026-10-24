package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2PrismaticJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.controls.treeClasses.TNode;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import environment.OpenWorld;
   import environment.PumpkinDefence;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.PNGEncoderOptions;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.text.TextFieldType;
   import flash.utils.ByteArray;
   import shiny.*;
   import triggers.Gun;
   import triggers.Unequip;
   
   public class IO
   {
      
      private static var bodyOrder:Vector.<b2Body>;
      
      internal static var loadOptions:Object;
      
      internal static var loadItems:Vector.<Object>;
      
      internal static var loadJoints:Vector.<Object>;
      
      internal static var loadIgnores:Vector.<Object>;
      
      internal static var loadModels:Vector.<Object>;
      
      internal static var loadLinks:Vector.<Object>;
      
      internal static var loadSkins:Vector.<Object>;
      
      internal static var loadContractItems:Vector.<Object>;
      
      internal static var loadContractAreas:Vector.<Object>;
      
      public static var lab:MaDLab;
      
      internal static var linkloader:Loader;
      
      internal static var urls:Array;
      
      public static var incrementalLoading:Boolean = false;
      
      internal static var offsetX:Number = 0;
      
      internal static var offsetY:Number = 0;
      
      internal static var hands:Vector.<b2Body> = new Vector.<b2Body>();
      
      internal static var contractLoaded:Boolean = false;
      
      internal static var incrementalLoadInd:int = -1;
      
      internal static var incrementalLoadAutoPlay:Boolean = false;
      
      private static var incrementalLoadStep:String = "items";
      
      private static var errorDetection:int = 0;
      
      private static const progressStart:* = "Loading...";
      
      private static const progressItems:* = "Loading items...\n";
      
      private static const progressCancel:* = "Loading cancelled.";
      
      private static const progressFinish:* = "Finished loading.";
      
      internal static var currentURL:* = 0;
      
      public function IO()
      {
         super();
      }
      
      public static function saveWorld() : Boolean
      {
         if(GameState.environment)
         {
            if(GameState.environment is OpenWorld || GameState.environment is PumpkinDefence)
            {
               return false;
            }
         }
         if(IsSaveLocked())
         {
            return false;
         }
         var _loc1_:String = "mutilate=2;";
         _loc1_ += SaveBasics();
         _loc1_ += "|";
         _loc1_ += SaveBodies();
         _loc1_ += "|";
         _loc1_ += SaveJoints();
         _loc1_ += "|";
         _loc1_ += SaveLinks();
         _loc1_ += "|";
         _loc1_ += SaveSkins();
         _loc1_ += "|";
         _loc1_ += Main.instance.contract.save(bodyOrder);
         _loc1_ += "|";
         _loc1_ += SaveIgnores();
         _loc1_ += "|";
         _loc1_ += SaveModels();
         _loc1_ = _loc1_.replace(/,;/g,";");
         _loc1_ = _loc1_.replace(/,\|/g,"|");
         _loc1_ = _loc1_.replace(/\|;/g,"|");
         Main.instance.currentSave = _loc1_;
         if(!GameState.spawningCustom)
         {
            quicksave();
         }
         return true;
      }
      
      private static function SaveModels() : String
      {
         var _loc1_:userData = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < bodyOrder.length)
         {
            _loc1_ = userData(bodyOrder[_loc4_].GetUserData());
            _loc7_ = R.library_names.indexOf(_loc1_.name) == -1;
            if(_loc7_)
            {
               if(_loc3_.indexOf(_loc1_.name) == -1)
               {
                  for each(_loc8_ in Main.instance.localItems)
                  {
                     _loc9_ = JSON.parse(_loc8_);
                     _loc10_ = _loc9_.ItemName.toLowerCase().replace(/\s/g,"");
                     if(_loc10_ == _loc1_.itemName || _loc10_ == _loc1_.name)
                     {
                        _loc2_.push(_loc8_);
                        _loc3_.push(_loc10_);
                        break;
                     }
                  }
               }
            }
            _loc4_++;
         }
         var _loc5_:* = "";
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            if(_loc6_ != 0)
            {
               _loc5_ += ",";
            }
            _loc5_ += Base64.compress(_loc2_[_loc6_]);
            _loc6_++;
         }
         return _loc5_;
      }
      
      private static function saveCreator() : String
      {
         var _loc1_:String = "creator=";
         var _loc2_:String = "Guest";
         if(Kongregate.API)
         {
            _loc2_ = Kongregate.playerName;
         }
         else if(Boolean(GameState.steamworks.API))
         {
            _loc2_ = GameState.steamworks.API.getPersonaName();
         }
         _loc2_ = _loc2_.split(" ").join("");
         _loc2_ = _loc2_.replace(/[\|;\.,#=]/g,"");
         return _loc1_ + _loc2_ + ";";
      }
      
      private static function saveCustomItem() : String
      {
         var _loc1_:* = "";
         _loc1_ += "compound=1";
         _loc1_ += ";unlocked=1";
         _loc1_ += ";name=" + Main.instance.customName;
         _loc1_ += ";CX=" + String(Main.instance.customPos.x * Physics.scale >> 0);
         _loc1_ += ";CY=" + String(Main.instance.customPos.y * Physics.scale >> 0);
         return _loc1_ + ";";
      }
      
      private static function saveGlobal() : String
      {
         var _loc1_:* = "";
         if(GameState.environment)
         {
            _loc1_ += "environment=" + GameState.environment.name;
            _loc1_ += ";bg=" + GameState.environment.backgroundColour.toString(16);
            _loc1_ += ";walls=" + GameState.environment.wallColour.toString(16);
            _loc1_ += ";floor=" + GameState.environment.floor;
            _loc1_ += ";wallR=" + GameState.environment.wallR;
            _loc1_ += ";wallL=" + GameState.environment.wallL;
            _loc1_ += ";roof=" + GameState.environment.roof;
            _loc1_ += ";particles=" + GameState.environment.particles;
            _loc1_ += ";camera=" + Main.instance.cam.x + "," + Main.instance.cam.y + "," + Main.instance.cam.scaleX;
            _loc1_ += ";loop=" + GameState.environment.loop;
            _loc1_ += ";filler=" + GameState.environment.filler;
            _loc1_ += ";autowind=" + GameState.environment.autoWind;
            _loc1_ += ";seed=" + Vars.seed;
            _loc1_ += ";clutter=" + GameState.environment.clutterDensity;
         }
         _loc1_ += ";gravity=" + Vars.gravity.toString();
         _loc1_ += ";wind=" + Vars.wind.toString();
         _loc1_ += ";temperature=" + Vars.temperature.toString();
         return _loc1_ + ";";
      }
      
      private static function IsSaveLocked() : Boolean
      {
         return false;
      }
      
      private static function SaveBasics() : String
      {
         var _loc1_:* = saveCreator();
         _loc1_ += "created=" + GeneralUtils.getYYMMDD() + ";";
         if(GameState.spawningCustom)
         {
            _loc1_ += saveCustomItem();
         }
         else
         {
            _loc1_ += saveGlobal();
         }
         return _loc1_;
      }
      
      private static function SaveBodies() : String
      {
         var _loc5_:* = 0;
         var _loc8_:b2Body = null;
         bodyOrder = new Vector.<b2Body>();
         var _loc1_:* = "";
         var _loc2_:Array = [];
         var _loc3_:b2Body = Physics.world.GetBodyList();
         while(_loc3_)
         {
            _loc2_.push(_loc3_);
            _loc3_ = _loc3_.GetNext();
         }
         var _loc4_:Array = [];
         _loc5_ = int(_loc2_.length - 1);
         while(_loc5_ >= 0)
         {
            _loc8_ = _loc2_[_loc5_];
            if(Main.instance.backBodies.indexOf(_loc8_) != -1)
            {
               _loc4_.push(_loc8_);
            }
            else
            {
               _loc4_.unshift(_loc8_);
            }
            _loc5_--;
         }
         var _loc6_:Boolean = true;
         var _loc7_:int = int(_loc4_.length);
         _loc5_ = int(_loc7_ - 1);
         while(_loc5_ >= 0)
         {
            _loc3_ = _loc4_[_loc5_];
            _loc1_ += SaveItem(_loc3_);
            _loc5_--;
         }
         return _loc1_;
      }
      
      private static function SaveItem(param1:b2Body) : String
      {
         var _loc18_:Firearm = null;
         var _loc19_:String = null;
         var _loc20_:BitmapData = null;
         var _loc21_:ByteArray = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:String = null;
         var _loc27_:Array = null;
         var _loc2_:* = "";
         if(param1 == Physics.world.GetGroundBody())
         {
            return "";
         }
         if(GameState.spawningCustom && Main.instance.selectedBodies.indexOf(param1) == -1)
         {
            return "";
         }
         if(GameState.environment.defaultBodies.indexOf(param1) != -1)
         {
            return "";
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_)
         {
            return "";
         }
         if(_loc3_.dead)
         {
            return "";
         }
         if(_loc3_.name == "deleted")
         {
            return "";
         }
         if(!_loc3_.body)
         {
            _loc3_.body = param1;
         }
         var _loc4_:String = _loc3_.name;
         var _loc5_:b2Vec2 = param1.GetPosition();
         if(!_loc4_)
         {
            return "";
         }
         if(!_loc3_.saveable)
         {
            return "";
         }
         if(_loc3_.name == "wall")
         {
            return "";
         }
         bodyOrder.push(param1);
         if(!param1.GetShapeList())
         {
            return "";
         }
         var _loc6_:Number = _loc5_.x * Physics.scale;
         var _loc7_:Number = _loc5_.y * Physics.scale;
         var _loc8_:Number = param1.GetAngle() * Vars.toDegrees;
         var _loc9_:Number = _loc3_.size;
         var _loc10_:Number = _loc3_.density;
         var _loc11_:Number = param1.GetShapeList().GetFriction();
         var _loc12_:Number = param1.GetShapeList().GetRestitution();
         var _loc13_:Number = param1.m_linearDamping;
         var _loc14_:Number = param1.m_angularDamping;
         var _loc15_:Array = _loc3_.getProperties();
         var _loc16_:String = "";
         if(_loc3_.saveName)
         {
            _loc16_ += ";NM=" + _loc3_.saveName + ",";
         }
         else
         {
            _loc16_ += ";NM=" + _loc4_ + ",";
         }
         _loc16_ += "PX=" + _loc6_.toFixed(2) + ",";
         _loc16_ = _loc16_ + ("PY=" + _loc7_.toFixed(2) + ",");
         var _loc17_:* = (_loc3_.group >= 1000 ? _loc3_.group - 1000 : _loc3_.group).toString();
         if(_loc3_.alive || Boolean(_loc3_.armour))
         {
            _loc16_ += "ID=" + _loc3_.id.toString() + ",";
         }
         if(_loc3_.alive || Boolean(_loc3_.armour))
         {
            _loc16_ += "HH=" + _loc3_.health.toString() + ",";
         }
         if(_loc3_.alive || Boolean(_loc3_.armour))
         {
            _loc16_ += "MH=" + _loc3_.maxhealth.toString() + ",";
         }
         if(_loc8_ != 0)
         {
            _loc16_ += "AN=" + _loc8_.toFixed(2) + ",";
         }
         if(_loc9_ != 1)
         {
            _loc16_ += "SZ=" + _loc9_.toString() + ",";
         }
         if(_loc10_ != 1)
         {
            _loc16_ += "DN=" + _loc10_.toString() + ",";
         }
         if(_loc11_ != 0.5)
         {
            _loc16_ += "FR=" + _loc11_.toString() + ",";
         }
         if(_loc12_ != 0.2)
         {
            _loc16_ += "RS=" + _loc12_.toString() + ",";
         }
         if(_loc13_ != 0)
         {
            _loc16_ += "DL=" + _loc13_.toString() + ",";
         }
         if(_loc14_ != 0)
         {
            _loc16_ += "DA=" + _loc14_.toString() + ",";
         }
         if(_loc3_.temperature)
         {
            _loc16_ += "TM=" + (_loc3_.temperature >> 0).toString() + ",";
         }
         if(_loc3_.group != 0)
         {
            _loc16_ += "GR=" + _loc17_ + ",";
         }
         if(_loc3_.target != -1)
         {
            _loc16_ += "TA=" + _loc3_.target + ",";
         }
         if(_loc3_.targetX != -1)
         {
            _loc16_ += "TAX=" + _loc3_.targetX + ",";
         }
         if(_loc3_.targetY != -1)
         {
            _loc16_ += "TAY=" + _loc3_.targetY + ",";
         }
         if(_loc3_.customCreator != "Guest")
         {
            _loc16_ += "CU=" + _loc3_.customCreator + ",";
         }
         _loc16_ += "LR=" + _loc3_.layer.toString() + ",";
         if(_loc3_.alpha != 1)
         {
            _loc16_ += "ALP=" + _loc3_.alpha.toString() + ",";
         }
         if(_loc3_.alive)
         {
            _loc16_ += "BC=" + _loc3_.bloodColour.toString(16) + ",";
         }
         if(_loc3_.multiConcussion != 1)
         {
            _loc16_ += "MCO=" + _loc3_.multiConcussion.toString() + ",";
         }
         if(_loc3_.multiStanding != 1)
         {
            _loc16_ += "MST=" + _loc3_.multiStanding.toString() + ",";
         }
         if(_loc3_.multiStabForce != 1)
         {
            _loc16_ += "MSF=" + _loc3_.multiStabForce.toString() + ",";
         }
         if(_loc3_.multiStabDensity != 1)
         {
            _loc16_ += "MSD=" + _loc3_.multiStabDensity.toString() + ",";
         }
         if(_loc3_.multiBulletPenetration != 1)
         {
            _loc16_ += "MBP=" + _loc3_.multiBulletPenetration.toString() + ",";
         }
         if(_loc3_.multiGlobalDamage != 1)
         {
            _loc16_ += "MGD=" + _loc3_.multiGlobalDamage.toString() + ",";
         }
         if(_loc3_.multiBulletDamage != 1)
         {
            _loc16_ += "MBU=" + _loc3_.multiBulletDamage.toString() + ",";
         }
         if(_loc3_.multiBluntDamage != 1)
         {
            _loc16_ += "MBL=" + _loc3_.multiBluntDamage.toString() + ",";
         }
         if(_loc3_.multiBleedDamage != 1)
         {
            _loc16_ += "MBLE=" + _loc3_.multiBleedDamage.toString() + ",";
         }
         if(_loc3_.multiSharpDamage != 1)
         {
            _loc16_ += "MSH=" + _loc3_.multiSharpDamage.toString() + ",";
         }
         if(_loc3_.multiRegen != 1)
         {
            _loc16_ += "MRE=" + _loc3_.multiRegen.toString() + ",";
         }
         if(Boolean(_loc3_.trigger) && Boolean(_loc3_.trigger is Gun) && Gun(_loc3_.trigger).firearm.modified)
         {
            _loc18_ = Gun(_loc3_.trigger).firearm;
            _loc16_ += "GBA=" + _loc18_.bulletAmount + ",";
            _loc16_ = _loc16_ + ("GBP=" + _loc18_.bulletProperties.join(".") + ",");
            _loc16_ = _loc16_ + ("GBS=" + _loc18_.bulletSize + ",");
            _loc16_ = _loc16_ + ("GBT=" + _loc18_.bulletType + ",");
            _loc16_ = _loc16_ + ("GBRA=" + _loc18_.burstAmount + ",");
            _loc16_ = _loc16_ + ("GBRD=" + _loc18_.burstDelay + ",");
            _loc16_ = _loc16_ + ("GTIM=" + _loc18_.chamberTime + ",");
            _loc16_ = _loc16_ + ("GMAG=" + _loc18_.magazineSize + ",");
            _loc16_ = _loc16_ + ("GREC=" + _loc18_.recoil + ",");
            _loc16_ = _loc16_ + ("GREL=" + _loc18_.reloadTime + ",");
            _loc16_ = _loc16_ + ("GSCA=" + _loc18_.scatter + ",");
            _loc16_ = _loc16_ + ("GFOR=" + _loc18_.shootForce + ",");
            _loc16_ = _loc16_ + ("GSND=" + _loc18_.soundNames.join(".") + ",");
            _loc16_ = _loc16_ + ("GVOL=" + _loc18_.soundVolumes.join(".") + ",");
         }
         if(_loc3_.triggerKey != -1)
         {
            _loc16_ += "TKEY=" + _loc3_.triggerKey.toString() + ",";
         }
         if(_loc3_.triggerKeyHold != -1)
         {
            _loc16_ += "HKEY=" + _loc3_.triggerKeyHold.toString() + ",";
         }
         if(_loc3_.overrideSound)
         {
            _loc16_ += "SFX=" + _loc3_.overrideSound + ",";
         }
         if(_loc3_.overrideVolume)
         {
            _loc16_ += "VOL=" + _loc3_.overrideVolume.toFixed(2) + ",";
         }
         if(_loc3_.pfx)
         {
            _loc16_ += _loc3_.pfx.Summarise() + ",";
         }
         if(Boolean(_loc3_.trigger) && Boolean(_loc3_.originalTrigger))
         {
            _loc3_.trigger.OnSaveCustom();
            _loc16_ += "TF=" + (_loc3_.triggerForce >> 0).toString() + ",";
            _loc16_ = _loc16_ + ("TR=" + (_loc3_.triggerRadius >> 0).toString() + ",");
            _loc16_ = _loc16_ + ("TD=" + (_loc3_.originalTriggerDuration >> 0).toString() + ",");
            _loc16_ = _loc16_ + ("TC=" + (_loc3_.triggerContact >> 0).toString() + ",");
         }
         if(_loc3_.triggerCustom)
         {
            if(_loc3_.triggerCustom.indexOf(";") == -1)
            {
               _loc16_ += "TCU=" + _loc3_.triggerCustom + ",";
            }
            else
            {
               _loc19_ = Base64.compress(_loc3_.triggerCustom);
               _loc19_ = _loc19_.replace(/=/g,"_");
               _loc16_ += "TCUC=" + _loc19_ + ",";
            }
         }
         if(Math.abs(param1.GetLinearVelocity().x) > 1)
         {
            _loc16_ += "VX=" + int(param1.GetLinearVelocity().x * Physics.scale).toString() + ",";
         }
         if(Math.abs(param1.GetLinearVelocity().y) > 1)
         {
            _loc16_ += "VY=" + int(param1.GetLinearVelocity().y * Physics.scale).toString() + ",";
         }
         if(Math.abs(param1.GetAngularVelocity()) > 1)
         {
            _loc16_ += "VA=" + int(param1.GetAngularVelocity() * Physics.scale).toString() + ",";
         }
         if(_loc3_.saveStains && !_loc3_.stainless)
         {
            _loc20_ = BoxUtils.getEffectBMD(param1);
            if(_loc20_)
            {
               _loc21_ = _loc20_.getPixels(_loc20_.rect);
               _loc20_.encode(_loc20_.rect,new PNGEncoderOptions(),_loc21_);
               _loc22_ = Base64.Encode(_loc21_).replace(/\//g,"-").replace(/=/g,"_");
               _loc22_ = _loc22_.replace(/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/g,"!");
               _loc22_ = _loc22_.replace(/!!!!!!!!!!/g,"%");
               _loc16_ += "GFX=" + _loc22_ + ",";
            }
         }
         if(_loc3_.bleeding.length > 0)
         {
            _loc23_ = "";
            _loc24_ = int(_loc3_.bleeding.length);
            _loc25_ = 0;
            while(_loc25_ < _loc24_)
            {
               _loc27_ = _loc3_.bleeding[_loc25_];
               _loc23_ += Number(_loc27_[0].x).toFixed(2).toString() + "," + Number(_loc27_[0].y).toFixed(2).toString() + ",";
               _loc23_ = _loc23_ + (Number(_loc27_[1].x).toFixed(2).toString() + "," + Number(_loc27_[1].y).toFixed(2).toString() + ",");
               if(_loc27_[2])
               {
                  _loc23_ += Number(_loc27_[2].x).toFixed(2).toString() + "," + Number(_loc27_[2].y).toFixed(2).toString() + ",";
               }
               else
               {
                  _loc23_ += "0,0,";
               }
               _loc23_ += _loc27_[3];
               if(_loc25_ != _loc24_ - 1)
               {
                  _loc23_ += ";";
               }
               _loc25_++;
            }
            _loc23_ = _loc23_.replace(/;/g,";");
            _loc26_ = "BLD=" + Base64.compress(_loc23_).replace(/=/g,"_") + ",";
            _loc26_ = _loc26_.replace(";,",",");
            _loc16_ += _loc26_;
         }
         if(_loc15_.length > 0)
         {
            _loc16_ += _loc15_.join("=1,") + "=1";
         }
         _loc16_ = _loc16_.replace(/,P:;/,";");
         return _loc2_ + _loc16_;
      }
      
      private static function SaveJoints() : String
      {
         var _loc3_:jointUserData = null;
         var _loc4_:String = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc1_:String = "";
         var _loc2_:b2Joint = Physics.world.GetJointList();
         for(; _loc2_; _loc2_ = _loc2_.GetNext())
         {
            _loc3_ = jointUserData(_loc2_.GetUserData());
            _loc4_ = _loc3_.name;
            if(_loc4_ == "ana" || _loc4_ == "frozen")
            {
               _loc4_ = "rag";
            }
            if(_loc4_ != "mouse")
            {
               if(_loc4_ != "snarejoint")
               {
                  if(_loc4_ != "vinejoint")
                  {
                     if(_loc4_ != "webjoint")
                     {
                        if(_loc4_ != "randomjoint")
                        {
                           _loc5_ = _loc2_.GetAnchor1();
                           _loc6_ = _loc2_.GetAnchor2();
                           _loc7_ = _loc2_.GetBody1();
                           _loc8_ = _loc2_.GetBody2();
                           if(_loc7_)
                           {
                              if(!userData(_loc7_.GetUserData()).saveable)
                              {
                                 continue;
                              }
                           }
                           if(_loc8_)
                           {
                              if(!userData(_loc8_.GetUserData()).saveable)
                              {
                                 continue;
                              }
                           }
                           if(_loc4_ == "rag" || _loc4_ == "revolute")
                           {
                              _loc9_ = _loc2_.GetBody1().GetPosition().x * Physics.scale;
                              _loc10_ = _loc2_.GetBody1().GetPosition().y * Physics.scale;
                              _loc11_ = _loc2_.GetBody2().GetPosition().x * Physics.scale;
                              _loc12_ = _loc2_.GetBody2().GetPosition().y * Physics.scale;
                           }
                           else if(!(_loc4_ == "weldjoint" || _loc4_ == "equip" || _loc4_ == "pistonjoint"))
                           {
                              _loc9_ = _loc5_.x * Physics.scale;
                              _loc10_ = _loc5_.y * Physics.scale;
                              _loc11_ = _loc6_.x * Physics.scale;
                              _loc12_ = _loc6_.y * Physics.scale;
                           }
                           _loc13_ = bodyOrder.indexOf(_loc2_.GetBody1());
                           _loc14_ = bodyOrder.indexOf(_loc2_.GetBody2());
                           if(!(_loc13_ == -1 && _loc14_ == -1))
                           {
                              _loc1_ += ";NM=" + _loc4_;
                              if(_loc9_)
                              {
                                 _loc1_ += ",X1=" + _loc9_.toFixed(2);
                                 _loc1_ += ",Y1=" + _loc10_.toFixed(2);
                                 _loc1_ += ",X2=" + _loc11_.toFixed(2);
                                 _loc1_ += ",Y2=" + _loc12_.toFixed(2);
                              }
                              _loc1_ += ",B1=" + _loc13_;
                              _loc1_ += ",B2=" + _loc14_;
                              if(_loc4_ == "rag")
                              {
                                 _loc15_ = _loc3_.lowerAngle;
                                 _loc16_ = _loc3_.upperAngle;
                                 if(_loc2_.GetUserData().name == "ana" || _loc2_.GetUserData().name == "frozen")
                                 {
                                    _loc15_ = _loc3_.defaultLA;
                                    _loc16_ = _loc3_.defaultUA;
                                 }
                                 _loc1_ += ",X3=" + Math.round(_loc5_.x * Physics.scale);
                                 _loc1_ += ",Y3=" + Math.round(_loc5_.y * Physics.scale);
                                 _loc1_ += ",lower=" + _loc15_;
                                 _loc1_ += ",upper=" + _loc16_;
                              }
                              else if(_loc4_ == "revolute")
                              {
                                 _loc1_ += ",X3=" + Math.round(_loc5_.x * Physics.scale);
                                 _loc1_ += ",Y3=" + Math.round(_loc5_.y * Physics.scale);
                                 _loc1_ += ",lower=" + _loc3_.lowerAngle;
                                 _loc1_ += ",upper=" + _loc3_.upperAngle;
                                 _loc1_ += ",speed=" + b2RevoluteJoint(_loc2_).m_motorSpeed;
                                 _loc1_ += ",force=" + b2RevoluteJoint(_loc2_).m_maxMotorTorque;
                              }
                              else if(_loc4_ == "pistonjoint")
                              {
                                 _loc1_ += ",X1=" + b2PrismaticJoint(_loc2_).m_localXAxis1.x;
                                 _loc1_ += ",Y1=" + b2PrismaticJoint(_loc2_).m_localXAxis1.y;
                                 _loc1_ += ",X2=" + b2PrismaticJoint(_loc2_).m_localYAxis1.x;
                                 _loc1_ += ",Y2=" + b2PrismaticJoint(_loc2_).m_localYAxis1.y;
                                 _loc1_ += ",lower=" + int(10 * b2PrismaticJoint(_loc2_).GetLowerLimit()) / 10;
                                 _loc1_ += ",upper=" + int(10 * b2PrismaticJoint(_loc2_).GetUpperLimit()) / 10;
                                 _loc1_ += ",speed=" + b2PrismaticJoint(_loc2_).m_motorSpeed;
                                 _loc1_ += ",force=" + b2PrismaticJoint(_loc2_).m_maxMotorForce;
                              }
                              else if(_loc4_ == "ropejoint")
                              {
                                 _loc1_ += ",FR=" + b2DistanceJoint(_loc2_).m_frequencyHz;
                                 _loc1_ += ",DA=" + b2DistanceJoint(_loc2_).m_dampingRatio;
                              }
                              _loc3_ = jointUserData(_loc2_.GetUserData());
                              _loc1_ += ",FL=" + _loc3_.forceLimit;
                              _loc1_ += ",LV=" + _loc3_.lineVisible;
                              _loc1_ += ",LW=" + _loc3_.lineWidth;
                              _loc1_ += ",LCC=" + _loc2_.m_collideConnected;
                              if(_loc3_.lineColour)
                              {
                                 _loc1_ += ",LC=" + _loc3_.lineColour;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      private static function SaveLinks() : String
      {
         var _loc2_:Vector.<b2Body> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:* = "";
         var _loc3_:int = 0;
         while(_loc3_ < bodyOrder.length)
         {
            _loc2_ = userData(bodyOrder[_loc3_].GetUserData()).connected;
            if(_loc2_.length > 0)
            {
               _loc1_ += ";LINK=" + _loc3_;
               _loc1_ += ",TO=";
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc5_ = bodyOrder.indexOf(_loc2_[_loc4_]);
                  if(_loc5_ != -1)
                  {
                     if(_loc4_ != 0)
                     {
                        _loc1_ += ".";
                     }
                     _loc1_ += _loc5_;
                  }
                  _loc4_++;
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private static function SaveIgnores() : String
      {
         var _loc1_:Vector.<b2Body> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < bodyOrder.length)
         {
            _loc1_ = userData(bodyOrder[_loc3_].GetUserData()).ignored;
            if(_loc1_.length > 0)
            {
               _loc2_ += ";IGN=" + _loc3_;
               _loc2_ += ",ORE=";
               _loc4_ = 0;
               while(_loc4_ < _loc1_.length)
               {
                  _loc5_ = bodyOrder.indexOf(_loc1_[_loc4_]);
                  if(_loc5_ != -1)
                  {
                     if(_loc4_ != 0)
                     {
                        _loc2_ += ".";
                     }
                     _loc2_ += _loc5_;
                  }
                  _loc4_++;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function SaveSkins() : String
      {
         var _loc3_:b2Body = null;
         var _loc4_:Vector.<Array> = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < bodyOrder.length)
         {
            _loc3_ = bodyOrder[_loc2_];
            _loc4_ = userData(_loc3_.GetUserData()).skin;
            if((Boolean(_loc4_)) && _loc4_.length > 0)
            {
               _loc5_ = "";
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  if(_loc6_ != 0)
                  {
                     _loc5_ += ".";
                  }
                  _loc5_ += _loc4_[_loc6_].join("");
                  _loc6_++;
               }
               if(_loc2_ != 0)
               {
                  _loc1_ += ";";
               }
               _loc1_ += "ID=" + _loc2_.toString();
               _loc1_ += ",SKIN=" + _loc5_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private static function getToggles() : Array
      {
         var _loc1_:Array = [World.toggleSlomo,World.toggleRagdollBreak,World.toggleJointBreak,World.toggleObjectBreak,World.toggleContact];
         var _loc2_:Array = ["slowmotion","breakalive","breakjoints","breakobjects","contacts"];
         var _loc3_:Array = [];
         var _loc4_:int = int(_loc1_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc1_[_loc5_])
            {
               _loc3_.push(_loc2_[_loc5_]);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function loadWorld(param1:String = null, param2:Boolean = false, param3:Boolean = false) : *
      {
         Main.instance.resetSpawnSettings();
         TimeLord.pause();
         TimeLord.pauseGrid.Finish();
         incrementalLoading = true;
         incrementalLoadAutoPlay = param2;
         incrementalLoadStart(param1,param3);
      }
      
      public static function IncrementalLoad() : void
      {
         var loadSpeed:int;
         var i:int;
         if(!loadItems || loadItems.length == 0)
         {
            FinishLoading();
            return;
         }
         contractLoaded = false;
         loadSpeed = Vars.loadSpeed;
         if(loadSpeed > 99)
         {
            loadSpeed = 1000;
         }
         i = 0;
         while(i < loadSpeed)
         {
            try
            {
               if(incrementalLoadStep == "items")
               {
                  if(!IncrementalLoadItems())
                  {
                     incrementalLoadStep = "joints";
                     incrementalLoadInd = 0;
                     if(loadJoints.length > 12 && loadItems.length > 10)
                     {
                        GameState.ui.showTooltip(GameState.ui.console,"Loading " + loadJoints.length + " joints...\nThis may take a while.\n",0,1000,200);
                     }
                  }
               }
               if(incrementalLoadStep == "joints")
               {
                  if(!IncrementalLoadJoints())
                  {
                     IncrementalLoadFinish();
                     break;
                  }
               }
            }
            catch(e:*)
            {
               ++incrementalLoadInd;
               ++errorDetection;
            }
            if(errorDetection > 30)
            {
               FinishLoading();
               break;
            }
            i++;
         }
      }
      
      private static function FinishLoading() : void
      {
         GameState.loading = false;
         incrementalLoading = false;
         GameState.ui.showTooltip(GameState.ui.console,"The content failed to load. Please submit it in Bug Reports to help improve the incremental loading system.\n\n\n",100,5000,200);
         GameState.ui.menuControls.alpha = 1;
         GameState.ui.menuMain.alpha = 1;
      }
      
      private static function ProgressTooltip(param1:String) : *
      {
         if(Vars.loadSpeed > 99)
         {
            return;
         }
         if(Boolean(loadItems) && loadItems.length < 20)
         {
            return;
         }
         GameState.ui.showTooltip(GameState.ui.console,param1,0,1000,200);
      }
      
      public static function incrementalLoadStart(param1:String = null, param2:Boolean = false) : *
      {
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc16_:Sprite = null;
         var _loc17_:Array = null;
         var _loc18_:String = null;
         var _loc19_:Array = null;
         var _loc20_:Object = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:Array = null;
         var _loc24_:Object = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         var _loc27_:Array = null;
         var _loc28_:Object = null;
         var _loc29_:String = null;
         var _loc30_:Object = null;
         var _loc31_:Array = null;
         var _loc32_:String = null;
         var _loc33_:String = null;
         var _loc34_:String = null;
         var _loc35_:Array = null;
         var _loc36_:Object = null;
         var _loc37_:String = null;
         var _loc38_:Sprite = null;
         var _loc39_:Number = NaN;
         var _loc40_:String = null;
         Properties.storeTempProperties();
         errorDetection = 0;
         GameState.ui.menuControls.alpha = 0;
         GameState.ui.menuMain.alpha = 0;
         ProgressTooltip(progressStart);
         incrementalLoadStep = "items";
         GameState.loading = true;
         incrementalLoadInd = 0;
         if(GameState.spawning)
         {
            GameState.spawning = false;
            Main.instance.flipped = false;
            GameState.objects.spawnScale = 1;
            GameState.objects.spawnAngle = 0;
            _loc16_ = GameState.ui.menuSpawn.getChildByName("itemHolder") as Sprite;
            _loc16_.visible = true;
            if(!GameState.spawningCustom)
            {
               if(GameState.objects.spawnSprite)
               {
                  GameState.objects.spawnSprite.parent.removeChild(GameState.objects.spawnSprite);
                  GameState.objects.spawnSprite = null;
               }
               Main.instance.updateSpawnPic();
            }
         }
         if(!param1)
         {
            if(Main.instance.loadedLevel != "")
            {
               param1 = Main.instance.loadedLevel;
               param2 = true;
            }
            else
            {
               param1 = Main.instance.currentSave;
            }
         }
         if(param2)
         {
            param1 = param1.replace(/-/g,"/");
            if(param1.substr(0,3) == "MAD")
            {
               param1 = param1.substr(3);
            }
            param1 = Base64.uncompress(param1);
         }
         if(param1 == "error")
         {
            GameState.ui.menuPrompt.unlock();
            GameState.ui.menuPrompt.getField("info").type = TextFieldType.DYNAMIC;
            GameState.ui.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(R.xml_done);
            GameState.ui.menuPrompt.visible = true;
            GameState.ui.menuPrompt.moveToTop();
            GameState.ui.menuPrompt.center();
            GameState.ui.menuPrompt.lock();
            GameState.ui.menuPrompt.title = "Load Error";
            GameState.ui.menuPrompt.getField("info").text = "The save could not be loaded for one reason or another.\n\nIf you manually loaded it from a string, please ensure it was fully copied or the compression breaks.";
            GameState.loading = false;
            incrementalLoading = false;
            return;
         }
         if(param1 == "")
         {
            GameState.loading = false;
            return;
         }
         if(!GameState.spawningCustom && !GameState.spawningEnvironment)
         {
            GameState.slomo = false;
            Main.instance.dollNumber = 0;
            Main.instance.reset(false,false);
            Tool.currentJoint = "";
            Main.instance.contract.Reset();
         }
         var _loc3_:Array = param1.split("|");
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         var _loc11_:Array = [];
         var _loc12_:Array = [];
         if(_loc3_.length >= 1)
         {
            _loc4_ = String(_loc3_[0]).split(";");
         }
         if(_loc3_.length >= 2)
         {
            _loc5_ = String(_loc3_[1]).split(";");
         }
         if(_loc3_.length >= 3)
         {
            _loc6_ = String(_loc3_[2]).split(";");
         }
         if(_loc3_.length >= 4)
         {
            _loc7_ = String(_loc3_[3]).split(";");
         }
         if(_loc3_.length >= 5)
         {
            _loc10_ = String(_loc3_[4]).split(";");
         }
         if(_loc3_.length >= 6)
         {
            _loc11_ = String(_loc3_[5]).split(";");
         }
         if(_loc3_.length >= 7)
         {
            _loc12_ = String(_loc3_[6]).split(";");
         }
         if(_loc3_.length >= 8)
         {
            _loc8_ = String(_loc3_[7]).split(";");
         }
         if(_loc3_.length >= 9)
         {
            _loc9_ = String(_loc3_[8]).split(",");
         }
         loadOptions = new Object();
         loadItems = new Vector.<Object>();
         loadJoints = new Vector.<Object>();
         loadIgnores = new Vector.<Object>();
         loadModels = new Vector.<Object>();
         loadLinks = new Vector.<Object>();
         loadSkins = new Vector.<Object>();
         loadContractItems = new Vector.<Object>();
         loadContractAreas = new Vector.<Object>();
         for each(_loc13_ in _loc4_)
         {
            _loc17_ = _loc13_.split("=");
            loadOptions[_loc17_[0]] = _loc17_[1];
         }
         if(_loc5_.length > 0 && Boolean(_loc5_[0]))
         {
            for each(_loc18_ in _loc5_)
            {
               _loc19_ = _loc18_.split(",");
               _loc20_ = new Object();
               for each(_loc21_ in _loc19_)
               {
                  _loc17_ = _loc21_.split("=");
                  _loc20_[_loc17_[0]] = _loc17_[1];
               }
               loadItems.push(_loc20_);
            }
         }
         if(_loc6_.length > 0 && Boolean(_loc6_[0]))
         {
            for each(_loc22_ in _loc6_)
            {
               _loc23_ = _loc22_.split(",");
               _loc24_ = new Object();
               for each(_loc25_ in _loc23_)
               {
                  _loc17_ = _loc25_.split("=");
                  _loc24_[_loc17_[0]] = _loc17_[1];
               }
               loadJoints.push(_loc24_);
            }
         }
         if(_loc7_.length > 0 && Boolean(_loc7_[0]))
         {
            for each(_loc26_ in _loc7_)
            {
               _loc27_ = _loc26_.split(",");
               _loc28_ = new Object();
               for each(_loc29_ in _loc27_)
               {
                  _loc17_ = _loc29_.split("=");
                  _loc28_[_loc17_[0]] = _loc17_[1];
               }
               loadLinks.push(_loc28_);
            }
         }
         if(_loc8_.length > 0 && Boolean(_loc8_[0]))
         {
            for each(_loc26_ in _loc8_)
            {
               _loc27_ = _loc26_.split(",");
               _loc28_ = new Object();
               for each(_loc29_ in _loc27_)
               {
                  _loc17_ = _loc29_.split("=");
                  _loc28_[_loc17_[0]] = _loc17_[1];
               }
               loadIgnores.push(_loc28_);
            }
         }
         if(_loc9_.length > 0 && Boolean(_loc9_[0]))
         {
            _loc31_ = [];
            for each(_loc32_ in _loc9_)
            {
               _loc33_ = Base64.uncompress(_loc32_);
               _loc30_ = JSON.parse(_loc33_);
               if(_loc31_.indexOf(_loc30_.ItemName) == -1)
               {
                  _loc31_.push(_loc30_.ItemName);
                  loadModels.push(_loc33_);
               }
            }
         }
         if(_loc10_.length > 0 && Boolean(_loc10_[0]))
         {
            for each(_loc34_ in _loc10_)
            {
               _loc35_ = _loc34_.split(",");
               _loc36_ = new Object();
               for each(_loc37_ in _loc35_)
               {
                  _loc17_ = _loc37_.split("=");
                  _loc36_[_loc17_[0]] = _loc17_[1];
               }
               loadSkins.push(_loc36_);
            }
         }
         if(_loc11_.length > 0 && Boolean(_loc11_[0]))
         {
            for each(_loc18_ in _loc11_)
            {
               _loc19_ = _loc18_.split(",");
               _loc20_ = new Object();
               for each(_loc21_ in _loc19_)
               {
                  _loc17_ = _loc21_.split("=");
                  _loc20_[_loc17_[0]] = _loc17_[1];
               }
               loadContractItems.push(_loc20_);
            }
         }
         if(_loc12_.length > 0 && Boolean(_loc12_[0]))
         {
            for each(_loc18_ in _loc12_)
            {
               _loc19_ = _loc18_.split(",");
               _loc20_ = new Object();
               for each(_loc21_ in _loc19_)
               {
                  _loc17_ = _loc21_.split("=");
                  _loc20_[_loc17_[0]] = _loc17_[1];
               }
               loadContractAreas.push(_loc20_);
            }
         }
         Main.instance.loadLocalItems();
         for each(_loc14_ in loadModels)
         {
            Main.instance.localItems.push(_loc14_);
         }
         Main.instance.loadLocalItems(false);
         if(loadModels.length > 0)
         {
            Main.instance.updateLibrary();
         }
         if(loadOptions.environment)
         {
            Main.instance.changeEnvironment(loadOptions.environment);
            GameState.environmenting = false;
         }
         if(loadOptions.bg)
         {
            if(uint("0x" + loadOptions.bg) != GameState.environment.backgroundColour)
            {
               Main.instance.colouring = "background";
               Main.instance.updateColour(loadOptions.bg,true,true,false);
               GameState.ui.updateEnvironmentInfo();
               Main.instance.colouring = null;
            }
         }
         if(loadOptions.walls)
         {
            Main.instance.colouring = "walls";
            Main.instance.updateColour(loadOptions.walls,true,true,false);
            GameState.ui.updateEnvironmentInfo();
            Main.instance.colouring = null;
         }
         if(loadOptions.blood)
         {
            Main.instance.colouring = "blood";
            Main.instance.updateColour(loadOptions.blood,true,true,false);
            Main.instance.colouring = null;
         }
         var _loc15_:Boolean = false;
         if(loadOptions.roof)
         {
            GameState.environment.roof = loadOptions.roof == "true";
            _loc15_ = true;
         }
         if(loadOptions.floor)
         {
            GameState.environment.floor = loadOptions.floor == "true";
            _loc15_ = true;
         }
         if(loadOptions.wallL)
         {
            GameState.environment.wallL = loadOptions.wallL == "true";
            _loc15_ = true;
         }
         if(loadOptions.wallR)
         {
            GameState.environment.wallR = loadOptions.wallR == "true";
            _loc15_ = true;
         }
         if(loadOptions.sides)
         {
            GameState.environment.wallR = loadOptions.sides == "true";
            GameState.environment.wallL = loadOptions.sides == "true";
            _loc15_ = true;
         }
         if(loadOptions.loop)
         {
            GameState.environment.loop = loadOptions.loop == "true";
         }
         if(loadOptions.filler)
         {
            GameState.environment.filler = loadOptions.filler == "true";
         }
         if(loadOptions.autowind)
         {
            GameState.environment.autoWind = loadOptions.autoWind == "true";
         }
         if(loadOptions.seed)
         {
            Vars.seed = GameState.environment.seed = int(loadOptions.seed);
         }
         if(loadOptions.clutter)
         {
            GameState.environment.clutterDensity = int(loadOptions.clutter);
            GameState.environment.seed = Vars.seed;
         }
         if(_loc15_)
         {
            GameState.environment.setupWalls();
         }
         if(loadOptions.particles)
         {
            GameState.environment.particles = loadOptions.particles == "true";
         }
         if(!(GameState.environment is PumpkinDefence))
         {
            GameState.environment.setupBackground();
         }
         if(loadOptions.camera)
         {
            _loc38_ = Main.instance.cam;
            _loc38_.x = Number(loadOptions.camera.split(",")[0]);
            _loc38_.y = Number(loadOptions.camera.split(",")[1]);
            if(String(loadOptions.camera).split(",").length == 3)
            {
               _loc38_.scaleX = Number(loadOptions.camera.split(",")[2]);
               _loc38_.scaleY = _loc38_.scaleX;
            }
            else
            {
               _loc38_.scaleX = _loc38_.scaleY = 1;
               _loc38_.x -= GameState.width * 0.5;
               _loc38_.y -= GameState.height * 0.5;
            }
            TimeLord.pauseGrid.Update();
         }
         if(loadOptions.speed)
         {
            Vars.speed = loadOptions.speed;
            TimeLord.speed = loadOptions.speed;
         }
         if(loadOptions.gravity)
         {
            Vars.gravity = loadOptions.gravity;
            GameState.ui.menuWorld.setValue("Gravity",loadOptions.gravity);
         }
         if(loadOptions.wind)
         {
            Vars.wind = loadOptions.wind;
            GameState.ui.menuWorld.setValue("Wind",loadOptions.wind);
         }
         if(loadOptions.temperature)
         {
            Vars.temperature = loadOptions.temperature;
            _loc39_ = Number(loadOptions.temperature);
            if(World.toggleFahrenheit == 1)
            {
               _loc39_ = 9 / 5 * _loc39_ + 32 >> 0;
            }
            GameState.ui.menuWorld.setValue("Temperature",_loc39_);
         }
         GameState.ui.updateEnvironmentInfo();
         if(GameState.spawningCustom)
         {
            loadOptions.unlocked = 1;
         }
         if(!GameState.spawningCustom)
         {
            Main.instance.currentSave = param1;
            if(true == false)
            {
               if(loadOptions.unlocked)
               {
                  if(loadOptions.unlocked == 1)
                  {
                     Main.instance.loadedLevel = "";
                  }
                  else
                  {
                     Main.instance.loadedLevel = param1;
                     Main.instance.currentSave = param1;
                  }
               }
            }
            if(Kongregate.API)
            {
               _loc40_ = Kongregate.API.services.getUsername();
               if(!loadOptions.creator || loadOptions.creator == "Guest" || Boolean(_loc40_) && Boolean(_loc40_ == loadOptions.creator))
               {
                  Main.instance.loadedLevel = "";
               }
               else
               {
                  GameState.ui.showTooltip(GameState.ui.menuControls,"Locked content loaded. You can play it normally, but it can\'t be saved or shared again.\n\n\n",0,5000,GameState.ui.menuPrompt.actualWidth);
               }
            }
            if(Main.instance.loadedLevel != "")
            {
               GameState.ui.updateControls();
            }
         }
         offsetX = 0;
         offsetY = 0;
         if(GameState.spawningCustom)
         {
            if(Main.instance.sharingItem)
            {
               offsetX = Main.instance.customPos.x - Number(loadOptions.CX);
               offsetY = Main.instance.customPos.y - Number(loadOptions.CY);
            }
            else
            {
               offsetX = -Number(loadOptions.CX) + Main.instance.mouseXWorld * Physics.scale - Main.instance.m_sprite.x >> 0;
               offsetY = -Number(loadOptions.CY) + Main.instance.mouseYWorld * Physics.scale - Main.instance.m_sprite.y >> 0;
            }
         }
         GameState.environmenting = false;
         bodyOrder = new Vector.<b2Body>();
      }
      
      public static function IncrementalLoadFinish() : void
      {
         var _loc3_:Object = null;
         IncrementalLoadRest();
         incrementalLoading = false;
         TimeLord.pauseGrid.Redraw();
         TimeLord.pauseGrid.Finish();
         GameState.ui.menuControls.alpha = 1;
         GameState.ui.menuMain.alpha = 1;
         if(incrementalLoadAutoPlay)
         {
            TimeLord.unpause();
         }
         GameState.ui.updateControls();
         if(Vars.loadSpeed > 99)
         {
            return;
         }
         var _loc1_:String = progressFinish;
         var _loc2_:int = 0;
         for each(_loc3_ in loadItems)
         {
            if(_loc3_.NM == "doll_head")
            {
               _loc2_++;
            }
         }
         if(loadItems.length > 0)
         {
            _loc1_ += "\n" + loadItems.length + " items\n";
         }
         if(_loc2_ > 0)
         {
         }
         if(loadJoints.length > 0)
         {
            _loc1_ += loadJoints.length + " joints";
         }
         if(loadItems.length > 20)
         {
            GameState.ui.showTooltip(GameState.ui.console,_loc1_,0,1000,200);
         }
         Properties.restoreTempProperties();
      }
      
      public static function IncrementalLoadCancel() : void
      {
         incrementalLoading = false;
         TimeLord.pauseGrid.Draw();
         GameState.ui.menuControls.alpha = 1;
         GameState.ui.menuMain.alpha = 1;
         GameState.ui.showTooltip(GameState.ui.console,progressCancel,0,500,200);
      }
      
      public static function IncrementalLoadItems() : Boolean
      {
         var loadItem:Object;
         var skin:Vector.<Array>;
         var spawnee:b2Body;
         var loadSkin:Object = null;
         var sk:Array = null;
         var origcol:String = null;
         var newcol:String = null;
         var replace:String = null;
         var spawnud:userData = null;
         var crarr:Array = null;
         var TCUC:String = null;
         var gungun:Firearm = null;
         var fxs:Array = null;
         var fxn:Array = null;
         var find:int = 0;
         var type:Class = null;
         var fxp:b2Vec2 = null;
         var fx:ParticleEffect = null;
         var fparts:Array = null;
         var fratios:Array = null;
         var fxi:int = 0;
         var bmd:BitmapData = null;
         var uncompressedString:String = null;
         var pixels:ByteArray = null;
         var bleeds:Array = null;
         var bleed:String = null;
         var wound:Array = null;
         if(!loadItems)
         {
            return true;
         }
         loadItem = loadItems[incrementalLoadInd];
         if(loadItem.NM == "deleted")
         {
            loadItem.NM = "square";
         }
         if(Boolean(loadItem.SZ) || Boolean(loadItem.DN) || Boolean(loadItem.FR) || Boolean(loadItem.RS) || Boolean(loadItem.DL) || Boolean(loadItem.DA))
         {
            if(loadItem.SZ)
            {
               Vars.objSize = loadItem.SZ;
            }
            if(loadItem.DN)
            {
               Vars.objDensity = loadItem.DN;
            }
            if(loadItem.FR)
            {
               Vars.objFriction = loadItem.FR;
            }
            if(loadItem.RS)
            {
               Vars.objRestitution = loadItem.RS;
            }
            if(loadItem.DL)
            {
               Vars.objDampLinear = loadItem.DL;
            }
            if(loadItem.DA)
            {
               Vars.objDampAngular = loadItem.DA;
            }
         }
         skin = new Vector.<Array>();
         for each(loadSkin in loadSkins)
         {
            if(loadSkin.ID == bodyOrder.length)
            {
               sk = String(loadSkin.SKIN).split(".");
               for each(replace in sk)
               {
                  newcol = replace.substr(-6,6);
                  replace = replace.replace(newcol,"");
                  origcol = replace;
                  skin.push([origcol,newcol]);
               }
               break;
            }
         }
         GameState.objects.spawnSkin = skin;
         loadItem.PX = Number(loadItem.PX) + offsetX;
         loadItem.PY = Number(loadItem.PY) + offsetY;
         loadItem.AN = Number(loadItem.AN);
         if(loadItem.vanilla)
         {
            Properties.forceObjVanilla = 1;
         }
         if(loadItem.fixedrotation)
         {
            Properties.forceObjFixed = 1;
         }
         if(loadItem.stainless)
         {
            Properties.forceObjStain = 1;
         }
         if(loadItem.ghost)
         {
            Properties.forceObjGhost = 1;
         }
         spawnee = GameState.objects.delayedSpawnObject(loadItem.NM,loadItem.PX,loadItem.PY,loadItem.AN ? Number(loadItem.AN) : 0,loadItem.flipped ? true : false,true,skin);
         if(!spawnee)
         {
            GameState.ui.showTooltip(GameState.ui.console,"Loading item model \"" + loadItem.NM + "\" failed.\nMake sure the item exists in your Library.\n",100,5000,250);
         }
         Properties.forceObjVanilla = 0;
         Properties.forceObjStain = 0;
         Properties.forceObjGhost = 0;
         Properties.forceObjFixed = 0;
         if(spawnee)
         {
            spawnud = userData(spawnee.GetUserData());
            if(GameState.spawningEnvironment)
            {
               GameState.environment.defaultBodies.push(spawnee);
            }
            if(GameState.spawningCustom)
            {
               crarr = GameState.objects.spawnName.split(" by ");
               if(crarr.length == 2)
               {
                  spawnud.customCreator = crarr[1];
               }
            }
            if(spawnud.name == "doll_hand" && !spawnud.triggerLock)
            {
               hands.push(spawnee);
            }
            if(spawnud.name == "doll_head" && loadItem.MH == 3000)
            {
               loadItem.MH *= 5;
               loadItem.HH *= 5;
            }
            if(spawnud.name == "doll_body" && loadItem.MH == 2000)
            {
               loadItem.MH *= 5;
               loadItem.HH *= 5;
            }
            if(spawnud.name == "doll_hand" && loadItem.MH == 1000)
            {
               loadItem.MH *= 5;
               loadItem.HH *= 5;
            }
            if(spawnud.name == "doll_arm" && loadItem.MH == 1250)
            {
               loadItem.MH *= 5;
               loadItem.HH *= 5;
            }
            if(spawnud.name == "doll_leg" && loadItem.MH == 1500)
            {
               loadItem.MH *= 5;
               loadItem.HH *= 5;
            }
            if(spawnud.name == "doll_foot" && loadItem.MH == 1000)
            {
               loadItem.MH *= 5;
               loadItem.HH *= 5;
            }
            if(spawnud.name == "doll_head" && loadItem.MH == 1800)
            {
               loadItem.MH *= 8;
               loadItem.HH *= 8;
            }
            if(spawnud.name == "doll_body" && loadItem.MH == 1200)
            {
               loadItem.MH *= 8;
               loadItem.HH *= 8;
            }
            if(spawnud.name == "doll_hand" && loadItem.MH == 600)
            {
               loadItem.MH *= 8;
               loadItem.HH *= 8;
            }
            if(spawnud.name == "doll_arm" && loadItem.MH == 600)
            {
               loadItem.MH *= 8;
               loadItem.HH *= 8;
            }
            if(spawnud.name == "doll_leg" && loadItem.MH == 600)
            {
               loadItem.MH *= 8;
               loadItem.HH *= 8;
            }
            if(spawnud.name == "doll_foot" && loadItem.MH == 600)
            {
               loadItem.MH *= 8;
               loadItem.HH *= 8;
            }
            if(loadItem.MH)
            {
               spawnud.maxhealth = loadItem.MH;
               spawnud.health = spawnud.maxhealth;
            }
            if(loadItem.HH)
            {
               spawnud.health = loadItem.HH;
            }
            if(loadItem.SFX)
            {
               spawnud.overrideSound = loadItem.SFX;
            }
            if(loadItem.VOL)
            {
               spawnud.overrideVolume = Number(loadItem.VOL);
            }
            if(loadItem.ALP)
            {
               spawnud.alpha = Number(loadItem.ALP);
            }
            if(loadItem.BC)
            {
               spawnud.bloodColour = uint("0x" + loadItem.BC);
            }
            if(loadItem.ID)
            {
               spawnud.id = loadItem.ID;
            }
            if(loadItem.TF)
            {
               spawnud.triggerForce = loadItem.TF;
            }
            if(loadItem.TR)
            {
               spawnud.triggerRadius = loadItem.TR;
            }
            if(loadItem.TC)
            {
               spawnud.triggerContact = loadItem.TC;
            }
            if(loadItem.TD)
            {
               spawnud.triggerDuration = loadItem.TD;
               spawnud.originalTriggerDuration = loadItem.TD;
            }
            if(loadItem.TCU)
            {
               spawnud.triggerCustom = loadItem.TCU;
               if(spawnud.trigger)
               {
                  spawnud.trigger.OnLoadCustom();
               }
            }
            if(loadItem.TCUC)
            {
               TCUC = loadItem.TCUC;
               TCUC = TCUC.replace(/_/g,"=");
               spawnud.triggerCustom = Base64.uncompress(TCUC);
               if(spawnud.trigger)
               {
                  spawnud.trigger.OnLoadCustom();
               }
            }
            if(loadItem.TM)
            {
               spawnud.temperature = loadItem.TM;
            }
            if(loadItem.GR)
            {
               spawnud.group = loadItem.GR;
            }
            if(loadItem.LR)
            {
               spawnud.layer = loadItem.LR;
               GraphicUtils.addGraphicToLayer(spawnud);
            }
            if(loadItem.MCO)
            {
               spawnud.multiConcussion = Number(loadItem.MCO);
            }
            if(loadItem.MST)
            {
               spawnud.multiStanding = Number(loadItem.MST);
            }
            if(loadItem.MSF)
            {
               spawnud.multiStabForce = Number(loadItem.MSF);
            }
            if(loadItem.MSD)
            {
               spawnud.multiStabDensity = Number(loadItem.MSD);
            }
            if(loadItem.MBP)
            {
               spawnud.multiBulletPenetration = Number(loadItem.MBP);
            }
            if(loadItem.MGD)
            {
               spawnud.multiGlobalDamage = Number(loadItem.MGD);
            }
            if(loadItem.MBU)
            {
               spawnud.multiBulletDamage = Number(loadItem.MBU);
            }
            if(loadItem.MBL)
            {
               spawnud.multiBluntDamage = Number(loadItem.MBL);
            }
            if(loadItem.MBLE)
            {
               spawnud.multiBleedDamage = Number(loadItem.MBLE);
            }
            if(loadItem.MSH)
            {
               spawnud.multiSharpDamage = Number(loadItem.MSH);
            }
            if(loadItem.MRE)
            {
               spawnud.multiRegen = Number(loadItem.MRE);
            }
            if(loadItem.TKEY)
            {
               spawnud.triggerKey = int(loadItem.TKEY);
            }
            if(loadItem.HKEY)
            {
               spawnud.triggerKeyHold = int(loadItem.HKEY);
            }
            if(loadItem.GBA)
            {
               gungun = Gun(spawnee.GetUserData().trigger).firearm;
               gungun.modified = true;
               gungun.bulletAmount = Number(loadItem.GBA);
               gungun.bulletSize = Number(loadItem.GBS);
               gungun.burstAmount = Number(loadItem.GBRA);
               gungun.burstDelay = Number(loadItem.GBRD);
               gungun.chamberTime = Number(loadItem.GTIM);
               gungun.magazineSize = Number(loadItem.GMAG);
               gungun.recoil = Number(loadItem.GREC);
               gungun.reloadTime = Number(loadItem.GREL);
               gungun.scatter = Number(loadItem.GSCA);
               gungun.shootForce = Number(loadItem.GFOR);
               gungun.bulletType = loadItem.GBT;
               gungun.bulletProperties = loadItem.GBP.split(".");
            }
            if(loadItem.CU)
            {
               spawnud.customCreator = loadItem.CU;
            }
            if(loadItem.FXE)
            {
               fxs = [PFXNone,PFXAngular,PFXCenter,PFXCenterEmit,PFXCircle,PFXCircleCycling,PFXCirclePingPong,PFXCirclePulse,PFXCircleRandom,PFXConnected,PFXCorners,PFXCross,PFXFirearm,PFXFourSides,PFXGlow,PFXHorizontal,PFXHorizontalPingPong,PFXInside,PFXInwards,PFXJoint,PFXJointAnchor,PFXOutline,PFXOutwards,PFXRadius,PFXSpiral,PFXVertical,PFXVerticalPingPong,PFXVoid,PFXZap,PFXPoint,PFXOverwrite,PFXScan,PFXSnake,PFXVoidInwards,PFXSpiralWave,PFXFirefly,PFXCollision,PFXCollisionExplosion,PFXWound];
               fxn = ["None","Angular","Center","CenterEmit","Circle","CircleCycling","CirclePingPong","CirclePulse","CircleRandom","Connected","Corners","Cross","Firearm","FourSides","Glow","Horizontal","HorizontalPingPong","Inside","Inwards","Joint","JointAnchor","Outline","Outwards","Radius","Spiral","Vertical","VerticalPingPong","Void","Zap","Point","Overwrite","Scan","Snake","VoidInwards","SpiralWave","Firefly","Collision","CollisionExplosion","Wound"];
               find = fxn.indexOf(loadItem.FXE);
               type = fxs[find] as Class;
               fxp = new b2Vec2();
               if(loadItem.FXPO)
               {
                  fxp = new b2Vec2(-loadItem.FXPO.split(".")[0],-loadItem.FXPO.split(".")[1]);
               }
               fxp.x += spawnee.GetPosition().x * Physics.scale;
               fxp.y += spawnee.GetPosition().y * Physics.scale;
               fxp.Multiply(1 / Physics.scale);
               fx = new type(spawnee,fxp);
               if(loadItem.FXSC == "1")
               {
                  fx.applyScale = true;
               }
               else
               {
                  fx.applyScale = false;
               }
               fparts = String(loadItem.FXPA).split(".");
               fratios = String(loadItem.FXR).split(".");
               fxi = 0;
               while(fxi < fparts.length)
               {
                  fx.attachParticles(fratios[fxi] * 0.01,fparts[fxi]);
                  fxi++;
               }
               fx.speed = Number(loadItem.FXSP);
               fx.size = Number(loadItem.FXSZ);
               fx.amount = Number(loadItem.FXN);
               spawnud.pfx = fx;
            }
            spawnud.triggered = false;
            if(loadItem.explosive)
            {
               spawnud.explosive = true;
            }
            if(loadItem.sticky)
            {
               spawnud.sticky = true;
            }
            if(loadItem.sharp)
            {
               spawnud.sharp = true;
            }
            if(loadItem.blunt)
            {
               spawnud.blunt = true;
            }
            if(loadItem.breakable)
            {
               spawnud.breakable = true;
            }
            if(loadItem.crumble)
            {
               spawnud.crumble = true;
            }
            if(loadItem.brittle)
            {
               spawnud.brittle = true;
            }
            if(loadItem.implosive)
            {
               spawnud.implosive = true;
            }
            if(loadItem.alive)
            {
               spawnud.alive = true;
            }
            if(loadItem.zerograv)
            {
               spawnud.zerograv = true;
            }
            if(loadItem.sleepOnSpawn)
            {
               spawnud.sleepOnSpawn = true;
               spawnee.PutToSleep();
            }
            if(loadItem.antigrav)
            {
               spawnud.antigrav = true;
            }
            if(loadItem.flaming)
            {
               spawnud.flaming = true;
            }
            if(loadItem.freezing)
            {
               spawnud.freezing = true;
            }
            if(loadItem.shocking)
            {
               spawnud.shocking = true;
            }
            if(loadItem.healing)
            {
               spawnud.healing = true;
            }
            if(loadItem.gusting)
            {
               spawnud.gusting = true;
            }
            if(loadItem.killing)
            {
               spawnud.killing = true;
            }
            if(loadItem.draining)
            {
               spawnud.draining = true;
            }
            if(loadItem.poisoning)
            {
               spawnud.poisoning = true;
            }
            if(loadItem.mute)
            {
               spawnud.mute = true;
            }
            if(loadItem.locked)
            {
               spawnud.locked = true;
            }
            if(loadItem.rending)
            {
               spawnud.rending = true;
            }
            if(loadItem.alchemying)
            {
               spawnud.alchemying = true;
            }
            if(loadItem.transmuting)
            {
               spawnud.transmuting = true;
            }
            if(loadItem.critting)
            {
               spawnud.critting = true;
            }
            if(loadItem.deleting)
            {
               spawnud.deleting = true;
            }
            if(loadItem.triggering)
            {
               spawnud.triggering = true;
            }
            if(loadItem.relaying)
            {
               spawnud.relaying = true;
            }
            if(loadItem.cleaning)
            {
               spawnud.cleaning = true;
            }
            if(loadItem.janitoring)
            {
               spawnud.janitoring = true;
            }
            if(loadItem.hyping)
            {
               spawnud.hyping = true;
            }
            if(loadItem.suspending)
            {
               spawnud.suspending = true;
            }
            if(loadItem.banning)
            {
               spawnud.banning = true;
            }
            if(loadItem.blighting)
            {
               spawnud.blighting = true;
            }
            if(loadItem.bulletproof)
            {
               spawnud.bulletproof = true;
            }
            if(loadItem.cauterizing)
            {
               spawnud.cauterizing = true;
            }
            if(loadItem.regenerating)
            {
               spawnud.regenerating = true;
            }
            if(loadItem.disintegrator)
            {
               spawnud.disintegrator = true;
            }
            if(loadItem.disintegrating)
            {
               spawnud.disintegrating = true;
            }
            if(loadItem.drying)
            {
               spawnud.drying = true;
            }
            if(loadItem.frostfiring)
            {
               spawnud.frostfiring = true;
            }
            if(loadItem.frying)
            {
               spawnud.frying = true;
            }
            if(loadItem.wetting)
            {
               spawnud.wetting = true;
            }
            if(loadItem.glassing)
            {
               spawnud.glassing = true;
            }
            if(loadItem.glitching)
            {
               spawnud.glitching = true;
            }
            if(loadItem.magnetic)
            {
               spawnud.magnetic = true;
            }
            if(loadItem.oily)
            {
               spawnud.oily = true;
            }
            if(loadItem.petrifying)
            {
               spawnud.petrifying = true;
            }
            if(loadItem.radioactive)
            {
               spawnud.radioactive = true;
            }
            if(loadItem.sanguine)
            {
               spawnud.sanguine = true;
            }
            if(loadItem.scorching)
            {
               spawnud.scorching = true;
            }
            if(loadItem.ultrasharp)
            {
               spawnud.ultrasharp = true;
            }
            if(loadItem.triggerOnCut)
            {
               spawnud.triggerOnCut = true;
            }
            if(loadItem.triggerLinkedInstead)
            {
               spawnud.triggerLinkedInstead = true;
            }
            if(loadItem.triggerLinkedAsWell)
            {
               spawnud.triggerLinkedAsWell = true;
            }
            if(loadItem.warming)
            {
               spawnud.warming = true;
            }
            if(loadItem.webbing)
            {
               spawnud.webbing = true;
            }
            if(loadItem.spreading)
            {
               spawnud.spreading = true;
            }
            if(loadItem.resistGhosting)
            {
               spawnud.resistGhosting = true;
            }
            if(loadItem.resistProtect)
            {
               spawnud.resistProtect = true;
            }
            if(loadItem.resistAdrenaline)
            {
               spawnud.resistAdrenaline = true;
            }
            if(loadItem.resistArc)
            {
               spawnud.resistArc = true;
            }
            if(loadItem.resistGravity)
            {
               spawnud.resistGravity = true;
            }
            if(loadItem.resistDroning)
            {
               spawnud.resistDroning = true;
            }
            if(loadItem.resistSnare)
            {
               spawnud.resistSnare = true;
            }
            if(loadItem.concussing)
            {
               spawnud.concussing = true;
            }
            if(loadItem.resistDispel)
            {
               spawnud.resistDispel = true;
            }
            if(loadItem.resistDrain)
            {
               spawnud.resistDrain = true;
            }
            if(loadItem.resistFlame)
            {
               spawnud.resistFlame = true;
            }
            if(loadItem.resistFreeze)
            {
               spawnud.resistFreeze = true;
            }
            if(loadItem.resistGust)
            {
               spawnud.resistGust = true;
            }
            if(loadItem.resistHeal)
            {
               spawnud.resistHeal = true;
            }
            if(loadItem.resistKill)
            {
               spawnud.resistKill = true;
            }
            if(loadItem.resistPoison)
            {
               spawnud.resistPoison = true;
            }
            if(loadItem.resistShock)
            {
               spawnud.resistShock = true;
            }
            if(loadItem.resistConcuss)
            {
               spawnud.resistConcuss = true;
            }
            if(loadItem.resistBanning)
            {
               spawnud.resistBanning = true;
            }
            if(loadItem.resistBlighting)
            {
               spawnud.resistBlighting = true;
            }
            if(loadItem.resistStasis)
            {
               spawnud.resistStasis = true;
            }
            if(loadItem.resistTransmuting)
            {
               spawnud.resistTransmuting = true;
            }
            if(loadItem.resistCutting)
            {
               spawnud.resistCutting = true;
            }
            if(loadItem.resistAliveBreak)
            {
               spawnud.resistAliveBreak = true;
            }
            if(loadItem.resistDisintegrating)
            {
               spawnud.resistDisintegrating = true;
            }
            if(loadItem.resistDrying)
            {
               spawnud.resistDrying = true;
            }
            if(loadItem.resistFrostfiring)
            {
               spawnud.resistFrostfiring = true;
            }
            if(loadItem.resistFrying)
            {
               spawnud.resistFrying = true;
            }
            if(loadItem.resistGassy)
            {
               spawnud.resistGassy = true;
            }
            if(loadItem.resistGlassing)
            {
               spawnud.resistGlassing = true;
            }
            if(loadItem.resistGlitching)
            {
               spawnud.resistGlitching = true;
            }
            if(loadItem.resistMagnetic)
            {
               spawnud.resistMagnetic = true;
            }
            if(loadItem.resistOily)
            {
               spawnud.resistOily = true;
            }
            if(loadItem.resistPetrifying)
            {
               spawnud.resistPetrifying = true;
            }
            if(loadItem.resistRadioactive)
            {
               spawnud.resistRadioactive = true;
            }
            if(loadItem.resistBleed)
            {
               spawnud.resistBleed = true;
            }
            if(loadItem.resistArmour)
            {
               spawnud.resistArmour = true;
            }
            if(loadItem.resistJoints)
            {
               spawnud.resistJoints = true;
            }
            if(loadItem.resistScorching)
            {
               spawnud.resistScorching = true;
            }
            if(loadItem.resistUltrasharp)
            {
               spawnud.resistUltrasharp = true;
            }
            if(loadItem.resistChilling)
            {
               spawnud.resistChilling = true;
            }
            if(loadItem.resistWarming)
            {
               spawnud.resistWarming = true;
            }
            if(loadItem.resistWebbing)
            {
               spawnud.resistWebbing = true;
            }
            if(loadItem.ghost)
            {
               spawnud.ghost = true;
            }
            if(loadItem.invisible)
            {
               spawnud.invisible = true;
            }
            if(loadItem.unbreakable)
            {
               spawnud.unbreakable = true;
            }
            if(loadItem.flammable)
            {
               spawnud.flammable = true;
               spawnud.conductivity = 0.01;
               spawnud.ignition = 100;
            }
            if(loadItem.dispelling)
            {
               spawnud.dispelling = true;
               spawnud.triggerDuration = 0;
            }
            if(loadItem.magnet)
            {
               spawnud.magnet = true;
            }
            if(loadItem.triggered)
            {
               spawnud.triggered = true;
            }
            if(loadItem.stainless)
            {
               spawnud.stainless = true;
            }
            if(loadItem.vanilla)
            {
               spawnud.vanilla = true;
            }
            if(loadItem.blunt)
            {
               spawnud.blunt = true;
            }
            if(loadItem.fixedrotation)
            {
               spawnud.fixedrotation = true;
               spawnee.SetFixedRotation(true);
            }
            if(loadItem.unequipDead)
            {
               spawnud.unequipDead = true;
            }
            if(loadItem.unequipConcuss)
            {
               spawnud.unequipConcuss = true;
            }
            if(loadItem.wallGhost)
            {
               spawnud.wallGhost = true;
            }
            if(loadItem.projectileGhost)
            {
               spawnud.projectileGhost = true;
            }
            if(loadItem.saveStains)
            {
               spawnud.saveStains = true;
            }
            if(spawnud.invisible)
            {
               spawnud.graphic.alpha = 0;
            }
            if(loadItem.TA)
            {
               Main.instance.contract.target = int(loadItem.TA);
               Main.instance.contract.addTargetBody(spawnee);
               contractLoaded = true;
               if(loadItem.TAX)
               {
                  spawnud.targetX = loadItem.TAX;
                  spawnud.targetY = loadItem.TAY;
               }
            }
            if(loadItem.VX)
            {
               spawnee.WakeUp();
               spawnee.GetLinearVelocity().x = loadItem.VX / Physics.scale;
            }
            if(loadItem.VY)
            {
               spawnee.WakeUp();
               spawnee.GetLinearVelocity().y = loadItem.VY / Physics.scale;
            }
            if(loadItem.VA)
            {
               spawnee.WakeUp();
               spawnee.SetAngularVelocity(loadItem.VA / Physics.scale);
            }
            if(loadItem.GFX)
            {
               try
               {
                  bmd = BoxUtils.getEffectBMD(spawnee);
                  uncompressedString = String(loadItem.GFX).replace(/-/g,"/").replace(/_/g,"=").replace(/%/g,"!!!!!!!!!!").replace(/!/g,"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                  pixels = Base64.Decode(uncompressedString);
                  pixels.position = 0;
                  bmd.setPixels(bmd.rect,pixels);
               }
               catch(e:Error)
               {
               }
            }
            if(loadItem.BLD)
            {
               bleeds = Base64.uncompress(loadItem.BLD.replace(/_/g,"=")).split(";");
               spawnud.bleeding = [];
               for each(bleed in bleeds)
               {
                  wound = bleed.split(",");
                  spawnud.bleeding.push([new b2Vec2(wound[0],wound[1]),new b2Vec2(wound[2],wound[3]),new b2Vec2(wound[4],wound[5]),wound[6]]);
               }
            }
            if(spawnud.trigger)
            {
               spawnud.trigger.OnLoadFinished();
            }
            bodyOrder.push(spawnee);
         }
         else
         {
            bodyOrder.push(null);
         }
         Properties.resetProperties();
         ++incrementalLoadInd;
         ProgressTooltip(progressItems + " " + incrementalLoadInd + "/" + loadItems.length + " (" + int(incrementalLoadInd / loadItems.length * 100) + "%)\n");
         if(incrementalLoadInd >= loadItems.length)
         {
            return false;
         }
         return true;
      }
      
      public static function IncrementalLoadJoints() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:b2Body = null;
         var _loc7_:b2Body = null;
         var _loc9_:b2Joint = null;
         var _loc10_:jointUserData = null;
         var _loc11_:Boolean = false;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:Boolean = false;
         var _loc18_:b2Vec2 = null;
         if(loadJoints.length == 0)
         {
            return false;
         }
         if(incrementalLoadInd >= loadJoints.length)
         {
            return false;
         }
         var _loc1_:Object = loadJoints[incrementalLoadInd];
         ++incrementalLoadInd;
         if(_loc1_.X1)
         {
            _loc2_ = (Number(_loc1_.X1) + offsetX) / Physics.scale;
            _loc3_ = (Number(_loc1_.Y1) + offsetY) / Physics.scale;
            _loc4_ = (Number(_loc1_.X2) + offsetX) / Physics.scale;
            _loc5_ = (Number(_loc1_.Y2) + offsetY) / Physics.scale;
            _loc6_ = Body.GetOne(_loc2_,_loc3_,true);
            _loc7_ = Body.GetOne(_loc4_,_loc5_,true);
         }
         if(Boolean(_loc1_.B1) && _loc1_.B1 != -1)
         {
            _loc6_ = bodyOrder[_loc1_.B1];
         }
         if(Boolean(_loc1_.B2) && _loc1_.B2 != -1)
         {
            _loc7_ = bodyOrder[_loc1_.B2];
         }
         var _loc8_:Number = 10000;
         if(_loc1_.FL)
         {
            _loc8_ = Number(_loc1_.FL);
         }
         if(_loc1_.NM == "bgjoint")
         {
            if(_loc6_)
            {
               _loc9_ = Joints.Pin("bgjoint",_loc6_,new b2Vec2(_loc2_,_loc3_),_loc8_);
            }
            else if(_loc7_)
            {
               _loc9_ = Joints.Pin("bgjoint",_loc7_,new b2Vec2(_loc4_,_loc5_),_loc8_);
            }
         }
         else if(_loc1_.NM == "objjoint")
         {
            if(_loc6_ == _loc7_)
            {
               _loc6_ = Physics.world.GetGroundBody();
            }
            if(!_loc6_ || !_loc7_)
            {
               if(_loc6_)
               {
                  _loc7_ = Physics.world.GetGroundBody();
               }
               else
               {
                  if(!_loc7_)
                  {
                     return true;
                  }
                  _loc6_ = Physics.world.GetGroundBody();
               }
            }
            if(_loc6_ == _loc7_)
            {
               return true;
            }
            _loc11_ = true;
            if(_loc1_.collide)
            {
               _loc11_ = loadOptions.collide == 1;
            }
            _loc9_ = Joints.Distance("objjoint",_loc6_,_loc7_,new b2Vec2(_loc2_,_loc3_),new b2Vec2(_loc4_,_loc5_),0,0,_loc11_,_loc8_);
         }
         else if(_loc1_.NM == "ropejoint")
         {
            if(_loc6_ == _loc7_)
            {
               _loc6_ = Physics.world.GetGroundBody();
            }
            if(!_loc6_ || !_loc7_)
            {
               if(_loc6_)
               {
                  _loc7_ = Physics.world.GetGroundBody();
               }
               else
               {
                  if(!_loc7_)
                  {
                     return true;
                  }
                  _loc6_ = Physics.world.GetGroundBody();
               }
            }
            if(_loc6_ == _loc7_)
            {
               return true;
            }
            _loc11_ = true;
            if(_loc1_.collide)
            {
               _loc11_ = loadOptions.collide == 1;
            }
            _loc12_ = 2;
            _loc13_ = 0.01;
            if(_loc1_.FR)
            {
               _loc12_ = Number(_loc1_.FR);
            }
            if(_loc1_.DA)
            {
               _loc13_ = Number(_loc1_.DA);
            }
            _loc9_ = Joints.Distance("ropejoint",_loc6_,_loc7_,new b2Vec2(_loc2_,_loc3_),new b2Vec2(_loc4_,_loc5_),_loc12_,_loc13_,_loc11_,_loc8_);
         }
         else if(_loc1_.NM == "weldjoint" || _loc1_.NM == "armour")
         {
            if(!_loc6_ || !_loc7_)
            {
               return true;
            }
            if(_loc6_ == _loc7_)
            {
               return true;
            }
            _loc9_ = Joints.Weld(_loc1_.NM,_loc6_,_loc7_,new b2Vec2((_loc6_.GetPosition().x + _loc7_.GetPosition().x) * 0.5,(_loc6_.GetPosition().y + _loc7_.GetPosition().y) * 0.5),_loc8_);
         }
         else if(_loc1_.NM == "equip")
         {
            if(!_loc6_ || !_loc7_)
            {
               return true;
            }
            if(_loc6_ == _loc7_)
            {
               return true;
            }
            _loc9_ = Joints.Weld("equip",_loc6_,_loc7_,new b2Vec2((_loc6_.GetPosition().x + _loc7_.GetPosition().x) * 0.5,(_loc6_.GetPosition().y + _loc7_.GetPosition().y) * 0.5));
         }
         else if(_loc1_.NM == "rag")
         {
            if(!_loc6_ || !_loc7_)
            {
               return true;
            }
            _loc9_ = Joints.Revolution("rag",_loc6_,_loc7_,Number(_loc1_.X3) + offsetX,Number(_loc1_.Y3) + offsetY,_loc1_.lower,_loc1_.upper,true,_loc8_);
            _loc10_ = jointUserData(_loc9_.GetUserData());
            _loc10_.cuttable = false;
            if(_loc1_.FL)
            {
               _loc10_.forceLimit = _loc1_.FL;
            }
            else
            {
               _loc10_.forceLimit = 42000;
            }
         }
         else if(_loc1_.NM == "revolute")
         {
            if(!_loc6_ || !_loc7_)
            {
               return true;
            }
            if(_loc1_.lower == 0)
            {
               _loc1_.lower = -9000;
            }
            if(_loc1_.upper == 0)
            {
               _loc1_.lower = 9000;
            }
            _loc9_ = Joints.Revolution("revolute",_loc6_,_loc7_,Number(_loc1_.X3) + offsetX,Number(_loc1_.Y3) + offsetY,_loc1_.lower,_loc1_.upper,true,_loc8_) as b2RevoluteJoint;
            _loc10_ = jointUserData(_loc9_.GetUserData());
            _loc10_.cuttable = false;
            if(_loc1_.speed != 0)
            {
               b2RevoluteJoint(_loc9_).EnableMotor(true);
               b2RevoluteJoint(_loc9_).SetMotorSpeed(_loc1_.speed);
               b2RevoluteJoint(_loc9_).SetMaxMotorTorque(_loc1_.force);
            }
         }
         else if(_loc1_.NM == "pistonjoint")
         {
            if(_loc6_ == _loc7_)
            {
               _loc6_ = Physics.world.GetGroundBody();
            }
            if(!_loc6_ || !_loc7_)
            {
               if(_loc6_)
               {
                  _loc7_ = Physics.world.GetGroundBody();
               }
               else
               {
                  if(!_loc7_)
                  {
                     return true;
                  }
                  _loc6_ = Physics.world.GetGroundBody();
               }
            }
            if(_loc6_ == _loc7_)
            {
               return true;
            }
            _loc14_ = new b2Vec2(-Number(_loc1_.X1) + offsetX,-Number(_loc1_.Y1) + offsetY);
            _loc15_ = new b2Vec2(Number(_loc1_.X2) + offsetX,Number(_loc1_.Y2) + offsetY);
            _loc16_ = _loc6_.GetPosition().Copy();
            _loc16_.Multiply(Physics.scale);
            _loc9_ = Joints.Prismatic("pistonjoint",_loc6_,_loc7_,new b2Vec2(),_loc14_,_loc8_);
            _loc17_ = false;
            if(Boolean(_loc1_.upper) && _loc1_.upper != 0)
            {
               _loc17_ = true;
               b2PrismaticJoint(_loc9_).m_upperTranslation = Math.abs(_loc1_.upper);
            }
            if(Boolean(_loc1_.lower) && _loc1_.lower != 0)
            {
               _loc17_ = true;
               b2PrismaticJoint(_loc9_).m_lowerTranslation = -Math.abs(_loc1_.lower);
            }
            if(_loc17_)
            {
               b2PrismaticJoint(_loc9_).EnableLimit(true);
            }
            b2PrismaticJoint(_loc9_).InitPositionConstraints();
            if(_loc1_.speed != 0)
            {
               if(_loc9_ is b2RevoluteJoint)
               {
                  b2RevoluteJoint(_loc9_).EnableMotor(true);
                  b2RevoluteJoint(_loc9_).SetMotorSpeed(_loc1_.speed);
                  b2RevoluteJoint(_loc9_).SetMaxMotorTorque(_loc1_.force);
               }
               if(_loc9_ is b2PrismaticJoint)
               {
                  b2PrismaticJoint(_loc9_).EnableMotor(true);
                  b2PrismaticJoint(_loc9_).SetMotorSpeed(_loc1_.speed);
                  b2PrismaticJoint(_loc9_).SetMaxMotorForce(_loc1_.force);
               }
            }
         }
         if(!_loc9_ || !_loc9_.GetUserData())
         {
            return true;
         }
         _loc10_ = jointUserData(_loc9_.GetUserData());
         if(_loc1_.LC)
         {
            _loc10_.lineColour = _loc1_.LC;
         }
         if(_loc1_.LW)
         {
            _loc10_.lineWidth = _loc1_.LW;
         }
         if(_loc1_.LV)
         {
            _loc10_.lineVisible = _loc1_.LV == "true";
         }
         if(_loc1_.FL)
         {
            _loc10_.forceLimit = _loc1_.FL;
         }
         if(_loc1_.LCC)
         {
            _loc9_.m_collideConnected = _loc1_.LCC == "true";
         }
         if(!_loc9_.m_collideConnected)
         {
            if(Boolean(_loc6_) && _loc6_ != Physics.world.GetGroundBody())
            {
               _loc18_ = _loc6_.GetPosition().Copy();
               _loc6_.SetXForm(new b2Vec2(-10,-10),_loc6_.GetAngle());
               _loc6_.SetXForm(_loc18_,_loc6_.GetAngle());
            }
            if(Boolean(_loc7_) && _loc7_ != Physics.world.GetGroundBody())
            {
               _loc18_ = _loc7_.GetPosition().Copy();
               _loc7_.SetXForm(new b2Vec2(10,-10),_loc7_.GetAngle());
               _loc7_.SetXForm(_loc18_,_loc7_.GetAngle());
            }
         }
         if(incrementalLoadInd >= loadJoints.length)
         {
            return false;
         }
         return true;
      }
      
      private static function IncrementalLoadRest() : void
      {
         var _loc1_:Object = null;
         var _loc2_:b2Body = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2JointEdge = null;
         var _loc9_:jointUserData = null;
         var _loc10_:Contract = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         for each(_loc1_ in loadLinks)
         {
            _loc4_ = int(_loc1_.LINK);
            _loc5_ = String(_loc1_.TO).split(".");
            for each(_loc6_ in _loc5_)
            {
               userData(bodyOrder[_loc4_].GetUserData()).connected.push(bodyOrder[int(_loc6_)]);
            }
         }
         for each(_loc1_ in loadIgnores)
         {
            _loc4_ = int(_loc1_.IGN);
            _loc5_ = String(_loc1_.ORE).split(".");
            if(_loc5_.length != 0)
            {
               for each(_loc6_ in _loc5_)
               {
                  if(int(_loc6_) != _loc4_)
                  {
                     userData(bodyOrder[_loc4_].GetUserData()).addIgnore(bodyOrder[int(_loc6_)]);
                  }
               }
               _loc7_ = bodyOrder[_loc4_].GetPosition().Copy();
               bodyOrder[_loc4_].SetXForm(new b2Vec2(-10,-10),bodyOrder[_loc4_].GetAngle());
               bodyOrder[_loc4_].SetXForm(_loc7_,bodyOrder[_loc4_].GetAngle());
            }
         }
         for each(_loc2_ in hands)
         {
            GameState.objects.Equips(_loc2_);
            _loc8_ = _loc2_.GetJointList();
            while(_loc8_)
            {
               _loc9_ = jointUserData(_loc8_.joint.GetUserData());
               if(_loc9_.name == "equip")
               {
                  userData(_loc2_.GetUserData()).trigger = new Unequip();
               }
               _loc8_ = _loc8_.next;
            }
         }
         _loc3_ = false;
         if(Boolean(loadOptions.compound) && loadOptions.compound == 1)
         {
            _loc3_ = true;
         }
         if(!_loc3_)
         {
            _loc10_ = Main.instance.contract;
            for each(_loc11_ in loadContractItems)
            {
               _loc13_ = new b2Vec2();
               _loc13_.x = Number(_loc11_.PX);
               _loc13_.y = Number(_loc11_.PY);
               _loc10_.addItem(_loc11_.NM,_loc13_);
               contractLoaded = true;
            }
            for each(_loc12_ in loadContractAreas)
            {
               _loc10_.ResetPermissions();
               if(_loc12_.SP)
               {
                  _loc10_.areaSpawn = true;
               }
               if(_loc12_.DR)
               {
                  _loc10_.areaDrag = true;
               }
               if(_loc12_.TR)
               {
                  _loc10_.areaTrigger = true;
               }
               if(_loc12_.CU)
               {
                  _loc10_.areaCut = true;
               }
               if(_loc12_.DE)
               {
                  _loc10_.areaDestroy = true;
               }
               if(_loc12_.PO)
               {
                  _loc10_.areaPower = true;
               }
               _loc14_ = new b2Vec2();
               _loc14_.x = Number(_loc12_.PX);
               _loc14_.y = Number(_loc12_.PY);
               _loc15_ = Number(_loc12_.W);
               _loc16_ = Number(_loc12_.H);
               _loc10_.addArea(_loc14_,_loc15_,_loc16_);
               contractLoaded = true;
            }
            if(contractLoaded && !_loc10_.previewing)
            {
               if(loadOptions.creator)
               {
                  _loc10_.creator = loadOptions.creator;
               }
               _loc10_.enabled = true;
               GameState.ui.menuChallenge.open();
               Main.instance.updateChallengeMenu("load");
            }
         }
         if(!incrementalLoadAutoPlay && !GameState.paused)
         {
            TimeLord.speed = Vars.speed;
            GameState.slomo = false;
            GameState.ui.updateControls();
            TimeLord.pause();
            GameState.ui.updateControls();
         }
         TimeLord.SetBlueprint();
         GameState.objects.spawnSkin = new Vector.<Array>();
         GameState.loading = false;
      }
      
      public static function loadEnvironment(param1:String) : void
      {
         incrementalLoading = true;
         incrementalLoadStart(param1,true);
         var _loc2_:int = 0;
         do
         {
            IncrementalLoad();
            _loc2_++;
         }
         while(incrementalLoading && _loc2_ < 9000);
      }
      
      private static function quicksave() : void
      {
         Main.instance.qSaveArray.push(Main.instance.currentSave);
         var _loc1_:Date = new Date();
         Main.instance.qSaveTimeArray.push(_loc1_.time);
         if(Main.instance.qSaveArray.length > 19)
         {
            Main.instance.qSaveArray.shift();
            Main.instance.qSaveTimeArray.shift();
         }
         Settings.saveQuicksaves();
         updateSaveHistory();
         GameState.ui.showTooltip(GameState.ui.console,"Saved.",0,1000,100);
      }
      
      public static function updateSaveHistory() : void
      {
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc1_:Tree = GameState.ui.menuSave.getTree("buttons");
         var _loc2_:TNode = _loc1_.findNode("func","unhistory");
         if(!_loc2_)
         {
            return;
         }
         GameState.ui.menuSave.title = "Save History";
         var _loc3_:XML = <node label="Root Node">
				<node label="Back" func="unhistory" center="true" background="#444444"/>
				<nope label="No recent saves."/>
			</node>;
         if(Main.instance.qSaveArray.length > 0)
         {
            _loc4_ = new Date();
            delete _loc3_.nope;
            _loc5_ = 0;
            while(_loc5_ < Main.instance.qSaveArray.length)
            {
               _loc6_ = <node/>;
               _loc6_.@tooltip = "Click to load.";
               _loc7_ = (_loc4_.time - Main.instance.qSaveTimeArray[_loc5_]) / 1000 >> 0;
               if(_loc7_ < 1)
               {
                  _loc8_ = "Just now.";
               }
               else if(_loc7_ > 3600)
               {
                  _loc8_ = "A long time ago...";
               }
               else if(_loc7_ > 60)
               {
                  _loc8_ = (_loc7_ / 60 >> 0).toString() + "min ago.";
               }
               else
               {
                  _loc8_ = _loc7_ + "sec ago.";
               }
               if(Main.instance.qSaveTimeArray[_loc5_] == 0)
               {
                  _loc8_ = "Previous Session";
                  _loc6_.@tooltip = "This is a recovery save from a previous session. They are stored automatically in case of issues.\n\n\n";
               }
               _loc6_.@label = _loc8_;
               _loc6_.@func = "qload";
               _loc6_.@center = "true";
               _loc6_.@id = _loc5_;
               _loc3_.appendChild(_loc6_);
               _loc5_++;
            }
         }
         GameState.ui.menuSave.getTree("buttons").dataProvider = new TreeDataProvider(_loc3_);
      }
      
      public static function updateSaveFavourites() : void
      {
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         GameState.ui.menuSave.title = "Your Favourited Saves";
         var _loc1_:XML = <node label="Root Node">
				<node label="Back" func="unhistory" center="true" background="#444444"/>
				<node label="Remove Favourites" func="removefavs" tooltip="Opens a list that lets you remove saves.&#10;" ico="tool_detail"/>
				<node label="Set Reset Save" func="defaultfavs" tooltip="Select a save that loads whenever you Reset.&#10;" ico="tool_delete"/>
				<nope label="No favourited saves."/>
			</node>;
         if(Main.instance.favouriteSaveNames.length > 0)
         {
            delete _loc1_.nope;
            _loc2_ = 0;
            while(_loc2_ < Main.instance.favouriteSaveNames.length)
            {
               _loc3_ = <node/>;
               _loc3_.@tooltip = "Click to load.";
               _loc3_.@label = Main.instance.favouriteSaveNames[_loc2_];
               _loc3_.@func = "favload";
               _loc3_.@center = "true";
               _loc3_.@id = _loc2_;
               _loc1_.appendChild(_loc3_);
               _loc2_++;
            }
         }
         GameState.ui.menuSave.getTree("buttons").dataProvider = new TreeDataProvider(_loc1_);
      }
      
      public static function LoadExternalModels() : void
      {
         var infiniteitems:File = null;
         var files:Array = null;
         var libxml:XML = null;
         var f:uint = 0;
         var fileStream:FileStream = null;
         var fileContents:ByteArray = null;
         try
         {
            infiniteitems = File.applicationStorageDirectory.resolvePath("models/");
            if(!infiniteitems || !infiniteitems.exists)
            {
               return;
            }
            files = infiniteitems.getDirectoryListing();
            libxml = R.xml_objects;
            f = 0;
            while(f < files.length)
            {
               if(File(files[f]).type == ".png")
               {
                  fileStream = new FileStream();
                  fileStream.open(files[f],FileMode.READ);
                  fileContents = new ByteArray();
                  fileStream.readBytes(fileContents,0,fileStream.bytesAvailable);
                  fileStream.close();
                  lab.parse(lab.getMetaData(fileContents));
               }
               f++;
            }
            Main.instance.loadLocalItems(false);
         }
         catch(err:Error)
         {
         }
      }
      
      public static function loadExternalModelFromUrl(param1:String) : void
      {
         GameState.ui.console.setConsoleText("URL Loading started");
         param1 = param1.replace(/\s/g,"");
         urls = param1.split(",");
         currentURL = -1;
         loadExternalModelNext();
      }
      
      private static function loadExternalModelNext() : void
      {
         var url:String;
         var request:URLRequest;
         var context:LoaderContext = null;
         ++currentURL;
         if(currentURL >= urls.length)
         {
            GameState.ui.showTooltip(GameState.ui.menuSpawn,"Local models loaded! Enjoy.\n",500,2000,200);
            Main.instance.ReInitLibraryItems();
            return;
         }
         url = urls[currentURL];
         request = new URLRequest(url);
         try
         {
            GameState.ui.console.setConsoleText("Pre-Loader");
            Security.loadPolicyFile("https://rava.games/crossdomain.xml");
            linkloader = new Loader();
            linkloader.contentLoaderInfo.addEventListener(Event.COMPLETE,urlLoaded);
            context = new LoaderContext();
            context.checkPolicyFile = true;
            linkloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loaderIOErrorHandler);
            GameState.ui.console.setConsoleText("Linkloader started");
            linkloader.load(request,context);
         }
         catch(e:*)
         {
            GameState.ui.console.setConsoleText("linkloader error" + e.toString());
         }
      }
      
      private static function loaderIOErrorHandler(param1:IOErrorEvent) : void
      {
         GameState.ui.console.setConsoleText("IOError " + param1.toString());
         linkloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,urlLoaded);
      }
      
      private static function urlLoaded(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc5_:File = null;
         var _loc6_:FileStream = null;
         linkloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,urlLoaded);
         var _loc2_:Object = lab.getMetaData(linkloader.contentLoaderInfo.bytes);
         lab.parse(_loc2_);
         Main.instance.loadLocalItems(false);
         Main.instance.updateLibrary();
         var _loc3_:String = _loc2_.ItemName;
         if(!_loc3_)
         {
            _loc3_ = _loc2_.Title;
         }
         GameState.ui.showTooltip(GameState.ui.menuMain,_loc3_ + " added!\nSee [Library > Local Models]\n",0,3000,300);
         GameState.ui.initSpawnMenu(224);
         GameState.ui.menuSpawn.forceOpen();
         GameState.ui.menuLibrary.forceOpen();
         Main.instance.librarySelect(_loc3_,true);
         _loc4_ = File.applicationStorageDirectory.nativePath;
         _loc5_ = new File(_loc4_);
         _loc5_ = _loc5_.resolvePath("models/" + _loc3_ + "_MaDLab.png");
         _loc6_ = new FileStream();
         _loc6_.open(_loc5_,FileMode.WRITE);
         _loc6_.writeBytes(linkloader.contentLoaderInfo.bytes,45);
         _loc6_.close();
         loadExternalModelNext();
      }
   }
}

