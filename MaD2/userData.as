package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import shiny.ParticleEffect;
   import triggers.Armour;
   import triggers.Disintegrate;
   import triggers.Electrified;
   import triggers.Invincible;
   import triggers.Invis;
   import triggers.Trigger;
   
   public class userData
   {
      
      private var _body:b2Body;
      
      private var _dead:Boolean;
      
      public var name:String;
      
      public var id:int;
      
      private var _itemName:String;
      
      public var size:Number;
      
      public var flipped:Boolean;
      
      public var graphic:Sprite;
      
      public var parent:DisplayObjectContainer;
      
      public var graphicAt:int;
      
      public var hull:Array;
      
      public var bloodColour:uint;
      
      private var _health:Number;
      
      public var maxhealth:Number;
      
      public var parentmaxhealth:Number;
      
      public var bleeding:Array;
      
      public var head:Boolean;
      
      public var foot:Boolean;
      
      public var hand:Boolean;
      
      public var explosive:Boolean;
      
      public var implosive:Boolean;
      
      public var sticky:Boolean;
      
      public var sharp:Boolean;
      
      public var breakable:Boolean;
      
      public var crumble:Boolean;
      
      public var brittle:Boolean;
      
      public var zerograv:Boolean;
      
      public var antigrav:Boolean;
      
      public var petrified:Boolean;
      
      public var relaying:Boolean;
      
      public var flaming:Boolean;
      
      public var freezing:Boolean;
      
      public var shocking:Boolean;
      
      public var healing:Boolean;
      
      public var killing:Boolean;
      
      public var draining:Boolean;
      
      public var dispelling:Boolean;
      
      public var poisoning:Boolean;
      
      public var gusting:Boolean;
      
      public var rending:Boolean;
      
      public var alchemying:Boolean;
      
      public var transmuting:Boolean;
      
      public var critting:Boolean;
      
      public var deleting:Boolean;
      
      public var triggering:Boolean;
      
      public var cleaning:Boolean;
      
      public var janitoring:Boolean;
      
      public var hyping:Boolean;
      
      public var suspending:Boolean;
      
      public var banning:Boolean;
      
      public var blighting:Boolean;
      
      public var cauterizing:Boolean;
      
      public var regenerating:Boolean;
      
      public var disintegrator:Boolean;
      
      public var disintegrating:Boolean;
      
      public var drying:Boolean;
      
      public var frostfiring:Boolean;
      
      public var frying:Boolean;
      
      public var wetting:Boolean;
      
      public var glassing:Boolean;
      
      public var glitching:Boolean;
      
      public var magnetic:Boolean;
      
      public var oily:Boolean;
      
      public var petrifying:Boolean;
      
      public var radioactive:Boolean;
      
      public var sanguine:Boolean;
      
      public var scorching:Boolean;
      
      public var ultrasharp:Boolean;
      
      public var triggerOnCut:Boolean;
      
      public var warming:Boolean;
      
      public var webbing:Boolean;
      
      public var spreading:Boolean;
      
      public var resistDispel:Boolean;
      
      public var resistDrain:Boolean;
      
      public var resistFlame:Boolean;
      
      public var resistFreeze:Boolean;
      
      public var resistGust:Boolean;
      
      public var resistHeal:Boolean;
      
      public var resistKill:Boolean;
      
      public var resistPoison:Boolean;
      
      public var resistShock:Boolean;
      
      public var resistConcuss:Boolean;
      
      public var resistBleed:Boolean;
      
      public var resistArmour:Boolean;
      
      public var resistJoints:Boolean;
      
      public var resistBanning:Boolean;
      
      public var resistBlighting:Boolean;
      
      public var resistStasis:Boolean;
      
      public var resistTransmuting:Boolean;
      
      public var resistCutting:Boolean;
      
      public var resistAliveBreak:Boolean;
      
      public var resistDisintegrating:Boolean;
      
      public var resistDrying:Boolean;
      
      public var resistFrostfiring:Boolean;
      
      public var resistFrying:Boolean;
      
      public var resistGassy:Boolean;
      
      public var resistGlassing:Boolean;
      
      public var resistGlitching:Boolean;
      
      public var resistMagnetic:Boolean;
      
      public var resistOily:Boolean;
      
      public var resistPetrifying:Boolean;
      
      public var resistRadioactive:Boolean;
      
      public var resistScorching:Boolean;
      
      public var resistUltrasharp:Boolean;
      
      public var resistChilling:Boolean;
      
      public var resistWarming:Boolean;
      
      public var resistWebbing:Boolean;
      
      public var resistGhosting:Boolean;
      
      public var resistProtect:Boolean;
      
      public var resistAdrenaline:Boolean;
      
      public var resistArc:Boolean;
      
      public var resistGravity:Boolean;
      
      public var resistDroning:Boolean;
      
      public var resistSnare:Boolean;
      
      public var concussing:Boolean;
      
      public var bulletproof:Boolean;
      
      public var resistCollision:Boolean;
      
      public var animated:Boolean;
      
      public var alive:Boolean;
      
      public var armoured:Boolean;
      
      public var burning:Boolean;
      
      public var blunt:Boolean;
      
      public var vanilla:Boolean;
      
      public var unbreakable:Boolean;
      
      public var flammable:Boolean;
      
      public var fixedrotation:Boolean;
      
      public var magnet:Boolean;
      
      public var sensor:Boolean;
      
      public var stainless:Boolean = false;
      
      private var _invisible:Boolean;
      
      public var ghost:Boolean;
      
      public var unequipDead:Boolean = false;
      
      public var unequipConcuss:Boolean = false;
      
      public var wallGhost:Boolean = false;
      
      public var projectileGhost:Boolean = false;
      
      public var inheritSettings:Boolean = false;
      
      public var mute:Boolean = false;
      
      public var locked:Boolean = false;
      
      public var hidden:Boolean = false;
      
      public var overrideSound:String;
      
      public var overrideVolume:Number;
      
      public var triggerKey:int = -1;
      
      public var triggerKeyHold:int = -1;
      
      public var keydown:Boolean = false;
      
      public var invisibling:Boolean = false;
      
      public var aimhacking:Boolean = false;
      
      public var multiHealth:Number = 1;
      
      public var multiConcussion:Number = 1;
      
      public var multiStanding:Number = 1;
      
      public var multiStabForce:Number = 1;
      
      public var multiStabDensity:Number = 1;
      
      public var multiBulletPenetration:Number = 1;
      
      public var multiGlobalDamage:Number = 1;
      
      public var multiBulletDamage:Number = 1;
      
      public var multiBluntDamage:Number = 1;
      
      public var multiBleedDamage:Number = 1;
      
      public var multiSharpDamage:Number = 1;
      
      public var multiRegen:Number = 1;
      
      private var _temperature:Number;
      
      public var ignition:Number;
      
      public var temperatureMelt:Number;
      
      public var temperatureMolten:Number;
      
      public var conductivity:Number;
      
      public var connected:Vector.<b2Body>;
      
      public var ignored:Vector.<b2Body>;
      
      private var _trigger:Trigger;
      
      public var armour:Armour;
      
      public var originalTrigger:Trigger;
      
      public var originalTriggered:int = 0;
      
      public var _triggered:Boolean;
      
      public var triggerState:int;
      
      public var triggerForce:Number;
      
      public var triggerForceAllowNegative:Boolean = false;
      
      public var triggerContact:Number;
      
      public var triggerCollide:Number;
      
      public var triggerColour:String;
      
      public var triggerSound:String;
      
      public var triggerParticle:String;
      
      private var _triggerDuration:Number;
      
      public var triggerCustom:String;
      
      public var originalTriggerDuration:Number;
      
      public var triggerRadius:Number;
      
      public var drawRadius:Boolean = true;
      
      public var triggerPos:b2Vec2;
      
      public var triggerPosFlipped:b2Vec2;
      
      public var triggerLock:Boolean;
      
      public var killOnContact:Boolean;
      
      public var weldOnContact:Boolean;
      
      public var ghostOnContact:Boolean;
      
      public var triggerOnContact:Boolean;
      
      public var triggerLinkedInstead:Boolean = false;
      
      public var triggerLinkedAsWell:Boolean = false;
      
      private var _saveable:Boolean;
      
      public var saveName:String;
      
      public var projectile:Boolean;
      
      public var projectileName:String;
      
      public var stabilise:Boolean;
      
      public var hasBeenCut:Boolean;
      
      public var density:Number;
      
      public var skin:Vector.<Array>;
      
      public var soft:Boolean;
      
      public var ghostCollide:Boolean = false;
      
      public var armourCollide:Boolean = true;
      
      public var debug:Boolean = false;
      
      public var gridSnap:Boolean = false;
      
      public var effectCounter:Number = 0;
      
      public var customCreator:String = "Guest";
      
      public var alphas:Array;
      
      public var sleepOnSpawn:Boolean;
      
      public var ignore:String = "";
      
      public var layer:int = 1;
      
      public var group:int = 0;
      
      private var _shiny:ParticleEffect;
      
      private var _cycle:int = 0;
      
      private var cycledir:int = 1;
      
      private var _width:Number;
      
      private var _height:Number;
      
      public var justSpawned:Boolean = false;
      
      public var target:int = -1;
      
      public var targetX:int = -1;
      
      public var targetY:int = -1;
      
      public var saveStains:Boolean = false;
      
      internal var propertyNames:Array = ["alchemying","alive","animated","antigrav","banning","blighting","blunt","breakable","brittle","bulletproof","burning","cauterizing","cleaning","concussing","critting","crumble","deleting","disintegrating","disintegrator","dispelling","draining","drying","explosive","fixedrotation","flaming","flammable","freezing","frostfiring","frying","ghost","wallGhost","glassing","glitching","gusting","healing","hyping","implosive","invisible","janitoring","killing","magnet","magnetic","oily","petrified","petrifying","poisoning","radioactive","regenerating","relaying","rending","resistAdrenaline","resistAliveBreak","resistArc","resistBanning","resistBleed","resistArmour","resistJoints","resistBlighting","resistChilling","resistConcuss","resistCutting","resistDisintegrating","resistDispel","resistDrain","resistDroning","resistDrying","resistFlame","resistFreeze","resistFrostfiring","resistFrying","resistGassy","resistGhosting","resistGlassing","resistGlitching","resistGravity"
      ,"resistGust","resistHeal","resistKill","resistMagnetic","resistOily","resistPetrifying","resistPoison","resistProtect","resistRadioactive","resistScorching","resistShock","resistSnare","resistStasis","resistTransmuting","resistUltrasharp","resistWarming","resistWebbing","sanguine","scorching","sensor","sharp","shocking","stainless","sticky","suspending","transmuting","triggerOnCut","triggerOnContact","triggerLinkedAsWell","triggerLinkedInstead","triggering","ultrasharp","unbreakable","vanilla","warming","webbing","wetting","spreading","zerograv","mute","unequipDead","unequipConcuss","saveStains","projectileGhost","inheritSettings","locked","killOnContact","ghostOnContact","weldOnContact","aimhacking","invisibling"];
      
      public var overwhelmDamages:Array = [];
      
      public var overwhelmAmount:int = 0;
      
      private var _alpha:* = 1;
      
      public var stabs:Vector.<StabData> = new Vector.<StabData>();
      
      public function userData(param1:String, param2:int, param3:String = "")
      {
         super();
         this.dead = false;
         this.name = param1;
         this.id = param2;
         this.bleeding = [];
         this.burning = false;
         this.flipped = false;
         this.stabilise = false;
         this.size = 1;
         this.health = Vars.objHealth;
         this.maxhealth = Vars.objMaxHealth;
         this.parentmaxhealth = 0;
         this.temperature = 37;
         this.triggered = false;
         this.triggerContact = 0;
         this.triggerCollide = 0;
         this.triggerPos = new b2Vec2();
         this.triggerLock = false;
         this.killOnContact = false;
         this.triggerOnContact = false;
         this.connected = new Vector.<b2Body>();
         this.ignored = new Vector.<b2Body>();
         this.saveable = true;
         this.hasBeenCut = false;
         this.soft = false;
         this.sleepOnSpawn = false;
         this.conductivity = 0.0001;
         this.bloodColour = Tweak.bloodColour;
         this.updateProperties(param3,",");
      }
      
      public function setProperties(param1:String) : void
      {
         this.updateProperties(param1,",");
      }
      
      private function updateProperties(param1:String, param2:String) : void
      {
         var _loc5_:String = null;
         if(!param1 || param1.length == 0)
         {
            return;
         }
         var _loc3_:Array = param1.split(param2);
         var _loc4_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = _loc3_[_loc6_];
            if(_loc5_ != "")
            {
               if(this.propertyNames.indexOf(_loc5_) != -1)
               {
                  this[_loc5_] = true;
               }
               else
               {
                  this[_loc5_] = false;
               }
            }
            _loc6_++;
         }
         if("health" in param1 || "maxhealth" in param1)
         {
            this.maxhealth = this.health;
         }
      }
      
      public function resistEverything() : *
      {
         this.resistDispel = true;
         this.resistDrain = true;
         this.resistFlame = true;
         this.resistFreeze = true;
         this.resistGust = true;
         this.resistHeal = true;
         this.resistKill = true;
         this.resistPoison = true;
         this.resistShock = true;
         this.resistConcuss = true;
         this.resistBleed = true;
         this.resistBanning = true;
         this.resistBlighting = true;
         this.resistStasis = true;
         this.resistTransmuting = true;
         this.resistCutting = true;
         this.resistAliveBreak = true;
         this.resistDisintegrating = true;
         this.resistDrying = true;
         this.resistFrostfiring = true;
         this.resistFrying = true;
         this.resistGassy = true;
         this.resistGlassing = true;
         this.resistGlitching = true;
         this.resistMagnetic = true;
         this.resistOily = true;
         this.resistPetrifying = true;
         this.resistRadioactive = true;
         this.resistScorching = true;
         this.resistUltrasharp = true;
         this.resistChilling = true;
         this.resistWarming = true;
         this.resistWebbing = true;
         this.resistGhosting = true;
         this.resistProtect = true;
         this.resistAdrenaline = true;
         this.resistArc = true;
         this.resistGravity = true;
         this.resistDroning = true;
         this.resistSnare = true;
         this.bulletproof = true;
         this.resistCollision = true;
      }
      
      public function ParseTriggerCustom() : Object
      {
         var _loc5_:String = null;
         var _loc1_:Object = {};
         if(!this.triggerCustom || this.triggerCustom.indexOf("=") == -1)
         {
            return _loc1_;
         }
         var _loc2_:Array = this.triggerCustom.split(",");
         if(this.triggerCustom.indexOf(";") != -1)
         {
            _loc2_ = this.triggerCustom.split(";");
         }
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         for each(_loc5_ in _loc2_)
         {
            if(_loc5_.indexOf("=") != -1)
            {
               _loc1_[_loc5_.split("=")[0]] = _loc5_.split("=")[1];
            }
         }
         return _loc1_;
      }
      
      public function copyElemental(param1:userData) : *
      {
         this.customCreator = param1.customCreator;
         this.explosive = param1.explosive;
         this.implosive = param1.implosive;
         this.sticky = param1.sticky;
         this.sharp = param1.sharp;
         this.breakable = param1.breakable;
         this.crumble = param1.crumble;
         this.brittle = param1.brittle;
         this.zerograv = param1.zerograv;
         this.antigrav = param1.antigrav;
         this.petrified = param1.petrified;
         this.relaying = param1.relaying;
         this.flaming = param1.flaming;
         this.freezing = param1.freezing;
         this.shocking = param1.shocking;
         this.healing = param1.healing;
         this.killing = param1.killing;
         this.draining = param1.draining;
         this.dispelling = param1.dispelling;
         this.poisoning = param1.poisoning;
         this.gusting = param1.gusting;
         this.rending = param1.rending;
         this.alchemying = param1.alchemying;
         this.transmuting = param1.transmuting;
         this.critting = param1.critting;
         this.deleting = param1.deleting;
         this.triggering = param1.triggering;
         this.cleaning = param1.cleaning;
         this.janitoring = param1.janitoring;
         this.hyping = param1.hyping;
         this.suspending = param1.suspending;
         this.banning = param1.banning;
         this.blighting = param1.blighting;
         this.cauterizing = param1.cauterizing;
         this.regenerating = param1.regenerating;
         this.disintegrator = param1.disintegrator;
         this.disintegrating = param1.disintegrating;
         this.drying = param1.drying;
         this.frostfiring = param1.frostfiring;
         this.frying = param1.frying;
         this.wetting = param1.wetting;
         this.glassing = param1.glassing;
         this.glitching = param1.glitching;
         this.magnetic = param1.magnetic;
         this.oily = param1.oily;
         this.petrifying = param1.petrifying;
         this.radioactive = param1.radioactive;
         this.sanguine = param1.sanguine;
         this.scorching = param1.scorching;
         this.ultrasharp = param1.ultrasharp;
         this.triggerOnCut = param1.triggerOnCut;
         this.triggerLinkedAsWell = param1.triggerLinkedAsWell;
         this.triggerLinkedInstead = param1.triggerLinkedInstead;
         this.warming = param1.warming;
         this.webbing = param1.webbing;
         this.spreading = param1.spreading;
         this.animated = param1.animated;
         this.resistDispel = param1.resistDispel;
         this.resistDrain = param1.resistDrain;
         this.resistFlame = param1.resistFlame;
         this.resistFreeze = param1.resistFreeze;
         this.resistGust = param1.resistGust;
         this.resistHeal = param1.resistHeal;
         this.resistKill = param1.resistKill;
         this.resistPoison = param1.resistPoison;
         this.resistShock = param1.resistShock;
         this.resistConcuss = param1.resistConcuss;
         this.resistBleed = param1.resistBleed;
         this.resistJoints = param1.resistJoints;
         this.resistArmour = param1.resistArmour;
         this.resistBanning = param1.resistBanning;
         this.resistBlighting = param1.resistBlighting;
         this.resistStasis = param1.resistStasis;
         this.resistTransmuting = param1.resistTransmuting;
         this.resistCutting = param1.resistCutting;
         this.resistAliveBreak = param1.resistAliveBreak;
         this.resistDisintegrating = param1.resistDisintegrating;
         this.resistDrying = param1.resistDrying;
         this.resistFrostfiring = param1.resistFrostfiring;
         this.resistFrying = param1.resistFrying;
         this.resistGassy = param1.resistGassy;
         this.resistGlassing = param1.resistGlassing;
         this.resistGlitching = param1.resistGlitching;
         this.resistMagnetic = param1.resistMagnetic;
         this.resistOily = param1.resistOily;
         this.resistPetrifying = param1.resistPetrifying;
         this.resistRadioactive = param1.resistRadioactive;
         this.resistScorching = param1.resistScorching;
         this.resistUltrasharp = param1.resistUltrasharp;
         this.resistChilling = param1.resistChilling;
         this.resistWarming = param1.resistWarming;
         this.resistWebbing = param1.resistWebbing;
         this.bulletproof = param1.bulletproof;
         this.resistCollision = param1.resistCollision;
         this.resistGhosting = param1.resistGhosting;
         this.resistProtect = param1.resistProtect;
         this.resistAdrenaline = param1.resistAdrenaline;
         this.resistArc = param1.resistArc;
         this.resistGravity = param1.resistGravity;
         this.resistDroning = param1.resistDroning;
         this.resistSnare = param1.resistSnare;
         this.concussing = param1.concussing;
      }
      
      public function copyProperties(param1:userData, param2:b2Body) : *
      {
         var _loc4_:Array = null;
         var _loc5_:b2Body = null;
         this.name = param1.name;
         this.id = param1.id;
         this.size = param1.size;
         this.flipped = param1.flipped;
         this.alive = param1.alive;
         this._health = param1.health;
         this.maxhealth = param1.maxhealth;
         this.parentmaxhealth = param1.parentmaxhealth;
         this.bleeding = param1.bleeding.slice();
         this.burning = param1.burning;
         this._itemName = param1.itemName;
         this.vanilla = param1.vanilla;
         this.flammable = param1.flammable;
         this.fixedrotation = param1.fixedrotation;
         this.unbreakable = param1.unbreakable;
         this.magnet = param1.magnet;
         this.temperature = param1.temperature;
         this.ignition = param1.ignition;
         this.conductivity = param1.conductivity;
         this.sensor = param1.sensor;
         this.triggered = param1.triggered;
         this.triggerState = param1.triggerState;
         this.triggerForce = param1.triggerForce;
         this.triggerContact = param1.triggerContact;
         this.triggerDuration = param1.triggerDuration;
         this.triggerRadius = param1.triggerRadius;
         this.triggerPos = param1.triggerPos;
         this.triggerLock = param1.triggerLock;
         this.killOnContact = param1.killOnContact;
         this.triggerOnContact = param1.triggerOnContact;
         this.saveable = param1.saveable;
         this.stabilise = param1.stabilise;
         this.hasBeenCut = param1.hasBeenCut;
         this.density = param1.density;
         this.soft = param1.soft;
         this.ghost = param1.ghost;
         this.wallGhost = param1.wallGhost;
         this.mute = param1.mute;
         this.invisible = param1.invisible;
         this.group = param1.group;
         this.layer = param1.layer;
         this.debug = param1.debug;
         this.locked = param1.locked;
         this.gridSnap = param1.gridSnap;
         this.stainless = param1.stainless;
         this.saveStains = param1.saveStains;
         this.blunt = param1.blunt;
         this.sleepOnSpawn = param1.sleepOnSpawn;
         this.unequipDead = param1.unequipDead;
         this.unequipConcuss = param1.unequipConcuss;
         this.projectileGhost = param1.projectileGhost;
         this.bloodColour = param1.bloodColour;
         this.alpha = param1.alpha;
         this.multiConcussion = param1.multiConcussion;
         this.multiStanding = param1.multiStanding;
         this.multiStabForce = param1.multiStabForce;
         this.multiStabDensity = param1.multiStabDensity;
         this.multiBulletPenetration = param1.multiBulletPenetration;
         this.multiGlobalDamage = param1.multiGlobalDamage;
         this.multiBulletDamage = param1.multiBulletDamage;
         this.multiBluntDamage = param1.multiBluntDamage;
         this.multiBleedDamage = param1.multiBleedDamage;
         this.multiSharpDamage = param1.multiSharpDamage;
         this.multiRegen = param1.multiRegen;
         if(this.graphic)
         {
            this.graphic.alpha = this.alpha;
         }
         this.copyElemental(param1);
         this.connected = new Vector.<b2Body>();
         this.ignored = new Vector.<b2Body>();
         var _loc3_:userData = userData(param2.GetUserData());
         if(!param1.dead && _loc3_.dead)
         {
            for each(_loc5_ in param1.connected)
            {
               this.connected.push(_loc5_);
               userData(_loc5_.GetUserData()).connected.push(param2);
            }
            for each(_loc5_ in param1.ignored)
            {
               this.ignored.push(_loc5_);
               userData(_loc5_.GetUserData()).ignored.push(param2);
            }
         }
         this.skin = new Vector.<Array>();
         for each(_loc4_ in param1.skin)
         {
            this.skin.push(_loc4_.slice());
         }
      }
      
      public function connect(param1:b2Body) : void
      {
         var _loc2_:int = this.connected.indexOf(param1);
         if(_loc2_ != -1)
         {
            return;
         }
         this.connected.push(param1);
      }
      
      public function disconnect(param1:b2Body) : void
      {
         var _loc2_:int = this.connected.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.connected.splice(_loc2_,1);
         }
      }
      
      public function disconnectAll() : void
      {
         var _loc2_:userData = null;
         var _loc1_:b2Body = Physics.world.GetBodyList();
         while(_loc1_)
         {
            _loc2_ = userData(_loc1_.GetUserData());
            if(_loc2_.connected.indexOf(this.body) != -1)
            {
               _loc2_.disconnect(this.body);
            }
            _loc1_ = _loc1_.GetNext();
         }
         this.connected = new Vector.<b2Body>();
      }
      
      public function reconnect(param1:b2Body) : *
      {
         var _loc4_:userData = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:b2Body = Physics.world.GetBodyList();
         while(_loc3_)
         {
            _loc4_ = userData(_loc3_.GetUserData());
            if(_loc4_.connected.indexOf(this.body) != -1)
            {
               _loc4_.connected.push(param1);
            }
            _loc3_ = _loc3_.GetNext();
         }
         _loc2_.connected = this.connected.slice();
      }
      
      public function reignore(param1:b2Body) : *
      {
         var _loc3_:b2Body = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         _loc2_.ignored = this.ignored.slice();
         for each(_loc3_ in _loc2_.ignored)
         {
            userData(_loc3_.GetUserData()).ignored.push(param1);
         }
      }
      
      public function addIgnore(param1:b2Body) : void
      {
         var _loc2_:int = this.ignored.indexOf(param1);
         if(_loc2_ != -1)
         {
            return;
         }
         this.ignored.push(param1);
      }
      
      public function unignore(param1:b2Body) : void
      {
         var _loc2_:int = this.ignored.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.ignored.splice(_loc2_,1);
         }
      }
      
      public function unignoreAll() : void
      {
         var _loc1_:b2Body = null;
         for each(_loc1_ in this.ignored)
         {
            userData(_loc1_.GetUserData()).unignore(this.body);
         }
         this.ignored = new Vector.<b2Body>();
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function set width(param1:Number) : *
      {
         this._width = param1;
      }
      
      public function set height(param1:Number) : *
      {
         this._height = param1;
      }
      
      public function get cycle() : int
      {
         return this._cycle;
      }
      
      public function set cycle(param1:int) : void
      {
         this._cycle = param1;
      }
      
      public function set item(param1:Item) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.width)
         {
            this._width = param1.width;
         }
         if(param1.height)
         {
            this._height = param1.height;
         }
         this._itemName = param1.name;
      }
      
      public function get itemName() : String
      {
         return this._itemName;
      }
      
      public function set itemName(param1:String) : void
      {
         this._itemName = param1;
      }
      
      public function get triggered() : Boolean
      {
         return this._triggered;
      }
      
      public function set triggered(param1:Boolean) : void
      {
         if(!this.triggerLock)
         {
            this._triggered = param1;
            if(Boolean(this.trigger) && Boolean(!GameState.loading) && !GameState.resizing)
            {
               if(!param1)
               {
                  this.trigger.onUntrigger();
               }
               else if(param1)
               {
                  this.trigger.onTrigger();
               }
            }
         }
      }
      
      public function get health() : Number
      {
         return this._health;
      }
      
      public function set health(param1:Number) : void
      {
         if(this._health > param1)
         {
            if(this._health - param1 > 10)
            {
               this.overwhelmDamages.push(this._health - param1);
               ++this.overwhelmAmount;
               if(this.overwhelmAmount > 5)
               {
                  Body.Overwhelm(this.body);
               }
            }
         }
         else
         {
            this.overwhelmDamages = [];
            this.overwhelmAmount = 0;
         }
         this._health = param1;
         if(this._health > this.maxhealth)
         {
            this._health = this.maxhealth;
         }
         if(this._health < -1)
         {
            this._health = -1;
         }
      }
      
      public function get saveable() : Boolean
      {
         return this._saveable;
      }
      
      public function set saveable(param1:Boolean) : void
      {
         this._saveable = param1;
      }
      
      public function get triggerDuration() : Number
      {
         return this._triggerDuration;
      }
      
      public function set triggerDuration(param1:Number) : void
      {
         if(!this.originalTriggerDuration)
         {
            this.originalTriggerDuration = param1;
         }
         this._triggerDuration = param1;
      }
      
      public function get trigger() : Trigger
      {
         return this._trigger;
      }
      
      public function set trigger(param1:Trigger) : void
      {
         if(this._trigger == param1)
         {
            return;
         }
         if(Boolean(this._trigger) && this._trigger.overwrite == false)
         {
            return;
         }
         if(Boolean(this.originalTriggered == 0) && Boolean(param1) && param1.temporary)
         {
            this.originalTriggered = this.triggered ? 1 : -1;
         }
         if(Boolean(param1) && Boolean(param1.temporary) && (this._trigger is Electrified || this._trigger is Invis || this._trigger is Invincible))
         {
            return;
         }
         if(Boolean(!this.originalTrigger) && Boolean(param1) && !param1.temporary)
         {
            this.originalTrigger = param1;
            if(this.body)
            {
               param1.init(this.body,this);
            }
         }
         this._trigger = param1;
      }
      
      public function get body() : b2Body
      {
         return this._body;
      }
      
      public function set body(param1:b2Body) : void
      {
         this._body = param1;
         if(this.trigger)
         {
            this.trigger.init(this.body,this);
         }
      }
      
      public function get temperature() : Number
      {
         return this._temperature;
      }
      
      public function set temperature(param1:Number) : void
      {
         var _loc2_:int = 0;
         this._temperature = param1;
         if(this.temperatureMelt)
         {
            if(this.temperature > 0)
            {
               if(Math.random() > 0.9)
               {
                  BoxUtils.randomParticlesOnBody(this.body,"water",0);
               }
            }
            if(this._temperature > this.temperatureMelt)
            {
               _loc2_ = 0;
               while(_loc2_ < Math.random() * 40 + 20)
               {
                  BoxUtils.randomParticlesOnBody(this.body,"water");
                  _loc2_++;
               }
               this.dead = true;
            }
         }
         if(Boolean(this.temperatureMolten) && this._temperature > this.temperatureMolten)
         {
            this.trigger = new Disintegrate("lava",50);
            this.triggerLock = false;
            this.triggered = true;
         }
         if(this._temperature > 500)
         {
            this._temperature = 500;
         }
         if(this._temperature < -273)
         {
            this._temperature = -273;
         }
      }
      
      public function get pfx() : ParticleEffect
      {
         return this._shiny;
      }
      
      public function set pfx(param1:ParticleEffect) : void
      {
         this._shiny = param1;
      }
      
      public function get dead() : Boolean
      {
         return this._dead;
      }
      
      public function set dead(param1:Boolean) : void
      {
         this._dead = param1;
         if(this.name == "wall")
         {
            this._dead = false;
         }
      }
      
      public function get alpha() : Number
      {
         if(!this.graphic)
         {
            return 1;
         }
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(!this.graphic)
         {
            return;
         }
         this.graphic.alpha = param1;
         this._alpha = param1;
      }
      
      public function get invisible() : Boolean
      {
         return this._invisible;
      }
      
      public function set invisible(param1:Boolean) : void
      {
         this._invisible = param1;
         if(this.graphic)
         {
            this.graphic.alpha = param1 ? 0 : 1;
         }
      }
      
      public function cycler(param1:int) : void
      {
         this._cycle += param1 * this.cycledir;
         if(this._cycle > 100 || this._cycle <= 0)
         {
            this.cycledir *= -1;
         }
      }
      
      public function getProperties() : Array
      {
         var _loc5_:String = null;
         var _loc1_:Array = [];
         var _loc2_:Array = this.propertyNames.slice();
         _loc2_.push("triggered","armour","flipped","invisible","sleepOnSpawn","vanilla");
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(this[_loc5_])
            {
               _loc1_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getParent() : DisplayObjectContainer
      {
         return this.graphic.parent;
      }
      
      public function Stab(param1:StabData) : void
      {
         this.stabs.push(param1);
      }
      
      public function isStabbing(param1:b2Body) : *
      {
         var _loc2_:StabData = null;
         for each(_loc2_ in this.stabs)
         {
            if(_loc2_.exists(this.body,param1))
            {
               return true;
            }
         }
         return false;
      }
      
      public function UpdateStabs() : void
      {
         var _loc2_:StabData = null;
         if(this.stabs.length == 0)
         {
            return;
         }
         var _loc1_:* = int(this.stabs.length - 1);
         while(_loc1_ >= 0)
         {
            if(this.stabs[_loc1_].dead)
            {
               this.stabs.splice(_loc1_,1);
            }
            _loc1_--;
         }
         for each(_loc2_ in this.stabs)
         {
            _loc2_.update();
         }
      }
   }
}

