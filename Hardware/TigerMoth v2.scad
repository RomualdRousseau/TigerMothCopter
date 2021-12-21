use <hardware.scad> 

echo("Version:",version());
$fn=20;
mode = "main"; // main or schema
lod = "high"; // low, normal, high

h=3.5;   // height between the plates
p=16;   // propeller size
n=8;    // body width
w=2.5;  // wing width

f=sqrt(2*((p+2)/4+n/2)*((p+2)/4+n/2));
e=sqrt(p);
l=sqrt(f*f/2);

module latice(sx, sy, th = 0.5, n = 5)
{
    difference()
    {
        children();
        
        m = ceil(n*sy/sx);
        
        for(i=[0:n], j=[0:2*m])
            translate([(i+(j%2)/2)*sx/n, j*sx/n/2 - sy])
                rotate(45)
                    square(sx/n/sqrt(2)-th, center=true);
    }
}

module propellers()
{
    translate([l + e, l + e, h + 3]) cylinder(d=p, h=0.1);
    translate([l+e, -l - e, h + 3]) cylinder(d=p, h=0.1);
    translate([-l, -l - e, h + 3]) cylinder(d=p, h=0.1);
    translate([-l, l + e, h + 3]) cylinder(d=p, h=0.1);
    
    translate([-l, -l - e, h - 0.1]) cube([l * 2 + e, l * 2 + e * 2, 0.1]);
    translate([-l, -n / 2, 0]) cube([l * 2 + e, n, h * 2]);
}

module controller(hole = false)
{
    translate([1.775, 1.775, 1.2])
        nut(d = 0.32, h = 1, solid_holes = hole);
    translate([1.775, -1.775, 1.2])
        nut(d = 0.32, h = 1, solid_holes = hole);
    translate([-1.775, -1.775, 1.2])
        nut(d = 0.32, h = 1, solid_holes = hole);
    translate([-1.775, 1.775, 1.2])
        nut(d = 0.32, h = 1, solid_holes = hole);

    if (hole)
    {
        translate([-7/2, -7/2, -0.001]) cube([7, 7, 4]);
    }
}

module plate(bottom = 0, depth = 0.3)
{
    a = sqrt(w * w / 2);
    
    difference()
    {
        union()
        {
            hull()
            {
                translate([-(l + w/2), -n/2, 0]) cube([l + w/2 + n/2 - a, n, depth]);
                translate([n/2 - a, -n/2 + a, 0]) cube([a, n - a*2, depth]);
            }
            
            translate([-(l + w/2), 0, 0]) cylinder(d = n, h = depth);
            
            translate([-9.75, -4.4, 0.0])  cube([2.5, 8.8, 0.3]);
            
            if (bottom)
            {
                b = n*6/8;
                translate([0, -b/2, 0]) rcube([l, b, depth], 1);
            }
        }
        
        if (!bottom)
        {
            translate([-1, 0, -0.1]) cylinder(d = n*3/8, h = depth + 0.2);
            translate([-n, 0, -0.1]) cylinder(d = n*3/8, h = depth + 0.2);
            translate([n/2 - 1, -1, -0.1]) cube([0.5, 2, depth + 0.2]);
        }
        
        if (bottom)
        {
            translate([-(n - 2), n/2 - 1.5, -0.1]) cube([n - 2, 0.5, depth + 0.2]);
            translate([-(n - 2), -n/2 + 1, -0.1]) cube([n - 2, 0.5, depth + 0.2]);
        }
    }
}

module wing_foot_front(length = 10, depth = 0.3, offset = 1.5)
{
    a = n/2 - offset;
    b = length - a - 3;

    y = h * (a + 2) / (b + 3) - (h + depth);

