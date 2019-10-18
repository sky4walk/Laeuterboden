// Andre Betz
// github@AndreBetz.de

MattMillDurchmesser 			= 497;
ClatronicEKA3338Durchmesser  	= 230+115;
BlechHoehe          = 2;
FilterBreite        = 1.3;
SchlitzLaenge       = 40;
SchraubeM5          = 5.5;

$fn=100;

module Schlitz(laenge,breite,hoehe,posX,posY) 
{
    translate([posX,posY,-1])
        cube([laenge,breite,hoehe]);
  /*  
    minkowski()
    {
        cube([laenge,breite,1]);
        cylinder(r=2,hoehe);
    }
  */
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

module BodenOeffnungenSchlitz(Durchmesser, Laenge, Breite, Hoehe, abFakX,abFakY)
{
    abstandX = Laenge * abFakX;
	abstandY = Breite * abFakY;
    countRow = Durchmesser / abstandX;
    countCol = Durchmesser / abstandY;
    echo(Laenge, Breite,abstandX,abstandY,countRow,countCol);
    
    for ( y = [0 : countCol-1] )
        for ( x = [0 : countRow-1] ) {
           pX = x*abstandX;
           pY = y*abstandY;
           echo(pX,pY);
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
                Durchmesser-abstand*2,
                Laenge,
                Breite,
                Hoehe*3,
                abFakX,4);
        
        Bohrloch (BohrLoch,  -radius+abstand,0,Hoehe*3);
        Bohrloch (BohrLoch,   radius-abstand,0,Hoehe*3);
        Bohrloch (BohrLoch,0, radius-abstand,  Hoehe*3);
        Bohrloch (BohrLoch,0,-radius+abstand,  Hoehe*3);
        Bohrloch (BohrLoch,0,0,Hoehe*3);
        
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

// 2D Projektion fuer SVG Datei
projection() 
{ 
    
    LaeuterBlechSchlitz(
//        MattMillDurchmesser,
        ClatronicEKA3338Durchmesser,
        SchlitzLaenge,
        FilterBreite,
        BlechHoehe,
        SchraubeM5);
}

