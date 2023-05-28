//Made by SomeRandomGodDamnFurry

// Example for a 201mm barrel rifled for 9x19.
// A positive value for expasion will add to the modified dimension while a negative value will shrink it.
// All Dimensions are in millimeter unless otherwisee specified.

// Just as a note, calipers aren't great at measuring distances smaller than 0.05 millimeter. 
// If you want to be super accurate, grab a cheap pair of digital micrometers and hole guages. 
// This isn't super necessary but it makes life alot easier.

// For 9x19, the land diameters given by ecm V2 are 9.3mm. In V3.5, its 9.11mm and an experimental 9.01mm. 
// Ivan gives a diamter of 9.3 for maximum safety with homemade ammo. 
// Meanwhile ImmortalRevolt gives 9.11 because it gives blends accuracy and safety. 
// The 9.01mm dimension is used in button rifled match barrels. In ECM, this is dimension is too small as it can cause blown out primers and exessive pressure.
// Thank you to ImmortalRevolt for explaining this to me.

// If you set the number of clamps to be the same as the number of lands, you can rotate your rifling jig between cuts. 
// This will help lessen the effects of marred or bent wire and give you cleaner rifling overall. 
// The initial cut times in the Doc are two sets of 5 minutes. You can break these down to 6 sets of 100 second cuts and rotate the mandrel between cuts.

/*
Q: The progressive twist is neat. How did you get OpenScad to do that?
A: With great fricken dificulty. 

Q: Why not just make this in a normal Cad program like Fusion360
A: Hell if I know. Guess I must be a masochist. 

Q: Can I request a feature? 
A: Sure. I'll probably ignore it though.

Q: I found a bug!
A: Refer to the documentation to ensure it is indeed a bug. My email is SomeRandomGodDamnFurry@proton.me 
   Email me as to what to do to recreate the bug and what you beleive the expected behavior should be.
   DO NOT use this email to ask for help with the code. Please find me on Detterance Dispensed chat or Element.io for that.

Q: Help, I can't figure out how to use the program.
A: Consult the docs. If you don't understand them, find someone who can explain it to you.
*/


//OpenScad Set up
inf = 1e200 * 1e200;
nan = 0/0; // Check for this by using x != x


// Sets whether or not the mandrel is shown segmented and ready for printing. The red bits are the boolean operators. 
Render_Sliced = true;   // Default false


//functions                      

function Wall_Thickness(
    numWall, 
    layer = Layer_Height, 
    exWidth = Extrusion_Width
    ) = 
    numWall == 1 ? exWidth
    :((round(100*(exWidth*numWall - ((layer*(1-PI/4)))*(numWall-1))))/100);
// Sets wall thickness based on Slic3r recomendations

function autoDet(percentExposure,manDia = Mandrel_Diameter+Mandrel_Diameter_Expansion, numLands = Number_Of_Lands) = manDia  * sin(((360*percentExposure)/numLands)/2);
// A value of 0.50 would mean that 50% of the barrel is exposed to be rifled. 0 would mean no barrel is exposed while 1 means the whole barrel would be exposed.
//Groove_Opening_Size can also be set manually. The value for the v2 guide was roughly 2.52


// Printer Specs:

// The line width you set your printer to extrude. Typical is usually 0.4 to 0.45 for 4mm nozzles. 
Extrusion_Width                 = 0.65;                                         
// The maximum hieght you are willing to print on your printer. Make sure you printer can be commanded to this Length without maxing out.
Max_Print_Height                = 240;                                          
// You must set this layer height to the layer height you use in your slicer.
Layer_Height                    = .2;                                           

// Mandrel Setup:

// End to end Length of the barrel
Barrel_Length                   = 200.0;                                          
// This sets the amount of round bar the mandrel that interfaces with the other end of the barrel
Mandrel_Interface_Extra         = 10.0;                                           
// The amount of extra rifling on the mandrel. This number does not effect the progressive rifling twist. It is added after all other rifling has been generated.
Mandrel_Rifling_Extra           = 7.0;                                            

// Diameter of the bored barrel. 9x19 is normally 8.82
Mandrel_Diameter                = 8.82;                                         
// This modifies the diameter of the jig.
Mandrel_Diameter_Expansion      = 0.02;                                         
// Specified by number of wall: This sets the large Diameter where the bundle of wires sit. This is poorly worded but you can probably figure it out.
Id_Of_Mandrel                   = Mandrel_Diameter - 2*Wall_Thickness(2);          
// Number of lands in the barrel. The default is 6.
Number_Of_Lands                 = 7;                                            
// This partially sets the thickness of your groove. Setting to a value of "autoDet(Value))" will use a function to determine this number. It can also be set manually.
Groove_Opening_Size             = autoDet(percentExposure = 0.55);              
// There is a small flat that runs perpedicular between the wall and copper wire. This number effects that. It doesn't do much except seem like a good idea and be hell to program.
Flat_Wall_Distance              = .3;                                           
// Degrees: This sets the amount of wire exposed. The lower the number, the less wire is exposed but the easier it is to install. 180 would leave no wire retention but maximum exposure.
Angle_Of_Exposed_Wire           = 90;    

// Progressive Rifling Twist
        // Twist rates are entered as Twist:Inch. So 1 twist per 10 inches would be entered as 1:10. A twist rate of Zero would be entered as 0.
        // If you do not care about progressive rifling, enter the desired twist rate for both the starting and ending twist rate and set the distances to 0.1mm
        // The rifling length is the Barrel_Length - (Chamber_Length + Chamber_Extra_Protection)
        // The distance in between the starting and ending distance is used to smooth the transistion between twist rates. You want this to be as much room as practicle for this.


// This is the twist rate that you want the bullet to start with. For a 1:10, you would type 10. For a 1:15, you would type 20. For no twist rate, type 0.
Starting_Twist_Rate             = 20.0;                                               
// This is how long that twist rate is held before the transition to the ending twist rate is started
Starting_Distance               = 20.0;                                               

// This is the final twist rate of the barrel. Set this to what ever is reccomended for you caliber. 9x19 has a twist rate of 1:10
Ending_Twist_Rate               = 10.0;                                               
// This is the length that the barrel holds the final twist rate. I like to keep about 20mm to 60mm of the final twist rate.
Ending_Distance                 = 20.0;        

//Chamber Settings

// Length of the final chamber
Chamber_Length                  = 15.95;                                        
// Extra Length added to protect the chamber from the rifling process
Chamber_Extra_Protection        = 1.55;                                         
// Specified by number of walls: The thickness of the plastic between the wire and the chamber walls. 
Chamber_Insulation_Wall_Thickness= 1;

Chamber_Insulation_Thickness    = Wall_Thickness(Chamber_Insulation_Wall_Thickness);  

// Barrel Clamp Settings:

// Outside diameter of the tube you are making a barrel
Barrel_Od                       = 16.0;                                           
// This modifies the diameter of the clamp.
Barrel_Od_Expansion             = 0.5;                                          
// The thickness of the clamps for the barrel
Clamp_Thickness                 = 4.75;                                         
// Length of the clamping fingers
clamp_Length                    = 25.0;                                           
// I reccomend making the same number of clamps as you have lands. See the blurb at the top for the explanation.
Number_Of_Clamps                = Number_Of_Lands;                              
// Thickness of the base that the rifling and clamps are attached too.
Base_Thickness                  = 6.0;                         

