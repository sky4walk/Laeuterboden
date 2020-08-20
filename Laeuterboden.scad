// Andre Betz
// github@AndreBetz.de

BottichDurchmesserDeckel = 350;
BottichDurchmesserBoden  = 322;
BottichHoehe             = 382;
BottichHoeheBlech        = 60;

MattMillDurchmesser 			= 497;
ClatronicEKA3338Durchmesser  	= 230+116;

BlechHoehe          = 1;
FilterBreite        = 1.2;
SchlitzLaenge       = 27;
SchlitzAbstandX     = 42;
SchlitzAbstandY     = 4;      
SchraubeM5          = 5.5;

$fn=100;

module Schlitz(laenge,breite,hoehe,posX,posY) 
{
    translate([posX,posY,-hoehe/4])
        minkowski()
        {
            cube([laenge,breite/2,hoehe]);
            cylinder(r=breite/4,hoehe/2);
        }  
}

module Vessel(r,h)
{
  cylinder (r, h);
  translate([0,0,2.9]) cylinder (r=8, h=20); 
  hull(){
    translate([0,0,30]) sphere (15, center=true);
    translate([0,0,60]) sphere (5);
  }
}

module Laeuterloch(Durchmesser,Hoehe,posX,posY) 
{
    translate([posX,posY,-1])
        cylinder(
            Hoehe,
            Durchmesser/2,
            Durchmesser/2,
            center = false);  
}

module BodenBlech(Radius,Hoehe)
{
    cylinder(
        Hoehe,
        Radius,
        Radius,
        center = false);
}

module SchlitzeVersetzt(laenge,breite,hoehe,d2,abstandX,abstandY,versatz)
{
    cx = d2 / abstandX / 2;
    cy = d2 / abstandY ;
    for ( y = [0 : cy] ) {
        for ( x = [0 : cx] ) {
            if ( y % 2 == 0 ) {
                Schlitz(laenge,breite,hoehe,x*abstandX-d2/2,y*abstandY-d2/2);
            } else {
                Schlitz(laenge,breite,hoehe,x*abstandX-d2/2+versatz,y*abstandY-d2/2);
            }
        }
    }
}

module BodenOeffnungenSchlitz(Laenge, Breite, Hoehe, Durchmesser, abFakX,abFakY)
{
    abstandX = Laenge * abFakX;
	abstandY = Breite * abFakY;
    countRow = Durchmesser / abstandX;
    countCol = Durchmesser / abstandY;
//    echo(Laenge, Breite,abstandX,abstandY,countRow,countCol);
    
    for ( y = [0 : countCol-1] )
        for ( x = [0 : countRow-1] ) {
           pX = x*abstandX;
           pY = y*abstandY;
           Schlitz(Laenge,Breite,Hoehe,pX,pY);
        }
}

module BodenOeffnungenLoch(Durchmesser, Breite, Hoehe)
{
    countRow = Durchmesser / Breite / 2;
    countCol = Durchmesser / Breite / 2;
    echo(countRow,countCol);
    
    for ( y = [0 : countCol-1] )
        for ( x = [0 : countRow-1] ) {
           pX = x*Breite*2;
           pY = y*Breite*2;
           echo(Breite,Hoehe,pX,pY);
           Laeuterloch(Breite,Hoehe,pX,pY);
        }
}

module Bohrloch(Durchmesser,posX,posY,Hoehe) 
{
    translate([posX,posY,-1])
        cylinder(
            Hoehe,
            Durchmesser/2,
            Durchmesser/2,
            center = false);
}

module LaeuterBlechSchlitz(Durchmesser,Laenge,Breite,Hoehe,BohrLoch)
{
    abFakX = 1.3;
    radius = Durchmesser/2;
    innerQuadrat = radius * sqrt(2);
    abstand = radius-sqrt(radius*radius - innerQuadrat*innerQuadrat/4);
    
