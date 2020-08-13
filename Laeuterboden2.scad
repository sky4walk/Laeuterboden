// Andre Betz
// github@AndreBetz.de

BottichDurchmesserDeckel = 350;
BottichDurchmesserBoden  = 322;
BottichHoehe             = 382;
LaeuterblechDicke        = 1;
LaeuterblechWinkel       = 120;
LaeuterblechAuflage      = 120;
SchlitzLaenge            = 27;
SchlitzBreite            = 1.2;
SchlitzAbstandX          = 42;

$fn=100;

module Laeuterbottich(hoehe, d_oben, d_unten)
{
    cylinder(h=hoehe, r1=d_unten/2, r2=d_oben/2, center=false);
}

module Ebene(dicke, breite, winkel,auflage)
{
    wb = ( 180 - winkel ) / 2;
    radius = breite / 2;
    abstand = radius - sqrt(radius*radius - (auflage/2)*(auflage/2));
    translate([-radius+abstand,-breite,0])
        rotate ([0,-wb,0])
            cube([breite*2,breite*2,1],center=false);
}

module BottichSchnitt(hohe,d1,d2,dicke,winkel,auflage)
{
    intersection()
    {
        Ebene( dicke, d2, winkel,auflage);
        Laeuterbottich(hohe,d1,d2);
    }
}

module BlechHalbe(hohe,d1,d2,dicke,winkel,auflage)
{
    difference()
    {
        BottichSchnitt(hohe,d1,d2,dicke,winkel,auflage);
        translate([0,-d1/2,0])
            cube([d1,d1,hohe],center=false);
    }
}

module BlechHalbe3DSpiegeln(hohe,d1,d2,dicke,winkel,auflage)
{
    BlechHalbe(hohe,d1,d2,dicke,winkel,auflage);
    mirror([1,0,0])
        BlechHalbe(hohe,d1,d2,dicke,winkel,auflage);
}

module BlechHalbeFlach(hohe,d1,d2,dicke,winkel,auflage)
{
    wb = ( 180 - winkel ) / 2;
    radius = d2 / 2;
    abstand = radius - sqrt(radius*radius - (auflage/2)*(auflage/2));
    translate([-radius-abstand,0,0])
        rotate([0,wb,0])
            translate([radius-abstand,0,0])
                BlechHalbe(hohe,d1,d2,dicke,winkel,auflage);
}

module BlechHalbe2DSpiegeln(hohe,d1,d2,dicke,winkel,auflage)
{
    BlechHalbeFlach(hohe,d1,d2,dicke,winkel,auflage);
    mirror([1,0,0])
        BlechHalbeFlach(hohe,d1,d2,dicke,winkel,auflage);
}

module Schlitz(laenge,breite,hoehe,posX,posY) 
{
    translate([posX,posY,-hoehe/4])
        minkowski()
        {
            cube([laenge,breite/2,hoehe]);
            cylinder(r=breite/4,hoehe/2);
        }  
}

module SchlitzeXDir(laenge,breite,hoehe,d2,auflage,winkel, abstand)
{
    wb = ( 180 - winkel ) / 2;
    radius = d2 / 2;
    distBoden = sqrt(radius*radius - (auflage/2)*(auflage/2));
    lenC = distBoden / cos(wb);
    count = lenC * 2 / abstand;
    for ( x = [0 : count-1] ) {        
        Schlitz(Laenge,Breite,Hoehe,pX,pY);
    }
}

/*
BlechHalbe2DSpiegeln(
    BottichHoehe,
    BottichDurchmesserDeckel,
    BottichDurchmesserBoden,
    LaeuterblechDicke,
    LaeuterblechWinkel,
    LaeuterblechAuflage);
*/
Schlitz(SchlitzLaenge,SchlitzBreite,LaeuterblechDicke,0,0);


// 2D Projektion fuer SVG Datei
projection() 
{ 
   
}
