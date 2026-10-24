package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class OpenWorld extends Environment
   {
      
      private var tf:TextField;
      
      private var fader:Sprite;
      
      private var itemName:String;
      
      public var drone:Sprite;
      
      public var head:b2Body;
      
      public var shoulders:b2Body;
      
      public var stomach:b2Body;
      
      public var hips:b2Body;
      
      public var arm_L:b2Body;
      
      public var arm_R:b2Body;
      
      public var foot_L:b2Body;
      
      public var foot_R:b2Body;
      
      public var item:int = -1;
      
      internal var stuff:Array = ["stapler"];
      
      internal var stuffY:Array = [575];
      
      internal var tutorial:int = 0;
      
      internal var tutoriallines:Array = ["Hello, person.","Welcome to this hallucination.","Brought to you by the malware-filled memory stick...","...That someone oh-so-accidentally inserted riiiight in my head.","What a monster.","I\'ve been informed by my algorithms that in this place, ragdolls can move.","Well that just seems wrong,\nbut I choose to believe what I was programmed to believe!","So.","Soo...","Soooo......","Use buttons to control the doll.\nOn the thing.\nIn front of you.","You know, the buttons:\nCAMERACONTROLS                         ","Welcome to the ooopen wooorld.\nThere are many activities here...","...such as moving and jumping and listening to me...","...and cloudwatching and climbing and smearing blood everywhere...","...and fading to black and listening to me some more and...","...Maybe you should get going, already. Not that there\'s a time limit.","Don\'t get your hopes up though, there\'s nothing in the end, really.","...","....",".....","What are you waiting for?"
      ,"Venture out in the open world. By moving right.","Use the buttons. On the thing.","CAMERACONTROLS","...","....",".....","......",".......","........",".........","Beep boop.\nPress buttons.","Do the thing.","Uhh...","Are you there?","The buttons.","Press the buttons.","If you don\'t press the buttons I\'ll just restart the tutorial.","Here we go...","Hello, person.","Welcome to this place.","This place of button pressing.","Come on, human.","Put that lump of fat you call a brain into use.","And press the buttons.","...","....",".....","Why did you press the Play button if you\'re not going to play?","Anyway here\'s the tutorial again:"];
      
      internal var backlines:Array = ["There\'s no going back.","Someone built a wall behind us!","Wrong direction.","Go right.","Left is wrong, right is right.","There\'s nothing here but a wall. And us, I guess.","->","-->","--->","Nothing here.","You found a secret corner filled with nothing!"];
      
      internal var randomlines:Array = ["These are just random items. There\'s like 1800 of them to jump over.","Welcome to endless jumping.","I\'m not sure some of these are even possible.","Random items sure are random.","20 down... 1800 to go...","Just keep going till you die of old age, puny human.","Random item after random item after random item.","Reset to return to the Lab whenever you\'re done.","This has got to be the worst city ever. Random floating items all over the place.","What kind of a person would put random items all over the place? And who would jump over them for fun? Weirdoes that\'s who.","Jump. Jump. Jump. Jump. Jump. Jump. Jump. Jump. Jump. Jump.","Walk slide jump repeat."];
      
      internal var winlines:Array = ["You win!\nYour prize:\nPretty much nothing.","Here\'s your floating trophy.","You did the thing.","This is the end.","The End.","Shiny.","Shiny shiny shiny.","You win.","You win?","You win!","Do you feel like you\'ve accomplished something?","Dopamine got?","Enjoy the enjoyment.","I told you there was nothing worthwhile in the end.","You can keep going, but there\'s just going to be\nmore of the same.","Good job.","Winner is you.","Great job with the pressing of the buttons.","Reset to return to the Lab, already.","Good job abusing the physics engine.","I sure did a great job helping you get this far. No problem.","Well leapt."];
      
      internal var lines:Array = ["Hello, world.","Sinister Software sent me a letter.\nIt reads \'I like the night.\'.\nWritten in blood.","I am the night!","Is it past your bedtime?","Is it past my bedtime?","Since there are no animals in this universe, I will try to imitate one to provide city atmosphere:\nCoo.","Since there are no animals in this universe, I will try to imitate one to provide city atmosphere:\nWoof.","Since there are no animals in this universe, I will try to imitate one to provide city atmosphere:\nMeow.","Since there are no animals in this universe, I will try to imitate one to provide city atmosphere:\nMoo.","Since there are no animals in this universe, I will try to imitate one to provide city atmosphere:\nHiss.","Since there are no animals in this universe, I will try to imitate one to provide city atmosphere:\nRoar.","I\'ve attempted cloudwatching.\nI don\'t have an imagination unit.","For a city, this place is pretty barren.","Who keeps leaving all this stuff around?"
      ,"Welcome to the jungle.","A concrete garden.","It sure is grey around here.","Keep going. I\'ll follow.","Left! Right! Left!","Left! Right! Left!\nNo wait, only right.\nThere\'s nothing left.","It\'s a good thing there are no vehicles on this road.\nOr in this universe.","It\'s so silent.","...","If you fail miserably you can always try again.","Only 1750 more items to jump over!","Go on.","Do something.","This isn\'t a real open world game you know.\nThere are no fetch quests.","I wonder what kind of obstacle will be on our way next?","I sure hope there\'s something rewarding in the end, and not just more random babbling.","Will the city ever end?","Avoid smearing on the concrete. Janitor Drones don\'t work for free.","I heard they implanted stronger magnets to make the doll move.\nThat\'s gross.","Paranoid Software emailed me\nit\'s the aliens making the doll move.","Paranoid Software messaged me\nit\'s the chemicals they pumped into the doll making it move.","Paranoid Software told me\nit\'s government mind-control making the doll move."
      ,"The doll sure is awful at walking. It\'s almost like it has no muscles.","Just give up and go back to the Lab, there\'s nothing in the end in any case.","This is artificial entertainment you know? Chasing a pointless goal?"];
      
      internal var speeds:Array = ["Watch out for the speed limit.","Mach 5!","Move it move it!","Gotta go fast!","The doll will just end up as a smear at that speed.","Going a bit fast there.","Time to smack against ITEMNAME real fast.","At this speed the doll will do a great meat crayon impersonation.","Smeeeaaaarrrrr...","Smack bam wham bash...","*Bashing Sounds*","Do you have any idea how fast you are going?"];
      
      internal var itemlines:Array = ["Hello, ITEMNAME.","I spot with my little sensor ITEMNAME.","Ahoy! ITEMNAME ahead.","ITEMNAME? ITEMNAME... ITEMNAME!","Why ITEMNAME?","How did ITEMNAME end up here?","Why is the obstacle always in the middle of the road?","Who keeps leaving this stuff here?","Why would ITEMNAME be here?","It\'s almost like the obstacles keep getting higher and higher.","ITEMNAME reminds me of a pointless obstacle.","Jumping over that ITEMNAME sure is going to be hard.","Have you tried going around the ITEMNAME?\nOh wait, it\'s a 2D game.","That ITEMNAME will prove to be a challenging yet satisfying obstacle. Maybe?","How will the doll ever get past this ITEMNAME?","ITEMNAME? Surely that\'s impossible to scale.","ITEMNAME. It\'s always ITEMNAME.","It\'s a good thing we\'re PERCENTAGE done with these obstacles."];
      
      internal var levellines:Array = ["LEVEL UP!!!\nNot really though.","[ACHIEVEMENT UNLOCKED]\nDopamine Released","[ACHIEVEMENT UNLOCKED]\nSome Progress Made","[ACHIEVEMENT UNLOCKED]\nProgress Made","[ACHIEVEMENT UNLOCKED]\nMultiple Buttons Pressed","[ACHIEVEMENT UNLOCKED]\nJumped At Least Once","[ACHIEVEMENT UNLOCKED]\nMoved Right","[ACHIEVEMENT UNLOCKED]\nObstacle Beaten","[ACHIEVEMENT UNLOCKED]\nUnlock At Least One Achievement","[ACHIEVEMENT UNLOCKED]\nListened To A Lot Of Pointless Babbling","[ACHIEVEMENT UNLOCKED]\nThese Aren\'t Actually Achievements You Know","[ACHIEVEMENT UNLOCKED]\nSomething Achieved","Congratulations!","You did a thing!","Accomplishment accomplished.","You have successfully pressed several buttons to progress.","That was easy. Maybe too easy.","That wasn\'t so hard now was it?","Obstacle = crossed;","Only REVPERCENTAGE to go.","PERCENTAGE of the way to victory! Progress!","Good job.\nNext up, another obstacle!","You are making progress.\nBut wait, there\'s more!","One progress successfully made. More to go."
      ,"One down. Like totally a bunch more left.","Here comes the fade out fade in thing. What\'s that all about anyway?","Keep going. If you really want to. There\'s nothing worth it in the end.","More obstacles crossed is better than fewer obstacles crossed. Obviously.","Grind grind grind. And not a single XP bar to mark progress.","Worst.\nProgression system.\nEver."];
      
      public function OpenWorld()
      {
         this.removeGraphics();
         this.drone = O.getItem("dronespeaker").updateGraphic();
         this.drone.x = 200;
         this.drone.y = 200;
         this.drone.name = "openworlddrone";
         this.fader = new Sprite();
         this.fader.name = "openworldfader";
         this.fader.graphics.beginFill(0);
         this.fader.graphics.drawRect(0,0,1280,720);
         this.tf = new TextField();
         this.tf.name = "openworldtf";
         this.tf.defaultTextFormat = new TextFormat(Window.FONT,24);
         this.tf.textColor = 16777164;
         this.tf.width = 450;
         this.tf.height = 200;
         this.tf.wordWrap = true;
         this.tf.multiline = true;
         this.tf.selectable = false;
         this.tf.mouseEnabled = false;
         this.tf.text = "Hello, world.";
         var _loc1_:TextFormat = this.tf.getTextFormat();
         _loc1_.align = TextFormatAlign.CENTER;
         this.tf.setTextFormat(_loc1_);
         this.tf.filters = [new GlowFilter(1118481,1,2,2,4)];
         Main.instance.stage.addChild(this.tf);
         Main.instance.stage.addChild(this.drone);
         Main.instance.stage.addChild(this.fader);
         this.animate();
         this.animaterotate();
         this.animatetext();
         this.addStuff("pickle",580);
         this.addStuff("modernrailroad",580);
         this.addStuff("parkbench",570);
         this.addStuff("guardrailsegment",570);
         this.addStuff("haybale",560);
         this.addStuff("sidewalksloperail",570);
         this.addStuff("generator",520);
         this.addStuff("cityfence",550);
         this.addStuff("grill",540);
         this.addStuff("sandbarrel",520);
         this.addStuff("restaurantboard",560);
         this.addStuff("grandpiano",540);
         this.addStuff("wetfloorsign",510);
         this.addStuff("atm",525);
         this.addStuff("hotdogstand",550);
         this.addStuff("gaspump",500);
         this.addStuff("newspaperdispenser",480);
         this.addStuff("fountain",510);
         this.addStuff("constructionsign",450);
         this.addStuff("locker",500);
         this.addStuff("railroadcrossing",470);
         this.addStuff("condoroof",450);
         this.addStuff("policebox",420);
         this.addStuff("mobiletoilet",410);
         this.addStuff("lamppost",380);
         this.addStuff("powerpole",380);
         this.addStuff("apartmentbuilding",420);
         this.addStuff("trophy",450);
         this.addStuff("random",450);
         super(GameState.width,GameState.height);
         _name = "openworld";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _borderLeft = -800;
         _borderRight = 2000;
         _backgroundColour = 2236962;
         _wallColour = 6710886;
         spawnX = 100;
         _background = new BitmapData(1600,600,false);
         _roof = false;
         _walls = false;
         _wallL = true;
         _wallR = false;
         _loop = true;
         enableParticles = false;
         this.setupBackground();
         this.animatefadein();
      }
      
      public function addStuff(param1:String, param2:Number) : *
      {
         this.stuff.push(param1);
         this.stuffY.push(param2);
      }
      
      public function reset() : void
      {
         this.removeGraphics();
         Tweener.removeAllTweens();
         GameState.menuHandler.getMenu("Main").open();
         GameState.menuHandler.getMenu("Toolbox").open();
         Main.instance.changeEnvironment("lab");
      }
      
      private function removeGraphics() : void
      {
         var _loc1_:DisplayObject = Main.instance.stage.getChildByName("openworlddrone");
         var _loc2_:DisplayObject = Main.instance.stage.getChildByName("openworldtf");
         var _loc3_:DisplayObject = Main.instance.stage.getChildByName("openworldfader");
         if(_loc1_)
         {
            Main.instance.stage.removeChild(_loc1_);
         }
         if(_loc2_)
         {
            Main.instance.stage.removeChild(_loc2_);
         }
         if(_loc3_)
         {
            Main.instance.stage.removeChild(_loc3_);
         }
         sounds.stop("elevatormusic");
      }
      
      private function animate() : void
      {
         Tweener.addTween(this.drone,{
            "x":Math.random() * 100 + 100,
            "y":Math.random() * 100 + 100,
            "time":(0.4 + Math.random() * 0.8) / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animate
         });
      }
      
      private function animaterotate() : void
      {
         Tweener.addTween(this.drone,{
            "rotation":Math.random() * 60 - 30,
            "delay":0.2 + Math.random() * 0.6,
            "time":(0.2 + Math.random() * 0.4) / TimeLord.timerSpeed,
            "transition":"easeInOutBounce",
            "onComplete":this.animaterotate
         });
      }
      
      private function animatetext() : void
      {
         var line:String = null;
         var camLeftName:String = null;
         var camRightName:String = null;
         var camUpName:String = null;
         try
         {
            line = this.lines[int(Math.random() * this.lines.length)];
            if(Boolean(this.head) && this.head.GetLinearVelocity().Length() > 20)
            {
               line = this.speeds[int(Math.random() * this.speeds.length)];
            }
            if(this.item == 0)
            {
               line = this.tutoriallines[this.tutorial];
               ++this.tutorial;
               camLeftName = Keymap.codeToKeyname(Keymap.nameToCode("CameraLeft"));
               camRightName = Keymap.codeToKeyname(Keymap.nameToCode("CameraRight"));
               camUpName = Keymap.codeToKeyname(Keymap.nameToCode("CameraUp"));
               line = line.replace("CAMERACONTROLS","Movement: [" + camLeftName + "] & [" + camRightName + "]\n" + "Jump: [" + camUpName + "].\n(Or: [Arrow Keys].)");
               if(this.tutorial >= this.tutoriallines.length)
               {
                  this.tutorial = 0;
               }
            }
            if(this.item > 0)
            {
               if(this.head.GetPosition().x * Physics.scale > 700)
               {
                  line = this.levellines[int(Math.random() * this.levellines.length)];
               }
               else if(this.head.GetPosition().x * Physics.scale > 400)
               {
                  if(Math.random() > 0.5)
                  {
                     line = this.itemlines[int(Math.random() * this.itemlines.length)];
                  }
               }
            }
            if(Boolean(this.head) && this.head.GetPosition().x * Physics.scale < -100)
            {
               line = this.backlines[int(Math.random() * this.backlines.length)];
            }
            if(this.stuff[this.item] == "trophy")
            {
               line = this.winlines[int(Math.random() * this.winlines.length)];
            }
            if(this.stuff[this.item] == "random" && Math.random() > 0.5)
            {
               line = this.randomlines[int(Math.random() * this.winlines.length)];
            }
            line = line.replace("REVPERCENTAGE",(100 * (1 - this.item / this.stuff.length)).toString() + "%");
            line = line.replace("PERCENTAGE",(100 * (this.item / this.stuff.length)).toString() + "%");
            line = line.split("ITEMNAME").join(GeneralUtils.objectToName(this.itemName));
         }
         catch(e:Error)
         {
            line = "...";
         }
         this.tf.text = line;
         this.tf.scaleX = 1;
         this.tf.scaleY = 1;
         Tweener.addTween(this.tf,{
            "scaleX":0.5,
            "scaleY":0.5,
            "delay":this.tf.text.length * 0.05 + 0.5,
            "time":0.2 / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animatetext
         });
      }
      
      private function animatefadeout() : void
      {
         GameState.menuHandler.getMenu("Main").forceClosed();
         GameState.menuHandler.getMenu("Toolbox").forceClosed();
         if(!sounds.isPlaying("elevatormusic"))
         {
            sounds.play("elevatormusic",null,null,1,true,9000);
         }
         Vars.seed = int(Math.random() * 10000);
         this.setupBackground();
         Main.instance.reset();
         if(this.stuff[this.item] != "random")
         {
            ++this.item;
         }
         this.spawnItem();
         Tweener.addTween(this.fader,{
            "alpha":0,
            "time":0.5 / TimeLord.timerSpeed,
            "transition":"easeInBack"
         });
         this.tf.text = "";
      }
      
      private function animatefadein() : void
      {
         Tweener.addTween(this.fader,{
            "alpha":1,
            "time":0.5 / TimeLord.timerSpeed,
            "transition":"easeInBack",
            "onComplete":this.animatefadeout
         });
      }
      
      private function spawnItem() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:int = 0;
         Vars.objFriction = 0.2;
         if(this.stuff[this.item] != "random")
         {
            Vars.objDensity = 0;
            this.itemName = this.stuff[this.item];
            _loc2_ = 0;
            while(_loc2_ < Math.min(1,Math.random() * Math.random() * 5))
            {
               _loc2_++;
            }
            _loc1_ = GameState.objects.spawnObject(this.itemName,400 + 100 * _loc2_,this.stuffY[this.item]);
            Vars.objDensity = 1;
         }
         else
         {
            Vars.objDampAngular = 9000;
            Vars.objDampLinear = 9000;
            this.itemName = O.names[int(Math.random() * O.names.length)];
            O.getItem(this.itemName).updateGraphic();
            _loc1_ = GameState.objects.spawnObject(this.itemName,700,600 - O.getItem(this.itemName).height);
            Vars.objDampAngular = 0;
            Vars.objDampLinear = 0;
         }
         if(_loc1_)
         {
            _defaultBodies.push(_loc1_);
         }
         Vars.objFriction = 0.5;
      }
      
      override public function setupBackground() : void
      {
         super.setupBackground();
         var _loc1_:b2Vec2 = new b2Vec2(random() * 850 + 150,random() * 150 + 100);
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(12301988);
         _loc2_.graphics.drawCircle(_loc1_.x,_loc1_.y,100);
         _loc2_.graphics.beginFill(_backgroundColour);
         _loc2_.graphics.drawCircle(random() * 100 - 50 + _loc1_.x,random() * 100 - 50 + _loc1_.y,random() * 50 - 25 + 100);
         _background.draw(_loc2_,_loc2_.transform.matrix);
         this.initItems();
         backgroundDone();
      }
      
      private function initItems() : void
      {
         var _loc1_:Item = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:b2Body = null;
         var _loc11_:Matrix = null;
         var _loc5_:Vector.<Array> = _loc5_ = new Vector.<Array>();
         _loc6_ = 0;
         while(_loc6_ < random() * 20 + 10)
         {
            _loc5_ = new Vector.<Array>();
            _loc7_ = 16;
            _loc8_ = 78 + random() * 20 - 10;
            _loc9_ = 23;
            _loc5_.push(["BEE8F7",GraphicUtils.scalehex(10066329,0.8 + random() * 0.2 - 0.1).toString(16)]);
            _loc2_ = 0.4 + random() * 0.4 - 0.2;
            _loc3_ = random() * 2400 + 200;
            _loc4_ = random() * 100 + 100 + _loc2_ * 50;
            _loc1_ = O.getItem("cloud");
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("downwardscloud");
            }
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("longcloud");
            }
            _loc10_ = GameState.objects.spawnItem(_loc1_.vertices,[0],_loc2_,_loc1_.name,_loc3_,_loc4_,0,_loc1_.colours,"none",_loc5_);
            _loc11_ = new Matrix();
            _loc11_.rotate((random() * 360 - 720) * Vars.toRadians);
            _loc11_.translate(_loc3_,_loc4_);
            _background.draw(userData(_loc10_.GetUserData()).graphic,_loc11_);
            Body.Destroy(_loc10_,"environment");
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 5)
         {
            _loc5_ = new Vector.<Array>();
            _loc5_.push(["edd5a7",GraphicUtils.scalehex(15586727,1 + random() * 0.2 - 0.1).toString(16)]);
            _loc5_.push(["3c3f47",GraphicUtils.scalehex(2895928,1 + random() * 0.2 - 0.1).toString(16)]);
            _loc7_ = 16;
            _loc8_ = 78 + random() * 20 - 10;
            _loc9_ = 23;
            _loc2_ = 2;
            _loc3_ = 50 + 250 * _loc6_;
            _loc4_ = 520;
            _loc1_ = O.getItem("cityskyline4");
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("cityskyline3");
            }
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("cityskyline2");
            }
            _loc10_ = GameState.objects.spawnItem(_loc1_.vertices,[1],_loc2_,_loc1_.name,_loc3_,_loc4_,0,_loc1_.colours,"none",_loc5_);
            _loc11_ = new Matrix();
            _loc11_.translate(_loc3_,_loc4_);
            _background.draw(userData(_loc10_.GetUserData()).graphic,_loc11_);
            Body.Destroy(_loc10_,"environment");
            _loc6_++;
         }
         setupBackgroundFiller(600,_wallColour);
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:Number = NaN;
         var _loc3_:b2Body = null;
         var _loc4_:int = 0;
         this.tf.x += (-this.tf.x + this.drone.x + 50) * 0.02;
         this.tf.y += (-this.tf.y + this.drone.y - 25) * 0.02;
         if(this.head)
         {
            GameState.followBody = this.head;
            if(this.head.GetPosition().x > 1100 / Physics.scale && !Tweener.isTweening(this.fader))
            {
               this.animatefadein();
            }
            _loc1_ = this.head.GetPosition().Copy();
            _loc1_.Multiply(Physics.scale);
            if(_loc1_.x > 700 || this.stuff[this.item] == "trophy")
            {
               if(Math.random() > 0.99)
               {
                  _loc3_ = GameState.objects.addbullet("firework",(_loc1_.x + Math.random() * 200 - 100) / Physics.scale,(_loc1_.y + Math.random() * 200 - 100) / Physics.scale,Math.random() * 360,1,1,new b2Vec2(0,0),1,this.head);
                  userData(_loc3_.GetUserData()).ghost = true;
                  userData(_loc3_.GetUserData()).triggerForce = Math.random() * 100;
                  userData(_loc3_.GetUserData()).triggerDuration = Math.random() * 100;
               }
            }
            _loc2_ = 500;
            if(Main.instance.panLeft)
            {
               this.head.WakeUp();
               this.head.ApplyTorque(-this.head.GetAngle() * _loc2_);
               this.shoulders.ApplyTorque(-this.shoulders.GetAngle() * _loc2_);
               this.stomach.ApplyTorque(-this.stomach.GetAngle() * _loc2_);
               this.hips.ApplyTorque(-this.hips.GetAngle() * _loc2_);
               this.head.ApplyImpulse(new b2Vec2(2 * this.head.GetMass(),-0.2 * this.head.GetMass()),this.head.GetWorldCenter());
               this.shoulders.ApplyImpulse(new b2Vec2(1 * this.shoulders.GetMass(),-0.1 * this.shoulders.GetMass()),this.shoulders.GetWorldCenter());
               this.stomach.ApplyImpulse(new b2Vec2(-2 * this.stomach.GetMass(),-0.01 * this.stomach.GetMass()),this.stomach.GetWorldCenter());
               this.hips.ApplyImpulse(new b2Vec2(-2 * this.hips.GetMass(),-0.01 * this.hips.GetMass()),this.hips.GetWorldCenter());
               this.arm_R.ApplyImpulse(new b2Vec2(-1 * this.arm_R.GetMass(),0.01 * this.arm_R.GetMass()),this.arm_R.GetWorldCenter());
               this.arm_L.ApplyImpulse(new b2Vec2(-1 * this.arm_L.GetMass(),0.01 * this.arm_L.GetMass()),this.arm_L.GetWorldCenter());
               this.foot_L.ApplyImpulse(new b2Vec2(-1 * this.foot_L.GetMass(),0.4 * this.foot_L.GetMass()),this.foot_L.GetWorldCenter());
               this.foot_R.ApplyImpulse(new b2Vec2(-1 * this.foot_R.GetMass(),0.4 * this.foot_R.GetMass()),this.foot_R.GetWorldCenter());
            }
            if(Main.instance.panRight)
            {
               this.head.WakeUp();
               this.head.ApplyTorque(-this.head.GetAngle() * _loc2_);
               this.shoulders.ApplyTorque(-this.shoulders.GetAngle() * _loc2_);
               this.stomach.ApplyTorque(-this.stomach.GetAngle() * _loc2_);
               this.hips.ApplyTorque(-this.hips.GetAngle() * _loc2_);
               this.head.ApplyImpulse(new b2Vec2(-2 * this.head.GetMass(),-0.2 * this.head.GetMass()),this.head.GetWorldCenter());
               this.shoulders.ApplyImpulse(new b2Vec2(-1 * this.shoulders.GetMass(),-0.1 * this.shoulders.GetMass()),this.shoulders.GetWorldCenter());
               this.arm_R.ApplyImpulse(new b2Vec2(1 * this.arm_R.GetMass(),0.01 * this.arm_R.GetMass()),this.arm_R.GetWorldCenter());
               this.arm_L.ApplyImpulse(new b2Vec2(1 * this.arm_L.GetMass(),0.01 * this.arm_L.GetMass()),this.arm_L.GetWorldCenter());
               this.stomach.ApplyImpulse(new b2Vec2(2 * this.stomach.GetMass(),-0.01 * this.stomach.GetMass()),this.stomach.GetWorldCenter());
               this.hips.ApplyImpulse(new b2Vec2(2 * this.hips.GetMass(),-0.01 * this.hips.GetMass()),this.hips.GetWorldCenter());
               this.foot_L.ApplyImpulse(new b2Vec2(1 * this.foot_L.GetMass(),0.4 * this.foot_L.GetMass()),this.foot_L.GetWorldCenter());
               this.foot_R.ApplyImpulse(new b2Vec2(1 * this.foot_R.GetMass(),0.4 * this.foot_R.GetMass()),this.foot_R.GetWorldCenter());
            }
            if(Main.instance.panUp && GameState.canJump)
            {
               this.head.WakeUp();
               _loc4_ = -10;
               if(this.stuff[this.item] == "random")
               {
                  _loc4_ = -5;
               }
               this.head.ApplyImpulse(new b2Vec2(0,(Math.random() * 0.7 + 0.3) * (this.item * 0.25 + 2) * _loc4_ * this.head.GetMass()),this.head.GetWorldCenter());
               this.shoulders.ApplyImpulse(new b2Vec2(0,(Math.random() * 0.7 + 0.3) * (this.item * 0.25 + 2) * _loc4_ * this.shoulders.GetMass()),this.head.GetWorldCenter());
               this.arm_R.ApplyImpulse(new b2Vec2(0,(Math.random() * 0.7 + 0.3) * (this.item * 0.25 + 2) * _loc4_ * this.arm_R.GetMass()),this.head.GetWorldCenter());
               this.arm_L.ApplyImpulse(new b2Vec2(0,(Math.random() * 0.7 + 0.3) * (this.item * 0.25 + 2) * _loc4_ * this.arm_L.GetMass()),this.head.GetWorldCenter());
               this.stomach.ApplyImpulse(new b2Vec2(0,(Math.random() * 0.7 + 0.3) * (this.item * 0.25 + 2) * _loc4_ * this.stomach.GetMass()),this.head.GetWorldCenter());
               GameState.canJump = false;
            }
         }
         super.update();
      }
   }
}