    color("Yellow") translate([a + 3 - depth, (w + depth)/2, -h - 4]) difference()
    {
        cube([depth, w - depth*2, h + 4 + y + depth]);
        
        // lighter
        translate([depth + 0.1, 0.5, 0.5]) rotate([0, -90, 0]) rcube([(h + 4 + y + depth - 1.5) / 2 - 0.5, w - depth*2 - 1, depth + 0.2], 0.5);
        translate([depth + 0.1, 0.5, (h + 4 + y + depth - 1.5) / 2 + 1]) rotate([0, -90, 0])  rcube([(h + 4 + y + depth - 1.5) / 2 - 0.5, w - depth*2 - 1, depth + 0.2], 0.5);
    }
}

module wing_foot_back(length = 10, depth = 0.3, offset = 1.5, angle = 1)
{
    a = n/2 - offset;
    v = [1.5, -4];

    color("Yellow") translate([2, (w + depth)/2, -h])
    {
        rotate([0, atan2(v[0], v[1]) * angle, 0]) scale([-1, 1, 1]) difference()
        {
            cube([depth, w - depth*2, norm(v) + 0.1]);
            
            // lighter
            translate([depth + 0.1, 0.5, 0.5]) rotate([0, -90, 0]) rcube([(norm(v) + 0.1 - 1) / 2 - 0.5, w - depth*2 - 1, depth + 0.2], 0.5);
            translate([depth + 0.1, 0.5, (norm(v) + 0.1 - 1) / 2 + 1]) rotate([0, -90, 0])  rcube([(norm(v) + 0.1 - 1) / 2 - 0.5, w - depth*2 - 1, depth + 0.2], 0.5);
        }
    }
}

module wing_foot_bottom1(length = 10, depth = 0.3, offset = 1.5, angle = 1)
{
    a = n/2 - offset;
    b = length - a - 3;
  
    y = h * (a + 2) / (b + 3) - (h + depth);
    v = [(b + 4) - (a + 3), y + depth];
    
    color("Yellow") translate([a + 3, (w + depth)/2, y])
    {
        rotate([0, (atan2(v[1], v[0]) + 90) * angle, 0]) scale([-1, 1, 1]) difference()
        {
            cube([depth, w - depth*2, norm(v) + 0.1]);
            
            // lighter
            translate([depth + 0.1, 0.5, 0.5]) rotate([0, -90, 0]) rcube([(norm(v) + 0.1 - 1) / 2 - 0.5, w - depth*2 - 1, depth + 0.2], 0.5);
            translate([depth + 0.1, 0.5, (norm(v) + 0.1 - 1) / 2 + 1]) rotate([0, -90, 0])  rcube([(norm(v) + 0.1 - 1) / 2 - 0.5, w - depth*2 - 1, depth + 0.2], 0.5);
        }
    }
}

module wing_foot_bottom2(length = 10, depth = 0.3, offset = 1.5)
{
    a = n/2 - offset;
    b = length - a - 3;
  
    y = h * (a + 2) / (b + 3) - (h + depth);
    v = [(b + 4) - (a + 3), y + depth];
    
    color("Yellow") translate([1, (w + depth)/2, -h])
    {
        cube([1 + depth, w - depth*2, depth]);
    }
}

module wing_support(length = 10, depth = 0.3, offset = 1.5, hole = false)
{
    a = n/2 - offset;
    b = length - a - 3;

    y = h * (a + 2) / (b + 3) - (h + depth);
    x = b * (y + 1) / (depth - h) + a + 2.5;
   
    points=[
        [0,depth*2], [1, depth*2], [1, 0],
        [b + 1, 0], [b + 1, depth], [b + 2, depth], [b + 2, 0],
        [b + 4, 0], [b + 4, -depth], [a + 3, y],
        [a + 3, -h - 4], [a + 1, -h - 4], [a - 0.5, -h],
        [1, -h], [1, -(h + depth)], [0, -(h + depth)]];
    points2=[
        [0.5, -0.5], [b - 0.3, -0.5], [x, -0.5 - depth], 
        [a + 2.5, y + 0.5],
        [a + 2.5, -h - 4 + 0.5], [a + 1.4, -h - 4 + 0.5],
        [a - 0.1, -h + 0.5],
        [0.5, -h + 0.5]];