//Build Plate Adhesion:

// Specified by number of Layers: Thickness of the bed support. 
Bed_Support_Layer_Count         = 15;
// Number of layers that interface with the mandrel. More give a stronger bond but make them harder to remove.
Bed_Interface_Layer_Count       = 3;
// This sets how long each support is.
Bed_Support_Length              = 10.0;
// The distance from the bed bed support the the mandrel. A smaller gap means a better grip but makes the harder to remove
Bed_To_Mandrel_Interface        = 0.02;
// The gap between bed peices. A smaller gap will give more grip.
Bed_To_Bed_Interface            = 0.02;
// Sets the angle of slope from the bottom of the bed interface to the bottom to the bed support. 90 is vertical.
Bed_Support_Slope_Angle         = 60.0;

Bed_Support_Interface_Thickness = Bed_Interface_Layer_Count*Layer_Height;
Bed_Support_Thickness = Bed_Support_Layer_Count*Layer_Height;

//Z support settings:

// Length of the support for the x/y axis
Zed_Support_Length              = 10.0;                                           
// Distance between the x/y axis support and the mandrel. A higher value makes it easier to remove but lessens its ability to adhere to the model.
Zed_To_Mandrel_Interface        = 0.02;                                         
// Changes gap between the supports. A higher value means it can be removed more easily while a lower value means they stick together better.
Zed_To_Zed_Interface            = 0.02;                                         
// Specified by number of Layers: The thickness for the interface between the x/y supports and the Mandrel.
Zed_Sup_Interface_Layer_Count   = 2;   
// Specified by number of Layers: The Thickness for the x/y supports.
Zed_Sup_Layer_Count             = 5;
// If the tallest support is closer to the top then the set value, the support will not be generated.
Zed_Min_Distance_From_Top       = 15.0;
// Sets the angle of slope from the bottom of the zed interface to the bottom to the zed support. 90 is vertical.
Zed_Support_Slope_Angle         = 60.0;
// The Z distance (hieght) between xy supports. These allow you to print a tall and thin part without too much wobble. 
Distance_Between_Supports       = 50.0;                                           
// I recomemend 75mm for a standard ender 3. If you see the part wobble as it prints, I reccomend decreasing this number. 
// A higher number will decrease the amount of supports and increase the the distance between them. A lower number does the opposite. 


Zed_Support_Interface_Thickness = Layer_Height*Zed_Sup_Interface_Layer_Count;
Zed_Support_Thickness           = Layer_Height*Zed_Sup_Layer_Count;

// Alignment Pin Settings:

// This is the diameter of the hole put in the top and bottom of slices. It helps when you glue sliced mandrel bits together.
Alignment_Hole_Diameter         = 2.5;
// This is the depth of the alignemnt hole.
Alignment_Hole_Depth            = 10.0;



// Wire Settings:

// Wire Diameter in mm. 20 awg is 0.81 while 18 awg is 1.02
Wire_Diameter                   = 1.02;                                         
// This modifies the diameter of the hole for the wire. The smaller this number, the more wire control but the harder it is to install.
Wire_Hole_Expansion             = 0.15;                                         
// Depth of the wire in the Mandrel
Wire_Depth                      = 1.76;   
                                            
//Quality Settings:

// This effects how many itterations the program does on the rifling, a higher number will give you a smoother twist.
Number_Of_Slices                = 128;                                              

// This effects how many points are generated with each curve.
GenericResolution               = 32;


// Spaghetti Code to make the Mandrel