    echo(abstand);
    difference() {
        BodenBlech(radius,Hoehe);
        
        translate([-radius+abstand+Laenge*abFakX/2,-radius+abstand,-1])       
            BodenOeffnungenSchlitz(
                Laenge,
                Breite,
                Hoehe*3,
                Durchmesser-abstand*2,
                abFakX,4);
        
       
        
        Bohrloch (BohrLoch,  -radius+abstand,0,Hoehe*3);
        Bohrloch (BohrLoch,   radius-abstand,0,Hoehe*3);
        Bohrloch (BohrLoch,0, radius-abstand,  Hoehe*3);
        Bohrloch (BohrLoch,0,-radius+abstand,  Hoehe*3);
        Bohrloch (BohrLoch,0,0,Hoehe*3);
        
    }
}

module BohrloecherHalterung(dInnen,Abstand,Hoehe)
{
    translate([0,0,Hoehe/2])
        cube([dInnen,Abstand/4,Hoehe],true);
    translate([0,0,Hoehe/2])
        cube([Abstand/4,dInnen,Hoehe],true);
}

module LaeuterBlechSchlitzRund(Durchmesser,Laenge,Breite,Hoehe,loch)
{
    abFakX = 1.3;
    radius = Durchmesser/2;
    DurchmesserInnen = Durchmesser - Laenge;
    innerQuadrat = radius * sqrt(2);
    abstand = radius-sqrt(radius*radius - innerQuadrat*innerQuadrat/4);
    
    difference() {
        union()
        {
            difference() {
                BodenBlech(radius,Hoehe);
                translate([0,0,-1])
                    BodenBlech(DurchmesserInnen/2,Hoehe*3);
            }
            

            difference() {
                BodenBlech(DurchmesserInnen/2,Hoehe);
                
                translate([-DurchmesserInnen/2,-DurchmesserInnen/2,-1])
                    BodenOeffnungenSchlitz(                        
                        Laenge,
                        Breite,
                        Hoehe*4,
                        DurchmesserInnen+Laenge,
                        abFakX,4);
/*
                     SchlitzeVersetzt(
                Laenge,
                        Breite,
                        Hoehe*4,
                        DurchmesserInnen+Laenge);
*/
            }
            
            BohrloecherHalterung(
                DurchmesserInnen,
                abstand,
                Hoehe);
        }
        union()
        {
            Bohrloch (loch,  -radius+abstand,0,Hoehe*3);
            Bohrloch (loch,   radius-abstand,0,Hoehe*3);
            Bohrloch (loch,0, radius-abstand,  Hoehe*3);
            Bohrloch (loch,0,-radius+abstand,  Hoehe*3);
            Bohrloch (loch,0,0,Hoehe*3);
        }
    }            
}

module LaeuterBlechLoch(Durchmesser,Filter,Breite,Hoehe,Schraube)
{
    radius = Durchmesser/2;
    difference() {
        BodenBlech(Durchmesser/2,Hoehe);
        translate([-radius,-radius,-1])
            BodenOeffnungenLoch(Durchmesser,Filter,Hoehe*3);
        
        Bohrloch (Schraube,  -radius+abstand,0,Hoehe*3);
        Bohrloch (Schraube,   radius-abstand,0,Hoehe*3);
        Bohrloch (Schraube,0, radius-abstand,  Hoehe*3);
        Bohrloch (Schraube,0,-radius+abstand,  Hoehe*3);
        Bohrloch (Schraube,0,0,Hoehe*3);

    }
}

module LaeuterBlechSchlitzRundEimer(
    dEimerOben,
    dEimerUnten,
    hEimerHoehe,
    hEimerHoeheBlech,
    Laenge,
    Breite,
    Hoehe,
    BohrLoch)
{
    diffD =  dEimerOben - dEimerUnten ;
    dBlech = dEimerUnten + hEimerHoeheBlech * diffD / hEimerHoehe;
    echo ( dBlech );
    LaeuterBlechSchlitzRund(
        dBlech,
        SchlitzLaenge,
        FilterBreite,
        BlechHoehe,
        SchraubeM5);
}

//Vessel(15,3);

projection() 
{
    LaeuterBlechSchlitzRundEimer(
        BottichDurchmesserDeckel,
        BottichDurchmesserBoden,
        BottichHoehe,
        BottichHoeheBlech,
        SchlitzLaenge,
        FilterBreite,
        BlechHoehe,
        SchraubeM5);
}