    color("Orange") translate([0, (w - depth)/2, 0])
    {
        if (!hole) difference()
        {
            union()
            {
                translate([0, depth, 0]) rotate([90, 0, 0])
                {
                    linear_extrude(depth) difference()
                    {
                        polygon(points);
                        polygon(points2);
                    }
                    
                    linear_extrude(depth) latice(length - a  + 1, h + 4, n = 6 * length / 12.5)
                    {
                        polygon(points2);
                    }
                }
            }
        }
        
        if (hole)
        {
            translate([0, 0, -(h + 1.5)]) cube([1, depth, h + 3.5]);
            translate([length - a - 2, 0, 0]) cube([1, depth, 1]);
            translate([a - 0.6, -1, -(h + 1.5)]) cube([1.1, depth + 1, h + 1.5]);
        }
    }
}

module wing(length = 10, depth = 0.3, offset = 1.5, hole = false, support = true)
{
    a = n/2 - offset;

    translate([a, -w/2, h])
    {
        if (!hole) difference()
        {
            color("Yellow") union()
            {
                cube([length - a, w, depth]);
                translate([length - a, w/2, 0]) cylinder(d = w*1.6, h = depth);
            }
            
            translate([0, w/2 - 0.15, 0]) wing_support(length, depth, offset, hole = true);
            translate([0, -w/2 + 0.15, 0]) wing_support(length, depth, offset, hole = true);
            
            // screws
            translate([0.5, 0.7, -0.1]) cylinder(d = 0.3, h = depth + 0.2);
            translate([0.5, w - 0.7, -0.1]) cylinder(d = 0.3, h = depth + 0.2);
            
            // engine
            translate([length - a, w/2, -0.1]) cylinder(d = 1, h = depth + 0.2);
            translate([length - a - 1.6, w/2, -0.1]) cylinder(d = 0.3, h = depth + 0.2);
            translate([length - a + 1.6, w/2, -0.1]) cylinder(d = 0.3, h = depth + 0.2);
            translate([length - a, w/2 + 1.6, -0.1]) cylinder(d = 0.3, h = depth + 0.2);
            translate([length - a, w/2 - 1.6, -0.1]) cylinder(d = 0.3, h = depth + 0.2);
            
            // lighter
            translate([2, 0.5, -0.1]) rcube([(length - a - w*1.6) / 2 - 1,  w - 1, depth + 0.2], 0.5);
            translate([(length - a - w*1.6) / 2 + 2.5, 0.5, -0.1]) rcube([(length - a - w*1.6) / 2 - 1,  w - 1, depth + 0.2], 0.5);
        }
    
        if (support)
        {
            translate([0, w/2 - 0.15, 0]) wing_support(length, depth, offset, hole);
            translate([0, w/2 + 0.15, 0]) scale([1, -1, 1]) wing_support(length, depth, offset, hole);
        
            if (!hole)
            {
                translate([0, -w/2 + 0.15, 0]) wing_foot_front(length, depth, offset);
                translate([0, -w/2 + 0.15, 0]) wing_foot_back(length, depth, offset);
                translate([0, -w/2 + 0.15, 0]) wing_foot_bottom1(length, depth, offset);
                translate([0, -w/2 + 0.15, 0]) wing_foot_bottom2(length, depth, offset);
            }
        }
        
        if (hole)
        {
            translate([0.5, 0.7, -h-1.5]) cylinder(d = 0.3, h = h + 3);
            translate([0.5, w - 0.7, -h-1.5]) cylinder(d = 0.3, h = h + 3);
        }
    }
}

module cockpit()
{
    a = 5;
    
    color("Orange")
    {
        translate([-a - 1, n/2, h/2]) rotate([90, 0, 0]) cylinder(d=h*1.5+0.3, h=n);
        
        hull()
        {
            translate([-0.7, -h/2, 0]) cube([1, h, h+0.3]);
            translate([-a, -h/2, 0]) cube([0.3, h, h - 0.5]);
        }
        
        hull()
        {
            translate([-a-2, 0, h/2]) rotate([0, -90, 0]) cylinder(d = h - 0.2, h = 0.3);
            translate([-(a + 4)-2, 0, h/2 - 0.5]) rotate([0, -90, 0]) cylinder(d = 0.1, h = 0.3);
        }
    }
}

