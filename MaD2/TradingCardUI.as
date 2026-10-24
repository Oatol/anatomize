package
{
   import com.gskinner.utils.Rndm;
   import com.yahoo.astra.fl.controls.AutoComplete;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.controls.treeClasses.TNode;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TradingCardUI
   {
      
      public function TradingCardUI()
      {
         super();
      }
      
      public static function Style(param1:String, param2:int, param3:int) : void
      {
         if(GameState.objects.spawnName == param1)
         {
            return;
         }
         if(Main.instance.localNames.indexOf(param1) != -1)
         {
            param1 = "square";
         }
         if(Main.instance.customNames.indexOf(param1) != -1)
         {
            param1 = "square";
         }
         var _loc4_:Item = O.getItem(param1);
         if(!_loc4_)
         {
            return;
         }
         if(!GameState.ui.menuSpawn.visible)
         {
            GameState.ui.menuSpawn.open();
         }
         var _loc5_:Tree = GameState.ui.menuLibrary.getTree("buttons");
         var _loc6_:TNode = _loc5_.findNode("label",GeneralUtils.objectToName(_loc4_.name));
         var _loc7_:int = _loc5_.showNode(_loc6_);
         if(_loc7_ != -1)
         {
            _loc5_.selectedIndex = _loc7_;
            _loc5_.scrollToSelected();
            GameState.ui.selectItem(_loc5_.selectedItem);
         }
         var _loc8_:Object = new Object();
         _loc8_.ColourBackground = 10855069;
         _loc8_.ColourTopbar = 7494966;
         _loc8_.ColourBorder = 5982763;
         _loc8_.ColourButtons = 10257247;
         _loc8_.ColourFont = 2761235;
         _loc8_.Rarity = param2;
         _loc8_.Seed = param3;
         FOOLSTYLE(_loc8_);
      }
      
      private static function FOOLSTYLE(param1:Object) : *
      {
         var rarity:int;
         var seed:Number;
         var actf:TextFormat;
         var tf:TextField;
         var tf2:TextField;
         var ac:AutoComplete;
         var rarityIcon:MovieClip;
         var j:int;
         var i:int;
         var rarityCol:uint = 0;
         var seededProps:Array = null;
         var prop:int = 0;
         var iteminfo:String = null;
         var style:Object = param1;
         GameState.ui.DisableTradingCardStyle();
         rarity = int(style.Rarity);
         seed = Number(style.Seed);
         rarityCol = uint([10066329,7320149,7710673,16763904,16616703][rarity]);
         style.ColourBorder = rarityCol;
         style.ColourButtons = rarityCol;
         style.ColourTopbar = GraphicUtils.scalehex(rarityCol,0.6);
         style.ColourBackground += GraphicUtils.scalehex(rarityCol,0.2);
         style.LineWidth = 2;
         GameState.ui.menuSpawn.title = "VIEW CARD";
         GameState.ui.menuSpawn.setStyle(style);
         GameState.ui.menuSpawn.redraw();
         actf = new TextFormat(Tweak.FONT,20,GameState.ui.menuSpawn.FONTCOLOUR,true);
         actf.align = TextFormatAlign.CENTER;
         actf.bold = true;
         tf = new TextField();
         tf.width = GameState.ui.menuSpawn.actualWidth - 8;
         tf.height = 28;
         tf.background = true;
         tf.backgroundColor = GameState.ui.menuSpawn.TOPBARCOLOUR;
         tf.setTextFormat(actf);
         tf.defaultTextFormat = actf;
         tf.text = GeneralUtils.objectToName(GameState.objects.spawnName);
         tf.name = "FOOLTEXT";
         tf.mouseEnabled = false;
         actf.color = style.ColourFont;
         actf.size = 14;
         actf.bold = false;
         GameState.ui.menuSpawn.fieldPosition = 0;
         tf2 = new TextField();
         tf2.multiline = true;
         tf2.wordWrap = true;
         tf2.width = GameState.ui.menuSpawn.actualWidth - 8;
         tf2.height = 28 + rarity * 2 + rarity * 24;
         tf.background = true;
         tf2.backgroundColor = GameState.ui.menuSpawn.BORDERCOLOUR;
         tf2.setTextFormat(actf);
         tf2.defaultTextFormat = actf;
         ac = GameState.ui.menuSpawn.getChildByName("autoComplete") as AutoComplete;
         tf.x = 4;
         tf.y = ac.y;
         tf2.x = tf.x;
         tf2.y = tf.y + 32;
         tf.filters = [new GlowFilter(rarityCol,1,2,2,4)];
         tf2.filters = [new GlowFilter(rarityCol,0.5,4,4,2)];
         GameState.ui.menuSpawn.addChild(tf);
         GameState.ui.menuSpawn.addChild(tf2);
         rarityIcon = new cardrarity();
         rarityIcon.gotoAndStop(style.Rarity + 1);
         GameState.ui.menuSpawn.addChild(rarityIcon);
         rarityIcon.name = "RARITYICON";
         rarityIcon.scaleX = rarityIcon.scaleY = 0.5;
         rarityIcon.x = GameState.ui.menuSpawn.actualWidth * 0.5;
         rarityIcon.y = GameState.ui.menuSpawn.height - rarityIcon.height * 0.5;
         rarityIcon.filters = [new DropShadowFilter(4,45,1118481,0.2,0,0)];
         if(rarity >= 3)
         {
            Main.instance.RandomiseSpawnSkin(seed);
         }
         GameState.ui.menuSpawn.getChildByName("favicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("flipicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("labicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("linkicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("infoicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("randomicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("settingicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("propertyicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("skinicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("searchicon").visible = false;
         GameState.ui.menuSpawn.getChildByName("armouricon").visible = false;
         GameState.ui.menuSpawn.getChildByName("resize").visible = false;
         GameState.ui.menuSpawn.getChildByName("itemprev").visible = false;
         GameState.ui.menuSpawn.getChildByName("itemnext").visible = false;
         ac.visible = false;
         seededProps = [];
         j = 0;
         while(j < 100)
         {
            seededProps.push(0);
            j++;
         }
         Properties.resetProperties();
         if(rarity >= 4)
         {
            Properties.forceObjEffect = 1;
         }
         Rndm.seed = seed;
         i = 0;
         while(i < rarity)
         {
            prop = int(100 * Rndm.random());
            if(prop > 81)
            {
               prop = 81;
            }
            if(seededProps[prop] == 1)
            {
               i--;
            }
            else
            {
               if(prop == 24)
               {
                  prop = 1;
               }
               seededProps[prop] = 1;
            }
            i++;
         }
         Properties.forceObjStick = seededProps[0];
         Properties.forceObjSharp = seededProps[1];
         Properties.forceObjBlunt = seededProps[2];
         Properties.forceObjExplo = seededProps[3];
         Properties.forceObjBreak = seededProps[4];
         Properties.forceObjCrumb = seededProps[5];
         Properties.forceObjBritt = seededProps[6];
         Properties.forceObjImplo = seededProps[7];
         Properties.forceObjAlive = seededProps[8];
         Properties.forceObjZGrav = seededProps[9];
         Properties.forceObjSleep = seededProps[10];
         Properties.forceObjAGrav = seededProps[11];
         Properties.forceObjFlame = seededProps[12];
         Properties.forceObjFreeze = seededProps[13];
         Properties.forceObjShock = seededProps[14];
         Properties.forceObjHeal = seededProps[15];
         Properties.forceObjDispel = seededProps[16];
         Properties.forceObjGust = seededProps[17];
         Properties.forceObjKill = seededProps[18];
         Properties.forceObjDrain = seededProps[19];
         Properties.forceObjPoison = seededProps[20];
         Properties.forceObjGhost = seededProps[21];
         Properties.forceObjStain = seededProps[22];
         Properties.forceObjInvis = seededProps[23];
         Properties.forceObjMagne = seededProps[24];
         Properties.forceObjUnBreak = seededProps[25];
         Properties.forceObjVanilla = seededProps[26];
         Properties.forceObjFlamm = seededProps[27];
         Properties.forceObjFixed = seededProps[28];
         Properties.forceObjRending = seededProps[29];
         Properties.forceObjAlchemying = seededProps[30];
         Properties.forceObjTransmuting = seededProps[31];
         Properties.forceObjCritting = seededProps[32];
         Properties.forceObjDeleting = seededProps[33];
         Properties.forceObjTriggering = seededProps[34];
         Properties.forceObjRelaying = seededProps[35];
         Properties.forceObjCleaning = seededProps[36];
         Properties.forceObjJanitoring = seededProps[37];
         Properties.forceObjHyping = seededProps[38];
         Properties.forceObjSuspending = seededProps[39];
         Properties.forceResDispel = seededProps[40];
         Properties.forceResDrain = seededProps[41];
         Properties.forceResFlame = seededProps[42];
         Properties.forceResFreeze = seededProps[43];
         Properties.forceResGust = seededProps[44];
         Properties.forceResHeal = seededProps[45];
         Properties.forceResKill = seededProps[46];
         Properties.forceResPoison = seededProps[47];
         Properties.forceResShock = seededProps[48];
         Properties.forceResConcuss = seededProps[49];
         Properties.forceObjBanning = seededProps[50];
         Properties.forceObjBlighting = seededProps[51];
         Properties.forceObjBulletproof = seededProps[52];
         Properties.forceObjCauterizing = seededProps[53];
         Properties.forceObjRegeneration = seededProps[54];
         Properties.forceObjDisintegrator = seededProps[55];
         Properties.forceObjDisintegrating = seededProps[56];
         Properties.forceObjDrying = seededProps[57];
         Properties.forceObjFrostfiring = seededProps[58];
         Properties.forceObjFrying = seededProps[59];
         Properties.forceObjWetting = seededProps[60];
         Properties.forceObjGlassing = seededProps[61];
         Properties.forceObjGlitching = seededProps[62];
         Properties.forceObjMagnetic = seededProps[63];
         Properties.forceObjOily = seededProps[64];
         Properties.forceObjPetrifying = seededProps[65];
         Properties.forceObjRadioactive = seededProps[66];
         Properties.forceObjSanguine = seededProps[67];
         Properties.forceObjScorching = seededProps[68];
         Properties.forceObjUltrasharp = seededProps[69];
         Properties.forceObjTriggerOnCut = seededProps[70];
         Properties.forceObjWarming = seededProps[71];
         Properties.forceObjWebbing = seededProps[72];
         Properties.forceObjSpreading = seededProps[73];
         Properties.forceResGhosting = seededProps[74];
         Properties.forceResProtect = seededProps[75];
         Properties.forceResAdrenaline = seededProps[76];
         Properties.forceResArc = seededProps[77];
         Properties.forceResGravity = seededProps[78];
         Properties.forceResDroning = seededProps[79];
         Properties.forceResSnare = seededProps[80];
         Properties.forceObjConcussing = seededProps[81];
         iteminfo = GameState.objects.spawnDetails;
         if(iteminfo)
         {
            rarityIcon.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
            {
               GameState.ui.genericIconHovered(iteminfo);
            });
         }
         if(rarity > 0)
         {
            GameState.objects.spawnDetails = rarityText(rarity).replace("\n\n","\n");
            tf2.text = GameState.objects.spawnDetails;
         }
         tf2.name = "FOOLTEXT2";
         tf2.mouseEnabled = false;
      }
      
      public static function seededrandom(param1:Number) : Number
      {
         param1 = (param1 * 9301 + 49297) % 233280;
         return param1 / 233280;
      }
      
      private static function rarityText(param1:int) : String
      {
         var _loc2_:String = "";
         if(param1 >= 3)
         {
            _loc2_ = "*Painted*\n";
         }
         if(param1 >= 4)
         {
            _loc2_ = _loc2_ = _loc2_ + "*Random Effect*\n";
         }
         return _loc2_ + rarityiconproperties();
      }
      
      private static function rarityiconproperties() : String
      {
         var _loc1_:Array = [];
         if(Properties.forceObjStick)
         {
            _loc1_.push("Sticky");
         }
         if(Properties.forceObjSharp)
         {
            _loc1_.push("Sharp");
         }
         if(Properties.forceObjBlunt)
         {
            _loc1_.push("Blunt");
         }
         if(Properties.forceObjExplo)
         {
            _loc1_.push("Explosive");
         }
         if(Properties.forceObjBreak)
         {
            _loc1_.push("Breakable");
         }
         if(Properties.forceObjCrumb)
         {
            _loc1_.push("Breakable");
         }
         if(Properties.forceObjBritt)
         {
            _loc1_.push("Brittle");
         }
         if(Properties.forceObjImplo)
         {
            _loc1_.push("Implosive");
         }
         if(Properties.forceObjAlive)
         {
            _loc1_.push("Alive");
         }
         if(Properties.forceObjZGrav)
         {
            _loc1_.push("Zerogravity");
         }
         if(Properties.forceObjSleep)
         {
            _loc1_.push("Sleep");
         }
         if(Properties.forceObjAGrav)
         {
            _loc1_.push("Antigravity");
         }
         if(Properties.forceObjFlame)
         {
            _loc1_.push("Burn");
         }
         if(Properties.forceObjFreeze)
         {
            _loc1_.push("Freeze");
         }
         if(Properties.forceObjShock)
         {
            _loc1_.push("Shock");
         }
         if(Properties.forceObjHeal)
         {
            _loc1_.push("Healing");
         }
         if(Properties.forceObjDispel)
         {
            _loc1_.push("Dispel");
         }
         if(Properties.forceObjGust)
         {
            _loc1_.push("Repel");
         }
         if(Properties.forceObjKill)
         {
            _loc1_.push("Killing");
         }
         if(Properties.forceObjDrain)
         {
            _loc1_.push("Draining");
         }
         if(Properties.forceObjPoison)
         {
            _loc1_.push("Poisoning");
         }
         if(Properties.forceObjGhost)
         {
            _loc1_.push("Ghost");
         }
         if(Properties.forceObjStain)
         {
            _loc1_.push("Stainless");
         }
         if(Properties.forceObjInvis)
         {
            _loc1_.push("Invisible");
         }
         if(Properties.forceObjUnBreak)
         {
            _loc1_.push("Unbreakable");
         }
         if(Properties.forceObjVanilla)
         {
            _loc1_.push("Vanilla");
         }
         if(Properties.forceObjFlamm)
         {
            _loc1_.push("Flammable");
         }
         if(Properties.forceObjFixed)
         {
            _loc1_.push("Fixed Rotation");
         }
         if(Properties.forceObjRending)
         {
            _loc1_.push("Rend");
         }
         if(Properties.forceObjAlchemying)
         {
            _loc1_.push("Transferring");
         }
         if(Properties.forceObjTransmuting)
         {
            _loc1_.push("Transmute");
         }
         if(Properties.forceObjCritting)
         {
            _loc1_.push("Critical Hit!");
         }
         if(Properties.forceObjDeleting)
         {
            _loc1_.push("Deleting");
         }
         if(Properties.forceObjTriggering)
         {
            _loc1_.push("Triggering");
         }
         if(Properties.forceObjRelaying)
         {
            _loc1_.push("Relaying");
         }
         if(Properties.forceObjCleaning)
         {
            _loc1_.push("Cleaning");
         }
         if(Properties.forceObjJanitoring)
         {
            _loc1_.push("Janitor");
         }
         if(Properties.forceObjHyping)
         {
            _loc1_.push("Hype");
         }
         if(Properties.forceObjSuspending)
         {
            _loc1_.push("Stasis");
         }
         if(Properties.forceObjBanning)
         {
            _loc1_.push("Banish");
         }
         if(Properties.forceObjBlighting)
         {
            _loc1_.push("Blight");
         }
         if(Properties.forceObjBulletproof)
         {
            _loc1_.push("Resist Bullets");
         }
         if(Properties.forceObjCauterizing)
         {
            _loc1_.push("Cauterize");
         }
         if(Properties.forceObjRegeneration)
         {
            _loc1_.push("Regeneration");
         }
         if(Properties.forceObjDisintegrator)
         {
            _loc1_.push("Powder");
         }
         if(Properties.forceObjDisintegrating)
         {
            _loc1_.push("Disintegrating");
         }
         if(Properties.forceObjDrying)
         {
            _loc1_.push("Sandstone");
         }
         if(Properties.forceObjFrostfiring)
         {
            _loc1_.push("Frostfire");
         }
         if(Properties.forceObjFrying)
         {
            _loc1_.push("Deepfry");
         }
         if(Properties.forceObjWetting)
         {
            _loc1_.push("Wet");
         }
         if(Properties.forceObjGlassing)
         {
            _loc1_.push("Glass");
         }
         if(Properties.forceObjGlitching)
         {
            _loc1_.push("Glitch");
         }
         if(Properties.forceObjPetrifying)
         {
            _loc1_.push("Petrify");
         }
         if(Properties.forceObjRadioactive)
         {
            _loc1_.push("Radioactive");
         }
         if(Properties.forceObjSanguine)
         {
            _loc1_.push("Lacerate");
         }
         if(Properties.forceObjScorching)
         {
            _loc1_.push("Scorch");
         }
         if(Properties.forceObjUltrasharp)
         {
            _loc1_.push("Ultrasharp");
         }
         if(Properties.forceObjTriggerOnCut)
         {
            _loc1_.push("Trigger On Cut");
         }
         if(Properties.forceObjWarming)
         {
            _loc1_.push("Warming");
         }
         if(Properties.forceResDispel)
         {
            _loc1_.push("Resist Dispel");
         }
         if(Properties.forceResDrain)
         {
            _loc1_.push("Resist Drain");
         }
         if(Properties.forceResFlame)
         {
            _loc1_.push("Resist Burning");
         }
         if(Properties.forceResFreeze)
         {
            _loc1_.push("Resist Freezing");
         }
         if(Properties.forceResGust)
         {
            _loc1_.push("Resist Gust");
         }
         if(Properties.forceResHeal)
         {
            _loc1_.push("Resist Heal");
         }
         if(Properties.forceResKill)
         {
            _loc1_.push("Resist Kill");
         }
         if(Properties.forceResPoison)
         {
            _loc1_.push("Resist Poison");
         }
         if(Properties.forceResShock)
         {
            _loc1_.push("Resist Shock");
         }
         if(Properties.forceResConcuss)
         {
            _loc1_.push("Resist Concuss");
         }
         if(Properties.forceResGhosting)
         {
            _loc1_.push("Resist Ghosting");
         }
         if(Properties.forceResProtect)
         {
            _loc1_.push("Resist Protect");
         }
         if(Properties.forceResAdrenaline)
         {
            _loc1_.push("Resist Adrenaline");
         }
         if(Properties.forceResArc)
         {
            _loc1_.push("Resist Arc");
         }
         if(Properties.forceResGravity)
         {
            _loc1_.push("Resist Gravity");
         }
         if(Properties.forceResDroning)
         {
            _loc1_.push("Resist Droning");
         }
         if(Properties.forceResSnare)
         {
            _loc1_.push("Resist Snare");
         }
         if(Properties.forceObjConcussing)
         {
            _loc1_.push("Concuss");
         }
         return _loc1_.join("\n");
      }
      
      private function rarityiconhovered(param1:int) : void
      {
         GameState.ui.showTooltip(GameState.ui.menuSpawn,rarityText(param1),0,-1,GameState.ui.menuSpawn.actualWidth);
      }
   }
}

