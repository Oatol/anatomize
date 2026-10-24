package
{
   import environment.OpenWorld;
   import environment.PumpkinDefence;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import powers.Power;
   import powers.PowerAcid;
   import powers.PowerAdrenaline;
   import powers.PowerAnimate;
   import powers.PowerArc;
   import powers.PowerBane;
   import powers.PowerBanish;
   import powers.PowerBee;
   import powers.PowerBleed;
   import powers.PowerBling;
   import powers.PowerBlunt;
   import powers.PowerBubble;
   import powers.PowerBullet;
   import powers.PowerCookie;
   import powers.PowerCrash;
   import powers.PowerCrit;
   import powers.PowerCrush;
   import powers.PowerDeath;
   import powers.PowerDice;
   import powers.PowerDisc;
   import powers.PowerDispel;
   import powers.PowerDrain;
   import powers.PowerDrone;
   import powers.PowerEarthquake;
   import powers.PowerError;
   import powers.PowerExplode;
   import powers.PowerFaceplant;
   import powers.PowerFlame;
   import powers.PowerForcefield;
   import powers.PowerFreeze;
   import powers.PowerFrostfire;
   import powers.PowerFry;
   import powers.PowerGasoline;
   import powers.PowerGhost;
   import powers.PowerGib;
   import powers.PowerGlass;
   import powers.PowerGlitch;
   import powers.PowerGlue;
   import powers.PowerGravity;
   import powers.PowerHail;
   import powers.PowerHandshake;
   import powers.PowerHeal;
   import powers.PowerHole;
   import powers.PowerHorn;
   import powers.PowerIcicle;
   import powers.PowerImplode;
   import powers.PowerLaser;
   import powers.PowerLava;
   import powers.PowerLevity;
   import powers.PowerMutate;
   import powers.PowerPaint;
   import powers.PowerPetrify;
   import powers.PowerPierce;
   import powers.PowerPoison;
   import powers.PowerPowder;
   import powers.PowerProtect;
   import powers.PowerRadiation;
   import powers.PowerRandom;
   import powers.PowerRicochet;
   import powers.PowerSandstone;
   import powers.PowerSharp;
   import powers.PowerShock;
   import powers.PowerShockwave;
   import powers.PowerSleep;
   import powers.PowerSlice;
   import powers.PowerSmoke;
   import powers.PowerSnare;
   import powers.PowerStasis;
   import powers.PowerSteam;
   import powers.PowerTeleport;
   import powers.PowerTest;
   import powers.PowerTidal;
   import powers.PowerTornado;
   import powers.PowerToxic;
   import powers.PowerTransmute;
   import powers.PowerUpgrade;
   import powers.PowerVoid;
   import powers.PowerWater;
   import powers.PowerWeb;
   import powers.PowerWind;
   
   public class Tool
   {
      
      private static var DEFAULT:String;
      
      private static var CURRENT:String;
      
      private static var POWER:Power;
      
      private static var ICON:BitmapData;
      
      public static var previousTool:String;
      
      public static var currentJointTool:String;
      
      public static var currentJoint:String;
      
      public static var currentPower:String;
      
      public static const CUT:String = "cut";
      
      public static const DRAG:String = "drag";
      
      public static const CAMERA:String = "camera";
      
      public static const ROTATE:String = "rotate";
      
      public static const SCALE:String = "scale";
      
      public static const DELETE:String = "delete";
      
      public static const SELECT:String = "select";
      
      public static const TRIGGER:String = "trigger";
      
      public static const LINK:String = "link";
      
      public static const JOINT:String = "joint";
      
      public static const PISTON:String = "piston";
      
      public static const ROPE:String = "rope";
      
      public static const WELD:String = "weld";
      
      public static const PIN:String = "pin";
      
      public static const DOLL:String = "doll";
      
      public static const DETAIL:String = "detail";
      
      public static const LAUNCH:String = "launch";
      
      public static const SWING:String = "swing";
      
      public static const STAB:String = "stab";
      
      public static const AIM:String = "aim";
      
      public static const FLAME:String = "flame";
      
      public static const FREEZE:String = "freeze";
      
      public static const WIND:String = "wind";
      
      public static const POISON:String = "poison";
      
      public static const SHOCK:String = "shock";
      
      public static const HEAL:String = "heal";
      
      public static const WATER:String = "water";
      
      public static const DRAIN:String = "drain";
      
      public static const VOID:String = "void";
      
      public static const SLICE:String = "slice";
      
      public static const DICE:String = "dice";
      
      public static const EXPLODE:String = "explode";
      
      public static const SNARE:String = "snare";
      
      public static const DEATH:String = "death";
      
      public static const DISPEL:String = "dispel";
      
      public static const BLUNT:String = "blunt";
      
      public static const SLEEP:String = "sleep";
      
      public static const ARC:String = "arc";
      
      public static const BEE:String = "bee";
      
      public static const BUBBLE:String = "bubble";
      
      public static const BULLET:String = "bullet";
      
      public static const POWDER:String = "powder";
      
      public static const GASOLINE:String = "gasoline";
      
      public static const GLUE:String = "glue";
      
      public static const GRAVITY:String = "gravity";
      
      public static const LASER:String = "laser";
      
      public static const LEVITY:String = "levity";
      
      public static const PAINT:String = "paint";
      
      public static const PORTAL:String = "portal";
      
      public static const RANDOM:String = "random";
      
      public static const RICOCHET:String = "ricochet";
      
      public static const SHARP:String = "sharp";
      
      public static const STASIS:String = "stasis";
      
      public static const TOXIC:String = "toxic";
      
      public static const TRANSMUTE:String = "transmute";
      
      public static const CRIT:String = "crit";
      
      public static const ACID:String = "acid";
      
      public static const SMOKE:String = "smoke";
      
      public static const HOLE:String = "hole";
      
      public static const DISC:String = "disc";
      
      public static const TELEPORT:String = "teleport";
      
      public static const CRUSH:String = "crush";
      
      public static const SCALD:String = "scald";
      
      public static const WEB:String = "web";
      
      public static const PETRIFY:String = "petrify";
      
      public static const HATS:String = "hats";
      
      public static const HAIL:String = "hail";
      
      public static const ICICLE:String = "icicle";
      
      public static const RADIATION:String = "radiation";
      
      public static const EARTHQUAKE:String = "earthquake";
      
      public static const BANE:String = "bane";
      
      public static const ADRENALINE:String = "adrenaline";
      
      public static const DRONE:String = "drone";
      
      public static const TIDAL:String = "tidal";
      
      public static const HANDSHAKE:String = "handshake";
      
      public static const BLING:String = "bling";
      
      public static const SHOCKWAVE:String = "shockwave";
      
      public static const STEAM:String = "steam";
      
      public static const HORN:String = "horn";
      
      public static const PIERCE:String = "pierce";
      
      public static const TEST:String = "test";
      
      public static const FRY:String = "fry";
      
      public static const FROSTFIRE:String = "frostfire";
      
      public static const BANISH:String = "banish";
      
      public static const GIB:String = "gib";
      
      public static const BLEED:String = "bleed";
      
      public static const TORNADO:String = "tornado";
      
      public static const COOKIE:String = "cookie";
      
      public static const GLASS:String = "glass";
      
      public static const ERROR:String = "error";
      
      public static const GLITCH:String = "glitch";
      
      public static const CRASH:String = "crash";
      
      public static const FORCEFIELD:String = "forcefield";
      
      public static const GHOST:String = "ghost";
      
      public static const PROTECT:String = "protect";
      
      public static const ANIMATE:String = "animate";
      
      public static const MUTATE:String = "mutate";
      
      public static const SANDSTONE:String = "sandstone";
      
      public static const LAVA:String = "lava";
      
      public static const FACEPLANT:String = "faceplant";
      
      public static const UPGRADE:String = "upgrade";
      
      public static const IMPLODE:String = "implode";
      
      public static const IGNORE:String = "ignore";
      
      public static var elementals:Array = [ACID,ADRENALINE,ANIMATE,ARC,BANE,BANISH,BEE,BLEED,BLING,BLUNT,BUBBLE,BULLET,SLEEP,COOKIE,CRIT,CRUSH,DEATH,DICE,DISC,DISPEL,DRAIN,DRONE,ERROR,EXPLODE,FACEPLANT,FLAME,FORCEFIELD,FREEZE,FROSTFIRE,FRY,GASOLINE,GHOST,GIB,GLASS,GLITCH,GLUE,GRAVITY,HAIL,HEAL,HOLE,HORN,ICICLE,IMPLODE,EARTHQUAKE,LASER,LAVA,LEVITY,MUTATE,HANDSHAKE,PAINT,PETRIFY,PIERCE,POISON,POWDER,PROTECT,RADIATION,RANDOM,RICOCHET,SANDSTONE,SHARP,SHOCK,SHOCKWAVE,SLICE,SMOKE,SNARE,STASIS,STEAM,TELEPORT,TIDAL,TORNADO,TOXIC,TRANSMUTE,UPGRADE,VOID,WATER,WEB,WIND,CRASH];
      
      internal var powerClasses:Array = [PowerTest,PowerFlame,PowerFreeze,PowerWind,PowerPoison,PowerShock,PowerHeal,PowerWater,PowerDrain,PowerVoid,PowerSlice,PowerExplode,PowerSnare,PowerDeath,PowerDispel,PowerBlunt,PowerSleep,PowerArc,PowerBee,PowerBubble,PowerBullet,PowerPowder,PowerGasoline,PowerGlue,PowerGravity,PowerLaser,PowerLevity,PowerPaint,PowerRandom,PowerRicochet,PowerSharp,PowerStasis,PowerToxic,PowerTransmute,PowerCrit,PowerAcid,PowerSmoke,PowerHole,PowerDisc,PowerTeleport,PowerCrush,PowerWeb,PowerPetrify,PowerHail,PowerIcicle,PowerRadiation,PowerEarthquake,PowerBane,PowerAdrenaline,PowerDrone,PowerTidal,PowerHandshake,PowerBling,PowerShockwave,PowerSteam,PowerHorn,PowerPierce,PowerImplode,PowerFry,PowerFrostfire,PowerBanish,PowerGib,PowerBleed,PowerTornado,PowerCookie,PowerGlass,PowerError,PowerGlitch,PowerCrash,PowerForcefield,PowerGhost,PowerProtect,PowerAnimate,PowerMutate,PowerSandstone,PowerLava,PowerFaceplant,PowerUpgrade,PowerDice];
      
      public function Tool()
      {
         super();
      }
      
      public static function init() : void
      {
         ICON = new BitmapData(32,32,true,0);
         DEFAULT = DRAG;
         drag();
      }
      
      public static function setTool(param1:String) : *
      {
         var _loc2_:String = null;
         var _loc3_:Class = null;
         if(Boolean(GameState.environment) && (GameState.environment is OpenWorld || GameState.environment is PumpkinDefence))
         {
            param1 = "none";
         }
         if(param1 == "none")
         {
            previousTool = CURRENT;
            CURRENT = param1;
            return;
         }
         if(CURRENT == param1)
         {
            return;
         }
         if(CURRENT == AIM && param1 != AIM)
         {
            Main.instance.stopAiming();
         }
         previousTool = CURRENT;
         CURRENT = param1;
         ICON.fillRect(ICON.rect,0);
         ICON.copyPixels(R.getSprite("tool_" + param1),ICON.rect,new Point());
         if(isPower)
         {
            currentPower = CURRENT;
            _loc2_ = CURRENT;
            _loc2_ = _loc2_.slice(0,1).toUpperCase() + _loc2_.slice(1).toLowerCase();
            _loc2_ = "powers::Power" + _loc2_;
            _loc3_ = getDefinitionByName(_loc2_) as Class;
            POWER = new _loc3_() as Power;
         }
      }
      
      public static function reset() : void
      {
         setTool(DEFAULT);
      }
      
      public static function cut() : void
      {
         setTool(CUT);
      }
      
      public static function drag() : void
      {
         setTool(DRAG);
      }
      
      public static function camera() : void
      {
         setTool(CAMERA);
      }
      
      public static function rotate() : void
      {
         setTool(ROTATE);
      }
      
      public static function scale() : void
      {
         setTool(SCALE);
      }
      
      public static function destroy() : void
      {
         setTool(DELETE);
      }
      
      public static function select() : void
      {
         setTool(SELECT);
      }
      
      public static function trigger() : void
      {
         setTool(TRIGGER);
      }
      
      public static function link() : void
      {
         setTool(LINK);
      }
      
      public static function joint() : void
      {
         setTool(JOINT);
      }
      
      public static function piston() : void
      {
         setTool(PISTON);
      }
      
      public static function rope() : void
      {
         setTool(ROPE);
      }
      
      public static function weld() : void
      {
         setTool(WELD);
      }
      
      public static function pin() : void
      {
         setTool(PIN);
      }
      
      public static function doll() : void
      {
         setTool(DOLL);
      }
      
      public static function detail() : void
      {
         setTool(DETAIL);
      }
      
      public static function launch() : void
      {
         setTool(LAUNCH);
      }
      
      public static function swing() : void
      {
         setTool(SWING);
      }
      
      public static function stab() : void
      {
         setTool(STAB);
      }
      
      public static function aim() : void
      {
         setTool(AIM);
      }
      
      public static function get current() : String
      {
         return CURRENT;
      }
      
      public static function get power() : Power
      {
         return POWER;
      }
      
      public static function get isCut() : Boolean
      {
         return CURRENT == CUT;
      }
      
      public static function get isDrag() : Boolean
      {
         return CURRENT == DRAG;
      }
      
      public static function get isCamera() : Boolean
      {
         return CURRENT == CAMERA;
      }
      
      public static function get isRotate() : Boolean
      {
         return CURRENT == ROTATE;
      }
      
      public static function get isScale() : Boolean
      {
         return CURRENT == SCALE;
      }
      
      public static function get isDestroy() : Boolean
      {
         return CURRENT == DELETE;
      }
      
      public static function get isSelect() : Boolean
      {
         return CURRENT == SELECT;
      }
      
      public static function get isTrigger() : Boolean
      {
         return CURRENT == TRIGGER;
      }
      
      public static function get isLink() : Boolean
      {
         return CURRENT == LINK;
      }
      
      public static function get isIgnore() : Boolean
      {
         return CURRENT == IGNORE;
      }
      
      public static function get isJoint() : Boolean
      {
         return CURRENT == JOINT;
      }
      
      public static function get isPiston() : Boolean
      {
         return CURRENT == PISTON;
      }
      
      public static function get isRope() : Boolean
      {
         return CURRENT == ROPE;
      }
      
      public static function get isWeld() : Boolean
      {
         return CURRENT == WELD;
      }
      
      public static function get isPin() : Boolean
      {
         return CURRENT == PIN;
      }
      
      public static function get isDoll() : Boolean
      {
         return CURRENT == DOLL;
      }
      
      public static function get isDetail() : Boolean
      {
         return CURRENT == DETAIL;
      }
      
      public static function get isLaunch() : Boolean
      {
         return CURRENT == LAUNCH;
      }
      
      public static function get isSwing() : Boolean
      {
         return CURRENT == SWING;
      }
      
      public static function get isStab() : Boolean
      {
         return CURRENT == STAB;
      }
      
      public static function get isAim() : Boolean
      {
         return CURRENT == AIM;
      }
      
      public static function get isFlame() : Boolean
      {
         return CURRENT == FLAME;
      }
      
      public static function get isFreeze() : Boolean
      {
         return CURRENT == FREEZE;
      }
      
      public static function get isWind() : Boolean
      {
         return CURRENT == WIND;
      }
      
      public static function get isPoison() : Boolean
      {
         return CURRENT == POISON;
      }
      
      public static function get isShock() : Boolean
      {
         return CURRENT == SHOCK;
      }
      
      public static function get isHeal() : Boolean
      {
         return CURRENT == HEAL;
      }
      
      public static function get isWater() : Boolean
      {
         return CURRENT == WATER;
      }
      
      public static function get isDrain() : Boolean
      {
         return CURRENT == DRAIN;
      }
      
      public static function get isVoid() : Boolean
      {
         return CURRENT == VOID;
      }
      
      public static function get isExplode() : Boolean
      {
         return CURRENT == EXPLODE;
      }
      
      public static function get isSlice() : Boolean
      {
         return CURRENT == SLICE;
      }
      
      public static function get isSnare() : Boolean
      {
         return CURRENT == SNARE;
      }
      
      public static function get isDeath() : Boolean
      {
         return CURRENT == DEATH;
      }
      
      public static function get isDispel() : Boolean
      {
         return CURRENT == DISPEL;
      }
      
      public static function get isBlunt() : Boolean
      {
         return CURRENT == BLUNT;
      }
      
      public static function get isArc() : Boolean
      {
         return CURRENT == ARC;
      }
      
      public static function get isBee() : Boolean
      {
         return CURRENT == BEE;
      }
      
      public static function get isBubble() : Boolean
      {
         return CURRENT == BUBBLE;
      }
      
      public static function get isBullet() : Boolean
      {
         return CURRENT == BULLET;
      }
      
      public static function get isGasoline() : Boolean
      {
         return CURRENT == GASOLINE;
      }
      
      public static function get isGlue() : Boolean
      {
         return CURRENT == GLUE;
      }
      
      public static function get isGravity() : Boolean
      {
         return CURRENT == GRAVITY;
      }
      
      public static function get isLaser() : Boolean
      {
         return CURRENT == LASER;
      }
      
      public static function get isLevity() : Boolean
      {
         return CURRENT == LEVITY;
      }
      
      public static function get isPaint() : Boolean
      {
         return CURRENT == PAINT;
      }
      
      public static function get isPortal() : Boolean
      {
         return CURRENT == PORTAL;
      }
      
      public static function get isPowder() : Boolean
      {
         return CURRENT == POWDER;
      }
      
      public static function get isRandom() : Boolean
      {
         return CURRENT == RANDOM;
      }
      
      public static function get isRicochet() : Boolean
      {
         return CURRENT == RICOCHET;
      }
      
      public static function get isSharp() : Boolean
      {
         return CURRENT == SHARP;
      }
      
      public static function get isSleep() : Boolean
      {
         return CURRENT == SLEEP;
      }
      
      public static function get isStasis() : Boolean
      {
         return CURRENT == STASIS;
      }
      
      public static function get isToxic() : Boolean
      {
         return CURRENT == TOXIC;
      }
      
      public static function get isHail() : Boolean
      {
         return CURRENT == HAIL;
      }
      
      public static function get isIcicle() : Boolean
      {
         return CURRENT == ICICLE;
      }
      
      public static function get isTransmute() : Boolean
      {
         return CURRENT == TRANSMUTE;
      }
      
      public static function get isCrit() : Boolean
      {
         return CURRENT == CRIT;
      }
      
      public static function get isAcid() : Boolean
      {
         return CURRENT == ACID;
      }
      
      public static function get isSmoke() : Boolean
      {
         return CURRENT == SMOKE;
      }
      
      public static function get isHole() : Boolean
      {
         return CURRENT == HOLE;
      }
      
      public static function get isDisc() : Boolean
      {
         return CURRENT == DISC;
      }
      
      public static function get isTeleport() : Boolean
      {
         return CURRENT == TELEPORT;
      }
      
      public static function get isPetrify() : Boolean
      {
         return CURRENT == PETRIFY;
      }
      
      public static function get isWeb() : Boolean
      {
         return CURRENT == WEB;
      }
      
      public static function get isCrush() : Boolean
      {
         return CURRENT == CRUSH;
      }
      
      public static function get isScald() : Boolean
      {
         return CURRENT == SCALD;
      }
      
      public static function get isTornado() : Boolean
      {
         return CURRENT == TORNADO;
      }
      
      public static function get isRadiation() : Boolean
      {
         return CURRENT == RADIATION;
      }
      
      public static function get isEarthquake() : Boolean
      {
         return CURRENT == EARTHQUAKE;
      }
      
      public static function get isBane() : Boolean
      {
         return CURRENT == BANE;
      }
      
      public static function get isAdrenaline() : Boolean
      {
         return CURRENT == ADRENALINE;
      }
      
      public static function get isDrone() : Boolean
      {
         return CURRENT == DRONE;
      }
      
      public static function get isTidal() : Boolean
      {
         return CURRENT == TIDAL;
      }
      
      public static function get isProtect() : Boolean
      {
         return CURRENT == PROTECT;
      }
      
      public static function get isHandshake() : Boolean
      {
         return CURRENT == HANDSHAKE;
      }
      
      public static function get isBling() : Boolean
      {
         return CURRENT == BLING;
      }
      
      public static function get isShockwave() : Boolean
      {
         return CURRENT == SHOCKWAVE;
      }
      
      public static function get isImplode() : Boolean
      {
         return CURRENT == IMPLODE;
      }
      
      public static function get isSteam() : Boolean
      {
         return CURRENT == STEAM;
      }
      
      public static function get isHorn() : Boolean
      {
         return CURRENT == HORN;
      }
      
      public static function get isPierce() : Boolean
      {
         return CURRENT == PIERCE;
      }
      
      public static function get isPower() : Boolean
      {
         return elementals.indexOf(CURRENT) != -1;
      }
      
      public static function get isAJoint() : Boolean
      {
         var _loc1_:Array = [PIN,JOINT,ROPE,WELD,DOLL,PISTON];
         return _loc1_.indexOf(CURRENT) != -1;
      }
      
      public static function get icon() : BitmapData
      {
         return ICON;
      }
   }
}

