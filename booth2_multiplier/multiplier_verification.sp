$example HSPICE setup file

$transistor model
.include "/proj/cad/library/mosis/GF65_LPe/cmos10lpe_CDS_oa_dl064_11_20160415/models/YI-SM00030/Hspice/models/design.inc"
.include multiplier_32x32_behav.pex.netlist
.param WAIT=20n
.global vdd gnd
.option post runlvl=5

x1 GND! VDD! Y<25> P<44> P<52> P<53> P<51> P<45>
+ P<19> P<16> P<49> Y<23> P<18> P<17> P<50> P<59> P<63> X<16> X<7> X<15> X<6>
+ X<30> X<18> X<17> Y<17> Y<16> P<40> P<62> P<61> P<38> P<31> P<29> P<14> CLK
+ P<22> P<15> P<39> P<20> P<21> Y<28> P<7> P<9> X<4> X<14> Y<7> Y<3> P<6> Y<26>
+ X<11> X<10> X<9> P<36> P<60> X<27> P<33> P<41> P<12> P<1> P<10> Y<0> X<0> P<8>
+ X<3> X<13> Y<9> X<8> P<56> P<3> P<58> X<2> P<27> X<1> X<29> P<24> P<30> Y<13>
+ Y<15> Y<11> X<31> Y<31> Y<10> X<19> X<26> X<24> X<22> Y<12> X<20> Y<6> Y<24>
+ P<48> P<47> P<23> Y<22> Y<21> Y<20> Y<19> P<54> P<57> P<13> P<35> P<37> P<32>
+ P<34> P<5> P<11> Y<1> P<0> Y<8> X<12> X<5> P<4> P<2> P<55> Y<27> P<28> X<28>
+ P<26> Y<2> Y<14> Y<30> X<25> X<23> X<21> Y<5> Y<29> Y<4> P<46> P<25> P<42>
+ Y<18> P<43> multiplier_32x32_behav

$VDD vdd gnd 1v
VDD  VDD! gnd 1v
$VGND GND! gnd 0v

Vclk CLK gnd PULSE (0v 1v 5ns 50ps 50ps 9950ps 20000ps)

$ delay(5000) = ZERO and delay(2500) = ONE

Vin1 X<0>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin2 X<1>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin3 X<2>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin4 X<3>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin5 X<4>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin6 X<5>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin7 X<6>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin8 X<7>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 

Vin9  X<8>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin10 X<9>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin11 X<10> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin12 X<11> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin13 X<12> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin14 X<13> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin15 X<14> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin16 X<15> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)

Vin17 X<16> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin18 X<17> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin19 X<18> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin20 X<19> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin21 X<20> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin22 X<21> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin23 X<22> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin24 X<23> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)

Vin25 X<24> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin26 X<25> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin27 X<26> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin28 X<27> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin29 X<28> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin30 X<29> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin31 X<30> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin32 X<31> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)

Vin33 Y<0> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin34 Y<1> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin35 Y<2> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin36 Y<3> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin37 Y<4> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin38 Y<5> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v) 
Vin39 Y<6> gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 
Vin40 Y<7> gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v) 

Vin41 Y<8>   gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin42 Y<9>   gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin43 Y<10>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin44 Y<11>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin45 Y<12>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin46 Y<13>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin47 Y<14>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin48 Y<15>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)

Vin49 Y<16>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin50 Y<17>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin51 Y<18>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin52 Y<19>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin53 Y<20>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin54 Y<21>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 0v '2*WAIT' 0v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin55 Y<22>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin56 Y<23>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)

Vin57 Y<24>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin58 Y<25>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 1v '5*WAIT' 1v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin59 Y<26>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin60 Y<27>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 1v '3*WAIT' 1v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin61 Y<28>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin62 Y<29>  gnd PWL (0ns 0v 'WAIT' 0v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)
Vin63 Y<30>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 0v '4*WAIT' 0v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 0v '6*WAIT' 0v '6*WAIT+50ps' 1v)
Vin64 Y<31>  gnd PWL (0ns 1v 'WAIT' 1v 'WAIT+50ps' 1v '2*WAIT' 1v '2*WAIT+50ps' 0v '3*WAIT' 0v '3*WAIT+50ps' 1v '4*WAIT' 1v '4*WAIT+50ps' 0v '5*WAIT' 0v '5*WAIT+50ps' 1v '6*WAIT' 1v '6*WAIT+50ps' 1v)

cout0 P<0> gnd 25f
cout1 P<1> gnd 25f
cout2 P<2> gnd 25f
cout3 P<3> gnd 25f
cout4 P<4> gnd 25f
cout5 P<5> gnd 25f
cout6 P<6> gnd 25f
cout7 P<7> gnd 25f
cout8 P<8> gnd 25f
cout9 P<9> gnd 25f
cout10 P<10> gnd 25f
cout11 P<11> gnd 25f
cout12 P<12> gnd 25f
cout13 P<13> gnd 25f
cout14 P<14> gnd 25f
cout15 P<15> gnd 25f
cout16 P<16> gnd 25f
cout17 P<17> gnd 25f
cout18 P<18> gnd 25f
cout19 P<19> gnd 25f
cout20 P<20> gnd 25f
cout21 P<21> gnd 25f
cout22 P<22> gnd 25f
cout23 P<23> gnd 25f
cout24 P<24> gnd 25f
cout25 P<25> gnd 25f
cout26 P<26> gnd 25f
cout27 P<27> gnd 25f
cout28 P<28> gnd 25f
cout29 P<29> gnd 25f
cout30 P<30> gnd 25f
cout31 P<31> gnd 25f
cout32 P<32> gnd 25f
cout33 P<33> gnd 25f
cout34 P<34> gnd 25f
cout35 P<35> gnd 25f
cout36 P<36> gnd 25f
cout37 P<37> gnd 25f
cout38 P<38> gnd 25f
cout39 P<39> gnd 25f
cout40 P<40> gnd 25f
cout41 P<41> gnd 25f
cout42 P<42> gnd 25f
cout43 P<43> gnd 25f
cout44 P<44> gnd 25f
cout45 P<45> gnd 25f
cout46 P<46> gnd 25f
cout47 P<47> gnd 25f
cout48 P<48> gnd 25f
cout49 P<49> gnd 25f
cout50 P<50> gnd 25f
cout51 P<51> gnd 25f
cout52 P<52> gnd 25f
cout53 P<53> gnd 25f
cout54 P<54> gnd 25f
cout55 P<55> gnd 25f
cout56 P<56> gnd 25f
cout57 P<57> gnd 25f
cout58 P<58> gnd 25f
cout59 P<59> gnd 25f
cout60 P<60> gnd 25f
cout61 P<61> gnd 25f
cout62 P<62> gnd 25f
cout63 P<63> gnd 25f

.tran 10ps '5*WAIT'
.end