module balloon()
{
    color("Orange") difference()
    {
        scale([1.025, 1, 1.025]) union()
        {
            translate([-0.5, 0.3/2, -0.1]) rotate([90, 0, 0]) linear_extrude(height = 0.3) import("balloon.svg", convexity=3);
            
            translate([-0.2, 0, 4.3]) scale([1, 0.6, 1]) rotate([0, 90, 0]) cylinder(d = 5.5, h = 0.5);
            translate([0.3, 0, 4.3]) scale([1, 0.6, 1]) rotate([0, 90, 0]) cylinder(d = 7.5, h = 0.5);
            translate([0.8, 0, 4.3]) scale([1, 0.6, 1]) rotate([0, 90, 0]) cylinder(d = 8.7, h = 0.5);
            
            difference()
            {
                union() {
                    translate([1.3, 0, 4.3]) scale([1, 0.6, 1]) rotate([0, 90, 0]) cylinder(d = 8.7, h = 0.3);
                    translate([4.5, 0, 2.8]) scale([1, 0.55, 1]) rotate([0, 90, 0]) cylinder(d = 15.4, h = 0.3);
                    translate([8, 0, 2.9]) scale([1, 0.55, 1]) rotate([0, 90, 0]) cylinder(d = 16.4, h = 0.3);
                    translate([11.5, 0, 2.9]) scale([1, 0.55, 1]) rotate([0, 90, 0]) cylinder(d = 16, h = 0.3);
                    translate([15, 0, 2.8]) scale([1, 0.6, 1]) rotate([0, 90, 0]) cylinder(d = 14.4, h = 0.3);
                    translate([18.22, 0, 2.9]) scale([1, 0.43, 1]) rotate([0, 90, 0]) cylinder(d = 12.5, h = 0.3);
                    translate([22, 0, 4.7]) scale([1, 0.43, 1]) rotate([0, 90, 0]) cylinder(d = 6.7, h = 0.3);
                }
                translate([-0.5, 0.3/2, -0.1]) rotate([90, 0, 0]) linear_extrude(height = 0.3) import("balloon.svg", convexity=3);
            }
        }
        translate([0, -5, -10]) cube([n/2 + w + l + n/2 + n*6/8, 10, 10]);
        translate([l + w + n/2 - 1, 0, 0]) controller(hole = true);
        translate([0.3, 0, 4.3]) scale([1, 1, 1.4]) rotate([0, 90, 0]) cylinder(d = 2.5, h = 21.2);
    }
}

module govern()
{
    color("Orange") scale([1.025, 1, 1.025]) translate([0.6, 0.3/2, -0.3]) rotate([90, 0, 0]) scale([0.2, 0.2, 1]) linear_extrude(height = 0.3) import("govern.svg", convexity=3);
}

module cabin(hole = false)
{
    if (!hole) color("Orange")
    {
        translate([-0.95, 0.3/2, -3.25]) rotate([90, 0, 0]) linear_extrude(height = 0.3) scale([0.8, 0.8, 1]) import("cabin.svg", convexity=3);
        translate([0, -0.3/2, 0])  cube([9.5, 0.3, 0.3]);
    }
    
    if (hole)
    {
        translate([0, -0.3/2, -0.1]) cube([9.5, 0.3, 0.5]);
    }
}

module upper_plate()
{
    color("Yellow") difference()
    {
        translate([0, 0, h + 0.6]) plate(depth = 0.3);
        translate([-l, 0, 0.3]) rotate([0, 0, 90]) wing(length = l + e, depth = 0.3, hole = true);
        translate([-l, 0, 0.3]) rotate([0, 0, -90]) wing(length = l + e, depth = 0.3, hole = true);
        translate([0, 0, 0.3]) rotate([0, 0, 45]) wing(length = f + sqrt(e*e*2), depth = 0.3, hole = true);
        translate([0, 0, 0.3]) rotate([0, 0, -45]) wing(length = f + sqrt(e*e*2), depth = 0.3, hole = true);
        translate([-1, 0, h + 0.9]) controller(hole = true);
    }
}

