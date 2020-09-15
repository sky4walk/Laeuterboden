// Andre Betz
// github@AndreBetz.de

BottichDurchmesser       = 450;
BottichDistanz           = 1.5;
BlechDicke               = 1;
BlechRand                = 8;
SchlitzLaenge            = 31;
SchlitzBreite            = 1.3;
SchlitzAbstandX          = 50;
SchlitzAbstandY          = 4;
SchlitzVersatz           = 25;
SchraubeM5               = 5.5;

$fn=100;

module RundBlech(
    d, 
    ab, 
    rand, 
    hoehe)
{
    durchm = d - ab*2 - rand*2;
    cylinder(h=hoehe,r=durchm/2,center=false);
}

module Bohrloch(
    d,
    posX,
    posY,
    hoehe) 
{
    translate([posX,posY,-1])
        cylinder(
            hoehe,
            d/2,
            d/2,
            center = false);
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

module Schlitze(
    laenge,
    breite,
    hoehe,
    d2,
    abstandX,
    abstandY,
    versatz)
{
    cx = d2 / abstandX;
    cy = d2 / abstandY;
    for ( y = [0 : cy] ) 
    {
        for ( x = [0 : cx] ) 
        {
            if ( y % 2 == 0 ) 
            {
                Schlitz(
                    laenge,
                    breite,
                    hoehe,
                    x*abstandX-d2/2,
                    y*abstandY-d2/2);
            } 
            else 
            {
                Schlitz(
                    laenge,
                    breite,
                    hoehe,
                    x*abstandX-d2/2+versatz,
                    y*abstandY-d2/2);
            }
        }
    }
}

module BlechSchlitze(
    d, 
    ab, 
    rand, 
    hoehe,
    laenge,
    breite,
    abstandX,
    abstandY,
    versatz)
{
    difference()
    {
        RundBlech(
            d,
            0,
            0,
            hoehe);
        translate([0,0,-1])
            RundBlech(
                d,
                ab,
                rand,
                hoehe+2);
    }

    difference()
    {
        RundBlech(
            d,
            ab,
            rand,
            hoehe);
        Schlitze(
            laenge,
            breite,
            hoehe,
            d,
            abstandX,
            abstandY,
            versatz);        
    }

}

module BlechSchlitzeLoecher(
    d, 
    ab, 
    rand, 
    hoehe,
    laenge,
    breite,
    abstandX,
    abstandY,
    versatz,
    ds)
{
    rPos = d/2 - ab - rand;  
    difference()
    {
        BlechSchlitze(
            d, 
            ab, 
            rand, 
            hoehe,
            laenge,
            breite,
            abstandX,
            abstandY,
            versatz);
        
        Bohrloch(
            ds,
            0,
            0,
            hoehe*3);
        Bohrloch(
            ds,
            rPos,
            0,
            hoehe*3);
        Bohrloch(
            ds,
            -rPos,
            0,
            hoehe*3);
        Bohrloch(
            ds,
            0,
            rPos,
            hoehe*3);
        Bohrloch(
            ds,
            0,
            -rPos,
            hoehe*3);
        Bohrloch(
            ds,
            rPos*sin(45),
            rPos*cos(45),
            hoehe*3);
        Bohrloch(
            ds,
            rPos*sin(45),
            -rPos*cos(45),
            hoehe*3);
        Bohrloch(
            ds,
            -rPos*sin(45),
            rPos*cos(45),
            hoehe*3);
        Bohrloch(
            ds,
            -rPos*sin(45),
            -rPos*cos(45),
            hoehe*3);        
    }
}
//projection()
{
    BlechSchlitzeLoecher(
        BottichDurchmesser,
        BottichDistanz,
        BlechRand,
        BlechDicke,
        SchlitzLaenge,
        SchlitzBreite,
        SchlitzAbstandX,
        SchlitzAbstandY,
        SchlitzVersatz,
        SchraubeM5);
}