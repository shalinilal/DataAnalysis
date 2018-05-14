import MapN

vi_template = containers.Map
vi_template('Vdsm')  = '';
vi_template('Vdsc')  = '';
vi_template('Idmax') = '';
vi_template('Vss')   = '';

devices = MapN();
devices('c46','Vdsm') = '3V'
v =devices( 'c46','Vdsm')
