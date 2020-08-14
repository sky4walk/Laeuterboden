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
SchlitzAbstandY          = 4;
SchlitzVersatz           = 20;
LaeuterblechRand         = 6;

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
    echo(abstand);
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

module BlechCutOut(hohe,d1,d2,dicke,winkel,auflage)
{
    difference()
    {
        BlechHalbe2DSpiegeln(hohe,d1,d2,dicke,winkel,auflage);
        translate([0,0,-1])
        cylinder(hohe+2, d2/2, d2/2, center=false);
    }
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

module Schlitze(laenge,breite,hoehe,d2,abstandX,abstandY,versatz)
{
    cx = d2 / abstandX;
    cy = d2 / abstandY;
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



module LaeuterBlechNeu(
    laenge, 
    breite, 
    dicke, 
    d1, d2, 
    bHoehe, 
    auflage, 
    winkel,
    abstandX,
    abstandY,
    versatz)
{
    
    BlechCutOut(bHoehe,d1,d2,dicke,winkel,auflage);
    difference()
    {
        translate([0,0,0])
            cylinder(dicke, d2/2, d2/2, center=false);
        Schlitze(laenge,breite,dicke,d2,abstandX,abstandY,versatz);
    }
    
}

projection() 
{ 
    LaeuterBlechNeu(
        SchlitzLaenge,
        SchlitzBreite,
        LaeuterblechDicke,
        BottichDurchmesserDeckel,
        BottichDurchmesserBoden,
        BottichHoehe,
        LaeuterblechAuflage,
        LaeuterblechWinkel,
        SchlitzAbstandX,
        SchlitzAbstandY,
        SchlitzVersatz);
}
