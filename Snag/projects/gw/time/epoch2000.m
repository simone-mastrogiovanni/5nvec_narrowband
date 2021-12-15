function [e2000,gps2000]=epoch2000()

e2000=v2mjd([2000 1 1 0 0 0]);
gps2000=mjd2gps(e2000);