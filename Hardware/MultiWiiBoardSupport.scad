use <hardware.scad>

$fn = 20;
mode = "main"; // main or schema

module board(s = [30, 30], o = 2.5, d = 3, hs = 10, layout = 4, hole = true, spacer = true)
{
    w = s[0];
    h = s[1];
    
    difference() {
        cube([w, h, 2]);
    
        translate([o, o, -1]) cylinder(d = d + 0.5, h = 4);
        translate([w - o, h - o, -1]) cylinder(d = d + 0.5, h = 4);
        if(layout == 4)
        {
            translate([w - o, o, -1]) cylinder(d = d + 0.5, h = 4);
            translate([o, h - o, -1]) cylinder(d = d + 0.5, h = 4);
        }
    }
    
    if (spacer) {
        translate([o, o, 0]) scale(10) nut(hs/10, d/10);
        translate([w - o, h - o, 0]) scale(10) nut(hs/10, d/10);
        if(layout == 4)
        {
            translate([w - o, o, 0]) scale(10) nut(hs/10, d/10);
            translate([o, h - o, 0]) scale(10) nut(hs/10, d/10);
        }
    }
    
    if (hole) {
        a = hs + 15;
        translate([o, o,  3 - a]) cylinder(d = d, h = a);
        translate([w - o, h - o, 3 - a]) cylinder(d = d, h = a);
        if(layout == 4)
        {
            translate([w - o, o, 3 - a]) cylinder(d = d, h = a);
            translate([o, h - o, 3 - a]) cylinder(d = d, h = a);
        }
    }
}

module flight_control(hole = false, spacer = false) 
{
    board(s = [60, 60], o = 2.5, d = 3, hs = 5, layout = 4, hole = hole, spacer = spacer);
}

module gps(hole = false, spacer = false)
{
    board(s = [36, 25], o = 3, d = 3, hs = 5, layout = 4, hole = hole, spacer = spacer);
}

module i2c_serial(hole = false, spacer = false)
{
    board(s = [20.5, 26], o = 3, d = 3, hs = 5, layout = 2, hole = hole, spacer = spacer);
}

module cam_osd(hole = false, spacer = false)
{
    board(s = [19.5, 19.5], o = 2, d = 2, hs = 5, layout = 4, hole = hole, spacer = spacer);
}

module cam_recv(hole = false)
{
    translate([0, 0, 4]) cube([25.5, 19.5, 1.5]);
    translate([0, 0, 2.5]) cube([23, 19.5, 2]);
    translate([25.5, 0, 0]) cube([5, 9, 7]);
    translate([30.5, 4.5, 3.5]) rotate([0, 90, 0]) cylinder(h = 9, d = 7);
    
    if (hole) {
        translate([25.5/4, -2, -17]) cylinder(d = 3, h = 20);
        translate([25.5/4, 19.5 + 2, -17]) cylinder(d = 3, h = 20);
        translate([25.5*3/4, -2, -17]) cylinder(d = 3, h = 20);
        translate([25.5*3/4, 19.5 + 2, -17]) cylinder(d = 3, h = 20);
    }
}

module plate1_l0(temper = false, spacer = false) 
{
    color("black") difference() {
        rcube([70,70,3], 20);
        
        // drone 
        translate([35 + 35/2, 35 + 35/2, -1]) cylinder(d = 3, h = 5);
        translate([35 + 35/2, 35 - 35/2, -1]) cylinder(d = 3, h = 5);
        translate([35 - 35/2, 35 - 35/2, -1]) cylinder(d = 3, h = 5);
        translate([35 - 35/2, 35 + 35/2, -1]) cylinder(d = 3, h = 5);
        
        // temper
        translate([35 + 55/2, 35, -1]) cylinder(d = 10, h = 5);
        translate([35, 35 - 55/2, -1]) cylinder(d = 10, h = 5);
        translate([35 - 55/2, 35, -1]) cylinder(d = 10, h = 5);
        translate([35, 35 + 55/2, -1]) cylinder(d = 10, h = 5);
        
        // weight lift
        translate([35 , 35, -1]) cylinder(d = 40, h = 5);
        for (i = [30, 60, 120, 150, 210, 240, 300, 330])
            translate([35 + cos(i) * 65/2, 35 + sin(i) * 65/2, -1]) cylinder(d = 10, h = 5);
    }
    
