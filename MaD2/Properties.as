package
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   import com.yahoo.astra.fl.controls.AutoComplete;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.events.DropdownEvent;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.events.FocusEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import triggers.Gun;
   
   public class Properties
   {
      
      public static var forceObjStick:int = 0;
      
      public static var forceObjSharp:int = 0;
      
      public static var forceObjBlunt:int = 0;
      
      public static var forceObjExplo:int = 0;
      
      public static var forceObjBreak:int = 0;
      
      public static var forceObjCrumb:int = 0;
      
      public static var forceObjBritt:int = 0;
      
      public static var forceObjImplo:int = 0;
      
      public static var forceObjAlive:int = 0;
      
      public static var forceObjZGrav:int = 0;
      
      public static var forceObjSleep:int = 0;
      
      public static var forceObjAGrav:int = 0;
      
      public static var forceObjFlame:int = 0;
      
      public static var forceObjFreeze:int = 0;
      
      public static var forceObjShock:int = 0;
      
      public static var forceObjHeal:int = 0;
      
      public static var forceObjDispel:int = 0;
      
      public static var forceObjGust:int = 0;
      
      public static var forceObjKill:int = 0;
      
      public static var forceObjDrain:int = 0;
      
      public static var forceObjPoison:int = 0;
      
      public static var forceObjGhost:int = 0;
      
      public static var forceObjStain:int = 0;
      
      public static var forceObjInvis:int = 0;
      
      public static var forceObjStatic:int = 0;
      
      public static var forceObjMagne:int = 0;
      
      public static var forceObjUnBreak:int = 0;
      
      public static var forceObjVanilla:int = 0;
      
      public static var forceObjFlamm:int = 0;
      
      public static var forceObjMuted:int = 0;
      
      public static var forceObjFixed:int = 0;
      
      public static var forceObjJointsDead:int = 0;
      
      public static var forceObjJointsConc:int = 0;
      
      public static var forceObjWallGhost:int = 0;
      
      public static var forceObjProjectileGhost:int = 0;
      
      public static var forceObjRending:int = 0;
      
      public static var forceObjAlchemying:int = 0;
      
      public static var forceObjTransmuting:int = 0;
      
      public static var forceObjCritting:int = 0;
      
      public static var forceObjDeleting:int = 0;
      
      public static var forceObjTriggering:int = 0;
      
      public static var forceObjRelaying:int = 0;
      
      public static var forceObjCleaning:int = 0;
      
      public static var forceObjJanitoring:int = 0;
      
      public static var forceObjHyping:int = 0;
      
      public static var forceObjSuspending:int = 0;
      
      public static var forceObjBanning:int = 0;
      
      public static var forceObjBlighting:int = 0;
      
      public static var forceObjBulletproof:int = 0;
      
      public static var forceResGhosting:int = 0;
      
      public static var forceResProtect:int = 0;
      
      public static var forceResAdrenaline:int = 0;
      
      public static var forceResArc:int = 0;
      
      public static var forceResGravity:int = 0;
      
      public static var forceResDroning:int = 0;
      
      public static var forceResSnare:int = 0;
      
      public static var forceObjConcussing:int = 0;
      
      public static var forceObjCauterizing:int = 0;
      
      public static var forceObjRegeneration:int = 0;
      
      public static var forceObjDisintegrator:int = 0;
      
      public static var forceObjDisintegrating:int = 0;
      
      public static var forceObjDrying:int = 0;
      
      public static var forceObjFrostfiring:int = 0;
      
      public static var forceObjFrying:int = 0;
      
      public static var forceObjWetting:int = 0;
      
      public static var forceObjGlassing:int = 0;
      
      public static var forceObjGlitching:int = 0;
      
      public static var forceObjMagnetic:int = 0;
      
      public static var forceObjOily:int = 0;
      
      public static var forceObjPetrifying:int = 0;
      
      public static var forceObjRadioactive:int = 0;
      
      public static var forceObjSanguine:int = 0;
      
      public static var forceObjScorching:int = 0;
      
      public static var forceObjUltrasharp:int = 0;
      
      public static var forceObjTriggerOnCut:int = 0;
      
      public static var forceObjLinkedAlso:int = 0;
      
      public static var forceObjLinkedOnly:int = 0;
      
      public static var forceObjWarming:int = 0;
      
      public static var forceObjWebbing:int = 0;
      
      public static var forceObjSpreading:int = 0;
      
      public static var forceResBanning:int = 0;
      
      public static var forceResBlighting:int = 0;
      
      public static var forceResStasis:int = 0;
      
      public static var forceResTransmuting:int = 0;
      
      public static var forceResCutting:int = 0;
      
      public static var forceResAliveBreak:int = 0;
      
      public static var forceResDisintegrating:int = 0;
      
      public static var forceResDrying:int = 0;
      
      public static var forceResFrostfiring:int = 0;
      
      public static var forceResFrying:int = 0;
      
      public static var forceResGassy:int = 0;
      
      public static var forceResGlassing:int = 0;
      
      public static var forceResGlitching:int = 0;
      
      public static var forceResMagnetic:int = 0;
      
      public static var forceResOily:int = 0;
      
      public static var forceResPetrifying:int = 0;
      
      public static var forceResRadioactive:int = 0;
      
      public static var forceResBleed:int = 0;
      
      public static var forceResArmour:int = 0;
      
      public static var forceResJoints:int = 0;
      
      public static var forceResScorching:int = 0;
      
      public static var forceResUltrasharp:int = 0;
      
      public static var forceResChilling:int = 0;
      
      public static var forceResWarming:int = 0;
      
      public static var forceResWebbing:int = 0;
      
      public static var forceResDispel:int = 0;
      
      public static var forceResDrain:int = 0;
      
      public static var forceResFlame:int = 0;
      
      public static var forceResFreeze:int = 0;
      
      public static var forceResGust:int = 0;
      
      public static var forceResHeal:int = 0;
      
      public static var forceResKill:int = 0;
      
      public static var forceResPoison:int = 0;
      
      public static var forceResShock:int = 0;
      
      public static var forceResConcuss:int = 0;
      
      public static var forceObjEffect:int = 0;
      
      private static var tempProperties:Array = [];
      
      public function Properties()
      {
         super();
      }
      
      public static function storeTempProperties() : void
      {
         tempProperties = [];
         tempProperties[0] = forceObjStick;
         tempProperties[1] = forceObjSharp;
         tempProperties[2] = forceObjBlunt;
         tempProperties[3] = forceObjExplo;
         tempProperties[4] = forceObjBreak;
         tempProperties[5] = forceObjCrumb;
         tempProperties[6] = forceObjBritt;
         tempProperties[7] = forceObjImplo;
         tempProperties[8] = forceObjAlive;
         tempProperties[9] = forceObjZGrav;
         tempProperties[10] = forceObjSleep;
         tempProperties[11] = forceObjAGrav;
         tempProperties[12] = forceObjFlame;
         tempProperties[13] = forceObjFreeze;
         tempProperties[14] = forceObjShock;
         tempProperties[15] = forceObjHeal;
         tempProperties[16] = forceObjDispel;
         tempProperties[17] = forceObjGust;
         tempProperties[18] = forceObjKill;
         tempProperties[19] = forceObjDrain;
         tempProperties[20] = forceObjPoison;
         tempProperties[21] = forceObjGhost;
         tempProperties[22] = forceObjStain;
         tempProperties[23] = forceObjInvis;
         tempProperties[24] = forceObjStatic;
         tempProperties[25] = forceObjMagne;
         tempProperties[26] = forceObjUnBreak;
         tempProperties[27] = forceObjVanilla;
         tempProperties[28] = forceObjFlamm;
         tempProperties[29] = forceObjMuted;
         tempProperties[30] = forceObjFixed;
         tempProperties[31] = forceObjJointsDead;
         tempProperties[32] = forceObjJointsConc;
         tempProperties[33] = forceObjWallGhost;
         tempProperties[34] = forceObjProjectileGhost;
         tempProperties[35] = forceObjRending;
         tempProperties[36] = forceObjAlchemying;
         tempProperties[37] = forceObjTransmuting;
         tempProperties[38] = forceObjCritting;
         tempProperties[39] = forceObjDeleting;
         tempProperties[40] = forceObjTriggering;
         tempProperties[41] = forceObjRelaying;
         tempProperties[42] = forceObjCleaning;
         tempProperties[43] = forceObjJanitoring;
         tempProperties[44] = forceObjHyping;
         tempProperties[45] = forceObjSuspending;
         tempProperties[46] = forceObjBanning;
         tempProperties[47] = forceObjBlighting;
         tempProperties[48] = forceObjBulletproof;
         tempProperties[49] = forceResGhosting;
         tempProperties[50] = forceResProtect;
         tempProperties[51] = forceResAdrenaline;
         tempProperties[52] = forceResArc;
         tempProperties[53] = forceResGravity;
         tempProperties[54] = forceResDroning;
         tempProperties[55] = forceResSnare;
         tempProperties[56] = forceObjConcussing;
         tempProperties[57] = forceObjCauterizing;
         tempProperties[58] = forceObjRegeneration;
         tempProperties[59] = forceObjDisintegrator;
         tempProperties[60] = forceObjDisintegrating;
         tempProperties[61] = forceObjDrying;
         tempProperties[62] = forceObjFrostfiring;
         tempProperties[63] = forceObjFrying;
         tempProperties[64] = forceObjWetting;
         tempProperties[65] = forceObjGlassing;
         tempProperties[66] = forceObjGlitching;
         tempProperties[67] = forceObjMagnetic;
         tempProperties[68] = forceObjOily;
         tempProperties[69] = forceObjPetrifying;
         tempProperties[70] = forceObjRadioactive;
         tempProperties[71] = forceObjSanguine;
         tempProperties[72] = forceObjScorching;
         tempProperties[73] = forceObjUltrasharp;
         tempProperties[74] = forceObjTriggerOnCut;
         tempProperties[75] = forceObjLinkedAlso;
         tempProperties[76] = forceObjLinkedOnly;
         tempProperties[77] = forceObjWarming;
         tempProperties[78] = forceObjWebbing;
         tempProperties[79] = forceObjSpreading;
         tempProperties[80] = forceResBanning;
         tempProperties[81] = forceResBlighting;
         tempProperties[82] = forceResStasis;
         tempProperties[83] = forceResTransmuting;
         tempProperties[84] = forceResCutting;
         tempProperties[85] = forceResAliveBreak;
         tempProperties[86] = forceResDisintegrating;
         tempProperties[87] = forceResDrying;
         tempProperties[88] = forceResFrostfiring;
         tempProperties[89] = forceResFrying;
         tempProperties[90] = forceResGassy;
         tempProperties[91] = forceResGlassing;
         tempProperties[92] = forceResGlitching;
         tempProperties[93] = forceResMagnetic;
         tempProperties[94] = forceResOily;
         tempProperties[95] = forceResPetrifying;
         tempProperties[96] = forceResRadioactive;
         tempProperties[97] = forceResBleed;
         tempProperties[98] = forceResScorching;
         tempProperties[99] = forceResUltrasharp;
         tempProperties[100] = forceResChilling;
         tempProperties[101] = forceResWarming;
         tempProperties[102] = forceResWebbing;
         tempProperties[103] = forceResDispel;
         tempProperties[104] = forceResDrain;
         tempProperties[105] = forceResFlame;
         tempProperties[106] = forceResFreeze;
         tempProperties[107] = forceResGust;
         tempProperties[108] = forceResHeal;
         tempProperties[109] = forceResKill;
         tempProperties[110] = forceResPoison;
         tempProperties[111] = forceResShock;
         tempProperties[112] = forceResConcuss;
         tempProperties[113] = forceObjEffect;
         tempProperties[114] = forceResArmour;
         tempProperties[115] = forceResJoints;
      }
      
      public static function restoreTempProperties() : void
      {
         forceObjStick = tempProperties[0];
         forceObjSharp = tempProperties[1];
         forceObjBlunt = tempProperties[2];
         forceObjExplo = tempProperties[3];
         forceObjBreak = tempProperties[4];
         forceObjCrumb = tempProperties[5];
         forceObjBritt = tempProperties[6];
         forceObjImplo = tempProperties[7];
         forceObjAlive = tempProperties[8];
         forceObjZGrav = tempProperties[9];
         forceObjSleep = tempProperties[10];
         forceObjAGrav = tempProperties[11];
         forceObjFlame = tempProperties[12];
         forceObjFreeze = tempProperties[13];
         forceObjShock = tempProperties[14];
         forceObjHeal = tempProperties[15];
         forceObjDispel = tempProperties[16];
         forceObjGust = tempProperties[17];
         forceObjKill = tempProperties[18];
         forceObjDrain = tempProperties[19];
         forceObjPoison = tempProperties[20];
         forceObjGhost = tempProperties[21];
         forceObjStain = tempProperties[22];
         forceObjInvis = tempProperties[23];
         forceObjStatic = tempProperties[24];
         forceObjMagne = tempProperties[25];
         forceObjUnBreak = tempProperties[26];
         forceObjVanilla = tempProperties[27];
         forceObjFlamm = tempProperties[28];
         forceObjMuted = tempProperties[29];
         forceObjFixed = tempProperties[30];
         forceObjJointsDead = tempProperties[31];
         forceObjJointsConc = tempProperties[32];
         forceObjWallGhost = tempProperties[33];
         forceObjProjectileGhost = tempProperties[34];
         forceObjRending = tempProperties[35];
         forceObjAlchemying = tempProperties[36];
         forceObjTransmuting = tempProperties[37];
         forceObjCritting = tempProperties[38];
         forceObjDeleting = tempProperties[39];
         forceObjTriggering = tempProperties[40];
         forceObjRelaying = tempProperties[41];
         forceObjCleaning = tempProperties[42];
         forceObjJanitoring = tempProperties[43];
         forceObjHyping = tempProperties[44];
         forceObjSuspending = tempProperties[45];
         forceObjBanning = tempProperties[46];
         forceObjBlighting = tempProperties[47];
         forceObjBulletproof = tempProperties[48];
         forceResGhosting = tempProperties[49];
         forceResProtect = tempProperties[50];
         forceResAdrenaline = tempProperties[51];
         forceResArc = tempProperties[52];
         forceResGravity = tempProperties[53];
         forceResDroning = tempProperties[54];
         forceResSnare = tempProperties[55];
         forceObjConcussing = tempProperties[56];
         forceObjCauterizing = tempProperties[57];
         forceObjRegeneration = tempProperties[58];
         forceObjDisintegrator = tempProperties[59];
         forceObjDisintegrating = tempProperties[60];
         forceObjDrying = tempProperties[61];
         forceObjFrostfiring = tempProperties[62];
         forceObjFrying = tempProperties[63];
         forceObjWetting = tempProperties[64];
         forceObjGlassing = tempProperties[65];
         forceObjGlitching = tempProperties[66];
         forceObjMagnetic = tempProperties[67];
         forceObjOily = tempProperties[68];
         forceObjPetrifying = tempProperties[69];
         forceObjRadioactive = tempProperties[70];
         forceObjSanguine = tempProperties[71];
         forceObjScorching = tempProperties[72];
         forceObjUltrasharp = tempProperties[73];
         forceObjTriggerOnCut = tempProperties[74];
         forceObjLinkedAlso = tempProperties[75];
         forceObjLinkedOnly = tempProperties[76];
         forceObjWarming = tempProperties[77];
         forceObjWebbing = tempProperties[78];
         forceObjSpreading = tempProperties[79];
         forceResBanning = tempProperties[80];
         forceResBlighting = tempProperties[81];
         forceResStasis = tempProperties[82];
         forceResTransmuting = tempProperties[83];
         forceResCutting = tempProperties[84];
         forceResAliveBreak = tempProperties[85];
         forceResDisintegrating = tempProperties[86];
         forceResDrying = tempProperties[87];
         forceResFrostfiring = tempProperties[88];
         forceResFrying = tempProperties[89];
         forceResGassy = tempProperties[90];
         forceResGlassing = tempProperties[91];
         forceResGlitching = tempProperties[92];
         forceResMagnetic = tempProperties[93];
         forceResOily = tempProperties[94];
         forceResPetrifying = tempProperties[95];
         forceResRadioactive = tempProperties[96];
         forceResBleed = tempProperties[97];
         forceResScorching = tempProperties[98];
         forceResUltrasharp = tempProperties[99];
         forceResChilling = tempProperties[100];
         forceResWarming = tempProperties[101];
         forceResWebbing = tempProperties[102];
         forceResDispel = tempProperties[103];
         forceResDrain = tempProperties[104];
         forceResFlame = tempProperties[105];
         forceResFreeze = tempProperties[106];
         forceResGust = tempProperties[107];
         forceResHeal = tempProperties[108];
         forceResKill = tempProperties[109];
         forceResPoison = tempProperties[110];
         forceResShock = tempProperties[111];
         forceResConcuss = tempProperties[112];
         forceObjEffect = tempProperties[113];
         forceResArmour = tempProperties[114];
         forceResJoints = tempProperties[115];
      }
      
      public static function resetProperties() : void
      {
         forceObjStatic = 0;
         forceObjStick = 0;
         forceObjSharp = 0;
         forceObjBlunt = 0;
         forceObjExplo = 0;
         forceObjBreak = 0;
         forceObjCrumb = 0;
         forceObjBritt = 0;
         forceObjImplo = 0;
         forceObjAlive = 0;
         forceObjSleep = 0;
         forceObjZGrav = 0;
         forceObjAGrav = 0;
         forceObjMagne = 0;
         forceObjFlame = 0;
         forceObjFreeze = 0;
         forceObjShock = 0;
         forceObjHeal = 0;
         forceObjDispel = 0;
         forceObjGust = 0;
         forceObjKill = 0;
         forceObjDrain = 0;
         forceObjPoison = 0;
         forceObjGhost = 0;
         forceObjStain = 0;
         forceObjInvis = 0;
         forceObjUnBreak = 0;
         forceObjVanilla = 0;
         forceObjFlamm = 0;
         forceObjFixed = 0;
         forceResDispel = 0;
         forceResDrain = 0;
         forceResFlame = 0;
         forceResFreeze = 0;
         forceResGust = 0;
         forceResHeal = 0;
         forceResKill = 0;
         forceResPoison = 0;
         forceResShock = 0;
         forceResConcuss = 0;
         forceObjEffect = 0;
         forceResDispel = 0;
         forceResDrain = 0;
         forceResFlame = 0;
         forceResFreeze = 0;
         forceResGust = 0;
         forceResHeal = 0;
         forceResKill = 0;
         forceResPoison = 0;
         forceResShock = 0;
         forceResCutting = 0;
         forceResAliveBreak = 0;
         forceResBleed = 0;
         forceResArmour = 0;
         forceResJoints = 0;
         forceObjRending = 0;
         forceObjAlchemying = 0;
         forceObjTransmuting = 0;
         forceObjCritting = 0;
         forceObjDeleting = 0;
         forceObjTriggering = 0;
         forceObjRelaying = 0;
         forceObjCleaning = 0;
         forceObjJanitoring = 0;
         forceObjHyping = 0;
         forceObjSuspending = 0;
         forceObjBanning = 0;
         forceObjBlighting = 0;
         forceObjBulletproof = 0;
         forceResGhosting = 0;
         forceResProtect = 0;
         forceResAdrenaline = 0;
         forceResArc = 0;
         forceResGravity = 0;
         forceResDroning = 0;
         forceResSnare = 0;
         forceObjConcussing = 0;
         forceObjCauterizing = 0;
         forceObjRegeneration = 0;
         forceObjDisintegrator = 0;
         forceObjDisintegrating = 0;
         forceObjDrying = 0;
         forceObjFrostfiring = 0;
         forceObjFrying = 0;
         forceObjWetting = 0;
         forceObjGlassing = 0;
         forceObjGlitching = 0;
         forceObjMagnetic = 0;
         forceObjOily = 0;
         forceObjPetrifying = 0;
         forceObjRadioactive = 0;
         forceObjSanguine = 0;
         forceObjScorching = 0;
         forceObjUltrasharp = 0;
         forceObjTriggerOnCut = 0;
         forceObjLinkedAlso = 0;
         forceObjLinkedOnly = 0;
         forceObjWarming = 0;
         forceObjWebbing = 0;
         forceObjSpreading = 0;
         forceResBanning = 0;
         forceResBlighting = 0;
         forceResStasis = 0;
         forceResTransmuting = 0;
         forceResCutting = 0;
         forceResAliveBreak = 0;
         forceResDisintegrating = 0;
         forceResDrying = 0;
         forceResFrostfiring = 0;
         forceResFrying = 0;
         forceResGassy = 0;
         forceResGlassing = 0;
         forceResGlitching = 0;
         forceResMagnetic = 0;
         forceResOily = 0;
         forceResPetrifying = 0;
         forceResRadioactive = 0;
         forceResBleed = 0;
         forceResArmour = 0;
         forceResJoints = 0;
         forceResScorching = 0;
         forceResUltrasharp = 0;
         forceResChilling = 0;
         forceResWarming = 0;
         forceResWebbing = 0;
         forceObjJointsDead = 0;
         forceObjJointsConc = 0;
         forceObjWallGhost = 0;
         forceObjProjectileGhost = 0;
         Vars.objSize = 1;
         Vars.objAngle = 0;
         Vars.objDensity = 1;
         Vars.objFriction = 0.5;
         Vars.objRestitution = 0.2;
         Vars.objDampLinear = 0;
         Vars.objDampAngular = 0;
         GameState.ui.menuObject.setValue("% Scale",100);
         GameState.ui.menuObject.setValue("° Angle",0);
         GameState.ui.menuObject.setValue("% Weight",100);
         GameState.ui.menuObject.setValue("% Friction",50);
         GameState.ui.menuObject.setValue("% Bounce",20);
         GameState.ui.menuObject.setValue("Damp Speed",0);
         GameState.ui.menuObject.setValue("Damp Spin",0);
      }
      
      public static function bulletProperties() : *
      {
         var _loc7_:XML = null;
         var _loc8_:Tree = null;
         var _loc9_:String = null;
         if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Bullet Properties")
         {
            GameState.ui.menuObject.close();
            return;
         }
         GameState.ui.menuObject.title = "Bullet Properties";
         if(!GameState.ui.menuObject.visible)
         {
            GameState.ui.menuObject.open();
         }
         var _loc1_:b2Body = Main.instance.detailBody;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:userData = _loc1_.GetUserData();
         if(!_loc2_.trigger || !(_loc2_.trigger is Gun))
         {
            return;
         }
         var _loc3_:Firearm = Gun(_loc2_.trigger).firearm;
         var _loc4_:Array = _loc3_.bulletProperties;
         var _loc5_:XMLList = R.bulletProperties.bulletProperty;
         GameState.ui.menuObject.removeAllChildren();
         var _loc6_:XML = <node label="Root Node"></node>;
         for each(_loc7_ in _loc5_)
         {
            _loc9_ = "0";
            if(_loc4_.indexOf(String(_loc7_.@property)) != -1)
            {
               _loc9_ = "1";
            }
            _loc6_.appendChild(<node label={_loc7_.@label} property={_loc7_.@property} toggleValue={_loc9_} tooltip={_loc7_.@tooltip}/>);
         }
         _loc8_ = GameState.ui.menuObject.addTree("buttons",_loc6_,52,0,24);
         _loc8_.selectable = false;
         GameState.ui.menuObject.maximiseHeight = 292;
         GameState.ui.menuObject.maximise();
         _loc8_.addEventListener(ListEvent.ITEM_CLICK,Main.instance.bulletPropertyClick);
         _loc8_.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,Main.instance.bulletPropertyClick);
         GameState.ui.dockItemMenuDetail();
      }
      
      public static function itemProperties(param1:Boolean = false, param2:Boolean = true) : void
      {
         var scropol:Number;
         var isAlive:String;
         var isSharp:String;
         var isBlunt:String;
         var isStick:String;
         var isBritt:String;
         var isUnBre:String;
         var isVanilla:String;
         var isBreak:String;
         var isExplo:String;
         var isImplo:String;
         var isFlamm:String;
         var isMuted:String;
         var isFixed:String;
         var isAGrav:String;
         var isZGrav:String;
         var isGhost:String;
         var isStain:String;
         var isInvis:String;
         var isStatic:String;
         var isSleep:String;
         var isDispel:String;
         var isDrain:String;
         var isFlame:String;
         var isFreeze:String;
         var isGust:String;
         var isHeal:String;
         var isKill:String;
         var isPoison:String;
         var isShock:String;
         var isRending:String;
         var isAlchemying:String;
         var isTransmuting:String;
         var isCritting:String;
         var isDeleting:String;
         var isTriggering:String;
         var isRelaying:String;
         var isCleaning:String;
         var isJanitoring:String;
         var isHyping:String;
         var isSuspending:String;
         var isBanning:String;
         var isBlighting:String;
         var isBulletproof:String;
         var isResGhosting:String;
         var isResProtect:String;
         var isResAdrenaline:String;
         var isResArc:String;
         var isResGravity:String;
         var isResDroning:String;
         var isResSnare:String;
         var isConcussing:String;
         var isCauterizing:String;
         var isRegeneration:String;
         var isDisintegrator:String;
         var isDisintegrating:String;
         var isDrying:String;
         var isFrostfiring:String;
         var isFrying:String;
         var isWetting:String;
         var isGlassing:String;
         var isGlitching:String;
         var isMagnetic:String;
         var isOily:String;
         var isPetrifying:String;
         var isRadioactive:String;
         var isSanguine:String;
         var isScorching:String;
         var isUltrasharp:String;
         var isTriggerOnCut:String;
         var isTriggerAlso:String;
         var isTriggerOnly:String;
         var isWarming:String;
         var isWebbing:String;
         var isSpreading:String;
         var isResDispel:String;
         var isResDrain:String;
         var isResFlame:String;
         var isResFreeze:String;
         var isResGust:String;
         var isResHeal:String;
         var isResKill:String;
         var isResPoison:String;
         var isResShock:String;
         var isResConcuss:String;
         var isResBanning:String;
         var isResBlighting:String;
         var isResStasis:String;
         var isResTransmuting:String;
         var isResCutting:String;
         var isResAliveBreak:String;
         var isResDisintegrating:String;
         var isResDrying:String;
         var isResFrostfiring:String;
         var isResFrying:String;
         var isResGassy:String;
         var isResGlassing:String;
         var isResGlitching:String;
         var isResMagnetic:String;
         var isResOily:String;
         var isResPetrifying:String;
         var isResRadioactive:String;
         var isResBleed:String;
         var isResArmour:String;
         var isResJoints:String;
         var isResScorching:String;
         var isResUltrasharp:String;
         var isResChilling:String;
         var isResWarming:String;
         var isResWebbing:String;
         var isJointsDead:String;
         var isJointsConc:String;
         var isWallGhost:String;
         var isProjectileGhost:String;
         var isDebug:String;
         var isLock:String;
         var isGridSnap:String;
         var propxml:XML;
         var searchArray:Array;
         var props:Array;
         var format:TextFormat = null;
         var actf:TextFormat = null;
         var acLib:AutoComplete = null;
         var object:XML = null;
         var treeObject:Tree = null;
         var ud:userData = null;
         var plabel:String = null;
         var detail:Boolean = param1;
         var toggle:Boolean = param2;
         if(toggle)
         {
            if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Properties" && !detail)
            {
               GameState.ui.menuObject.close();
               return;
            }
            if(GameState.ui.menuObject.visible && GameState.ui.menuObject.title == "Detail Properties" && detail)
            {
               GameState.ui.menuObject.close();
               return;
            }
         }
         if(!GameState.ui.menuObject.visible)
         {
            GameState.ui.menuObject.open();
         }
         if(GameState.ui.menuObject.title == "Settings")
         {
            GameState.ui.remSettingListeners();
         }
         scropol = 0;
         if(GameState.ui.menuObject.getTree("buttons"))
         {
            scropol = GameState.ui.menuObject.getTree("buttons").verticalScrollPosition;
         }
         GameState.ui.menuObject.removeAllChildren();
         if(detail)
         {
            GameState.ui.menuObject.title = "Detail Properties";
         }
         else
         {
            GameState.ui.menuObject.title = "Properties";
         }
         isAlive = String(forceObjAlive);
         isSharp = String(forceObjSharp);
         isBlunt = String(forceObjBlunt);
         isStick = String(forceObjStick);
         isBritt = String(forceObjBritt);
         isUnBre = String(forceObjUnBreak);
         isVanilla = String(forceObjVanilla);
         isBreak = String(forceObjCrumb);
         isExplo = String(forceObjExplo);
         isImplo = String(forceObjImplo);
         isFlamm = String(forceObjFlamm);
         isMuted = String(forceObjMuted);
         isFixed = String(forceObjFixed);
         isAGrav = String(forceObjAGrav);
         isZGrav = String(forceObjZGrav);
         isGhost = String(forceObjGhost);
         isStain = String(forceObjStain);
         isInvis = String(forceObjInvis);
         isStatic = String(forceObjStatic);
         isSleep = String(forceObjSleep);
         isDispel = String(forceObjDispel);
         isDrain = String(forceObjDrain);
         isFlame = String(forceObjFlame);
         isFreeze = String(forceObjFreeze);
         isGust = String(forceObjGust);
         isHeal = String(forceObjHeal);
         isKill = String(forceObjKill);
         isPoison = String(forceObjPoison);
         isShock = String(forceObjShock);
         isRending = String(forceObjRending);
         isAlchemying = String(forceObjAlchemying);
         isTransmuting = String(forceObjTransmuting);
         isCritting = String(forceObjCritting);
         isDeleting = String(forceObjDeleting);
         isTriggering = String(forceObjTriggering);
         isRelaying = String(forceObjRelaying);
         isCleaning = String(forceObjCleaning);
         isJanitoring = String(forceObjJanitoring);
         isHyping = String(forceObjHyping);
         isSuspending = String(forceObjSuspending);
         isBanning = String(forceObjBanning);
         isBlighting = String(forceObjBlighting);
         isBulletproof = String(forceObjBulletproof);
         isResGhosting = String(forceResGhosting);
         isResProtect = String(forceResProtect);
         isResAdrenaline = String(forceResAdrenaline);
         isResArc = String(forceResArc);
         isResGravity = String(forceResGravity);
         isResDroning = String(forceResDroning);
         isResSnare = String(forceResSnare);
         isConcussing = String(forceObjConcussing);
         isCauterizing = String(forceObjCauterizing);
         isRegeneration = String(forceObjRegeneration);
         isDisintegrator = String(forceObjDisintegrator);
         isDisintegrating = String(forceObjDisintegrating);
         isDrying = String(forceObjDrying);
         isFrostfiring = String(forceObjFrostfiring);
         isFrying = String(forceObjFrying);
         isWetting = String(forceObjWetting);
         isGlassing = String(forceObjGlassing);
         isGlitching = String(forceObjGlitching);
         isMagnetic = String(forceObjMagnetic);
         isOily = String(forceObjOily);
         isPetrifying = String(forceObjPetrifying);
         isRadioactive = String(forceObjRadioactive);
         isSanguine = String(forceObjSanguine);
         isScorching = String(forceObjScorching);
         isUltrasharp = String(forceObjUltrasharp);
         isTriggerOnCut = String(forceObjTriggerOnCut);
         isTriggerAlso = String(forceObjLinkedAlso);
         isTriggerOnly = String(forceObjLinkedOnly);
         isWarming = String(forceObjWarming);
         isWebbing = String(forceObjWebbing);
         isSpreading = String(forceObjSpreading);
         isResDispel = String(forceResDispel);
         isResDrain = String(forceResDrain);
         isResFlame = String(forceResFlame);
         isResFreeze = String(forceResFreeze);
         isResGust = String(forceResGust);
         isResHeal = String(forceResHeal);
         isResKill = String(forceResKill);
         isResPoison = String(forceResPoison);
         isResShock = String(forceResShock);
         isResConcuss = String(forceResConcuss);
         isResBanning = String(forceResBanning);
         isResBlighting = String(forceResBlighting);
         isResStasis = String(forceResStasis);
         isResTransmuting = String(forceResTransmuting);
         isResCutting = String(forceResCutting);
         isResAliveBreak = String(forceResAliveBreak);
         isResDisintegrating = String(forceResDisintegrating);
         isResDrying = String(forceResDrying);
         isResFrostfiring = String(forceResFrostfiring);
         isResFrying = String(forceResFrying);
         isResGassy = String(forceResGassy);
         isResGlassing = String(forceResGlassing);
         isResGlitching = String(forceResGlitching);
         isResMagnetic = String(forceResMagnetic);
         isResOily = String(forceResOily);
         isResPetrifying = String(forceResPetrifying);
         isResRadioactive = String(forceResRadioactive);
         isResBleed = String(forceResBleed);
         isResArmour = String(forceResArmour);
         isResJoints = String(forceResJoints);
         isResScorching = String(forceResScorching);
         isResUltrasharp = String(forceResUltrasharp);
         isResChilling = String(forceResChilling);
         isResWarming = String(forceResWarming);
         isResWebbing = String(forceResWebbing);
         isJointsDead = String(forceObjJointsDead);
         isJointsConc = String(forceObjJointsConc);
         isWallGhost = String(forceObjWallGhost);
         isProjectileGhost = String(forceObjProjectileGhost);
         isDebug = "0";
         isLock = "0";
         isGridSnap = "0";
         if(detail)
         {
            ud = userData(Main.instance.detailBody.GetUserData());
            isDebug = ud.debug ? "1" : "0";
            isLock = ud.locked ? "1" : "0";
            isGridSnap = ud.gridSnap ? "1" : "0";
            isAlive = ud.alive ? "1" : "0";
            isSharp = ud.sharp ? "1" : "0";
            isBlunt = ud.blunt ? "1" : "0";
            isStick = ud.sticky ? "1" : "0";
            isBritt = ud.brittle ? "1" : "0";
            isUnBre = ud.unbreakable ? "1" : "0";
            isVanilla = ud.vanilla ? "1" : "0";
            isBreak = ud.breakable || ud.crumble ? "1" : "0";
            isExplo = ud.explosive ? "1" : "0";
            isImplo = ud.implosive ? "1" : "0";
            isFlamm = ud.flammable ? "1" : "0";
            isFixed = ud.fixedrotation ? "1" : "0";
            isAGrav = ud.antigrav ? "1" : "0";
            isZGrav = ud.zerograv ? "1" : "0";
            isGhost = ud.ghost ? "1" : "0";
            isStain = ud.stainless ? "1" : "0";
            isInvis = ud.invisible ? "1" : "0";
            isSleep = ud.sleepOnSpawn ? "1" : "0";
            isDispel = ud.dispelling ? "1" : "0";
            isDrain = ud.draining ? "1" : "0";
            isFlame = ud.flaming ? "1" : "0";
            isFreeze = ud.freezing ? "1" : "0";
            isGust = ud.gusting ? "1" : "0";
            isHeal = ud.healing ? "1" : "0";
            isKill = ud.killing ? "1" : "0";
            isPoison = ud.poisoning ? "1" : "0";
            isShock = ud.shocking ? "1" : "0";
            isMuted = ud.mute ? "1" : "0";
            isRending = ud.rending ? "1" : "0";
            isAlchemying = ud.alchemying ? "1" : "0";
            isTransmuting = ud.transmuting ? "1" : "0";
            isCritting = ud.critting ? "1" : "0";
            isDeleting = ud.deleting ? "1" : "0";
            isTriggering = ud.triggering ? "1" : "0";
            isRelaying = ud.relaying ? "1" : "0";
            isCleaning = ud.cleaning ? "1" : "0";
            isJanitoring = ud.janitoring ? "1" : "0";
            isHyping = ud.hyping ? "1" : "0";
            isSuspending = ud.suspending ? "1" : "0";
            isBanning = ud.banning ? "1" : "0";
            isBlighting = ud.blighting ? "1" : "0";
            isBulletproof = ud.bulletproof ? "1" : "0";
            isResGhosting = ud.resistGhosting ? "1" : "0";
            isResProtect = ud.resistProtect ? "1" : "0";
            isResAdrenaline = ud.resistAdrenaline ? "1" : "0";
            isResArc = ud.resistArc ? "1" : "0";
            isResGravity = ud.resistGravity ? "1" : "0";
            isResDroning = ud.resistDroning ? "1" : "0";
            isResSnare = ud.resistSnare ? "1" : "0";
            isConcussing = ud.concussing ? "1" : "0";
            isCauterizing = ud.cauterizing ? "1" : "0";
            isRegeneration = ud.regenerating ? "1" : "0";
            isDisintegrator = ud.disintegrator ? "1" : "0";
            isDisintegrating = ud.disintegrating ? "1" : "0";
            isDrying = ud.drying ? "1" : "0";
            isFrostfiring = ud.frostfiring ? "1" : "0";
            isFrying = ud.frying ? "1" : "0";
            isWetting = ud.wetting ? "1" : "0";
            isGlassing = ud.glassing ? "1" : "0";
            isGlitching = ud.glitching ? "1" : "0";
            isMagnetic = ud.magnetic ? "1" : "0";
            isOily = ud.oily ? "1" : "0";
            isPetrifying = ud.petrifying ? "1" : "0";
            isRadioactive = ud.radioactive ? "1" : "0";
            isSanguine = ud.sanguine ? "1" : "0";
            isScorching = ud.scorching ? "1" : "0";
            isUltrasharp = ud.ultrasharp ? "1" : "0";
            isTriggerOnCut = ud.triggerOnCut ? "1" : "0";
            isTriggerOnly = ud.triggerLinkedInstead ? "1" : "0";
            isTriggerAlso = ud.triggerLinkedAsWell ? "1" : "0";
            isWarming = ud.warming ? "1" : "0";
            isWebbing = ud.webbing ? "1" : "0";
            isSpreading = ud.spreading ? "1" : "0";
            isResDispel = ud.resistDispel ? "1" : "0";
            isResDrain = ud.resistDrain ? "1" : "0";
            isResFlame = ud.resistFlame ? "1" : "0";
            isResFreeze = ud.resistFreeze ? "1" : "0";
            isResGust = ud.resistGust ? "1" : "0";
            isResHeal = ud.resistHeal ? "1" : "0";
            isResKill = ud.resistKill ? "1" : "0";
            isResPoison = ud.resistPoison ? "1" : "0";
            isResShock = ud.resistShock ? "1" : "0";
            isResConcuss = ud.resistConcuss ? "1" : "0";
            isResBanning = ud.resistBanning ? "1" : "0";
            isResBlighting = ud.resistBlighting ? "1" : "0";
            isResStasis = ud.resistStasis ? "1" : "0";
            isResTransmuting = ud.resistTransmuting ? "1" : "0";
            isResCutting = ud.resistCutting ? "1" : "0";
            isResAliveBreak = ud.resistAliveBreak ? "1" : "0";
            isResDisintegrating = ud.resistDisintegrating ? "1" : "0";
            isResDrying = ud.resistDrying ? "1" : "0";
            isResFrostfiring = ud.resistFrostfiring ? "1" : "0";
            isResFrying = ud.resistFrying ? "1" : "0";
            isResGassy = ud.resistGassy ? "1" : "0";
            isResGlassing = ud.resistGlassing ? "1" : "0";
            isResGlitching = ud.resistGlitching ? "1" : "0";
            isResMagnetic = ud.resistMagnetic ? "1" : "0";
            isResOily = ud.resistOily ? "1" : "0";
            isResPetrifying = ud.resistPetrifying ? "1" : "0";
            isResRadioactive = ud.resistRadioactive ? "1" : "0";
            isResBleed = ud.resistBleed ? "1" : "0";
            isResArmour = ud.resistArmour ? "1" : "0";
            isResJoints = ud.resistJoints ? "1" : "0";
            isResScorching = ud.resistScorching ? "1" : "0";
            isResUltrasharp = ud.resistUltrasharp ? "1" : "0";
            isResChilling = ud.resistChilling ? "1" : "0";
            isResWarming = ud.resistWarming ? "1" : "0";
            isResWebbing = ud.resistWebbing ? "1" : "0";
            isJointsDead = ud.unequipDead ? "1" : "0";
            isJointsConc = ud.unequipConcuss ? "1" : "0";
            isWallGhost = ud.wallGhost ? "1" : "0";
         }
         propxml = <node label="Root Node">
				<node label="Basic">
					<node label="Alive " toggleValue={isAlive} tooltip="Turns the item Alive, giving it health and making it bleed when damaged. Alive items act as a bodypart when jointed to a doll. Modify health/maxhealth via Detail Tool.&#10;&#10;&#10;&#10;&#10;"/>
					<node label="Breakable " toggleValue={isBreak} tooltip="Breaks on&#10;collision."/>
					<node label="Brittle " toggleValue={isBritt} tooltip="Breaks apart&#10;on hard&#10;collision."/>
					<node label="Dull " toggleValue={isBlunt} tooltip="Dulls all sharp parts of the item, making them blunt.&#10;&#10;&#10;"/>
					<node label="Flammable " toggleValue={isFlamm} tooltip="Highly flammable.&#10;"/>
					<node label="Muted " toggleValue={isMuted} tooltip="Disables sounds the item might produce.&#10;"/>
					<node label="Resist Cutting" toggleValue={isResCutting} tooltip="Can't be cut apart. Damage still applies.&#10;&#10;"/>
					<node label="Sharp " toggleValue={isSharp} tooltip="Cuts other items based on collision force.&#10;&#10;"/>
					<node label="Static " toggleValue={isStatic} tooltip="Static obstacle unaffected by physics. Same as setting 0% weight.&#10;&#10;&#10;"/>
					<node label="Sticky " toggleValue={isStick} tooltip="Sticks to other items on collision.&#10;&#10;"/>
					<node label="Ultrasharp" toggleValue={isUltrasharp} tooltip="Cuts items instantly at the slightest touch.&#10;"/>
				</node>
				<node label="Graphics">
					<node label="Stainless " toggleValue={isStain} tooltip="Disables all visual effects on this item.&#10;"/>
					<node label="Invisible " toggleValue={isInvis} tooltip="Not visible even when paused.&#10;"/>
					<node label="Cleaning" toggleValue={isCleaning} tooltip="Cleans stains on other items on collision.&#10;"/>
				</node>
				<node label="Physics">
					<node label="Anti-Gravity" toggleValue={isAGrav} tooltip="Negative&#10;gravity."/>
					<node label="Disintegrating" toggleValue={isDisintegrating} tooltip="Disintegrates on collision. (See Powder to disintegrate other items.)&#10;&#10;"/>
					<node label="Fixed Rotation " toggleValue={isFixed} tooltip="Can not rotate. May affects various physics in weird ways.&#10;&#10;&#10;"/>
					<node label="Ghost " toggleValue={isGhost} tooltip="Doesn't collide with anything but walls.&#10;"/>
					<node label="Wall Ghost" toggleValue={isWallGhost} tooltip="Doesn't collide with walls.&#10;"/>
					<node label="Bullet Ghost" toggleValue={isProjectileGhost} tooltip="Doesn't collide with bullets and other projectiles.&#10;&#10;"/>
					<node label="Sleep " toggleValue={isSleep} tooltip="Not affected by physics until touched or moved.&#10;&#10;"/>
					<node label="Zero-Gravity" toggleValue={isZGrav} tooltip="No gravity."/>
					<node label="Resist Joints" toggleValue={isResJoints} tooltip="Resists any new joints.&#10;"/>
				</node>
				<node label="Alive" tooltip="Properties that only affect Alive items.&#10;">
					<node label="Alive " toggleValue={isAlive} tooltip="Turns the item Alive, giving it health and making it bleed when damaged. Alive items act as a bodypart when jointed to a doll. Modify health/maxhealth via Detail Tool.&#10;&#10;&#10;&#10;&#10;"/>
					<node label="Blight" toggleValue={isBlighting} tooltip="Damages Alive items, causing them to burst on death, spreading more blight.&#10;&#10;&#10;"/>
					<node label="Cauterize" toggleValue={isCauterizing} tooltip="Cauterizes bleeding wounds on collision.&#10;"/>
					<node label="Concuss" toggleValue={isResTransmuting} tooltip="Concusses Alive items while touching.&#10;"/>
					<node label="Critical Hit!" toggleValue={isCritting} tooltip="Has 5% chance to instantly kill an Alive item on collision.&#10;&#10;"/>
					<node label="Deadly" toggleValue={isKill} tooltip="Instantly kills Alive items on collision.&#10;"/>
					<node label="Drain" toggleValue={isDrain} tooltip="Leeches health from Alive items on collision, healing self if also Alive.&#10;&#10;"/>
					<node label="Heal" toggleValue={isHeal} tooltip="Heals Alive items on collision.&#10;"/>
					<node label="Lacerate" toggleValue={isSanguine} tooltip="Inflicts bleeding wounds all over Alive items on collision.&#10;&#10;"/>
					<node label="Poison" toggleValue={isPoison} tooltip="Poisons Alive items, making them slowly degenerate health.&#10;&#10;"/>
					<node label="Radioactive" toggleValue={isRadioactive} tooltip="Damages nearby alive items.&#10;&#10;"/>
					<node label="Regeneration" toggleValue={isRegeneration} tooltip="Regenerates health over time.&#10;&#10;"/>
					<node label="Resist Breaking" toggleValue={isResAliveBreak} tooltip="Prevents dead items gibbing when damaged.&#10;Alive Revolute joints won't break when pulled.&#10;Doesn't affect direct cutting.&#10;&#10;"/>
					<node label="Resist Concuss" toggleValue={isResConcuss} tooltip="Can't be concussed.&#10;&#10;"/>
					<node label="Resist Wounds" toggleValue={isResBleed} tooltip="Resists bleeding wounds. Cutting still possible.&#10;"/>
					<node label="Resist Armour" toggleValue={isResArmour} tooltip="Resists equipping any armour pieces.&#10;"/>
					<node label="Unequip Death" toggleValue={isJointsDead} tooltip="Equipped items will drop on deadly damage most of the time.&#10;&#10;"/>
					<node label="Unequip Concuss" toggleValue={isJointsConc} tooltip="Equipped items will drop on concuss.&#10;"/>
				</node>
				<node label="Collision" tooltip="Affects other items on collision.&#10;&#10;&#10;">
					<node label="Burn" toggleValue={isFlame} tooltip="Sets flammable items on fire.&#10;&#10;"/>
					<node label="Deepfry" toggleValue={isFrying} tooltip="Deepfries items, making them extra tasty. Damages Alive.&#10;&#10;"/>
					<node label="Dispel" toggleValue={isDispel} tooltip="Removes status effects (burn, freeze, etc.)&#10;&#10;"/>
					<node label="Deleting" toggleValue={isDeleting} tooltip="Deletes other items on collision.&#10;"/>
					<node label="Explosive " toggleValue={isExplo} tooltip="Explodes on collision.&#10;"/>
					<node label="Freeze" toggleValue={isFreeze} tooltip="Freezes items, making them and their joints brittle.&#10;&#10;&#10;"/>
					<node label="Frostfire" toggleValue={isFrostfiring} tooltip="Engulfs items in a freezing burning flame.&#10;"/>
					<node label="Glass" toggleValue={isGlassing} tooltip="Turns items into fragile glass.&#10;"/>
					<node label="Glitch" toggleValue={isGlitching} tooltip="Glitches items visually.&#10;"/>
					<node label="Hype" toggleValue={isHyping} tooltip="Violently shakes.&#10;"/>
					<node label="Implosive " toggleValue={isImplo} tooltip="Implodes on collision.&#10;"/>
					<node label="Janitor" toggleValue={isJanitoring} tooltip="Destroys small cut debris on touch.&#10;"/>
					<node label="Petrify" toggleValue={isPetrifying} tooltip="Petrifies items, locking their joints.&#10;"/>
					<node label="Powder" toggleValue={isDisintegrator} tooltip="Disintegrates items into powder.&#10;"/>
					<node label="Rend" toggleValue={isRending} tooltip="Inflicts small cuts all over.&#10;&#10;"/>
					<node label="Repel" toggleValue={isGust} tooltip="Repels item on touch, launching them away.&#10;&#10;"/>
					<node label="Sandstone" toggleValue={isDrying} tooltip="Turns items into crumbling sandstone.&#10;"/>
					<node label="Scorch" toggleValue={isScorching} tooltip="Scorches items, causing them to melt into lava.&#10;"/>
					<node label="Shock" toggleValue={isShock} tooltip="Shocks items, triggering their functionality.&#10;"/>
					<node label="Stasis" toggleValue={isSuspending} tooltip="Applies stasis, floating items in place.&#10;"/>
					<node label="Transmute" toggleValue={isTransmuting} tooltip="Randomly turns the item into another.&#10;&#10;"/>
					<node label="Wet" toggleValue={isWetting} tooltip="Drenches items with a splash of water, cleaning, stabilizing temperature, and clearing Concuss, Petrify and Sticky.&#10;&#10;&#10;&#10;"/>
				</node>
				<node label="Resistances">
					<node label="Resist Arc" toggleValue={isResArc} tooltip="Undamaged by Arc.&#10;"/>
					<node label="Resist Blight" toggleValue={isResBlighting} tooltip="Resists Blight.&#10;"/>
					<node label="Resist Bullets" toggleValue={isBulletproof} tooltip="Won't be cut or damaged by plain bullets. Doesn't affect projectile functionality.&#10;&#10;"/>
					<node label="Resist Burning" toggleValue={isResFlame} tooltip="Doesn't burn. Temperature changes and direct fire damage may still apply.&#10;&#10;&#10;"/>
					<node label="Resist Deadly" toggleValue={isResKill} tooltip="Resists Deadly.&#10;"/>
					<node label="Resist Disintegrating" toggleValue={isResDisintegrating} tooltip="Can't be disintegrated.&#10;"/>
					<node label="Resist Drain" toggleValue={isResDrain} tooltip="Can't be drained of blood.&#10;"/>
					<node label="Resist Freezing" toggleValue={isResFreeze} tooltip="Can't be frozen. Temperature changes and direct frost damage may still apply.&#10;&#10;&#10;"/>
					<node label="Resist Frostfire" toggleValue={isResFrostfiring} tooltip="Resists Frostfire.&#10;"/>
					<node label="Resist Fry" toggleValue={isResFrying} tooltip="Can't be deepfried.&#10;"/>
					<node label="Resist Ghosting" toggleValue={isResGhosting} tooltip="Can't be turned into a g-g-ghost.&#10;"/>
					<node label="Resist Glass" toggleValue={isResGlassing} tooltip="Resists Glass.&#10;"/>
					<node label="Resist Glitch" toggleValue={isResGlitching} tooltip="Resists Glitching.&#10;"/>
					<node label="Resist Gravity" toggleValue={isResGravity} tooltip="Resists changes in gravity.&#10;"/>
					<node label="Resist Petrify" toggleValue={isResPetrifying} tooltip="Can't be petrified.&#10;"/>
					<node label="Resist Poison" toggleValue={isResPoison} tooltip="Resists poisoning and acid.&#10;"/>
					<node label="Resist Radiation" toggleValue={isResRadioactive} tooltip="Resists radiation.&#10;"/>
					<node label="Resist Repel" toggleValue={isResGust} tooltip="Unaffected by items with Repel.&#10;"/>
					<node label="Resist Sandstone" toggleValue={isResDrying} tooltip="Resists Sandstone.&#10;"/>
					<node label="Resist Scorch" toggleValue={isResScorching} tooltip="Resists Scorching and lava.&#10;"/>
					<node label="Resist Shocking" toggleValue={isResShock} tooltip="Can't be shocked.&#10;"/>
					<node label="Resist Stasis" toggleValue={isResStasis} tooltip="Unaffected by Stasis.&#10;"/>
					<node label="Resist Transmute" toggleValue={isResTransmuting} tooltip="Can't be transmuted into other items.&#10;"/>
				</node>
				<node label="Trigger" tooltip="Properties that trigger items.">
					<node label="Relaying" toggleValue={isRelaying} tooltip="Toggles trigger of items linked to this item on collision.&#10;&#10;"/>
					<node label="Spreading" toggleValue={isSpreading} tooltip="Transfers properties (including Spreading) to other items on collision.&#10;&#10;&#10;"/>
					<node label="Transferring" toggleValue={isAlchemying} tooltip="Transfers properties (except Transferring) to other items on collision.&#10;&#10;&#10;"/>
					<node label="Triggering" toggleValue={isTriggering} tooltip="Toggles trigger of other items on collision.&#10;&#10;"/>
					<node label="Trigger On Cut" toggleValue={isTriggerOnCut} tooltip="Triggers on cut instead of getting cut.&#10;&#10;"/>
					<node label="Linked Also" toggleValue={isTriggerAlso} tooltip="Triggers linked items as well.&#10;&#10;"/>
					<node label="Linked Only" toggleValue={isTriggerOnly} tooltip="Triggers linked items instead of this item. Requires item that has a trigger.&#10;&#10;"/>
					<node label="Vanilla " toggleValue={isVanilla} tooltip="Spawns the item model without any functionality.&#10;&#10;"/>
				</node>
			</node>;
         if(detail)
         {
            propxml.appendChild(<node label="Locked " toggleValue={isLock} tooltip="Locks the item so it can't be selected by tools or certain effects of items.&#10;&#10;&#10;"/>);
            propxml.appendChild(<node label="Debug " toggleValue={isDebug} tooltip="Displays additional info about the item while paused.&#10;&#10;"/>);
            if(ud.unbreakable)
            {
               propxml.appendChild(<node label="Unbreakable " toggleValue={isUnBre} tooltip="Legacy property! This toggle is only here so you can disable it from existing items.&#10;&#10;&#10;"/>);
            }
            if(World.toggleGrid == 1)
            {
               propxml.appendChild(<node label="Snap to Grid " toggleValue={isGridSnap} tooltip="Snaps the item position to the pause grid when moved.&#10;&#10;"/>);
            }
         }
         else
         {
            propxml.prependChild(<node label="Unselect All" func="resetproperties"/>);
         }
         format = new TextFormat(Tweak.FONT,14,GameState.ui.menuObject.FONTCOLOUR,true);
         format.align = TextFormatAlign.CENTER;
         actf = new TextFormat(Tweak.FONT,14,GameState.ui.menuObject.FONTCOLOUR,true);
         actf.align = TextFormatAlign.CENTER;
         actf.bold = true;
         acLib = new AutoComplete();
         acLib.name = "autoComplete";
         acLib.textField.name = "autoCompleteField";
         acLib.textField.text = "Search...";
         acLib.textField.embedFonts = true;
         acLib.textField.defaultTextFormat = format;
         acLib.textField.setTextFormat(format);
         acLib.setStyle("textFormat",format);
         acLib.textField.background = true;
         acLib.textField.backgroundColor = GameState.ui.menuObject.FIELDBACKGROUNDCOLOUR;
         acLib.textField.cacheAsBitmap = true;
         acLib.setStyle("borderThickness",-2);
         acLib.tabEnabled = false;
         acLib.tabChildren = false;
         acLib.keysEnabled = false;
         acLib.textField.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):*
         {
            param1.currentTarget.text = "";
            acLib.setStyle("textFormat",actf);
            acLib.rowCount = int((GameState.ui.menuLibrary.height - 50) / 24);
         });
         acLib.textField.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):*
         {
            if(param1.currentTarget.text == "")
            {
               param1.currentTarget.text = "Search...";
               acLib.setStyle("textFormat",format);
            }
         });
         acLib.x = Window.BUFFER * 2;
         acLib.width = GameState.ui.menuObject.actualWidth - Window.BUFFER * 4;
         acLib.dropdown.rowHeight = 24;
         GameState.ui.menuObject.ignoreDrag("autoComplete");
         searchArray = [];
         props = [];
         for each(object in propxml.node.node)
         {
            plabel = object.@label;
            if(props.indexOf(plabel) == -1)
            {
               props.push(plabel);
               searchArray.push({"label":plabel});
            }
         }
         acLib.addEventListener(DropdownEvent.CLOSE,GameState.ui.autocompleteProperties);
         acLib.dataProvider = new DataProvider(searchArray);
         GameState.ui.menuObject.addOther(acLib);
         treeObject = GameState.ui.menuObject.addTree("buttons",propxml,52,0,24);
         treeObject.selectable = false;
         GameState.ui.menuObject.maximiseHeight = 292;
         GameState.ui.menuObject.maximise();
         if(detail)
         {
            treeObject.addEventListener(ListEvent.ITEM_CLICK,Main.instance.detailTreeClick);
            treeObject.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,Main.instance.detailTreeClick);
         }
         else
         {
            treeObject.addEventListener(ListEvent.ITEM_CLICK,Main.instance.handleTreeClick);
            treeObject.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,Main.instance.handleTreeClick);
         }
         treeObject.verticalScrollPosition = scropol;
         if(detail)
         {
            GameState.ui.dockItemMenuDetail();
         }
         else
         {
            GameState.ui.dockItemMenu();
         }
      }
      
      public static function objectProperties(param1:String, param2:int = 100, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false) : userData
      {
         var _loc14_:Object = {
            "name":param1,
            "health":param2,
            "explosive":param3,
            "sticky":param4,
            "sharp":param5,
            "breakable":param6,
            "crumble":param7,
            "implosive":param8,
            "alive":param9,
            "antigrav":param10,
            "zerograv":param11,
            "magnet":param12,
            "sensor":param13,
            "brittle":false
         };
         if(param1.substr(0,4) == "doll")
         {
            _loc14_.id = Main.instance.dollNumber;
         }
         else
         {
            _loc14_.id = -1;
         }
         var _loc15_:userData = new userData(_loc14_.name,_loc14_.id,GeneralUtils.stringProperties(_loc14_));
         if(param1 != "wall" && param1 != "blooddrop" && !GameState.cutting && !GameState.resizing && GameState.spawning)
         {
            if(forceObjStick == 1)
            {
               _loc15_.sticky = true;
            }
            if(forceObjSharp == 1)
            {
               _loc15_.sharp = true;
            }
            if(forceObjBlunt == 1)
            {
               _loc15_.blunt = true;
            }
            if(forceObjBreak == 1)
            {
               _loc15_.breakable = true;
            }
            if(forceObjUnBreak == 1)
            {
               _loc15_.unbreakable = true;
            }
            if(forceObjVanilla == 1)
            {
               _loc15_.vanilla = true;
            }
            if(forceObjFlamm == 1)
            {
               _loc15_.flammable = true;
               _loc15_.conductivity = 0.01;
               _loc15_.ignition = 100;
            }
            if(forceObjCrumb == 1)
            {
               _loc15_.crumble = true;
            }
            if(forceObjBritt == 1)
            {
               _loc15_.brittle = true;
            }
            if(forceObjExplo == 1)
            {
               _loc15_.explosive = true;
               _loc15_.triggerForce = 1000;
               _loc15_.triggerRadius = 200;
            }
            if(forceObjImplo == 1)
            {
               _loc15_.implosive = true;
               _loc15_.triggerForce = 1000;
               _loc15_.triggerRadius = 200;
            }
            if(forceObjAlive == 1)
            {
               _loc15_.alive = true;
               _loc15_.health = param2;
            }
            if(forceObjZGrav == 1)
            {
               _loc15_.zerograv = true;
            }
            if(forceObjSleep == 1)
            {
               _loc15_.sleepOnSpawn = true;
            }
            if(forceObjAGrav == 1)
            {
               _loc15_.antigrav = true;
            }
            if(forceObjFlame == 1)
            {
               _loc15_.flaming = true;
            }
            if(forceObjFreeze == 1)
            {
               _loc15_.freezing = true;
            }
            if(forceObjShock == 1)
            {
               _loc15_.shocking = true;
            }
            if(forceObjHeal == 1)
            {
               _loc15_.healing = true;
            }
            if(forceObjDispel == 1)
            {
               _loc15_.dispelling = true;
               _loc15_.triggerDuration = 0;
               _loc15_.triggerState = -1;
            }
            if(forceObjGust == 1)
            {
               _loc15_.gusting = true;
            }
            if(forceObjKill == 1)
            {
               _loc15_.killing = true;
            }
            if(forceObjDrain == 1)
            {
               _loc15_.draining = true;
            }
            if(forceObjPoison == 1)
            {
               _loc15_.poisoning = true;
            }
            if(forceObjGhost == 1)
            {
               _loc15_.ghost = true;
            }
            if(forceObjStain == 1)
            {
               _loc15_.stainless = true;
            }
            if(forceObjJointsDead == 1)
            {
               _loc15_.unequipDead = true;
            }
            if(forceObjJointsConc == 1)
            {
               _loc15_.unequipConcuss = true;
            }
            if(forceObjWallGhost == 1)
            {
               _loc15_.wallGhost = true;
            }
            if(forceObjProjectileGhost == 1)
            {
               _loc15_.projectileGhost = true;
            }
            if(forceObjInvis == 1)
            {
               _loc15_.invisible = true;
            }
            if(forceObjMagne == 1)
            {
               _loc15_.magnet = true;
            }
            if(forceObjFixed == 1)
            {
               _loc15_.fixedrotation = true;
            }
            if(forceObjMuted == 1)
            {
               _loc15_.mute = true;
            }
            if(forceObjRending == 1)
            {
               _loc15_.rending = true;
            }
            if(forceObjAlchemying == 1)
            {
               _loc15_.alchemying = true;
            }
            if(forceObjTransmuting == 1)
            {
               _loc15_.transmuting = true;
            }
            if(forceObjCritting == 1)
            {
               _loc15_.critting = true;
            }
            if(forceObjDeleting == 1)
            {
               _loc15_.deleting = true;
            }
            if(forceObjTriggering == 1)
            {
               _loc15_.triggering = true;
            }
            if(forceObjRelaying == 1)
            {
               _loc15_.relaying = true;
            }
            if(forceObjCleaning == 1)
            {
               _loc15_.cleaning = true;
            }
            if(forceObjJanitoring == 1)
            {
               _loc15_.janitoring = true;
            }
            if(forceObjHyping == 1)
            {
               _loc15_.hyping = true;
            }
            if(forceObjSuspending == 1)
            {
               _loc15_.suspending = true;
            }
            if(forceObjBanning == 1)
            {
               _loc15_.banning = true;
            }
            if(forceObjBlighting == 1)
            {
               _loc15_.blighting = true;
            }
            if(forceObjBulletproof == 1)
            {
               _loc15_.bulletproof = true;
            }
            if(forceObjConcussing == 1)
            {
               _loc15_.concussing = true;
            }
            if(forceObjCauterizing == 1)
            {
               _loc15_.cauterizing = true;
            }
            if(forceObjRegeneration == 1)
            {
               _loc15_.regenerating = true;
            }
            if(forceObjDisintegrator == 1)
            {
               _loc15_.disintegrator = true;
            }
            if(forceObjDisintegrating == 1)
            {
               _loc15_.disintegrating = true;
            }
            if(forceObjDrying == 1)
            {
               _loc15_.drying = true;
            }
            if(forceObjFrostfiring == 1)
            {
               _loc15_.frostfiring = true;
            }
            if(forceObjFrying == 1)
            {
               _loc15_.frying = true;
            }
            if(forceObjWetting == 1)
            {
               _loc15_.wetting = true;
            }
            if(forceObjGlassing == 1)
            {
               _loc15_.glassing = true;
            }
            if(forceObjGlitching == 1)
            {
               _loc15_.glitching = true;
            }
            if(forceObjMagnetic == 1)
            {
               _loc15_.magnetic = true;
            }
            if(forceObjOily == 1)
            {
               _loc15_.oily = true;
            }
            if(forceObjPetrifying == 1)
            {
               _loc15_.petrifying = true;
            }
            if(forceObjRadioactive == 1)
            {
               _loc15_.radioactive = true;
            }
            if(forceObjSanguine == 1)
            {
               _loc15_.sanguine = true;
            }
            if(forceObjScorching == 1)
            {
               _loc15_.scorching = true;
            }
            if(forceObjUltrasharp == 1)
            {
               _loc15_.ultrasharp = true;
            }
            if(forceObjTriggerOnCut == 1)
            {
               _loc15_.triggerOnCut = true;
            }
            if(forceObjLinkedOnly == 1)
            {
               _loc15_.triggerLinkedInstead = true;
            }
            if(forceObjLinkedAlso == 1)
            {
               _loc15_.triggerLinkedAsWell = true;
            }
            if(forceObjWarming == 1)
            {
               _loc15_.warming = true;
            }
            if(forceObjWebbing == 1)
            {
               _loc15_.webbing = true;
            }
            if(forceObjSpreading == 1)
            {
               _loc15_.spreading = true;
            }
            if(forceResDispel == 1)
            {
               _loc15_.resistDispel = true;
            }
            if(forceResDrain == 1)
            {
               _loc15_.resistDrain = true;
            }
            if(forceResFlame == 1)
            {
               _loc15_.resistFlame = true;
            }
            if(forceResFreeze == 1)
            {
               _loc15_.resistFreeze = true;
            }
            if(forceResGust == 1)
            {
               _loc15_.resistGust = true;
            }
            if(forceResHeal == 1)
            {
               _loc15_.resistHeal = true;
            }
            if(forceResKill == 1)
            {
               _loc15_.resistKill = true;
            }
            if(forceResPoison == 1)
            {
               _loc15_.resistPoison = true;
            }
            if(forceResShock == 1)
            {
               _loc15_.resistShock = true;
            }
            if(forceResConcuss == 1)
            {
               _loc15_.resistConcuss = true;
            }
            if(forceResBanning == 1)
            {
               _loc15_.resistBanning = true;
            }
            if(forceResBlighting == 1)
            {
               _loc15_.resistBlighting = true;
            }
            if(forceResStasis == 1)
            {
               _loc15_.resistStasis = true;
            }
            if(forceResTransmuting == 1)
            {
               _loc15_.resistTransmuting = true;
            }
            if(forceResCutting == 1)
            {
               _loc15_.resistCutting = true;
            }
            if(forceResAliveBreak == 1)
            {
               _loc15_.resistAliveBreak = true;
            }
            if(forceResDisintegrating == 1)
            {
               _loc15_.resistDisintegrating = true;
            }
            if(forceResDrying == 1)
            {
               _loc15_.resistDrying = true;
            }
            if(forceResFrostfiring == 1)
            {
               _loc15_.resistFrostfiring = true;
            }
            if(forceResFrying == 1)
            {
               _loc15_.resistFrying = true;
            }
            if(forceResGassy == 1)
            {
               _loc15_.resistGassy = true;
            }
            if(forceResGlassing == 1)
            {
               _loc15_.resistGlassing = true;
            }
            if(forceResGlitching == 1)
            {
               _loc15_.resistGlitching = true;
            }
            if(forceResMagnetic == 1)
            {
               _loc15_.resistMagnetic = true;
            }
            if(forceResOily == 1)
            {
               _loc15_.resistOily = true;
            }
            if(forceResPetrifying == 1)
            {
               _loc15_.resistPetrifying = true;
            }
            if(forceResRadioactive == 1)
            {
               _loc15_.resistRadioactive = true;
            }
            if(forceResBleed == 1)
            {
               _loc15_.resistBleed = true;
            }
            if(forceResArmour == 1)
            {
               _loc15_.resistArmour = true;
            }
            if(forceResJoints == 1)
            {
               _loc15_.resistJoints = true;
            }
            if(forceResScorching == 1)
            {
               _loc15_.resistScorching = true;
            }
            if(forceResUltrasharp == 1)
            {
               _loc15_.resistUltrasharp = true;
            }
            if(forceResChilling == 1)
            {
               _loc15_.resistChilling = true;
            }
            if(forceResWarming == 1)
            {
               _loc15_.resistWarming = true;
            }
            if(forceResWebbing == 1)
            {
               _loc15_.resistWebbing = true;
            }
            if(forceResGhosting == 1)
            {
               _loc15_.resistGhosting = true;
            }
            if(forceResProtect == 1)
            {
               _loc15_.resistProtect = true;
            }
            if(forceResAdrenaline == 1)
            {
               _loc15_.resistAdrenaline = true;
            }
            if(forceResArc == 1)
            {
               _loc15_.resistArc = true;
            }
            if(forceResGravity == 1)
            {
               _loc15_.resistGravity = true;
            }
            if(forceResDroning == 1)
            {
               _loc15_.resistDroning = true;
            }
            if(forceResSnare == 1)
            {
               _loc15_.resistSnare = true;
            }
         }
         _loc15_.health = Vars.objHealth;
         _loc15_.maxhealth = Vars.objMaxHealth;
         _loc15_.temperature = 37;
         return _loc15_;
      }
      
      public static function shapeProperties(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : ShapeUserData
      {
         var _loc5_:Object = {
            "name":param1,
            "sticky":param2,
            "sharp":param3,
            "sensor":param4
         };
         return new ShapeUserData(_loc5_.name,GeneralUtils.stringProperties(_loc5_));
      }
      
      public static function objExplosive(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.explosive = true;
         return _loc2_;
      }
      
      public static function objImplosive(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.implosive = true;
         return _loc2_;
      }
      
      public static function objBrittle(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.brittle = true;
         return _loc2_;
      }
      
      public static function objMagnet(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.magnet = true;
         return _loc2_;
      }
      
      public static function objBreak(param1:String) : userData
      {
         return objectProperties(param1,-1,false,false,false,true);
      }
      
      public static function objCrumble(param1:String) : userData
      {
         return objectProperties(param1,-1,false,false,false,false,true);
      }
      
      public static function objSharp(param1:String) : userData
      {
         return objectProperties(param1,-1,false,false,true,false);
      }
      
      public static function objStick(param1:String) : userData
      {
         return objectProperties(param1,-1,false,true,false,false);
      }
      
      public static function shapeSharp(param1:String) : ShapeUserData
      {
         return shapeProperties(param1,false,true);
      }
      
      public static function shapeStickSharp(param1:String) : ShapeUserData
      {
         return shapeProperties(param1,true,true);
      }
      
      public static function shapeStick(param1:String) : ShapeUserData
      {
         return shapeProperties(param1,true);
      }
      
      public static function shapeGhost(param1:String) : ShapeUserData
      {
         return shapeProperties(param1,true);
      }
      
      public static function shapeDecor(param1:String) : ShapeUserData
      {
         var _loc2_:ShapeUserData = shapeProperties(param1);
         _loc2_.decorative = true;
         return _loc2_;
      }
      
      public static function shapeRandom(param1:String) : ShapeUserData
      {
         var _loc2_:ShapeUserData = shapeProperties(param1);
         _loc2_.decorative = true;
         _loc2_.randomDecoration = true;
         return _loc2_;
      }
      
      public static function shapeInvis(param1:String) : ShapeUserData
      {
         var _loc2_:ShapeUserData = shapeProperties(param1);
         _loc2_.invisible = true;
         return _loc2_;
      }
      
      public static function shapeInvisSensor(param1:String) : ShapeUserData
      {
         var _loc2_:ShapeUserData = shapeProperties(param1);
         _loc2_.invisible = true;
         _loc2_.sensor = true;
         return _loc2_;
      }
      
      public static function shapeInvisStickSharp(param1:String) : ShapeUserData
      {
         var _loc2_:ShapeUserData = shapeProperties(param1);
         _loc2_.invisible = true;
         _loc2_.sharp = true;
         _loc2_.sticky = true;
         return _loc2_;
      }
      
      public static function shapeInvisSharp(param1:String) : ShapeUserData
      {
         var _loc2_:ShapeUserData = shapeProperties(param1);
         _loc2_.invisible = true;
         _loc2_.sharp = true;
         return _loc2_;
      }
      
      public static function shapeInvisStick(param1:String) : ShapeUserData
      {
         var _loc2_:ShapeUserData = shapeProperties(param1);
         _loc2_.invisible = true;
         _loc2_.sticky = true;
         return _loc2_;
      }
      
      public static function shapeSensor(param1:String) : ShapeUserData
      {
         return shapeProperties(param1,false,false,true);
      }
      
      public static function objTemp(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.killOnContact = true;
         _loc2_.saveable = false;
         _loc2_.projectile = true;
         return _loc2_;
      }
      
      public static function objAlive(param1:String, param2:Number) : userData
      {
         var _loc3_:userData = objectProperties(param1,param2);
         _loc3_.alive = true;
         _loc3_.soft = true;
         _loc3_.temperature = 37;
         _loc3_.conductivity = 0.01;
         _loc3_.ignition = 100;
         _loc3_.maxhealth = param2;
         _loc3_.health = param2;
         return _loc3_;
      }
      
      public static function objSenso(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.sensor = true;
         return _loc2_;
      }
      
      public static function objBurn(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.temperature = 37;
         _loc2_.conductivity = 0.01;
         _loc2_.ignition = 100;
         return _loc2_;
      }
      
      public static function objWood(param1:String) : userData
      {
         var _loc2_:userData = objectProperties(param1);
         _loc2_.temperature = 37;
         _loc2_.conductivity = 0.01;
         _loc2_.ignition = 100;
         _loc2_.breakable = true;
         return _loc2_;
      }
   }
}

