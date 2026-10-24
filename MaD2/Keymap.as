package
{
   import flash.system.Capabilities;
   
   public class Keymap
   {
      
      private static var defaultKeymap:String;
      
      private static var isMac:Boolean = false;
      
      private static var keymapxml:XML = <Keys>
		<Key ID="0">	<name> Debug			</name>	<alias> Toggle debug    	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="1">	<name> Console			</name>	<alias> Console         	</alias> <code>	36	</code>	<category> debug	 </category> </Key>
		<Key ID="2">	<name> Delete			</name>	<alias> Delete object   	</alias> <code>	88	</code>	<category> system	 </category> </Key>
		<Key ID="3">	<name> Delete2			</name>	<alias> Delete object   	</alias> <code>	8	</code>	<category> system	 </category> </Key>
		<Key ID="4">	<name> Flip				</name>	<alias> Flip object     	</alias> <code>	9	</code>	<category> system	 </category> </Key>
		<Key ID="5">	<name> ToggleHUD		</name>	<alias> Toggle HUD      	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="6">	<name> MultipleSelect	</name>	<alias> Select 				</alias> <code>	16	</code>	<category> system	 </category> </Key>
		<Key ID="7">	<name> Spawning			</name>	<alias> Spawn menu        	</alias> <code>	0	</code>	<category> system	 </category> </Key>
		<Key ID="8">	<name> SaveMenu			</name>	<alias> Save menu       	</alias> <code>	0	</code>	<category> system	 </category> </Key>
		<Key ID="9">	<name> WorldMenu		</name>	<alias> World menu      	</alias> <code>	0	</code>	<category> system	 </category> </Key>
		<Key ID="10">	<name> ObjectMenu		</name>	<alias> Object menu     	</alias> <code>	0	</code>	<category> system	 </category> </Key>
		<Key ID="11">	<name> ColourMenu		</name>	<alias> Colour menu     	</alias> <code>	0	</code>	<category> system	 </category> </Key>
		<Key ID="12">	<name> RotateL			</name>	<alias> Rotate left     	</alias> <code>	37	</code>	<category> system	 </category> </Key>
		<Key ID="13">	<name> RotateR			</name>	<alias> Rotate right    	</alias> <code>	39	</code>	<category> system	 </category> </Key>
		<Key ID="14">	<name> ResizeU			</name>	<alias> Scale up        	</alias> <code>	38	</code>	<category> system	 </category> </Key>
		<Key ID="15">	<name> ResizeD			</name>	<alias> Scale down      	</alias> <code>	40	</code>	<category> system	 </category> </Key>
		<Key ID="16">	<name> KeyLeft			</name>	<alias> Move left       	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="17">	<name> KeyDown			</name>	<alias> Move right      	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="18">	<name> KeyUp			</name>	<alias> Move up         	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="19">	<name> KeyRight			</name>	<alias> Move down       	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="20">	<name> Pause			</name>	<alias> Pause           	</alias> <code>	32	</code>	<category> system	 </category> </Key>
		<Key ID="21">	<name> Reset			</name>	<alias> Reset           	</alias> <code>	27	</code>	<category> system	 </category> </Key>
		<Key ID="22">	<name> Reset2			</name>	<alias> Reset           	</alias> <code>	27	</code>	<category> debug	 </category> </Key>
		<Key ID="23">	<name> Save				</name>	<alias> Quicksave       	</alias> <code>	67	</code>	<category> system	 </category> </Key>
		<Key ID="24">	<name> Load				</name>	<alias> Quickload       	</alias> <code>	86	</code>	<category> system	 </category> </Key>
		<Key ID="25">	<name> Slomo			</name>	<alias> Slow Motion     	</alias> <code>	71	</code>	<category> system	 </category> </Key>
		<Key ID="26">	<name> RotationReset	</name>	<alias> Reset rotation  	</alias> <code>	190	</code>	<category> debug	 </category> </Key>
		<Key ID="27">	<name> CameraHome		</name>	<alias> Camera Reset     	</alias> <code>	191	</code>	<category> camera	 </category> </Key>
		<Key ID="28">	<name> CameraUp			</name>	<alias> Camera Up     		</alias> <code>	87	</code>	<category> camera	 </category> </Key>
		<Key ID="29">	<name> CameraDown		</name>	<alias> Camera Down   		</alias> <code>	83	</code>	<category> camera	 </category> </Key>
		<Key ID="30">	<name> CameraLeft		</name>	<alias> Camera Left   		</alias> <code>	65	</code>	<category> camera	 </category> </Key>
		<Key ID="31">	<name> CameraRight		</name>	<alias> Camera Right  		</alias> <code>	68	</code>	<category> camera	 </category> </Key>
		<Key ID="32">	<name> CameraFollow		</name>	<alias> Camera Follow  		</alias> <code>	0	</code>	<category> camera	 </category> </Key>
		<Key ID="33">	<name> CameraOut		</name>	<alias> Camera out    		</alias> <code>	189	</code>	<category> camera	 </category> </Key>
		<Key ID="34">	<name> CameraIn			</name>	<alias> Camera in        	</alias> <code>	187	</code>	<category> camera	 </category> </Key>
		<Key ID="35">	<name> Cut				</name>	<alias> Cut Tool	       	</alias> <code>	69	</code>	<category> tool		 </category> </Key>
		<Key ID="36">	<name> MouseCut			</name>	<alias> Circular cut    	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="37">	<name> RandomCut		</name>	<alias> Random cut      	</alias> <code>	0	</code>	<category> debug	 </category> </Key>
		<Key ID="38">	<name> BGJoint			</name>	<alias> Pin Joint			</alias> <code>	73	</code>	<category> joint	 </category> </Key>
		<Key ID="39">	<name> LinkJoint		</name>	<alias> Link		      	</alias> <code>	79	</code>	<category> joint	 </category> </Key>
		<Key ID="40">	<name> WeldJoint		</name>	<alias> Weld joint     		</alias> <code>	80	</code>	<category> joint	 </category> </Key>
		<Key ID="41">	<name> ObjJoint			</name>	<alias> Object joint    	</alias> <code>	85	</code>	<category> joint	 </category> </Key>
		<Key ID="42">	<name> RopeJoint		</name>	<alias> Rope joint      	</alias> <code>	89	</code>	<category> joint	 </category> </Key>
		<Key ID="43">	<name> Favourite1       </name>	<alias> Favourite 1     	</alias> <code>	49	</code>	<category> favourite </category> </Key>
		<Key ID="44">	<name> Favourite2       </name>	<alias> Favourite 2     	</alias> <code>	50	</code>	<category> favourite </category> </Key>
		<Key ID="45">	<name> Favourite3       </name>	<alias> Favourite 3     	</alias> <code>	51	</code>	<category> favourite </category> </Key>
		<Key ID="46">	<name> Favourite4       </name>	<alias> Favourite 4     	</alias> <code>	52	</code>	<category> favourite </category> </Key>
		<Key ID="47">	<name> Favourite5       </name>	<alias> Favourite 5     	</alias> <code>	53	</code>	<category> favourite </category> </Key>
		<Key ID="48">	<name> Favourite6       </name>	<alias> Favourite 6     	</alias> <code>	54	</code>	<category> favourite </category> </Key>
		<Key ID="49">	<name> Favourite7       </name>	<alias> Favourite 7     	</alias> <code>	55	</code>	<category> favourite </category> </Key>
		<Key ID="50">	<name> Favourite8       </name>	<alias> Favourite 8     	</alias> <code>	56	</code>	<category> favourite </category> </Key>
		<Key ID="51">	<name> Favourite9       </name>	<alias> Favourite 9     	</alias> <code>	57	</code>	<category> favourite </category> </Key>
		<Key ID="52">	<name> Details      	</name>	<alias> Detail Tool			</alias> <code>	77	</code>	<category> tool  	 </category> </Key>
		<Key ID="53">	<name> Select			</name>	<alias> Select Tool        	</alias> <code>	17	</code>	<category> tool		 </category> </Key>
		<Key ID="54">	<name> Action			</name>	<alias> Trigger Tool       	</alias> <code>	70	</code>	<category> system	 </category> </Key>
		<Key ID="55">	<name> Scalerotate		</name>	<alias> Scale Tool			</alias> <code>	84	</code>	<category> tool		 </category> </Key>
		<Key ID="56">	<name> Drag				</name>	<alias> Drag Tool			</alias> <code>	81	</code>	<category> tool		 </category> </Key>
		<Key ID="57">	<name> Favourite10      </name>	<alias> Favourite 10     	</alias> <code>	48	</code>	<category> favourite </category> </Key>
		<Key ID="58">	<name> Rotate      		</name>	<alias> Rotate Tool			</alias> <code>	82	</code>	<category> tool 	 </category> </Key>
		<Key ID="59">	<name> Flame			</name>	<alias> Flame Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="60">	<name> Frost			</name>	<alias> Frost Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="61">	<name> Wind				</name>	<alias> Wind Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="62">	<name> Water			</name>	<alias> Water Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="63">	<name> Shock			</name>	<alias> Shock Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="64">	<name> Poison			</name>	<alias> Poison Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="65">	<name> Heal				</name>	<alias> Heal Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="66">	<name> Drain			</name>	<alias> Drain Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="67">	<name> Void				</name>	<alias> Void Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="68">	<name> Rend				</name>	<alias> Rend Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="69">	<name> Blast			</name>	<alias> Blast Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="70">	<name> Snare			</name>	<alias> Snare Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="71">	<name> Death			</name>	<alias> Death Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="72">	<name> Dispel			</name>	<alias> Dispel Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="73">	<name> Blunt			</name>	<alias> Blunt Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="74">	<name> Arc				</name>	<alias> Arc Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="75">	<name> Bee				</name>	<alias> Bee Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="76">	<name> Bubble			</name>	<alias> Bubble Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="77">	<name> Bullet			</name>	<alias> Bullet Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="78">	<name> Gasoline			</name>	<alias> Gasoline Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="79">	<name> Glue				</name>	<alias> Glue Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="80">	<name> Gravity			</name>	<alias> Gravity Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="81">	<name> Laser			</name>	<alias> Laser Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="82">	<name> Levity			</name>	<alias> Levity Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="83">	<name> Paint			</name>	<alias> Paint Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="84">	<name> Powder			</name>	<alias> Powder Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="85">	<name> Random			</name>	<alias> Random Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="86">	<name> Ricochet			</name>	<alias> Ricochet Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="87">	<name> Sharp			</name>	<alias> Sharp Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="88">	<name> Stasis			</name>	<alias> Stasis Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="89">	<name> Toxic			</name>	<alias> Toxic Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="90">	<name> Favourite11		</name>	<alias> Favourite 11		</alias> <code>	96	</code>	<category> favourite </category> </Key>
		<Key ID="91">	<name> Favourite12		</name>	<alias> Favourite 12		</alias> <code>	97	</code>	<category> favourite </category> </Key>
		<Key ID="92">	<name> Favourite13		</name>	<alias> Favourite 13		</alias> <code>	98	</code>	<category> favourite </category> </Key>
		<Key ID="93">	<name> Favourite14		</name>	<alias> Favourite 14		</alias> <code>	99	</code>	<category> favourite </category> </Key>
		<Key ID="94">	<name> Favourite15		</name>	<alias> Favourite 15		</alias> <code>	100	</code>	<category> favourite </category> </Key>
		<Key ID="95">	<name> Favourite16		</name>	<alias> Favourite 16		</alias> <code>	101	</code>	<category> favourite </category> </Key>
		<Key ID="96">	<name> Favourite17		</name>	<alias> Favourite 17		</alias> <code>	102	</code>	<category> favourite </category> </Key>
		<Key ID="97">	<name> Favourite18		</name>	<alias> Favourite 18		</alias> <code>	103	</code>	<category> favourite </category> </Key>
		<Key ID="98">	<name> Favourite19		</name>	<alias> Favourite 19		</alias> <code>	104	</code>	<category> favourite </category> </Key>
		<Key ID="99">	<name> Favourite20		</name>	<alias> Favourite 20		</alias> <code>	105	</code>	<category> favourite </category> </Key>
		<Key ID="100">	<name> Launch			</name>	<alias> Launch Tool			</alias> <code>	76	</code>	<category> tool		 </category> </Key>
		<Key ID="101">	<name> Aim				</name>	<alias> Aim Tool			</alias> <code>	75	</code>	<category> tool		 </category> </Key>
		<Key ID="102">	<name> Concuss			</name>	<alias> Concuss Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="103">	<name> RevoluteJoint	</name>	<alias> Revolute Joint		</alias> <code>	0	</code>	<category> joint 	 </category> </Key>
		<Key ID="104">	<name> Transmute		</name>	<alias> Transmute Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="105">	<name> Critical			</name>	<alias> Critical Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="106">	<name> Acid				</name>	<alias> Acid Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="107">	<name> Smoke			</name>	<alias> Smoke Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="108">	<name> Hole				</name>	<alias> Hole Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="109">	<name> Disc				</name>	<alias> Disc Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="110">	<name> Swing			</name>	<alias> Swing Tool			</alias> <code>	74	</code>	<category> tool 	 </category> </Key>
		<Key ID="111">	<name> Hail				</name>	<alias> Hail Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="112">	<name> Icicle			</name>	<alias> Icicle Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="113">	<name> Crush			</name>	<alias> Crush Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="114">	<name> Teleport			</name>	<alias> Teleport Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="115">	<name> Petrify			</name>	<alias> Petrify Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="116">	<name> Web				</name>	<alias> Web Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="117">	<name> Clean			</name>	<alias> Clean Shrapnel		</alias> <code>	0	</code>	<category> system 	 </category> </Key>
		<Key ID="118">	<name> RightClick		</name>	<alias> Right Click			</alias> <code>	70	</code>	<category> system 	 </category> </Key>
		<Key ID="119">	<name> MiddleClick		</name>	<alias> Middle Click		</alias> <code>	90	</code>	<category> system 	 </category> </Key>
		<Key ID="120">	<name> Radiation		</name>	<alias> Radiation Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="121">	<name> Landslide		</name>	<alias> Landslide Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="122">	<name> Blight			</name>	<alias> Blight Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="123">	<name> Adrenaline		</name>	<alias> Adrenaline Power	</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="124">	<name> Droner			</name>	<alias> Droner Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="125">	<name> Tidal			</name>	<alias> Tidal Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="126">	<name> Napalm			</name>	<alias> Napalm Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="127">	<name> Bling			</name>	<alias> Bling Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="128">	<name> Shockwave		</name>	<alias> Shockwave Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="129">	<name> Steam			</name>	<alias> Steam Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="130">	<name> Noise			</name>	<alias> Noise Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="131">	<name> Pierce			</name>	<alias> Pierce Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="132">	<name> ResetRagdoll		</name>	<alias> Clean Alive			</alias> <code>	0	</code>	<category> system 	 </category> </Key>
		<Key ID="133">	<name> Animate			</name>	<alias> Animate Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="134">	<name> Banish			</name>	<alias> Banish Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="135">	<name> Bleed			</name>	<alias> Bleed Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="136">	<name> Cookie			</name>	<alias> Cookie Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="137">	<name> Crash			</name>	<alias> Crash Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="138">	<name> ERROR			</name>	<alias> ERROR Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="139">	<name> Faceplant		</name>	<alias> Faceplant Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="140">	<name> Forcefield		</name>	<alias> Forcefield Power	</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="141">	<name> Frostfire		</name>	<alias> Frostfire Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="142">	<name> Deepfry			</name>	<alias> Deepfry Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="143">	<name> Ghost			</name>	<alias> Ghost Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="144">	<name> Gib				</name>	<alias> Gib Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="145">	<name> Glass			</name>	<alias> Glass Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="146">	<name> Glitch			</name>	<alias> Glitch Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="147">	<name> Implode			</name>	<alias> Implode Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="148">	<name> Lava				</name>	<alias> Lava Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="149">	<name> Mutate			</name>	<alias> Mutate Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="150">	<name> Protect			</name>	<alias> Protect Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="151">	<name> Sandstone		</name>	<alias> Sandstone Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="152">	<name> Tornado			</name>	<alias> Tornado Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="153">	<name> Upgrade			</name>	<alias> Upgrade Power		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="154">	<name> PowerPrev		</name>	<alias> Previous Power		</alias> <code>	0	</code>	<category> system 	 </category> </Key>
		<Key ID="155">	<name> PowerNext		</name>	<alias> Next Power			</alias> <code>	0	</code>	<category> system 	 </category> </Key>
		<Key ID="156">	<name> Dice				</name>	<alias> Dice Power			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="157">	<name> Update			</name>	<alias> Update				</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="158">	<name> Roleplay			</name>	<alias> Doll Drag Tool		</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="159">	<name> Ignore			</name>	<alias> Ignore Tool			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="160">	<name> PistonJoint		</name>	<alias> Piston Joint		</alias> <code>	0	</code>	<category> joint 	 </category> </Key>
		<Key ID="161">	<name> Spawn			</name>	<alias> Spawn Item			</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="162">	<name> Particles		</name>	<alias> Confetti			</alias> <code>	0	</code>	<category> debug 	 </category> </Key>
		<Key ID="163">	<name> Camera			</name>	<alias> Camera Tool			</alias> <code>	90	</code>	<category> tool 	 </category> </Key>
		<Key ID="164">	<name> CameraToggle		</name>	<alias> Camera Tool Toggle	</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="165">	<name> Stab				</name>	<alias> Stab Tool			</alias> <code>	72	</code>	<category> tool 	 </category> </Key>
		<Key ID="166">	<name> PowerMenu		</name>	<alias> Power Menu			</alias> <code>	0	</code>	<category> menu 	 </category> </Key>
		<Key ID="167">	<name> JointMenu		</name>	<alias> Joint Menu			</alias> <code>	0	</code>	<category> menu 	 </category> </Key>
		<Key ID="168">	<name> ToolMenu			</name>	<alias> Tool Menu			</alias> <code>	0	</code>	<category> menu 	 </category> </Key>
		<Key ID="169">	<name> SpawnRandom		</name>	<alias> Spawn Random		</alias> <code>	0	</code>	<category> system 	 </category> </Key>
		<Key ID="170">	<name> Explode			</name>	<alias> Explode				</alias> <code>	0	</code>	<category> tool 	 </category> </Key>
		<Key ID="171">	<name> QuickSpawn		</name>	<alias> Quick Spawn			</alias> <code>	13	</code>	<category> system 	 </category> </Key>
		<Key ID="172">	<name> QuickDelete		</name>	<alias> Quick Delete		</alias> <code>	46	</code>	<category> system 	 </category> </Key>
		<Key ID="173">	<name> RightClickPause	</name>	<alias> Right Click Pause	</alias> <code>	77	</code>	<category> system 	 </category> </Key>
		<Key ID="174">	<name> Freeze			</name>	<alias> Freeze				</alias> <code>	78	</code>	<category> system 	 </category> </Key>
		</Keys>;
      
      private static var _keymapobj:Object = {};
      
      public function Keymap()
      {
         super();
         var _loc1_:String = Capabilities.os;
         isMac = _loc1_.indexOf("Mac") == 0;
      }
      
      public static function setKeymap(param1:String = "default") : Boolean
      {
         var _loc5_:RegExp = null;
         var _loc6_:* = undefined;
         var _loc2_:Array = [];
         if(param1 == "default")
         {
            _loc2_ = Keymap.getDefault().split("|");
         }
         else
         {
            _loc5_ = /^[0-9\|]*$/;
            if(!_loc5_.test(param1))
            {
               return false;
            }
            _loc2_ = param1.split("|");
         }
         if(_loc2_.length <= 1)
         {
            return false;
         }
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = _loc2_[_loc4_];
            if(_loc6_ != "-")
            {
               Keymap.setKeyByID(_loc4_,int(_loc6_));
            }
            _loc4_++;
         }
         return true;
      }
      
      public static function init() : *
      {
         updateObj();
         defaultKeymap = getString();
      }
      
      public static function setKeyByID(param1:int, param2:int) : void
      {
         var name:String = null;
         var ID:int = param1;
         var code:int = param2;
         keymapxml.Key.(@ID == ID).code = code;
         name = IDToName(ID);
         if(Boolean(name) && Boolean(_keymapobj))
         {
            _keymapobj[name] = code;
         }
      }
      
      public static function setKeyByName(param1:String, param2:int) : void
      {
         var keyname:String = param1;
         var code:int = param2;
         keymapxml.Key.(name.toLowerCase() == keyname.toLowerCase()).code = code;
         _keymapobj[keyname.toLowerCase()] = code;
      }
      
      public static function IDToName(param1:int) : String
      {
         var id:int = param1;
         var name:* = "";
         if(Boolean(keymapxml.Key.(@ID == id)) && keymapxml.Key.(@ID == id).length() > 0)
         {
            name = String(keymapxml.Key.(@ID == id).name).toLowerCase();
         }
         return name;
      }
      
      public static function IDToAlias(param1:int) : String
      {
         var id:int = param1;
         return String(keymapxml.Key.(@ID == id).alias);
      }
      
      public static function nameToCode(param1:String) : int
      {
         return _keymapobj[param1.toLowerCase()];
      }
      
      public static function findKeys(param1:int) : *
      {
         var keyCode:int = param1;
         return keymapxml.Key.(code == keyCode);
      }
      
      public static function codeToKeyname(param1:Number) : String
      {
         if(param1 < 0)
         {
            return codeToKeyname(param1 * -1) + "*";
         }
         if(param1 == 0)
         {
            return "Not Mapped";
         }
         if(param1 == 16)
         {
            return "Shift";
         }
         if(param1 == 17)
         {
            return isMac ? "Cmd" : "Ctrl";
         }
         if(param1 == 19)
         {
            return "Pause";
         }
         if(param1 == 20)
         {
            return "Caps Lock";
         }
         if(param1 == 27)
         {
            return "Esc";
         }
         if(param1 == 46)
         {
            return "Del";
         }
         if(param1 == 45)
         {
            return "Insert";
         }
         if(param1 == 32)
         {
            return "Space";
         }
         if(param1 == 13)
         {
            return "Enter";
         }
         if(param1 == 36)
         {
            return "Home";
         }
         if(param1 == 35)
         {
            return "End";
         }
         if(param1 == 33)
         {
            return "Page Up";
         }
         if(param1 == 34)
         {
            return "Page Down";
         }
         if(param1 == 37)
         {
            return "Left";
         }
         if(param1 == 38)
         {
            return "Up";
         }
         if(param1 == 39)
         {
            return "Right";
         }
         if(param1 == 40)
         {
            return "Down";
         }
         if(param1 == 8)
         {
            return "Backspace";
         }
         if(param1 == 9)
         {
            return "TAB";
         }
         if(param1 == 188)
         {
            return ",";
         }
         if(param1 == 190)
         {
            return ".";
         }
         if(param1 == 191)
         {
            return "/\'";
         }
         if(param1 == 189)
         {
            return "-";
         }
         if(param1 == 187)
         {
            return "+";
         }
         if(param1 == 192)
         {
            return "Ö";
         }
         if(param1 == 222)
         {
            return "Ä";
         }
         if(param1 == 221)
         {
            return "Å";
         }
         if(param1 == 96)
         {
            return "N0";
         }
         if(param1 == 97)
         {
            return "N1";
         }
         if(param1 == 98)
         {
            return "N2";
         }
         if(param1 == 99)
         {
            return "N3";
         }
         if(param1 == 100)
         {
            return "N4";
         }
         if(param1 == 101)
         {
            return "N5";
         }
         if(param1 == 102)
         {
            return "N6";
         }
         if(param1 == 103)
         {
            return "N7";
         }
         if(param1 == 104)
         {
            return "N8";
         }
         if(param1 == 105)
         {
            return "N9";
         }
         if(param1 == 106)
         {
            return "N*";
         }
         if(param1 == 107)
         {
            return "N+";
         }
         if(param1 == 109)
         {
            return "N-";
         }
         if(param1 == 110)
         {
            return "N.";
         }
         if(param1 == 111)
         {
            return "N/";
         }
         if(param1 > 111 && param1 < 124)
         {
            return "F" + String(param1 - 111);
         }
         return String.fromCharCode(param1);
      }
      
      public static function getCategoryByName(param1:String) : String
      {
         var keyname:String = param1;
         return keymapxml.Key.(name.toLowerCase() == keyname.toLowerCase()).category;
      }
      
      public static function getDefault() : String
      {
         return defaultKeymap;
      }
      
      public static function getString() : String
      {
         var key:XML = null;
         var j:* = undefined;
         var str:String = "";
         var i:int = 0;
         for each(key in keymapxml.Key)
         {
            if(key.@ID == i)
            {
               str += key.code.text() + "|";
            }
            else
            {
               j = key.@ID;
               while(key.@ID != i)
               {
                  str += "-|";
                  i++;
               }
               str += key.(@ID == j).code.text() + "|";
            }
            i++;
         }
         return str.slice(0,-1);
      }
      
      public static function updateKeymap(param1:String) : String
      {
         var _loc2_:Array = param1.split("|");
         var _loc3_:Array = getString().split("|");
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = int(_loc3_.length);
         if(_loc5_ <= _loc4_)
         {
            return param1;
         }
         _loc2_ = _loc2_.concat(_loc3_.slice(_loc4_,_loc5_));
         return _loc2_.join("|");
      }
      
      public static function updateObj() : void
      {
         var _loc1_:XML = null;
         for each(_loc1_ in keymapxml.Key)
         {
            _keymapobj[String(_loc1_.name.text()).toLowerCase()] = int(_loc1_.code.text());
         }
      }
      
      public static function get KeymapObj() : Object
      {
         return _keymapobj;
      }
   }
}

