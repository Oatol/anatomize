package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.BloodDrop;
   
   public class PS
   {
      
      public var systems:Vector.<ParticleSystem>;
      
      public var simpleParticleSystem:ParticleSystemSimple;
      
      public var names:Array;
      
      public function PS()
      {
         super();
      }
      
      public function addParticles(param1:Number, param2:Number, param3:Number, param4:String, param5:* = 0, param6:* = 0, param7:Number = 1, param8:Number = 1, param9:Boolean = false) : Vector.<MyLittleParticle>
      {
         var _loc10_:Vector.<MyLittleParticle> = null;
         var _loc15_:ParticleSystem = null;
         var _loc16_:userData = null;
         var _loc17_:b2Body = null;
         var _loc18_:userData = null;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:b2Vec2 = null;
         var _loc22_:MyLittleParticle = null;
         var _loc23_:String = null;
         if(param4 == "none")
         {
            return null;
         }
         _loc10_ = new Vector.<MyLittleParticle>();
         if(Vars.particles == 0)
         {
            return null;
         }
         if(World.toggleGore == 0 && param4 == "blood")
         {
            return null;
         }
         var _loc11_:Array = GameState.particles.names;
         if(param4 == "random")
         {
            param4 = _loc11_[int(_loc11_.length * Math.random())];
         }
         var _loc12_:* = _loc11_.indexOf(param4);
         if(_loc12_ == -1)
         {
            return null;
         }
         var _loc13_:Number = Vars.particles;
         if(World.toggleSmoothBlood == 1 && param4 == "blood")
         {
            _loc13_ *= 0.5;
         }
         param3 >>= 0;
         if(param3 < 1)
         {
            param3 = 1;
         }
         param3 *= _loc13_;
         if(param3 < 1)
         {
            if(Math.random() >= _loc13_)
            {
               return null;
            }
            param3 = 1;
         }
         if(param3 > 50)
         {
            param3 = 50;
         }
         _loc10_ = new Vector.<MyLittleParticle>();
         var _loc14_:int = 0;
         while(_loc14_ < param3)
         {
            if(Vars.particles > 1)
            {
               if(param7 == 0)
               {
                  param7 = 1;
               }
               if(param8 == 0)
               {
                  param8 = 1;
               }
               param1 += Math.random() * 2 - 1;
               param2 += Math.random() * 2 - 1;
            }
            if(param4 == "blood" && World.togglePhysicsBlood == 1 && Math.random() > 0.5)
            {
               _loc16_ = Properties.objectProperties("blooddrop");
               _loc17_ = Spawn.circle(param1 + param5 * 4,param2 + param6 * 4,0.1,_loc16_,[0.001,1,0.01]);
               _loc18_ = userData(_loc17_.GetUserData());
               _loc18_.trigger = new BloodDrop();
               _loc18_.triggerDuration = 0;
               _loc18_.triggered = true;
               _loc18_.triggerLock = true;
               _loc19_ = Math.round(Math.random() * param7 - param7 * 0.5);
               _loc20_ = Math.round(Math.random() * param8 - param8 * 0.5);
               _loc21_ = new b2Vec2(_loc19_ + param5,_loc20_ + param6);
               _loc21_.Multiply(3);
               _loc17_.SetLinearVelocity(_loc21_);
               return null;
            }
            _loc15_ = GameState.particles.systems[_loc12_];
            _loc10_.push(_loc15_.addParticles(1,param1,param2,param5,param6,param7,param8)[0]);
            _loc14_++;
         }
         if(param4 == "blood")
         {
            for each(_loc22_ in _loc10_)
            {
               _loc22_.colour = Tweak.bloodColour;
               _loc23_ = "blood_" + _loc22_.colour;
               if(!R.getSprite(_loc23_))
               {
                  R.setSprite("smooth_" + _loc23_,Main.instance.updateSmoothBloodBMD(_loc22_.colour).clone());
                  R.setSprite(_loc23_,Main.instance.updateBloodBMD(_loc22_.colour).clone());
               }
               if(World.toggleSmoothBlood)
               {
                  _loc22_.sprite = "smooth_" + _loc23_;
               }
               else
               {
                  _loc22_.sprite = _loc23_;
               }
            }
         }
         return _loc10_;
      }
      
      public function addSimpleParticles(param1:Number, param2:Number, param3:int, param4:uint, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0) : *
      {
         var _loc9_:Number = Vars.particles;
         if(param3 == 1)
         {
            if(Math.random() > _loc9_ * TimeLord.speed)
            {
               return;
            }
         }
         else
         {
            param3 *= _loc9_;
         }
         if(param3 > 100)
         {
            param3 = 100;
         }
         GameState.particles.simpleParticleSystem.addParticles(param3,param1,param2,param4,param5,param6,param7,param8);
      }
      
      public function get blood() : ParticleSystem
      {
         return this.systems[0];
      }
      
      private function InitSystem(param1:String, param2:String) : void
      {
         var _loc3_:ParticleSystem = null;
         _loc3_ = new ParticleSystem(param1,GameState.width,GameState.height,R.getSprite(param2));
         this.names.push(param1);
         this.systems.push(_loc3_);
      }
      
      public function init() : *
      {
         this.names = new Array();
         this.systems = new Vector.<ParticleSystem>();
         this.simpleParticleSystem = new ParticleSystemSimple("simple",GameState.width,GameState.height);
         this.InitSystem("blood","p_blood");
         this.InitSystem("explosive","p_explosive");
         this.InitSystem("portal1","p_portal1");
         this.InitSystem("portal2","p_portal2");
         this.InitSystem("gas","p_gas");
         this.InitSystem("smoke","p_smoke");
         this.InitSystem("fire2","p_firered");
         this.InitSystem("fire3","p_fireyellow");
         this.InitSystem("poof","p_smoke");
         this.InitSystem("forcefield","p_forcefield");
         this.InitSystem("sparkle","p_sand");
         this.InitSystem("crystal","p_crystal");
         this.InitSystem("bees","p_bees");
         this.InitSystem("heal","p_heal");
         this.InitSystem("air","p_air");
         this.InitSystem("shock","p_shock");
         this.InitSystem("shock2","p_shock2");
         this.InitSystem("trailblazer","p_trailblazer");
         this.InitSystem("water","p_water");
         this.InitSystem("void","p_void");
         this.InitSystem("dark","p_dark");
         this.InitSystem("light","p_light");
         this.InitSystem("bubbles","p_bubble");
         this.InitSystem("decoration","p_sparkly");
         this.InitSystem("gravity","p_gravity");
         this.InitSystem("poison","p_poison");
         this.InitSystem("slice","p_clear");
         this.InitSystem("snare","p_snare");
         this.InitSystem("gasoline","p_gasoline");
         this.InitSystem("laser","p_clear");
         this.InitSystem("sleep","p_sleep");
         this.InitSystem("bigSmoke","p_smokeBig");
         this.InitSystem("acid","p_acid");
         this.InitSystem("hail","p_hail");
         this.InitSystem("petrify","p_petrify");
         this.InitSystem("ring","p_ring");
         this.InitSystem("glowgreen","p_glowgreen");
         this.InitSystem("yinyang","p_yinyang");
         this.InitSystem("arrow","p_arrow");
         this.InitSystem("speech","p_speech");
         this.InitSystem("smiley","p_smiley");
         this.InitSystem("blink","p_blink");
         this.InitSystem("reds","p_reds");
         this.InitSystem("balls","p_balls");
         this.InitSystem("darkskull","p_darkskull");
         this.InitSystem("candy","p_candy");
         this.InitSystem("cloudy","p_cloudy");
         this.InitSystem("supershiny","p_supershiny");
         this.InitSystem("cursor","p_cursor");
         this.InitSystem("lock","p_lock");
         this.InitSystem("shard","p_shard");
         this.InitSystem("petal","p_petal");
         this.InitSystem("spiky","p_spiky");
         this.InitSystem("rocket","p_rocket");
         this.InitSystem("heart","p_heart");
         this.InitSystem("tinyskull","p_tinyskull");
         this.InitSystem("star","p_star");
         this.InitSystem("vines","p_vines");
         this.InitSystem("icechunk","p_icechunk");
         this.InitSystem("growth","p_growth");
         this.InitSystem("leaflet","p_leaflet");
         this.InitSystem("bushy","p_bushy");
         this.InitSystem("bush","p_bush");
         this.InitSystem("blinkred","p_blinkred");
         this.InitSystem("snake","p_snake");
         this.InitSystem("cog","p_cog");
         this.InitSystem("pine","p_pine");
         this.InitSystem("moss","p_moss");
         this.InitSystem("boulder","p_boulder");
         this.InitSystem("tinyshroom","p_tinyshroom");
         this.InitSystem("fruit","p_fruit");
         this.InitSystem("scroll","p_scroll");
         this.InitSystem("spike","p_spike");
         this.InitSystem("shell","p_shell");
         this.InitSystem("coiny","p_coiny");
         this.InitSystem("rocky","p_rocky");
         this.InitSystem("key","p_key");
         this.InitSystem("lab","p_lab");
         this.InitSystem("kong","p_kong");
         this.InitSystem("chess","p_chess");
         this.InitSystem("drone","p_drone");
         this.InitSystem("helmet","p_helmet");
         this.InitSystem("moon","p_moon");
         this.InitSystem("error","p_error");
         this.InitSystem("note","p_note");
         this.InitSystem("clubs","p_clubs");
         this.InitSystem("diamonds","p_diamonds");
         this.InitSystem("spades","p_spades");
         this.InitSystem("hearts","p_hearts");
         this.InitSystem("arrow2","p_arrow2");
         this.InitSystem("radioactive","p_radioactive");
         this.InitSystem("chaos","p_chaos");
         this.InitSystem("pierce","p_pierce");
         this.InitSystem("ammo","p_ammo");
         this.InitSystem("verydark","p_verydark");
         this.InitSystem("money","p_money");
         this.InitSystem("hype","p_hype");
         this.InitSystem("iceshard","p_iceshard");
         this.InitSystem("caustic","p_caustic");
         this.InitSystem("sprinkle","p_sprinkle");
         this.InitSystem("claw","p_claw");
         this.InitSystem("stump","p_stump");
         this.InitSystem("box","p_box");
         this.InitSystem("steak","p_steak");
         this.InitSystem("grass","p_grass");
         this.InitSystem("duck","p_duck");
         this.InitSystem("bunny","p_bunny");
         this.InitSystem("rod","p_rod");
         this.InitSystem("iceorb","p_iceorb");
         this.InitSystem("darkorb","p_darkorb");
         this.InitSystem("chip","p_chip");
         this.InitSystem("iceburn","p_iceburn");
         this.InitSystem("cloud","p_cloud");
         this.InitSystem("fan","p_fan");
         this.InitSystem("grid","p_grid");
         this.InitSystem("lightning","p_lightning");
         this.InitSystem("rope","p_rope");
         this.InitSystem("warning","p_warning");
         this.InitSystem("slime","p_slime");
         this.InitSystem("bat","p_bat");
         this.InitSystem("ghost","p_ghost");
         this.InitSystem("wizardhat","p_wizardhat");
         this.InitSystem("balloon","p_balloon");
         this.InitSystem("spider","p_spider");
         this.InitSystem("stoneskull","p_stoneskull");
         this.InitSystem("burnado","p_burnado");
         this.InitSystem("rift","p_rift");
         this.InitSystem("football","p_football");
         this.InitSystem("metalring","p_metalring");
         this.InitSystem("icebubble","p_icebubble");
         this.InitSystem("carving","p_carving");
         this.InitSystem("mine","p_mine");
         this.InitSystem("shuriken","p_shuriken");
         this.InitSystem("sword","p_sword");
         this.InitSystem("cube","p_cube");
         this.InitSystem("waves","p_waves");
         this.InitSystem("eye","p_eye");
         this.InitSystem("goop","p_goop");
         this.InitSystem("spatter","p_spatter");
         this.InitSystem("praise","p_praise");
         this.InitSystem("snow","p_gas");
         this.InitSystem("bullet","p_bullet");
         this.InitSystem("frostfire","p_frostfire");
         this.InitSystem("darkness","p_darkness");
         this.InitSystem("shinysliver","p_shinysliver");
         this.InitSystem("thundercloud","p_thundercloud");
         this.InitSystem("fried","p_fried");
         this.InitSystem("flare","p_flare");
         this.InitSystem("dust","p_dust");
         this.InitSystem("lava","p_lava");
         this.InitSystem("snowBig","p_snowBig");
         this.InitSystem("chain","p_chain");
         this.InitSystem("cookie","p_cookie");
         this.InitSystem("tinysprinkle","p_tinysprinkle");
         this.InitSystem("tinydust","p_tinydust");
         this.InitSystem("ash","p_smoke");
         this.InitSystem("score","p_haha");
         this.InitSystem("paper","p_paper");
         this.InitSystem("shinygreen","p_shinygreen");
         this.InitSystem("bone","p_bone");
         this.InitSystem("skull","p_skull");
         this.InitSystem("flares","p_flares");
         this.InitSystem("book","p_book");
         this.InitSystem("parchment","p_parchment");
         this.InitSystem("dusty","p_poof");
         this.InitSystem("vine","p_vine");
         this.InitSystem("goo","p_goo");
         this.InitSystem("ribs","p_ribs");
         this.InitSystem("hcandy","p_hcandy");
         this.InitSystem("ignite","p_ignite");
         this.InitSystem("pinkbolt","p_pinkbolt");
         this.InitSystem("pinkflame","p_pinkflame");
         this.InitSystem("pumpkin","p_pumpkin");
         this.InitSystem("carvedpumpkin","p_carvedpumpkin");
         this.InitSystem("candycane","p_candycane");
         this.InitSystem("poisongas","p_poisongas");
         this.InitSystem("fog","p_fog");
         this.InitSystem("lemon","p_tinylemon");
         this.InitSystem("delete","p_delete");
         this.InitSystem("mist","p_mist");
         var _loc1_:int = 35;
         while(_loc1_ < 159)
         {
            this.doTheDefaultThing(this.systems[_loc1_]);
            _loc1_++;
         }
         this.systems[161].useWorldGravity = false;
         this.systems[161].particleGravity = -0.1;
         this.systems[161].particleFade = 1;
         this.systems[161].particleFadeRandom = 10;
         this.systems[161].particleHealth = 1000;
         this.systems[161].particleRestitution = 0;
         this.systems[161].particleFriction = 0.7;
         this.systems[161].particleWander = 1;
         this.systems[175].useWorldGravity = false;
         this.systems[175].particleGravity = -0.1;
         this.systems[175].particleFade = 1;
         this.systems[175].particleFadeRandom = 10;
         this.systems[175].particleHealth = 1000;
         this.systems[175].particleRestitution = 0;
         this.systems[175].particleFriction = 0.7;
         this.systems[175].particleWander = 1;
         this.systems[176].useWorldGravity = false;
         this.systems[176].particleGravity = -0.1;
         this.systems[176].particleFade = 1;
         this.systems[176].particleFadeRandom = 10;
         this.systems[176].particleHealth = 2000;
         this.systems[176].particleRestitution = 0;
         this.systems[176].particleFriction = 0.9;
         this.systems[176].particleWander = 2;
         this.systems[179].useWorldGravity = false;
         this.systems[179].particleGravity = -0.01;
         this.systems[179].particleFade = 1;
         this.systems[179].particleFadeRandom = 10;
         this.systems[179].particleHealth = 1000;
         this.systems[179].particleRestitution = 0;
         this.systems[179].particleFriction = 0.9;
         this.systems[179].particleWander = 1;
         this.systems[174].useWorldGravity = false;
         this.systems[174].particleGravity = -0.1;
         this.systems[174].particleFade = 1;
         this.systems[174].particleFadeRandom = 10;
         this.systems[174].particleHealth = 1000;
         this.systems[174].particleRestitution = 0;
         this.systems[174].particleFriction = 0.7;
         this.systems[174].particleWander = 1;
         this.systems[169].useWorldGravity = false;
         this.systems[169].particleGravity = -0.1;
         this.systems[169].particleFade = 1;
         this.systems[169].particleFadeRandom = 10;
         this.systems[169].particleHealth = 1000;
         this.systems[169].particleRestitution = 0;
         this.systems[169].particleFriction = 0.5;
         this.systems[169].particleWander = 1;
         this.systems[165].useWorldGravity = false;
         this.systems[165].particleGravity = 0.5;
         this.systems[165].particleFade = 1;
         this.systems[165].particleFadeRandom = 10;
         this.systems[165].particleHealth = 1000;
         this.systems[165].particleRestitution = 0;
         this.systems[165].particleFriction = 0.5;
         this.systems[165].particleWander = 1;
         this.systems[164].useWorldGravity = false;
         this.systems[164].particleGravity = 0.1;
         this.systems[164].particleFade = 1;
         this.systems[164].particleFadeRandom = 10;
         this.systems[164].particleHealth = 1000;
         this.systems[164].particleRestitution = 0;
         this.systems[164].particleFriction = 0.9;
         this.systems[164].particleWander = 1;
         this.systems[163].particleWander = 0.5;
         this.systems[163].particleGravity = 0.1;
         this.systems[163].useWorldGravity = false;
         this.systems[169].useWorldGravity = false;
         this.systems[166].particleRestitution = 0.5;
         this.systems[166].particleWander = 0.1;
         this.systems[168].particleRestitution = 0.3;
         this.systems[160].particleRestitution = 0.5;
         this.systems[159].particleRestitution = 0.5;
         this.systems[167].particleRestitution = 0.5;
         this.systems[170].useWorldGravity = false;
         this.systems[170].particleGravity = 0.25;
         this.systems[170].particleFade = 1;
         this.systems[170].particleFadeRandom = 10;
         this.systems[170].particleHealth = 1000;
         this.systems[170].particleRestitution = 0;
         this.systems[170].particleFriction = 0.5;
         this.systems[170].particleWander = 10;
         this.systems[171].useWorldGravity = false;
         this.systems[171].particleGravity = 0.25;
         this.systems[171].particleFade = 1;
         this.systems[171].particleFadeRandom = 10;
         this.systems[171].particleHealth = 1000;
         this.systems[171].particleRestitution = 0;
         this.systems[171].particleFriction = 0.9;
         this.systems[171].particleWander = 1;
         this.systems[155].useWorldGravity = false;
         this.systems[155].particleGravity = 0.5;
         this.systems[155].particleFade = 1;
         this.systems[155].particleFadeRandom = 10;
         this.systems[155].particleHealth = 1000;
         this.systems[155].particleRestitution = 0;
         this.systems[155].particleFriction = 0.9;
         this.systems[155].particleWander = 1;
         this.systems[156].useWorldGravity = false;
         this.systems[156].particleGravity = -0.4;
         this.systems[156].particleFade = 1;
         this.systems[156].particleFadeRandom = 1;
         this.systems[156].particleHealth = 50;
         this.systems[156].particleRestitution = 0;
         this.systems[156].particleFriction = 0.9;
         this.systems[156].particleWander = 1;
         this.systems[151].particleWander = 0.4;
         this.systems[151].useWorldGravity = false;
         this.systems[151].particleGravity = -0.1;
         this.systems[151].particleRestitution = 0.1;
         this.systems[151].particleHealth = 1000;
         this.systems[151].particleFadeRandom = 50;
         this.systems[151].particleFriction = 0.96;
         this.systems[149].particleWander = 0.4;
         this.systems[149].useWorldGravity = true;
         this.systems[149].particleRestitution = 0.1;
         this.systems[149].particleHealth = 1000;
         this.systems[149].particleFadeRandom = 50;
         this.systems[149].particleFriction = 0.96;
         this.systems[148].particleWander = 1;
         this.systems[148].useWorldGravity = true;
         this.systems[148].particleRestitution = -1;
         this.systems[148].particleHealth = 1000;
         this.systems[148].particleFadeRandom = 50;
         this.systems[148].particleFriction = 0.99;
         this.systems[90].particleWander = 0.01;
         this.systems[90].useWorldGravity = false;
         this.systems[90].particleRestitution = -1;
         this.systems[90].particleHealth = 1000;
         this.systems[90].particleFadeRandom = 50;
         this.systems[83].particleWander = 0.01;
         this.systems[83].useWorldGravity = false;
         this.systems[83].particleRestitution = -1;
         this.systems[83].particleHealth = 1000;
         this.systems[83].particleFadeRandom = 50;
         this.systems[178].particleWander = 0.01;
         this.systems[178].useWorldGravity = false;
         this.systems[178].particleRestitution = -1;
         this.systems[178].particleHealth = 1000;
         this.systems[178].particleFadeRandom = 50;
         this.systems[80].particleWander = 0.1;
         this.systems[80].useWorldGravity = false;
         this.systems[80].particleRestitution = -1;
         this.systems[80].particleHealth = 1000;
         this.systems[80].particleFadeRandom = 50;
         this.systems[53].particleFriction = 1.1;
         this.systems[53].particleWander = 0.1;
         this.systems[53].useWorldGravity = false;
         this.systems[53].particleRestitution = -1;
         this.systems[53].particleHealth = 1000;
         this.systems[53].particleFadeRandom = 100;
         this.systems[37].useWorldGravity = false;
         this.systems[37].particleHealth = 1000;
         this.systems[37].particleFadeRandom = 200;
         this.systems[37].particleWander = 0.1;
         this.systems[48].useWorldGravity = false;
         this.systems[48].particleHealth = 1000;
         this.systems[48].particleFadeRandom = 500;
         this.systems[48].particleWander = 1;
         this.systems[48].particleFriction = 0.99;
         this.systems[41].particleRestitution = -1;
         this.systems[41].particleFriction = 0.8;
         this.systems[41].particleWander = 4;
         this.systems[41].particleHealth = 100;
         this.systems[41].particleGravity = 2;
         this.systems[56].particleRestitution = 0.6;
         this.systems[56].particleHealth = 200;
         this.systems[56].particleGravity = -0.2;
         this.systems[56].particleWander = 0.2;
         this.systems[63].particleWander = 2.2;
         this.systems[63].particleFriction = 0.8;
         this.systems[47].particleWander = 2.2;
         this.systems[47].particleFriction = 0.8;
         this.systems[158].particleWander = 1.6;
         this.systems[158].particleFriction = 0.6;
         this.systems[158].particleFadeRandom = 10;
         this.systems[158].particleHealth = 500;
         this.systems[39].particleWander = 0.2;
         this.systems[39].particleGravity = -0.2;
         this.systems[51].particleWander = 0.2;
         this.systems[46].particleWander = 0.1;
         this.systems[46].particleGravity = -0.1;
         this.systems[51].particleGravity = 0.06;
         this.systems[60].particleGravity = -0.06;
         this.systems[54].particleWander = 0.2;
         this.systems[105].particleWander = 0.2;
         this.systems[105].particleFadeRandom = 50;
         this.systems[105].particleHealth = 500;
         this.systems[95].particleFadeRandom = 20;
         this.systems[95].particleHealth = 400;
         this.systems[95].particleGravity = 0.1;
         this.systems[95].particleFriction = 0.9;
         this.systems[95].particleWander = 1;
         this.systems[42].particleRestitution = 0.2;
         this.systems[43].particleRestitution = 0.2;
         this.systems[44].particleRestitution = 0.2;
         this.systems[45].particleRestitution = 0.2;
         this.systems[46].particleRestitution = 0.2;
         this.systems[51].particleRestitution = 0.2;
         this.systems[57].particleRestitution = 0.2;
         this.systems[58].particleRestitution = 0.2;
         this.systems[59].particleRestitution = 0.2;
         this.systems[60].particleRestitution = 0.2;
         this.systems[61].particleRestitution = 0.2;
         this.systems[62].particleRestitution = 0.2;
         this.systems[64].particleRestitution = 0.2;
         this.systems[66].particleRestitution = 0.2;
         this.systems[67].particleRestitution = 0.2;
         this.systems[68].particleRestitution = 0.4;
         this.systems[69].particleRestitution = 0.2;
         this.systems[70].particleRestitution = 0.2;
         this.systems[71].particleRestitution = 0.2;
         this.systems[75].particleRestitution = 0.2;
         this.systems[68].useWorldGravity = true;
         this.systems[0].particleRestitution = 0.2;
         this.systems[0].particleHealth = 1000;
         this.systems[0].particleFade = 1;
         this.systems[0].particleFadeRandom = 10;
         this.systems[0].particleCollide = true;
         this.systems[1].particleFade = 5;
         this.systems[1].particleFadeRandom = 10;
         this.systems[1].particleRestitution = 0.5;
         this.systems[1].particleFriction = 0.85;
         this.systems[2].useWorldGravity = false;
         this.systems[2].particleFriction = 0.9;
         this.systems[2].particleFadeRandom = 10;
         this.systems[3].useWorldGravity = false;
         this.systems[3].particleFriction = 0.9;
         this.systems[3].particleFadeRandom = 20;
         this.systems[4].particleFriction = 0.95;
         this.systems[4].particleFade = 1;
         this.systems[4].particleFadeRandom = 2;
         this.systems[4].particleWander = 0.1;
         this.systems[140].particleFriction = 0.95;
         this.systems[140].particleFade = 1;
         this.systems[140].particleHealth = 500;
         this.systems[140].particleFadeRandom = 2;
         this.systems[140].particleWander = 0.1;
         this.systems[150].particleFriction = 0.95;
         this.systems[150].particleFade = 1;
         this.systems[150].particleHealth = 500;
         this.systems[150].particleFadeRandom = 2;
         this.systems[150].particleWander = 0.1;
         this.systems[5].useWorldGravity = false;
         this.systems[5].particleFade = 2;
         this.systems[5].particleGravity = -0.2;
         this.systems[5].particleFadeRandom = 10;
         this.systems[5].particleHealth = 400;
         this.systems[5].particleRestitution = 0.5;
         this.systems[5].particleFriction = 0.9;
         this.systems[5].particleWander = 1;
         this.systems[31].useWorldGravity = false;
         this.systems[31].particleFade = 2;
         this.systems[31].particleGravity = -0.4;
         this.systems[31].particleFadeRandom = 10;
         this.systems[31].particleHealth = 400;
         this.systems[31].particleRestitution = 0.5;
         this.systems[31].particleFriction = 0.9;
         this.systems[31].particleWander = 1;
         this.systems[6].useWorldGravity = false;
         this.systems[6].particleFade = 4;
         this.systems[6].particleFadeRandom = 4;
         this.systems[6].particleRestitution = 0.5;
         this.systems[6].particleGravity = -0.4;
         this.systems[6].particleFriction = 0.99;
         this.systems[6].particleWander = 0.5;
         this.systems[142].useWorldGravity = false;
         this.systems[142].particleFade = 4;
         this.systems[142].particleFadeRandom = 4;
         this.systems[142].particleRestitution = 0.5;
         this.systems[142].particleGravity = -0.4;
         this.systems[142].particleFriction = 0.99;
         this.systems[142].particleWander = 0.5;
         this.systems[143].useWorldGravity = false;
         this.systems[143].particleFade = 1;
         this.systems[143].particleFriction = 0.5;
         this.systems[145].useWorldGravity = false;
         this.systems[145].particleFadeRandom = 5;
         this.systems[145].particleHealth = 1000;
         this.systems[145].particleFriction = 0.5;
         this.systems[145].particleWander = 1;
         this.systems[7].useWorldGravity = false;
         this.systems[7].particleFadeRandom = 24;
         this.systems[7].particleHealth = 200;
         this.systems[7].particleRestitution = 0.5;
         this.systems[7].particleFriction = 0.99;
         this.systems[7].particleWander = 0.5;
         this.systems[8].simple = true;
         this.systems[8].pixelColour = 4284900966;
         this.systems[8].particleFade = 1;
         this.systems[8].particleFadeRandom = 10;
         this.systems[8].particleWander = 0.5;
         this.systems[8].particleFriction = 0.95;
         this.systems[8].useWorldGravity = false;
         this.systems[9].useWorldGravity = false;
         this.systems[9].particleFriction = 0.9;
         this.systems[9].particleFadeRandom = 20;
         this.systems[10].useWorldGravity = false;
         this.systems[10].particleFriction = 0.9;
         this.systems[10].particleFadeRandom = 1;
         this.systems[10].simple = true;
         this.systems[10].pixelColour = 4294967040;
         this.systems[11].useWorldGravity = false;
         this.systems[11].particleFade = 1;
         this.systems[11].particleFadeRandom = 1;
         this.systems[11].particleHealth = 200;
         this.systems[11].particleRestitution = 0.5;
         this.systems[11].particleFriction = 0.75;
         this.systems[11].particleWander = 0.5;
         this.systems[33].useWorldGravity = false;
         this.systems[33].particleFade = 1;
         this.systems[33].particleFadeRandom = 1;
         this.systems[33].particleHealth = 200;
         this.systems[33].particleRestitution = 0.5;
         this.systems[33].particleFriction = 0.75;
         this.systems[33].particleWander = 0.5;
         this.systems[12].particleFade = 1;
         this.systems[12].particleFadeRandom = 6;
         this.systems[12].particleHealth = 300;
         this.systems[12].particleWander = 1;
         this.systems[12].particleFriction = 0.95;
         this.systems[12].useWorldGravity = false;
         this.systems[13].particleFade = 1;
         this.systems[13].particleFadeRandom = 3;
         this.systems[13].particleHealth = 400;
         this.systems[13].particleWander = 1;
         this.systems[13].particleFriction = 0.5;
         this.systems[13].useWorldGravity = false;
         this.systems[14].particleFriction = 0.99;
         this.systems[14].useWorldGravity = false;
         this.systems[14].particleFade = 1;
         this.systems[14].particleFadeRandom = 2;
         this.systems[14].particleWander = 0.1;
         this.systems[15].smooth = true;
         this.systems[15].pixelColour = 4294966283;
         this.systems[15].particleFade = 0.1;
         this.systems[15].particleFadeRandom = 200;
         this.systems[15].particleHealth = 200;
         this.systems[15].particleRestitution = 0.9;
         this.systems[16].smooth = true;
         this.systems[16].pixelColour = 4287121663;
         this.systems[16].particleFadeRandom = 200;
         this.systems[16].particleHealth = 200;
         this.systems[16].particleRestitution = 0.9;
         this.systems[17].smooth = true;
         this.systems[17].useWorldGravity = false;
         this.systems[17].pixelColour = 4278229503;
         this.systems[17].particleFade = 4;
         this.systems[17].particleFadeRandom = 20;
         this.systems[17].particleHealth = 100;
         this.systems[17].particleRestitution = -1;
         this.systems[17].particleWander = 8;
         this.systems[18].useWorldGravity = true;
         this.systems[18].particleFadeRandom = 20;
         this.systems[18].particleHealth = 100;
         this.systems[18].particleRestitution = 0.1;
         this.systems[19].useWorldGravity = false;
         this.systems[19].particleFade = 1;
         this.systems[19].particleFadeRandom = 2;
         this.systems[19].particleFriction = 0.95;
         this.systems[19].particleHealth = 300;
         this.systems[20].particleFriction = 0.5;
         this.systems[20].particleFade = 1;
         this.systems[20].particleFadeRandom = 10;
         this.systems[20].particleHealth = 300;
         this.systems[20].particleRestitution = 0;
         this.systems[20].particleWander = 6;
         this.systems[20].useWorldGravity = false;
         this.systems[21].smooth = true;
         this.systems[21].pixelColour = 2868837023;
         this.systems[21].useWorldGravity = false;
         this.systems[21].particleFade = 1;
         this.systems[21].particleFadeRandom = 100;
         this.systems[21].particleHealth = 100;
         this.systems[21].particleFriction = 1.2;
         this.systems[21].particleRestitution = -1;
         this.systems[22].particleFade = 1;
         this.systems[22].particleFadeRandom = 100;
         this.systems[22].particleHealth = 800;
         this.systems[22].particleWander = 0.1;
         this.systems[22].particleFriction = 0.9;
         this.systems[22].useWorldGravity = false;
         this.systems[23].particleRestitution = 0.2;
         this.systems[23].particleHealth = 1;
         this.systems[23].particleFade = 1;
         this.systems[23].useWorldGravity = false;
         this.systems[24].particleFriction = 0.9;
         this.systems[24].useWorldGravity = false;
         this.systems[24].particleFade = 1;
         this.systems[24].particleFadeRandom = 2;
         this.systems[24].particleWander = 0.1;
         this.systems[25].particleFriction = 0.8;
         this.systems[25].useWorldGravity = false;
         this.systems[25].particleHealth = 400;
         this.systems[25].particleFade = 0.1;
         this.systems[25].particleFadeRandom = 4;
         this.systems[25].particleWander = 0.5;
         this.systems[32].particleFriction = 0.8;
         this.systems[32].useWorldGravity = false;
         this.systems[32].particleHealth = 400;
         this.systems[32].particleFade = 0.1;
         this.systems[32].particleFadeRandom = 4;
         this.systems[32].particleWander = 0.5;
         this.systems[26].smooth = true;
         this.systems[26].pixelColour = 4291611852;
         this.systems[26].particleFade = 1;
         this.systems[26].particleFadeRandom = 2;
         this.systems[26].particleHealth = 6;
         this.systems[26].particleRestitution = 0;
         this.systems[26].useWorldGravity = false;
         this.systems[27].particleFriction = 0.7;
         this.systems[27].particleFade = 1;
         this.systems[27].particleFadeRandom = 10;
         this.systems[27].particleHealth = 300;
         this.systems[27].particleRestitution = 0;
         this.systems[27].particleWander = 1;
         this.systems[27].useWorldGravity = false;
         this.systems[28].useWorldGravity = true;
         this.systems[28].particleFadeRandom = 20;
         this.systems[28].particleHealth = 100;
         this.systems[28].particleRestitution = 0.1;
         this.systems[29].smooth = true;
         this.systems[29].pixelColour = 4294901760;
         this.systems[29].particleFadeRandom = 10;
         this.systems[29].particleHealth = 200;
         this.systems[29].particleFriction = 0.5;
         this.systems[29].particleWander = 1;
         this.systems[29].useWorldGravity = false;
         this.systems[30].useWorldGravity = false;
         this.systems[30].particleFriction = 0.9;
         this.systems[30].particleHealth = 1000;
         this.systems[30].particleFadeRandom = 100;
         this.systems[30].particleGravity = -0.1;
         this.systems[30].particleWander = 0.2;
         this.systems[34].particleFriction = 0.8;
         this.systems[34].useWorldGravity = false;
         this.systems[34].particleHealth = 400;
         this.systems[34].particleFade = 0.1;
         this.systems[34].particleFadeRandom = 4;
         this.systems[34].particleWander = 0.5;
      }
      
      private function doTheDefaultThing(param1:ParticleSystem) : void
      {
         if(!param1)
         {
            return;
         }
         param1.useWorldGravity = false;
         param1.particleFadeRandom = 50;
         param1.particleHealth = 400;
         param1.particleFriction = 0.98;
         param1.particleRestitution = 0.1;
         param1.particleWander = 0.1;
         param1.particleRestitution = 0.6;
      }
   }
}