module lower_plate()
{
    color("Yellow") difference()
    {
        plate(bottom = 1, depth = 0.3);
        translate([-l, 0, 0.3]) rotate([0, 0, 90]) wing(length = l + e, depth = 0.3, hole = true);
        translate([-l, 0, 0.3]) rotate([0, 0, -90]) wing(length = l + e, depth = 0.3, hole = true);
        translate([0, 0, 0.3]) rotate([0, 0, 45]) wing(length = f + sqrt(e*e*2), depth = 0.3, hole = true);
        translate([0, 0, 0.3]) rotate([0, 0, -45]) wing(length = f + sqrt(e*e*2), depth = 0.3, hole = true);
        translate([-13, 0, 0]) cabin(hole = true);
    }
}

module main()
{
    upper_plate();
    lower_plate();
    translate([-l, 0, 0.3]) rotate([0, 0, 90]) wing(length = l + e, depth = 0.3);
    translate([-l, 0, 0.3]) rotate([0, 0, -90]) wing(length = l + e, depth = 0.3);
    translate([0, 0, 0.3]) rotate([0, 0, 45]) wing(length = f + sqrt(e*e*2), depth = 0.3);
    translate([0, 0, 0.3]) rotate([0, 0, -45]) wing(length = f + sqrt(e*e*2), depth = 0.3);
    
    if (lod == "normal")
    {
        translate([-1, 0, h + 0.6]) controller(hole = false);
    }
    
    if (lod == "high")
    {
        translate([-(l + w + n/2), 0, h + 0.9]) balloon();
        translate([-(l + w + n/4), 0, 0.3]) cockpit();
        translate([12, 0, 0.3]) govern();
        translate([-(l + w + n/4), 0, 0]) cabin();
    }
        
    *color("SteelBlue")
    { 
        propellers();
    }
}

module schema()
{
    projection($fn=40)
    {
        translate([14, 4, 0]) upper_plate();
        
        translate([14, 15, 0]) lower_plate();
        
        translate([0, 22, 0])
        {
            translate([4.5, 8.5, 0]) rotate([-90, 0, 0]) wing_support(length = f + sqrt(e*e*2), depth = 0.3);      
            translate([2, 13.5, 0]) wing(length = f + sqrt(e*e*2), depth = 0.3, support = 0);
            translate([24.5, 2.5, 0]) rotate([0, 90, 0]) wing_foot_front(length = f + sqrt(e*e*2), depth = 0.3);
            translate([3.5, -1.5, 0]) rotate([0, 90, 0]) wing_foot_back(length = f + sqrt(e*e*2), depth = 0.3, angle = 0);
            translate([0.5, 3.5, 0]) wing_foot_bottom2(length = f + sqrt(e*e*2), depth = 0.3);
            translate([14.5, -1.5, 0]) rotate([0, 90, 0]) wing_foot_bottom1(length = f + sqrt(e*e*2), depth = 0.3, angle = 0);
        }
        
        translate([0, 40, 0])
        {
            translate([4.5, 8.5, 0]) rotate([-90, 0, 0]) wing_support(length = l + e, depth = 0.3);      
            translate([2, 13.5, 0]) wing(length = l + e, depth = 0.3, support = 0);
            translate([24.5, 2.5, 0]) rotate([0, 90, 0]) wing_foot_front(length = l + e, depth = 0.3);
            translate([3.5, -1.5, 0]) rotate([0, 90, 0]) wing_foot_back(length = l + e, depth = 0.3, angle = 0);
            translate([0.5, 3.5, 0]) wing_foot_bottom2(length = l + e, depth = 0.3);
            translate([14.5, -1.5, 0]) rotate([0, 90, 0]) wing_foot_bottom1(length = l + e, depth = 0.3, angle = 0);
        }
    }
}



if (mode == "main")
{
    main();
}
if (mode == "schema")
{
    scale(10) schema();
}
