package com.anegmetex.Soundmanager
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.*;
   import flash.events.Event;
   import flash.geom.*;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.*;
   
   public dynamic class sounds
   {
      
      internal static var chn:Vector.<SoundCheck>;
      
      internal static var snd:Object;
      
      internal static var stageRadius:Number;
      
      public static var soundNames:Array;
      
      private static var p:Point;
      
      public static var vol:Number = 0.2;
      
      public static var enabled:Boolean = true;
      
      public static var cenX:Number = 0;
      
      public static var cenY:Number = 0;
      
      private static var v:ageVector = new ageVector();
      
      public static var UISound:Boolean = true;
      
      public function sounds()
      {
         super();
      }
      
      public static function init(param1:Number, param2:Number) : *
      {
         snd = new Object();
         chn = new Vector.<SoundCheck>();
         soundNames = [];
         addSound("whaawhaa",R.s_whaawhaa);
         addSound("bfg",R.s_bfg);
         addSound("chainsaw_idle",R.s_chainsawidle);
         addSound("chainsaw_cut",R.s_chainsawcut);
         addSound("thumper_explosion",R.s_explosion);
         addSound("thumper_shoot",R.s_m79);
         addSound("pistol_shoot",R.s_pistol);
         addSound("magnum_shoot",R.s_magnum);
         addSound("revolver_shoot",R.s_revolver);
         addSound("flintlock_shoot",R.s_flintlock);
         addSound("shotgun_shoot",R.s_shotgun);
         addSound("blaster_shoot",R.s_blaster);
         addSound("assault_shoot",R.s_assault);
         addSound("assault2_shoot",R.s_assault2);
         addSound("assault3_shoot",R.s_assault3);
         addSound("bark",R.s_bark);
         addSound("big_shoot",R.s_biggun);
         addSound("bigger_shoot",R.s_biggun2);
         addSound("robot_shoot",R.s_robotgun);
         addSound("robot2_shoot",R.s_robotgun2);
         addSound("ggg_sub",R.s_ggg_sub);
         addSound("ggg_spitbiggest",R.s_ggg_spitbiggest);
         addSound("ggg_subbigger",R.s_ggg_subbigger);
         addSound("ggg_spitbigger",R.s_ggg_spitbigger);
         addSound("ggg_spit",R.s_ggg_spit);
         addSound("ggg_sniperbigger",R.s_ggg_sniperbigger);
         addSound("ggg_sniper",R.s_ggg_sniper);
         addSound("ggg_shotgunsmall",R.s_ggg_shotgunsmall);
         addSound("ggg_shotgun",R.s_ggg_shotgun);
         addSound("ggg_handgun2",R.s_ggg_handgun2);
         addSound("ggg_handgun",R.s_ggg_handgun);
         addSound("ggg_assault",R.s_ggg_assault);
         addSound("sniper_shoot",R.s_sniper);
         addSound("rifle_shoot",R.s_rifle);
         addSound("flamer_shoot",R.s_flamer);
         addSound("minigun_shoot",R.s_minigun);
         addSound("lmg_shoot",R.s_lmg);
         addSound("lmg2_shoot",R.s_lmg2);
         addSound("harpoon_shoot",R.s_harpoon);
         addSound("nailgun_shoot",R.s_harpoon);
         addSound("hivecannon_shoot",R.s_hivecannon);
         addSound("tesla_shoot",R.s_tesla);
         addSound("firespread_shoot",R.s_firespread);
         addSound("pulse_shoot",R.s_pulse);
         addSound("disc_shoot",R.s_disc);
         addSound("backlash_shoot",R.s_ui_hover);
         addSound("basscannon_shoot",R.s_basscannon);
         addSound("smg_shoot",R.s_smg);
         addSound("sub_shoot",R.s_sub);
         addSound("tommy_shoot",R.s_tommy);
         addSound("bizon_shoot",R.s_bizon);
         addSound("tac_shoot",R.s_tac);
         addSound("carbine_shoot",R.s_carbine);
         addSound("cannon",R.s_cannon);
         addSound("cannon2",R.s_cannon2);
         addSound("bubbles",R.s_bubbles);
         addSound("mac_shoot",R.s_mac);
         addSound("whump",R.s_whump);
         addSound("launch",R.s_launch);
         addSound("nerf",R.s_nerf);
         addSound("ricochet1",R.s_ricochet1);
         addSound("ricochet2",R.s_ricochet2);
         addSound("ricochet3",R.s_ricochet3);
         addSound("burn1",R.s_burn1);
         addSound("burn2",R.s_burn2);
         addSound("burn3",R.s_burn3);
         addSound("burn4",R.s_burn4);
         addSound("throw1",R.s_throw1);
         addSound("throw2",R.s_throw2);
         addSound("throw3",R.s_throw3);
         addSound("throw4",R.s_throw4);
         addSound("throw5",R.s_throw5);
         addSound("breakneck",R.s_detach_head);
         addSound("breaklimb1",R.s_detach1);
         addSound("breaklimb2",R.s_detach2);
         addSound("touch1",R.s_touch1);
         addSound("touch2",R.s_touch2);
         addSound("touch3",R.s_touch3);
         addSound("touch4",R.s_touch4);
         addSound("touch5",R.s_touch5);
         addSound("hit2",R.s_hit2);
         addSound("hit3",R.s_hit3);
         addSound("hit4",R.s_hit4);
         addSound("hit5",R.s_hit5);
         addSound("hit6",R.s_hit6);
         addSound("hit7",R.s_hit7);
         addSound("hit8",R.s_hit8);
         addSound("hit9",R.s_hit9);
         addSound("hit10",R.s_hit10);
         addSound("hit11",R.s_hit11);
         addSound("hit12",R.s_hit12);
         addSound("hit26",R.s_hit26);
         addSound("hit27",R.s_hit27);
         addSound("hit28",R.s_hit28);
         addSound("hit29",R.s_hit29);
         addSound("hitfrozen",R.s_hitfrozen);
         addSound("bat1",R.s_bat1);
         addSound("bat2",R.s_bat2);
         addSound("bat3",R.s_bat3);
         addSound("bulletwall1",R.s_bulletwall1);
         addSound("bulletwall2",R.s_bulletwall2);
         addSound("bulletwall3",R.s_bulletwall3);
         addSound("stab1",R.s_stab1);
         addSound("stab2",R.s_stab2);
         addSound("stab3",R.s_stab3);
         addSound("stab4",R.s_stab4);
         addSound("stab5",R.s_stab5);
         addSound("cut1",R.s_cut1);
         addSound("cut2",R.s_cut2);
         addSound("cut3",R.s_cut3);
         addSound("cut4",R.s_cut4);
         addSound("cut5",R.s_cut5);
         addSound("cut6",R.s_cut6);
         addSound("cut7",R.s_cut7);
         addSound("ui_hover",R.s_ui_hover);
         addSound("explosion5",R.s_explosion5);
         addSound("explosion4",R.s_explosion4);
         addSound("explosion3",R.s_explosion3);
         addSound("explosion2",R.s_explosion2);
         addSound("explosion",R.s_explosion);
         addSound("thunder",R.s_thunder);
         addSound("burn",R.s_burn);
         addSound("incendiary",R.s_incendiary);
         addSound("cryo",R.s_cryo);
         addSound("arcgrenade",R.s_explosionfuture);
         addSound("acidburn",R.s_acid);
         addSound("swish",R.s_swish);
         addSound("honk",R.s_honk);
         addSound("horn",R.s_horn);
         addSound("splash",R.s_splash);
         addSound("crash",R.s_crash);
         addSound("jingle",R.s_jingle);
         addSound("ching",R.s_ching);
         addSound("doorbell",R.s_doorbell);
         addSound("guitar1",R.s_guitar1);
         addSound("guitar2",R.s_guitar2);
         addSound("guitar3",R.s_guitar3);
         addSound("guitar4",R.s_guitar4);
         addSound("guitar5",R.s_guitar5);
         addSound("guitar6",R.s_guitar6);
         addSound("dispel",R.s_dispel);
         addSound("drain1",R.s_drain1);
         addSound("drain2",R.s_drain2);
         addSound("drain3",R.s_drain3);
         addSound("drain4",R.s_drain4);
         addSound("petrify",R.s_petrify);
         addSound("hiss",R.s_hiss);
         addSound("tinyhiss",R.s_hiss2);
         addSound("shock",R.s_shock);
         addSound("tinyshock",R.s_shock2);
         addSound("growth",R.s_growth);
         addSound("tinygrowth",R.s_growth2);
         addSound("flies",R.s_flies);
         addSound("tinyflies",R.s_flies2);
         addSound("trombone",R.s_trombone);
         addSound("maraca1",R.s_maraca1);
         addSound("maraca2",R.s_maraca2);
         addSound("maraca3",R.s_maraca3);
         addSound("rustle",R.s_rustle);
         addSound("violin",R.s_violin);
         addSound("elevatormusic",R.s_music);
         addSound("halloweenmusic",R.s_halloweenmusic);
         stageRadius = param1 * 4;
         cenX = param1 * 0.5;
         cenY = param2 * 0.5;
      }
      
      internal static function addSound(param1:String, param2:Sound) : *
      {
         snd[param1] = param2;
         soundNames.push(param1);
      }
      
      public static function play(param1:String, param2:b2Body = null, param3:b2Vec2 = null, param4:Number = 1, param5:Boolean = true, param6:int = 0) : void
      {
         var _loc7_:SoundTransform = null;
         var _loc10_:userData = null;
         var _loc11_:SoundCheck = null;
         if(chn.length > 10)
         {
            return;
         }
         if(!UISound && param1 == "ui_hover")
         {
            return;
         }
         if(param2)
         {
            _loc10_ = userData(param2.GetUserData());
            if(_loc10_.mute)
            {
               param2 = null;
               return;
            }
            if(_loc10_.overrideSound)
            {
               param1 = _loc10_.overrideSound;
            }
            if(_loc10_.overrideVolume)
            {
               param4 = _loc10_.overrideVolume;
            }
         }
         if(param1 == "random")
         {
            param1 = soundNames[int(soundNames.length * Math.random())];
            if(param1 == "violin" || param1 == "elevatormusic")
            {
               param1 = "whaawhaa";
            }
         }
         if(!param5)
         {
            for each(_loc11_ in chn)
            {
               if(_loc11_.name == param1)
               {
                  return;
               }
            }
         }
         if(!enabled || vol < 0.001)
         {
            return;
         }
         _loc7_ = new SoundTransform();
         if(!param3)
         {
            param3 = new b2Vec2(cenX,cenY);
         }
         v.x = GraphicUtils.camX(param3.x - cenX);
         v.y = GraphicUtils.camY(param3.y - cenY);
         if(GameState.environment)
         {
            v.x += Main.instance.m_sprite.x;
            v.y += Main.instance.m_sprite.y;
         }
         _loc7_.volume = ageMath.trimToRange(param4 * vol * ageMath.RemapVal(v.len(),0,param4 * stageRadius,1,0),0,1);
         var _loc8_:SoundChannel = Sound(snd[param1]).play(0,param6,_loc7_);
         chn.push(new SoundCheck(param1,_loc8_));
         var _loc9_:SoundCheck = SoundCheck(chn[chn.length - 1]);
         if((Boolean(_loc9_)) && Boolean(_loc9_.channel))
         {
            _loc9_.channel.addEventListener(Event.SOUND_COMPLETE,soundcomplete);
         }
      }
      
      public static function stop(param1:*) : *
      {
         var _loc2_:SoundCheck = null;
         for each(_loc2_ in chn)
         {
            if(param1 == _loc2_.name)
            {
               _loc2_.channel.stop();
               chn.splice(chn.indexOf(_loc2_),1);
            }
         }
      }
      
      public static function isPlaying(param1:String) : Boolean
      {
         var _loc2_:SoundCheck = null;
         for each(_loc2_ in chn)
         {
            if(param1 == _loc2_.name)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function soundcomplete(param1:Event) : void
      {
         var _loc2_:SoundCheck = null;
         for each(_loc2_ in chn)
         {
            if(param1.currentTarget == _loc2_.channel)
            {
               chn.splice(chn.indexOf(_loc2_),1);
            }
         }
      }
      
      public static function random(param1:Array, param2:b2Body, param3:b2Vec2, param4:Number = 1, param5:Boolean = true) : void
      {
         play(param1[Math.floor(Math.random() * param1.length)],param2,param3,param4,param5);
      }
      
      public static function randomWithVolume(param1:Array, param2:b2Body, param3:b2Vec2, param4:Array, param5:Boolean = true) : void
      {
         var _loc6_:int = Math.floor(Math.random() * param1.length);
         play(param1[_loc6_],param2,param3,param4[_loc6_],param5);
      }
   }
}