    if (temper) {
        translate([35 + 55/2 - 5, 35 - 5, -13]) scale(10) tube(size = [1, 1, 1.3], radius = 0.5, solid_holes = 0);
        translate([35 - 5, 35 - 55/2 - 5, -13]) scale(10) tube(size = [1, 1, 1.3], radius = 0.5, solid_holes = 0);
        translate([35 - 55/2 - 5, 35 - 5, -13]) scale(10) tube(size = [1, 1, 1.3], radius = 0.5, solid_holes = 0);
        translate([35 - 5, 35 + 55/2 - 5, -13]) scale(10) tube(size = [1, 1, 1.3], radius = 0.5, solid_holes = 0);
    }
    
    if (spacer) {
        translate([35 + 35/2, 35 + 35/2, 0]) scale(10) nut(0.5, 0.3);
        translate([35 + 35/2, 35 - 35/2, 0]) scale(10) nut(0.5, 0.3);
        translate([35 - 35/2, 35 - 35/2, 0]) scale(10) nut(0.5, 0.3);
        translate([35 - 35/2, 35 + 35/2, 0]) scale(10) nut(0.5, 0.3);
    }
}

module plate1(temper = false, spacer = false) {
    difference() {
        plate1_l0(temper = temper, spacer = spacer);
        translate([35 - 60/2, 35 - 60/2, 10]) flight_control(hole = true);
    }
}

module plate2_l0(spacer = false) 
{
    color("black") difference() {
        rcube([70,70,3], 20);
         
        // weight lift
        translate([25, 42, -1]) cylinder(d = 20, h = 5);
        translate([23, 17, -1]) cylinder(d = 20, h = 5);
    }
    
    if (spacer) translate([35 - 60/2, 35 - 60/2, 0]) {
        translate([2.5, 2.5, 0]) scale(10) nut(3, 0.3);
        translate([60 - 2.5, 2.5, 0]) scale(10) nut(3, 0.3);
        translate([60 - 2.5, 60 - 2.5, 0]) scale(10) nut(3, 0.3);
        translate([2.5, 60 - 2.5, 0]) scale(10) nut(3, 0.3);
    }
}

module plate2(spacer = false) {
    difference() {
        plate2_l0(spacer = spacer);
        translate([35 - 60/2, 35 - 60/2, 10]) flight_control(hole = true);
        translate([35 - 60/2 - 0.5, 35 - 60/2 - 0.5, 10]) gps(hole = true);
        translate([35 - 60/2 - 0.5, 35 - 60/2 + 29.5, 10]) i2c_serial(hole = true);
        translate([35 - 60/2 - 0.5 + 40, 35 - 60/2 + 6, 10]) cam_osd(hole = true);
        translate([35 - 60/2 - 0.5 + 46, 35 - 60/2 + 27, 10]) rotate([0, 0, 45]) cam_recv(hole = true);
    }
}

module main()
{
    translate([0, 0, 5]) plate1(spacer = true);
    translate([0, 0, 21]) plate1(temper = true);
    translate([35 - 60/2, 35 - 60/2, 29]) flight_control(spacer = true);
    translate([0, 0, 61]) plate2(spacer = true);
    translate([35 - 60/2 - 0.5, 35 - 60/2 - 0.5, 69]) gps(spacer = true);
    translate([35 - 60/2 - 0.5, 35 - 60/2 + 29.5, 69]) i2c_serial(spacer = true);
    translate([35 - 60/2 - 0.5 + 40, 35 - 60/2 + 6, 69]) cam_osd(spacer = true);
    translate([35 - 60/2 - 0.5 + 46, 35 - 60/2 + 27, 64]) rotate([0, 0, 45]) cam_recv();
}

module schema()
{
    projection() plate1($fn = 40);
    translate([80, 0, 0]) projection() plate2($fn = 40);
}

if (mode == "main")
{
    main();
}
if (mode == "schema")
{
    schema();
}