//Function Creation

    function numSlicesNeeded ( //Number of slices needed to keep the mandrel height below the max height of printer
        maxHeight = Max_Print_Height,
        mandrelHeight = Barrel_Length+Mandrel_Interface_Extra+Mandrel_Rifling_Extra+Base_Thickness
    ) = 
    ceil(mandrelHeight/maxHeight);

    function flipList(inputList) = [for (i=[0:len(inputList)-1]) inputList[(len(inputList)-i-1)]];

    function arcAngle(dia,chord) = acos((2*(dia^2/4)-chord^2)/(2*(dia^2/4)));
    // Finds the angle for an arc from the diameter and the chord lenght (strait line lenght from start of arc to end)
    
    function chordLength(dia, angl) = (dia/2)*(sqrt((1-cos(angl))^2+sin(angl)^2));


    function arcPieGenerationFunction(theOrigin, numPoints, dia, arcAng, degOfRot) = [for (theta=([for (i = [0:(numPoints - 1)]) i*(arcAng/(numPoints - 1))+degOfRot])) [(dia/2)*cos(theta), (dia/2)*sin(theta)],theOrigin];
    // Same as the module but outputs a list of points

    function arcGenerationFunction(numPoints, dia, arcAng, degOfRot) = [for (theta=([for (i = [0:(numPoints - 1)]) i*(arcAng/(numPoints - 1))+degOfRot])) [(dia/2)*cos(theta), (dia/2)*sin(theta)]];
    // Same as arcPieGenerationFunction but does not need have the origin point

    function orderGeneration(listToBeCounted, startPointFinder) = [for (i=[0:len(listToBeCounted)-1]) i+max(startPointFinder)+1];
    //Creates a list of numbers that counts points. If given a second list, it starts at 1+ the largest number.

    function translate2D(x,y,listToMove) = 
        [for (i=[0:len(listToMove)-1]) 
            [listToMove[i][0]+x,listToMove[i][1]+y]];
    //Like Translate except it moves a 2d list on a 2d plane

    function translate3D(xyz,listToMove) = // Takes a list in [x,y,z] form and uses that for the translations
    [for (i=[0:len(listToMove)-1]) 
        [for (a = [0:2])
            if (listToMove[i][a] == undef) xyz[a]
            else listToMove[i][a] + xyz[a]]];
    //Just adding a Z axis translation. No, I'm not combing 2D with this. Fite me.

    function rotato(angle,listToMove) = // Takes a list in [x,y,z] form and uses that for the translations // Must be an xyz coordinate
        errSetZero(angle) == 0 ? listToMove // If the angle comes back as zero, it returns the original list.
        :[for (i=[0:len(listToMove)-1]) 
        [
            cos(angle)*(listToMove[i][0])-sin(angle)*(listToMove[i][1]), sin(angle)*(listToMove[i][0])+cos(angle)*(listToMove[i][1]), listToMove[i][2]] // Calculates the new posistion of the point using vector math stuffs
        ];

    function errSetZero(val) = // Sets error values to zero
        val == inf ? 0 // Divide by zero error
        :val == undef ? 0 // Undefined number error
        :val != val ? 0 // Nan error
        :val ; // Returns value if it is not an error listed above


    function wirePathFuc( //Condensing the Wirepath Module into an unreadable function for iteration purposes. This is just as cancerous as it looks.  | Update, I just learned that the let() function exist. I'll fix this later. Probably.
    holeDia = (Wire_Diameter+Wire_Hole_Expansion),   // Now that I know about let, I should fix this code.
    wireDepth = Wire_Depth, 
    flatSize = Flat_Wall_Distance, 
    manDia = (Mandrel_Diameter+Mandrel_Diameter_Expansion), 
    wireOpen = Angle_Of_Exposed_Wire, 
    groveWidth = Groove_Opening_Size, 
    landCount = Number_Of_Lands,) 
    = 
    let(
        rotAngle = (360/landCount), //This calulcates the arc angle from the center of the rod between the opening at the edge. Confused? Dont worry, I am too. Just mess with it and you find out what it does. Hopefully.
        totAngle = rotAngle-arcAngle(manDia,groveWidth) // Gets the slices total angle. At 6 lands, this value is 60
    )
    [for( i = [0:Number_Of_Lands-1]) // Copies a section of the mandrel around the center to make the whole 2d slice
        let(
            // Creates the semi whole that the wire runs through
            wireHole = translate2D(x = (cos(i*rotAngle))*(manDia/2 - wireDepth), y = (sin(i*rotAngle))*(manDia/2 - wireDepth), listToMove = (arcGenerationFunction(numPoints = 32, dia = holeDia, arcAng = -(360-wireOpen), degOfRot = (rotAngle*i)-wireOpen/2))),
            // Generate the first curve from the right
            poly0 = arcGenerationFunction(numPoints = 6, dia = manDia, arcAng = (totAngle)/2, degOfRot = (rotAngle*i)-rotAngle/2), 
            // This duplicates the first point of the hole and moves it upwards so we have the flats.
            poly1 = translate2D(x = (cos(i*rotAngle))*(flatSize), y = (sin(i*rotAngle))*(flatSize), listToMove = [wireHole[0]]), 
            // Add the semi hole to the order
            poly2 = wireHole,
            // Moves the last point of the semi hole to make a flat on the other side
            poly3 = translate2D(x = (cos(i*rotAngle))*(flatSize), y = (sin(i*rotAngle))*(flatSize), listToMove = [wireHole[len(wireHole)-1]]),
            // Generates the last curve of the arc
            poly4 = arcGenerationFunction(numPoints = 6, dia = manDia, arcAng = (totAngle)/2, degOfRot = (rotAngle*i)+(rotAngle-(totAngle))/2)
            )
        concat(poly0,poly1,poly2,poly3,poly4) // Adds all the points together into one list
    ];
    //echo(wirePathFuc());
    function wireStripper(wireFuc) = // This cleans up the output from wirePathFuc by unesting the list. The previous bit of code could only make a nested list as and output. This is my fix for that.
        [for ( i = [0:len(wireFuc)-1]) 
            for (a = [0:len(wireFuc[i])-1])
                wireFuc[i][a]
        ];
    
    function wirePathFinal(wireFuc = wireStripper(wirePathFuc())) = [wireFuc,orderGeneration(wireFuc,-1)]; // Generates the paths/faces to the previously generated points
    
    function faceBuilderMk0(firstPath, secondPath) = // Sets must have the same number of points // Generates faces between four points of the polygon at a time
        [for (i = [0:len(firstPath)-2])
            [firstPath[i],secondPath[i],secondPath[i+1],firstPath[i+1]]
        , [firstPath[(len(firstPath)-1)],secondPath[(len(secondPath)-1)],secondPath[0],firstPath[0]]];

    function bulkPathGeneration(listToBeCounted, startPointFinder) = 
        let(startPoint =max(startPointFinder)+1 )
            [for (i = [0:len(listToBeCounted)-1])
                [for (a = [0:len(listToBeCounted[i])-1]) i*len(listToBeCounted[i])+a+startPoint]]; //Takes a list of faces and generates paths for them

    function standardTwistGeneration(Poly2D, givenTwist, twistDist, slices, zOffsetIn) =  // This increases the twist rate a linear amount 
        // Start == End -> Generates with twist given
        [let (
            distBetweenSlice = twistDist/slices, 
            twistPerSlice = errSetZero((twistDist*360)/(givenTwist*25.4))/slices, 
            zOffset = errSetZero(zOffsetIn)) 
            for (i = [0:slices]) 
                rotato(twistPerSlice*i,translate3D(xyz = [0,0,(distBetweenSlice*i)+zOffset], listToMove = Poly2D))];



   function faceBuilderMk1(pointList) =  //Make the faces along multiple slices. Does not make the top or bottom face. //Needs in form [[orderList1],[orderList2],...]
        let (itter = len(pointList)) 
        [
            for (i = [0:itter-2])
               faceBuilderMk0(pointList[i],pointList[i+1])
        ];

    function additiveCondenser (inputList) =  //This takes a list of lists and add them together from back to front. [0,1,2,3] and [1,2] would add together to form [0,1,3,5]
        [
        len(inputList) > 2 ? wireStripper(additiveCondenser([inputList[0] + inputList[1], for (i = [2:len(inputList)-1]) inputList[i]]))
        : len(inputList) == 2 ? wireStripper([inputList[0] + inputList[1]])
        : inputList
        ];

    function cumulativeGeneration(inputList) =  // Makes a list series that the addative condesor can deal with. generates [[1,3,4,5],[1,2,5,6],[1,2,3,7]] from [1,2,3,4]
        [
        inputList, for (i = [0:len(inputList)-2])
            [for (a = [(0):len(inputList)-1])
                a <= i ? 0
                :inputList[i]]
        ];


    function twistAnglesListGeneration(twistDist, startTwist, endTwist, slices, zOffsetIn) = //Makes a list with linearly increasing angles. The angles are not cumulative.
        [let (
                distBetweenSlice = twistDist/(slices),  
                zOffset = errSetZero(zOffsetIn),
                x1 = 0,
                x2 = twistDist,
                y1 = errSetZero((distBetweenSlice*360)/(startTwist*25.4)),
                y2 = errSetZero((distBetweenSlice*360)/(endTwist*25.4)),
                slope = (y1-y2)/(x1-x2)
            ) 
                for (i = [0:slices]) 
                    slope*(i*distBetweenSlice-x2)+y2 
        ]
    ;

    function linearTwistGeneration(Poly2D, startTwist, endTwist, twistDist, slices, zOffsetIn) =  // This increases the twist rate a linear amount 
        // Start == End -> Generates with twist given
        startTwist == endTwist ? 
            [let (
                distBetweenSlice = twistDist/slices, 
                twistPerSlice = errSetZero((twistDist*360)/(startTwist*25.4))/slices, 
                zOffset = errSetZero(zOffsetIn)) 
                for (i = [0:slices]
                ) 
                    rotato(twistPerSlice*i,translate3D(xyz = [0,0,(distBetweenSlice*i)+zOffset], listToMove = Poly2D))]
        // Start != End --> increment twist rate
        :
        [let (
                distBetweenSlice = twistDist/(slices),  
                zOffset = errSetZero(zOffsetIn),
                x1 = 0,
                x2 = twistDist,
                y1 = (distBetweenSlice*360)/(startTwist*25.4),
                y2 = ((distBetweenSlice*360)/(endTwist*25.4)),
                slope = (y1-y2)/(x1-x2),
                angleList = wireStripper(additiveCondenser(cumulativeGeneration(twistAnglesListGeneration(twistDist, startTwist, endTwist, slices, zOffsetIn)))) // One massive line to generate the list of angles and iterativly add them together

            ) 
                for (i = [0:len(angleList)-1]) 
                    rotato(angleList[i]-angleList[0],translate3D(xyz = [0,0,(distBetweenSlice*i)+zOffset], listToMove = Poly2D))
        ]
            ;

    function shellFuc(Poly2D, startTwist, endTwist, twistDist, slices, zOffsetIn) =  // This increases the twist rate a linear amount 
        [let (
                distBetweenSlice = twistDist/(slices),  
                zOffset = errSetZero(zOffsetIn),
                x1 = 0,
                x2 = twistDist,
                y1 = (distBetweenSlice*360)/(startTwist*25.4),
                y2 = ((distBetweenSlice*360)/(endTwist*25.4)),
                slope = (y1-y2)/(x1-x2),
                angleList = twistAnglesListGeneration(twistDist, startTwist, endTwist, slices, zOffsetIn)
            ) 
                wireStripper(additiveCondenser(cumulativeGeneration(twistAnglesListGeneration(twistDist, startTwist, endTwist, slices, zOffsetIn)))) // One massive line to generate the list of angles and iterativly add them together
                        
    ];

    function progressiveRotationCalculator(distance, startTwist = Starting_Twist_Rate, endTwist = Ending_Twist_Rate, riflingLength = Barrel_Length - (Chamber_Length + Chamber_Extra_Protection), startDist = Starting_Distance,endDist = Ending_Distance) =  // This increases the twist rate a linear amount 
        // Start == End -> Generates with twist given
        startTwist == endTwist ? 
            (distance/(startTwist*25.4))*360
        // Start != End --> increment twist rate
        :
        let (
                x1 = 0,
                x2 = riflingLength - startDist - endDist,
                y1 = errSetZero((360)*(1/(startTwist*25.4))),
                y2 = errSetZero((360)*(1/(endTwist*25.4))),
                slope = (y1-y2)/(x1-x2)
            ) 
                (slope*distance^2)/2+y1*distance
            ;

    function angleAtHeight(CurrentDist,baseThicc = Base_Thickness,chamProtec = Chamber_Extra_Protection + Chamber_Length,startDist = Starting_Distance,endDist = Ending_Distance,rifleExtra = Mandrel_Rifling_Extra, riflingLength = Barrel_Length - (Chamber_Length + Chamber_Extra_Protection))= 
        let ( //Output the angle that the lands have been rotated.
            startingRotation = -90, // Starting rotation is the angle that the rifling should start at.
            startRiflingFinalRotation = startingRotation + 360*(startDist/(Starting_Twist_Rate*25.4)), // This is the angle that the starting rifling ends at.
            progressiveFinalRotation = startRiflingFinalRotation + (progressiveRotationCalculator(riflingLength - startDist - endDist)), // This is the angle that the progressive rifling ends at.
            endRiflingFinalRotation = progressiveFinalRotation + 360*(endDist/(Ending_Twist_Rate*25.4)),  // This is the angle that the ending rifling ends at.
            progDist = riflingLength - startDist - endDist
        )
            CurrentDist <= baseThicc + chamProtec? startingRotation: // This sets the rotation value for anything shorter than the chamberInsulation to zero
            CurrentDist > baseThicc && CurrentDist <= baseThicc+chamProtec+startDist ? startingRotation + 360*((CurrentDist-(baseThicc + chamProtec))/(Starting_Twist_Rate*25.4)): // This finds the rotation value for any value within the starting twist
            CurrentDist > baseThicc+chamProtec+startDist && CurrentDist <= baseThicc+chamProtec+startDist+progDist ? startRiflingFinalRotation + progressiveRotationCalculator((CurrentDist-(baseThicc+chamProtec+startDist))): // This finds the rotation value for any value within the progressive twist
            CurrentDist > baseThicc+chamProtec+startDist+progDist && CurrentDist <= baseThicc+chamProtec+startDist+progDist+endDist ? progressiveFinalRotation + 360*((CurrentDist-(baseThicc+chamProtec+startDist+progDist))/(Ending_Twist_Rate*25.4)): // This finds the rotation value for any value within the ending twist
            CurrentDist > baseThicc+chamProtec+startDist+progDist+endDist && CurrentDist <= baseThicc+chamProtec+startDist+progDist+endDist+rifleExtra ? endRiflingFinalRotation + 360*((CurrentDist-(baseThicc+chamProtec+startDist+progDist+endDist))/(Ending_Twist_Rate*25.4)) : // This finds the rotation value for any value within the rifleExtra
            0;
    

    //Module Creation

    module arcPieGenerationModule( // origin = is the first point placed [0,0], numpoints = number of total points in the arc | dia = the diameter of the arc | ArcAngle = the total 
        theOrigin, 
        numPoints, 
        dia, 
        arcAng, 
        degOfRot) 
        {
        rads = dia/2;
        numPoints = numPoints - 1;
        angles = [for (i = [0:numPoints]) i*(arcAng/numPoints)+degOfRot];
        coords = [for (theta=angles) [rads*cos(theta), rads*sin(theta)],theOrigin];
        polygon(coords);
    }
    
    module wirePath( //Makes one section of the 2D shape of the wire part of the Mandrel

        holeDia = (Wire_Diameter+Wire_Hole_Expansion), 
        wireDepth = Wire_Depth,
        flatSize = Flat_Wall_Distance, 
        manDia = (Mandrel_Diameter+Mandrel_Diameter_Expansion), 
        wireOpen = Angle_Of_Exposed_Wire, 
        groveWidth = Groove_Opening_Size, 
        landCount = Number_Of_Lands) 
    {
        totAngle = (360/landCount)-arcAngle(manDia,groveWidth); // This calulcates the arc angle from the center of the rod between the opening at the edge. Confused? Dont worry, I am too. Just mess with it and you find out what it does. Hopefully.
        rotAngle = 360/landCount; // Gets the slices total angle. At 6 lands, this value is 60
        poly0old = arcGenerationFunction(numPoints = 6, dia = manDia, arcAng = totAngle/2, degOfRot = 90-rotAngle/2); // Generate the first curve from the right
        poly0 = concat([[0,0]],poly0old); //Add a point at the origin
        order0 = orderGeneration(poly0, -1); //Add and order to the points so OpenScad has a path to follow
        poly1old = arcGenerationFunction(numPoints = 32, dia = holeDia, arcAng = -(360-wireOpen), degOfRot = 90-wireOpen/2); //Generate the points for the semi hole that the wire runs through. This places the center of the hole at origin.
        poly1 = translate2D(x = 0, y = manDia/2 - wireDepth, listToMove = poly1old); // This moves the center of the hole we just generated to the correct depth of the mandrel
        poly2 = translate2D(x = 0, y = flatSize, listToMove = [poly1[0]]); // This duplicates the first point of the hole and moves it upwards so we have the flats.
        order2 =  orderGeneration(poly2, order0); // This generates the number for point we just moved first. If we don't OpenScad draws the lines imporperly.
        order1 = orderGeneration(poly1, order2);  // This generates the paths/faces for the wire hole. It does this after the numbers were given to the point we moved.
        poly3 =  translate2D(x = 0, y = flatSize, listToMove = [poly1[len(poly1)-1]]); // This copies the last point of the wire hole and moves it upwards.
        order3 = orderGeneration(poly2, order1); // This add the path value to the prevois point generated
        poly4 = arcGenerationFunction(numPoints = 6, dia = manDia, arcAng = totAngle/2, degOfRot = 90+(rotAngle-totAngle)/2); //this generates the curve on the lest side
        order4 = orderGeneration(poly0, order3); // This gives the points thier path order
        a = concat(poly0, poly2, poly1, poly3, poly4); // This combines the list of all the points we just generated
        //echo(a); //This is for debugging
        b = [concat(order0, order2, order1, order3, order4, [0])]; // This combines the path data for all the points
        //echo(b); //This is also for debugging
        polygon(a,b); // This makes the polygon. Hurrah.
        //rotate(60) polygon(a,b); // This was a validation check. No parental Validation found.
    }

    
    module chamberInsulationGeneration (// Generates the wire insulation for the chamber

        holeDia = (Wire_Diameter+Wire_Hole_Expansion),
        manDia = (Mandrel_Diameter+Mandrel_Diameter_Expansion), 
        wireDepth = Wire_Depth,
        landCount = Number_Of_Lands,
        insulation = Chamber_Insulation_Thickness,
        landCount = Number_Of_Lands,
        chamberProtectionLength = Chamber_Length + Chamber_Extra_Protection
    )
    {
        rotAngle = 360/landCount;
        for (i=[0:landCount-1])
            rotate([0,0,-rotAngle*i-90])
                translate([0,manDia/2 - wireDepth,-chamberProtectionLength/2]) 
                    difference() {
                        cylinder(h = chamberProtectionLength, d = holeDia+2*insulation, center = true, $fn=GenericResolution);
                        cylinder(h = chamberProtectionLength+2, d = holeDia*1.002, center = true, $fn=GenericResolution);
                        }
    }

    module justTheTip( //Generate the hollow cylinder at the top of the model for the wire to sit
        manDia = (Mandrel_Diameter+Mandrel_Diameter_Expansion),
        extraLenth = Mandrel_Interface_Extra,
        id = Id_Of_Mandrel,
        zMove = Barrel_Length - (Chamber_Length+Chamber_Extra_Protection) + Mandrel_Rifling_Extra
    )
    {
        translate(v = [0,0,zMove])
            linear_extrude(height = extraLenth, slices=3) 
                difference() 
                {
                    circle(d=manDia, $fn=GenericResolution);
                    circle(d=id, $fn=GenericResolution);
                };
    }

    module baseOfMandrel ( //Creates the round base for the mandrel
        outDia = Barrel_Od+Barrel_Od_Expansion+Clamp_Thickness,
        zMove = -(Chamber_Length + Chamber_Extra_Protection + Base_Thickness),
        landCount = Number_Of_Lands,
        thickness = Base_Thickness,
        manDia = (Mandrel_Diameter+Mandrel_Diameter_Expansion), 
        wireDepth = Wire_Depth,
        insulation = Chamber_Insulation_Thickness,
        holeDia = Wire_Diameter + Wire_Hole_Expansion,
        grooveOpen = Groove_Opening_Size,
        wireOpen = chordLength(Wire_Diameter+Wire_Hole_Expansion,Angle_Of_Exposed_Wire),
        angExp = Angle_Of_Exposed_Wire,
        holeOff = Flat_Wall_Distance,
        insulationDia = Wire_Diameter + Wire_Hole_Expansion+2*Chamber_Insulation_Thickness
    ) 
    {
        outerAngleInwards = (((grooveOpen-wireOpen)/2)/(manDia/2));
        unfixThisValue = arcAngle(manDia, grooveOpen); //Arc angle calculation is hard for this one. Its a larger diamter than the hole because of the insulation. So some advanced trig needs to be done here.
        manToChord = cos(arcAngle(manDia, grooveOpen)/2)*manDia/2; // Calculates the distance from the center of the mandrel to the chord grooveOpen

        stanTheWaterMan = sqrt((insulationDia/2)^2-(wireOpen/2)^2)-cos(angExp/2)*(holeDia/2);

        polydrain = insulation<=holeOff ? 
            let(
                moveDist = -(holeOff-stanTheWaterMan), // Find the length from the outer diameter to the chord length and subtract it from holeOff
                innerArc = translate2D(0,(-(manDia/2-wireDepth+0.001)),arcGenerationFunction(numPoints = 16, dia = holeDia+2*insulation, arcAng = -arcAngle(insulationDia,wireOpen), degOfRot =-90+arcAngle(insulationDia,wireOpen)/2)),
                outerArc = translate2D(0,-manToChord,arcGenerationFunction(numPoints = 16, dia = grooveOpen, arcAng = 180, degOfRot = -90-180/2)) 
            )
                concat(innerArc,translate2D(x = 0, y = moveDist, listToMove = [innerArc[len(innerArc)-1]]),outerArc,translate2D(x = 0, y = moveDist, listToMove = [innerArc[0]]))
        :    
            let(
                distanceCentToWireToInChord = cos(angExp/2)*(holeDia/2), //This is the distance from the middle of the wire hole to the chord of the same hole
                distFromMandrelToOutChord = manDia/2-cos(arcAngle(manDia, grooveOpen)/2)*manDia/2, // This is the distance from the outer diameter of the mandrel to the chord for groove opening  
                firstPoint = [wireOpen/2,distanceCentToWireToInChord+holeOff], // x1 and y1 for point slope
                secondPoint = [grooveOpen/2,wireDepth-distFromMandrelToOutChord], // x2 and y2 for point slope
                mSlope = (firstPoint[1]-secondPoint[1])/(firstPoint[0]-secondPoint[0]),
                xSub2=secondPoint[0],
                ySub2=secondPoint[1],
                radi=insulationDia/2,
                //Behold. The cluster fuck. This finds the slope of the line between the edges of the chords wireOpen and groove open. It then combines this point slope formula with the equation for a circle to find the x distance of the crossing point. It then uses this to find the chord length appropriate for the insulation diameter.
                unfix = 2*((mSlope^2)*xSub2-mSlope*ySub2+sqrt(radi^2+(mSlope^2)*radi^2+2*mSlope*xSub2*ySub2-(mSlope^2)*xSub2^2-ySub2^2))/((mSlope^2)+1)
                )
            concat(translate2D(0,-manDia/2+wireDepth-0.001,arcGenerationFunction(numPoints = 16, dia = holeDia+2*insulation, arcAng = -arcAngle(insulationDia,unfix), degOfRot =-90+arcAngle(insulationDia,unfix)/2)),translate2D(0,-manToChord,arcGenerationFunction(numPoints = 16, dia = grooveOpen, arcAng = 180, degOfRot = -90-180/2)));

        
        //polydrain = concat(translate2D(0,-manDia/2+wireDepth-0.001,arcGenerationFunction(numPoints = 16, dia = holeDia+2*insulation, arcAng = -unfixThisValue2, degOfRot =-90+unfixThisValue2/2)),translate2D(0,-manToChord,arcGenerationFunction(numPoints = 16, dia = grooveOpen, arcAng = 180, degOfRot = -90-180/2)));
        polydrainPath = orderGeneration(polydrain,-1);
        rotAngle = 360/landCount;
        translate(v = [0,0,zMove])
            linear_extrude(height = thickness, slices=3) 
                difference()
                {
                    circle(d=outDia, $fn=GenericResolution);
                    for (i=[0:landCount-1])
                        rotate([0,0,-rotAngle*i-90])
                            translate([0,manDia/2 - wireDepth])
                                circle(d = holeDia, $fn=GenericResolution);
                    for (i=[0:landCount-1])            
                        rotate([0,0,-rotAngle*i+90])
                            polygon(polydrain,[polydrainPath]); //Mod This to where it equals the width of the groove and the depth. The width can be set by moving a section with the same arc length as the missing bit with the diameter of the outer mandrel to the correct position. Good luck.
                }
    }

    module clampGeneration( // Generates the clamps that hold the mandrel to the barrel
        clampLength = clamp_Length,
        clampThickness = Clamp_Thickness,
        numberOfClamps = Number_Of_Clamps,
        clampID = Barrel_Od + Barrel_Od_Expansion,
        zMove = -(Chamber_Length + Chamber_Extra_Protection)
    )
    {
        rotAngle = 360/numberOfClamps;
        clamps = concat(arcGenerationFunction(numPoints = 16, dia = clampID, arcAng = rotAngle/2, degOfRot = -90-rotAngle/4),arcGenerationFunction(numPoints = 16, dia = clampID+Clamp_Thickness, arcAng = -rotAngle/2, degOfRot = -90+rotAngle/4));
        clampsPath = orderGeneration(clamps,-1);
        translate(v = [0,0,zMove])
            linear_extrude(height = clampLength, slices=3) 
                difference()
                { 
                    for (i=[0:numberOfClamps-1])            
                        rotate([0,0,-rotAngle*i+90])
                            polygon(clamps,[clampsPath]); //Mod This to where it equals the width of the groove and the depth. The width can be set by moving a section with the same arc length as the missing bit with the diameter of the outer mandrel to the correct position. Good luck.
                }
    }

    module progressiveTwist( 
        startTwist = Starting_Twist_Rate, 
        startDist = Starting_Distance, 
        endTwist = Ending_Twist_Rate, 
        endDist = Ending_Distance,
        riflingLength = Barrel_Length - (Chamber_Length + Chamber_Extra_Protection),
        segments = Number_Of_Slices,
        riflingExtra = Mandrel_Rifling_Extra,
        chamberProtectionLength = Chamber_Length + Chamber_Extra_Protection) {
        
        
        //May God have mercy on my soul
        render(convexity = 10){
        progressiveDistance = riflingLength - startDist - endDist;// Length of the progressive rifling distance
        //echo(startTwist, endTwist, progressiveDistance);

        slicesForStart = round(segments*startDist/riflingLength);// Allocates slices based on the % share of length
        slicesForEnd = round(segments*endDist/riflingLength);// Same thing as the previous variable
        slicesForExtra = round(segments*riflingExtra/riflingLength); // Same thing but for the extra bit of rifling at the end
        slicesForChamber = round(segments*chamberProtectionLength/riflingLength);
        remainderForRest = segments - slicesForStart - slicesForEnd - slicesForExtra - slicesForChamber;

        rotForStart = errSetZero((startDist *360) / (startTwist*25.6)); //Converts inch to mm // Calculates the total angle needed to twist for the first segment
        rotForEnd = errSetZero(endDist *360)/(endTwist*25.4); // Does the same thing as rotForStart but on the second segment

        section2D =  wirePathFinal(); // Generates the 2d section of the rifling jig

        //Chamber Protection
        chamberSegment = (standardTwistGeneration(section2D[0], 0, chamberProtectionLength, slicesForChamber, -chamberProtectionLength)); // Makes the points that build the chamber portion. This does not add the insulation.
        chamberSegmentPath = wireStripper(faceBuilderMk1(bulkPathGeneration(chamberSegment,-1))); // Generates teh paths

        //Bottom face generation
        bottomFace = [section2D[1]]; //Sets the path for the bottom face by grabbing the pre-generated paths/faces

        //Starting Segment  
        startSegment = (standardTwistGeneration(chamberSegment[len(chamberSegment)-1], startTwist, startDist, slicesForStart)); // Makes the first twist section. 
        startSegmentPath = wireStripper(faceBuilderMk1(bulkPathGeneration(startSegment,max(wireStripper(chamberSegmentPath))))); // Generates all the paths/faces for the 3d shape and reformats them.

        //Progressive Segment
        progressiveSegment = (linearTwistGeneration(startSegment[len(startSegment)-1], startTwist, endTwist, progressiveDistance, remainderForRest)); // Makes the points for the progressive twist seciton
        progressiveSegmentPath = wireStripper(faceBuilderMk1(bulkPathGeneration(progressiveSegment,max(wireStripper(startSegmentPath))))); // Generates all the paths/faces for the 3d shape and reformats them.

        //End Segment
        endSegment = (standardTwistGeneration(progressiveSegment[len(progressiveSegment)-1], endTwist, endDist, slicesForEnd)); // Makes the points for ending twist section
        endSegmentPath = wireStripper(faceBuilderMk1(bulkPathGeneration(endSegment,max(wireStripper(progressiveSegmentPath))))); // Generates all the paths/faces for the 3d shape and reformats them.

        //Rifling Extra Bit
        riflingExtraSegment = (standardTwistGeneration(endSegment[len(endSegment)-1], endTwist, riflingExtra, slicesForExtra)); // Makes the points for extra twist section
        riflingExtraSegmentPath = wireStripper(faceBuilderMk1(bulkPathGeneration(riflingExtraSegment,max(wireStripper(endSegmentPath))))); // Generates all the paths/faces for the 3d shape and reformats them.

        topFace = [flipList(orderGeneration(riflingExtraSegment[len(riflingExtraSegment)-1],max(wireStripper(riflingExtraSegmentPath))-len(riflingExtraSegment[len(riflingExtraSegment)-1])))]; //Generates the last face of the rifling section

        totalPath = concat(bottomFace,chamberSegmentPath,startSegmentPath,progressiveSegmentPath,endSegmentPath,riflingExtraSegmentPath,topFace); //Adds all of the faces/paths into one list
        totalpoints = concat(wireStripper(chamberSegment),wireStripper(startSegment),wireStripper(progressiveSegment),wireStripper(endSegment),wireStripper(riflingExtraSegment)); //Creates a final list of points

        polyhedron(points = totalpoints, faces = totalPath, convexity = 10); //Generates the final shape

        }}

    module generateWhole ( // This generates the model in one module becasue its easier to work with this way.

    ){
        progressiveTwist();
        chamberInsulationGeneration();
        justTheTip();
        baseOfMandrel();
        clampGeneration();
    }
    module generatePart ( // This generates the model in one module becasue its easier to work with this way.

    ){
        progressiveTwist();
        justTheTip();
    }

    module generateSplits( // This calls generateWhole and slices the model into printable chunks
        slicesNeeded = numSlicesNeeded(),
        totalLenght = Barrel_Length+Mandrel_Interface_Extra+Mandrel_Rifling_Extra+Base_Thickness,
        zMove = (Chamber_Length + Chamber_Extra_Protection + Base_Thickness),
        baseDia = Clamp_Thickness + Barrel_Od + Barrel_Od_Expansion
    ){
        sliceLenght = slicesNeeded / totalLenght;
        totalLengthButNot = totalLenght; 
        totalLengthButNot2 = totalLenght;

        if (slicesNeeded == 1){
            translate([0,0,zMove]) generateWhole();
        }
        else if (!$preview) {
            for (i = [0:slicesNeeded-1])
                {
                    if (i == 0)
                    {
                        difference()
                        {
                            translate([0,i*baseDia*1.5,zMove-((slicesNeeded-1-i)/slicesNeeded)*(totalLenght)]) generateWhole();
                            union()
                            {
                                color("Red") translate([0,i*baseDia*1.5,-totalLenght/2]) cylinder(totalLenght, d = baseDia*1.5,center = true);
                                color("Red") translate([0,i*baseDia*1.5,Alignment_Hole_Depth/2]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                            }
                            /*
                            union()
                            {
                                color("Red") translate([0,i*baseDia*1.5,totalLengthButNot/2+(totalLengthButNot2/slicesNeeded)]) cylinder(totalLengthButNot, d = baseDia*1.5,center = true);
                                color("Red") translate([0,i*baseDia*1.5,-Alignment_Hole_Depth/2+(totalLengthButNot2/slicesNeeded)]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                            }*/
                        }
                    }
                    else if(i == slicesNeeded-1)
                    {
                        difference()
                        {
                            translate([0,i*baseDia*1.5,zMove-((slicesNeeded-1-i)/slicesNeeded)*(totalLenght)]) generateWhole();
                            /*
                            union()
                            {
                                color("Red") translate([0,i*baseDia*1.5,-totalLenght/2]) cylinder(totalLenght, d = baseDia*1.5,center = true);
                                color("Red") translate([0,i*baseDia*1.5,Alignment_Hole_Depth/2]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                            }
                            */
                            union()
                            {
                                color("Red") translate([0,i*baseDia*1.5,totalLengthButNot/2+(totalLengthButNot2/slicesNeeded)]) cylinder(totalLengthButNot, d = baseDia*1.5,center = true);
                                color("Red") translate([0,i*baseDia*1.5,-Alignment_Hole_Depth/2+(totalLengthButNot2/slicesNeeded)]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                            }
                        }
                    }
                    else 
                    {
                        difference()
                        {
                            translate([0,i*baseDia*1.5,zMove-((slicesNeeded-1-i)/slicesNeeded)*(totalLenght)]) progressiveTwist();
                            union()
                            {
                                color("Red") translate([0,i*baseDia*1.5,-totalLenght/2]) cylinder(totalLenght, d = baseDia*1.5,center = true);
                                color("Red") translate([0,i*baseDia*1.5,Alignment_Hole_Depth/2]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                            }
                            union()
                            {
                                color("Red") translate([0,i*baseDia*1.5,totalLengthButNot/2+(totalLengthButNot2/slicesNeeded)]) cylinder(totalLengthButNot, d = baseDia*1.5,center = true);
                                color("Red") translate([0,i*baseDia*1.5,-Alignment_Hole_Depth/2+(totalLengthButNot2/slicesNeeded)]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                            }
                        }
                    }
                }
        }
        else {
            for (i = [0:slicesNeeded-1])
                {
                    if (i == 0)
                    {
                            translate([0,i*baseDia*1.5,zMove-((slicesNeeded-1-i)/slicesNeeded)*(totalLenght)]) generateWhole();
                            color("Red") translate([0,i*baseDia*1.5,-totalLenght/2]) cylinder(totalLenght, d = baseDia*1.5,center = true);
                            color("Red") translate([0,i*baseDia*1.5,Alignment_Hole_Depth/2]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                            //color("Red") translate([0,i*baseDia*1.5,totalLengthButNot/2+(totalLengthButNot2/slicesNeeded)]) cylinder(totalLengthButNot, d = baseDia*1.5,center = true);
                            //color("Red") translate([0,i*baseDia*1.5,-Alignment_Hole_Depth/2+(totalLengthButNot2/slicesNeeded)]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true);
                    }
                    else if(i == slicesNeeded-1)
                    {
                            translate([0,i*baseDia*1.5,zMove-((slicesNeeded-1-i)/slicesNeeded)*(totalLenght)]) generateWhole();
                            //color("Red") translate([0,i*baseDia*1.5,-totalLenght/2]) cylinder(totalLenght, d = baseDia*1.5,center = true);
                            //color("Red") translate([0,i*baseDia*1.5,Alignment_Hole_Depth/2]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true);
                            color("Red") translate([0,i*baseDia*1.5,totalLengthButNot/2+(totalLengthButNot2/slicesNeeded)]) cylinder(totalLengthButNot, d = baseDia*1.5,center = true);
                            color("Red") translate([0,i*baseDia*1.5,-Alignment_Hole_Depth/2+(totalLengthButNot2/slicesNeeded)]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                    }
                    else 
                    {
                            translate([0,i*baseDia*1.5,zMove-((slicesNeeded-1-i)/slicesNeeded)*(totalLenght)]) progressiveTwist();
                            color("Red") translate([0,i*baseDia*1.5,-totalLenght/2]) cylinder(totalLenght, d = baseDia*1.5,center = true);
                            color("Red") translate([0,i*baseDia*1.5,Alignment_Hole_Depth/2]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true);
                            color("Red") translate([0,i*baseDia*1.5,totalLengthButNot/2+(totalLengthButNot2/slicesNeeded)]) cylinder(totalLengthButNot, d = baseDia*1.5,center = true);
                            color("Red") translate([0,i*baseDia*1.5,-Alignment_Hole_Depth/2+(totalLengthButNot2/slicesNeeded)]) cylinder(Alignment_Hole_Depth, d = Alignment_Hole_Diameter,center = true, $fn = GenericResolution);
                    }
        }
    }}

    module zedSupportGenerator( // Modify so it does not place the supports in the clamps
        zSupportLenght = Zed_Support_Length,
        gapToMandrel = Zed_To_Mandrel_Interface,
        gapToSupports = Zed_To_Zed_Interface,
        interFaceThickness = Zed_Support_Interface_Thickness,
        zSupportThickness = Zed_Support_Thickness,
        angleOfSlope = Zed_Support_Slope_Angle,
        manRad = (Mandrel_Diameter + Mandrel_Diameter_Expansion)/2,
        numLands = Number_Of_Lands
    )
    {
        rotAngle = 360/numLands;
        if (!$preview)
        {
            difference()
            {
                union()
                {
                    zPointBuild = [[0,0],[0,-interFaceThickness],[cos(angleOfSlope)*(zSupportThickness-interFaceThickness),-zSupportThickness], [zSupportLenght,-zSupportThickness], [zSupportLenght,0]];
                    color("DeepSkyBlue") rotate_extrude(angle = 360, $fn=GenericResolution*2) translate([manRad+gapToMandrel,0.0]) polygon(zPointBuild);
                    for (i = [0:numLands-1])
                    {
                        rotate([0,0,rotAngle/2+rotAngle*i]) translate([-Extrusion_Width/6,(manRad-gapToMandrel*3),-interFaceThickness]) cube([Extrusion_Width/3,gapToMandrel*6,interFaceThickness]);
                    }
                }
                for (i = [0:numLands-1])
                {
                    color("Red") rotate([0,0,rotAngle*i]) translate([0,(manRad+gapToMandrel+zSupportLenght/2),-zSupportThickness/2]) cube([gapToSupports,zSupportLenght*1.5,zSupportThickness*1.5],center=true);
                }
            }
        }
        else
        {
            zPointBuild = [[0,0],[0,-interFaceThickness],[cos(angleOfSlope)*(zSupportThickness-interFaceThickness),-zSupportThickness], [zSupportLenght,-zSupportThickness], [zSupportLenght,0]];
            color("DeepSkyBlue") rotate_extrude(angle = 360, $fn=GenericResolution*2) translate([manRad+gapToMandrel,0.0]) polygon(zPointBuild);
            for (i = [0:numLands-1])
            {
                rotate([0,0,rotAngle/2+rotAngle*i]) translate([-Extrusion_Width/6,(manRad-gapToMandrel*3),-interFaceThickness]) cube([Extrusion_Width/3,gapToMandrel*6,interFaceThickness]);

            }
            for (i = [0:numLands-1])
            {
                color("Red") rotate([0,0,rotAngle*i]) translate([0,(manRad+gapToMandrel+zSupportLenght/2),-zSupportThickness/2]) cube([gapToSupports,zSupportLenght*1.5,zSupportThickness*1.5],center=true);
            }
        }
    }

    module bedSupportGenerator( // Modify so it does not place the supports in the clamps
        bedSupportLenght = Bed_Support_Length,
        gapToMandrel = Bed_To_Mandrel_Interface,
        gapToSupports = Bed_To_Bed_Interface,
        interFaceThickness = Bed_Support_Interface_Thickness,
        bedSupportThickness = Bed_Support_Thickness,
        angleOfSlope = Bed_Support_Slope_Angle,
        manRad = (Mandrel_Diameter + Mandrel_Diameter_Expansion)/2,
        numLands = Number_Of_Lands
    )
    {
        rotAngle = 360/numLands;
        if (!$preview)
        {
            difference()
            {
                for (i = [0:numLands-1])
                {
                    bedPointBuild = [[0,0],[0,-interFaceThickness],[cos(angleOfSlope)*(bedSupportThickness-interFaceThickness),-bedSupportThickness], [bedSupportLenght,-bedSupportThickness], [bedSupportLenght,0]];
                    color("DeepSkyBlue") rotate([0,0,rotAngle*i+90]) rotate_extrude(angle = rotAngle, $fn=GenericResolution*2) translate([manRad+gapToMandrel,0.0]) polygon(bedPointBuild);
                    rotate([0,0,rotAngle/2+rotAngle*i]) translate([-Extrusion_Width/6,(manRad-gapToMandrel*3),-interFaceThickness]) cube([Extrusion_Width/3,gapToMandrel*6,interFaceThickness]);

                }
                for (i = [0:numLands-1])
                {
                    color("Red") rotate([0,0,rotAngle*i]) translate([0,(manRad+gapToMandrel+bedSupportLenght/2),-bedSupportThickness/2]) cube([gapToSupports,bedSupportLenght*1.5,bedSupportThickness*1.5],center=true);
                }
            }
        }
        else
        {
            for (i = [0:numLands-1])
            {
                bedPointBuild = [[0,0],[0,-interFaceThickness],[cos(angleOfSlope)*(bedSupportThickness-interFaceThickness),-bedSupportThickness], [bedSupportLenght,-bedSupportThickness], [bedSupportLenght,0]];
                color("DeepSkyBlue") rotate([0,0,rotAngle*i+90]) rotate_extrude(angle = rotAngle, $fn=GenericResolution*2) translate([manRad+gapToMandrel,0.0]) polygon(bedPointBuild);
                rotate([0,0,rotAngle/2+rotAngle*i]) translate([-Extrusion_Width/6,(manRad-gapToMandrel*3),-interFaceThickness]) cube([Extrusion_Width/3,gapToMandrel*6,interFaceThickness]);

            }
            for (i = [0:numLands-1])
            {
                color("Red") rotate([0,0,rotAngle*i]) translate([0,(manRad+gapToMandrel+bedSupportLenght/2),-bedSupportThickness/2]) cube([gapToSupports,bedSupportLenght*1.5,bedSupportThickness*1.5],center=true);
            }
        }
    }
    


    module zedSupportPlacer ( // Places a support and rotates it to the correct postion.
        slicesNeeded = numSlicesNeeded(),
        totalLenght = Barrel_Length+Mandrel_Interface_Extra+Mandrel_Rifling_Extra+Base_Thickness,
        baseDia = Clamp_Thickness + Barrel_Od + Barrel_Od_Expansion,
        zSupportThickness = Zed_Support_Thickness,
        zSupportIntThickness = Zed_Support_Interface_Thickness,
        supportDist = Distance_Between_Supports,
        bedSupportThickness = Bed_Support_Thickness,
        bedSupportIntThickness = Bed_Support_Interface_Thickness
    ){
        numberOfSupportsOne = floor((((totalLenght-Bed_Support_Thickness)/slicesNeeded)-Zed_Min_Distance_From_Top)/supportDist);
        numberOfSupportsBaseOld = floor((((totalLenght-Base_Thickness)/slicesNeeded)-Zed_Min_Distance_From_Top)/supportDist);
        numberOfSupportsBase = numberOfSupportsBaseOld-1 >= 0 ? numberOfSupportsBaseOld-1: 0; //Set supports to zero if number of supports is negative
        for (i = [0:slicesNeeded-1])
        {
            if (i != slicesNeeded-1)
            {
                translate([0,i*baseDia*1.5,bedSupportThickness]) rotate([0,0,angleAtHeight(totalLenght-((totalLenght/slicesNeeded)*(i+1)-(bedSupportThickness-bedSupportIntThickness)))]) bedSupportGenerator();
                for (a = [0:numberOfSupportsOne-1])
                {
                        translate([0,i*baseDia*1.5,Distance_Between_Supports*(a+1)+Bed_Support_Thickness+zSupportIntThickness/2]) rotate([0,0,angleAtHeight(totalLenght-((totalLenght/slicesNeeded)*(i+1))+Distance_Between_Supports*(a+1)+Bed_Support_Thickness)]) zedSupportGenerator(); //Distance_Between_Supports*(a+1)+Bed_Support_Thickness
                }
            }
            else
            {
                for (a = [0:numberOfSupportsBase])
                {
                    if (Distance_Between_Supports*(a+1)+Base_Thickness+zSupportIntThickness/2 > Base_Thickness + clamp_Length)
                        translate([0,i*baseDia*1.5,Distance_Between_Supports*(a+1)+Base_Thickness+zSupportIntThickness/2]) rotate([0,0,angleAtHeight(Distance_Between_Supports*(a+1)+Base_Thickness)]) zedSupportGenerator(); //Distance_Between_Supports*(a+1)+Base_Thickness
                }
            }
        }
    }
// Generate, the opposite of degenerate


if (Render_Sliced || !$preview) {
    generateSplits();
    zedSupportPlacer();
}
else {
    translate([0,0,Chamber_Length + Chamber_Extra_Protection + Base_Thickness]) generateWhole();
}
