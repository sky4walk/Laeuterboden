// Andre Betz
// github@AndreBetz.de

MattMillDurchmesser = 497;
BlechHoehe          = 2;
FilterBreite        = 1.3;
SchlitzLaenge       = 10;
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

module BodenOeffnungenSchlitz(Durchmesser, Laenge, Breite, Hoehe)
{
    countRow = Durchmesser / Laenge / 4;
    countCol = Durchmesser / Breite / 2;
    echo(countRow,countCol);
    
    for ( y = [0 : countCol-1] )
        for ( x = [0 : countRow-1] ) {
           pX = x*Laenge*4;
           pY = y*Breite*2;
           //echo(pX,pY);
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
           //echo(pX,pY);
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
    radius = Durchmesser/2;
    innerQuadrat = radius * sqrt(2);
    abstand = radius-sqrt(radius*radius - innerQuadrat*innerQuadrat/4);
    
    echo(abstand);
    difference() {
        BodenBlech(Durchmesser/2,Hoehe);
        translate([-Durchmesser/2+abstand,-Durchmesser/2+abstand+Laenge*2,-1])
            BodenOeffnungenSchlitz(Durchmesser-abstand*2,Laenge,Breite,Hoehe*3);
        
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
//projection() 
{ 
    LaeuterBlechSchlitz(MattMillDurchmesser,FilterBreite,SchlitzLaenge,BlechHoehe,SchraubeM5);
}

